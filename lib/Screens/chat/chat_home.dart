import 'package:courses_app/Screens/Auth/model/usermodel.dart';
import 'package:courses_app/Screens/Profile/model/profilemodel.dart';
import 'package:courses_app/backend/firebase_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'messages_screen.dart';

class ChatHome extends StatelessWidget {
  static const String routeName = 'chat-home';
  const ChatHome({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Chat',
          style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: FirebaseFunctions.getMyEnrollCourses(currentUser.uid),
        builder: (context, snapshot) {
          if (snapshot.hasError) return const Center(child: Text('Something went wrong'));
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          final enrollCourses = snapshot.data ?? [];
          final enrolledUserIds = enrollCourses.map((e) => e.coursesModel.userId).toSet();

          return FutureBuilder<QuerySnapshot>(
            future: FirebaseFirestore.instance
                .collection('chats')
                .where('userIds.${currentUser.uid}', isEqualTo: true)
                .get(),
            builder: (context, chatSnapshot) {
              if (chatSnapshot.hasError) return const Center(child: Text('Failed to load chats'));
              if (!chatSnapshot.hasData) return const Center(child: CircularProgressIndicator());

              final chatDocs = chatSnapshot.data!.docs;
              final chatUserIds = <String>{};

              for (var doc in chatDocs) {
                final users = List<String>.from(doc['users']);
                final otherUserId = users.firstWhere((id) => id != currentUser.uid);
                chatUserIds.add(otherUserId);
              }

              final allUserIds = {...enrolledUserIds, ...chatUserIds}.toList();

              return FutureBuilder<Map<String, ProfileModel>>(
                future: FirebaseFunctions.getUsersByIds(allUserIds),
                builder: (context, userSnapshot) {
                  if (userSnapshot.hasError) return const Center(child: Text('Failed to load users'));
                  if (!userSnapshot.hasData) return const Center(child: CircularProgressIndicator());

                  final usersMap = userSnapshot.data!;
                  return ListView.builder(
                    itemCount: allUserIds.length,
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                    itemBuilder: (context, index) {
                      final chatUserId = allUserIds[index];
                      final user = usersMap[chatUserId];
                      if (user == null) return const SizedBox.shrink();

                      List<String> ids = [currentUser.uid, chatUserId]..sort();
                      final chatId = '${ids[0]}_${ids[1]}';

                      return StreamBuilder<DocumentSnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('chats')
                            .doc(chatId)
                            .snapshots(),
                        builder: (context, chatSnapshot) {
                          String lastMessage = 'No messages yet';
                          String lastMessageTime = '';
                          bool isMe = false;
                          bool hasMessages = false;
                          String? lastMessageSenderId;

                          if (chatSnapshot.hasData && chatSnapshot.data!.exists) {
                            final data = chatSnapshot.data!.data() as Map<String, dynamic>?;
                            if (data != null) {
                              lastMessage = data['lastMessage'] ?? 'No messages yet';
                              final timestamp = data['lastMessageTime'] as Timestamp?;
                              lastMessageSenderId = data['lastMessageSenderId'] as String?;

                              if (lastMessage.isNotEmpty && lastMessage != 'No messages yet') {
                                hasMessages = true;
                                if (timestamp != null) {
                                  lastMessageTime = DateFormat('h:mm a').format(timestamp.toDate());
                                }
                                isMe = lastMessageSenderId == currentUser.uid;
                              }
                            }
                          }

                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            elevation: 2,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              leading: CircleAvatar(
                                radius: 28,
                                backgroundImage: NetworkImage(user.profileImage),
                                backgroundColor: Colors.grey[300],
                              ),
                              title: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${user.firstName} ${user.lastName}',
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                      ),
                                      if (lastMessageTime.isNotEmpty)
                                        Text(
                                          lastMessageTime,
                                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                                        ),
                                  
                                    ],
                                  ),
                                ],
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 4),
                                  if (hasMessages)
                                    Text(
                                      isMe ? 'You: $lastMessage' : lastMessage,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(color: Colors.grey[700], fontSize: 14),
                                    )
                                  else
                                    Text(
                                      'Start a new chat',
                                      style: TextStyle(
                                        color: Colors.blue[400],
                                        fontStyle: FontStyle.italic,
                                        fontSize: 14,
                                      ),
                                    ),
                                ],
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MessagesScreen(
                                      receiverId: chatUserId,
                                      receiverName: '${user.firstName} ${user.lastName}',
                                      receiverImage: user.profileImage,
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
