import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessagesScreen extends StatefulWidget {
  static const String routeName = 'messages-screen';
  final String receiverId;
  final String receiverName;
  final String receiverImage;

  const MessagesScreen({
    Key? key,
    required this.receiverId,
    required this.receiverName,
    required this.receiverImage,
  }) : super(key: key);

  @override
  _MessagesScreenState createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final currentUser = FirebaseAuth.instance.currentUser!;
  late String chatId;

  @override
  void initState() {
    super.initState();
    // Create a unique chat ID by combining user IDs in alphabetical order
    List<String> ids = [currentUser.uid, widget.receiverId]..sort();
    chatId = '${ids[0]}_${ids[1]}';
    print('Chat ID: $chatId');
    print('Current User ID: ${currentUser.uid}');
    print('Receiver ID: ${widget.receiverId}');
    
    // Print the full path to the messages collection for debugging
    print('Listening to messages at: chats/$chatId/messages');
  }

  void _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    try {
      print('Sending message to chat: $chatId');
      print('Message content: ${_messageController.text}');
      await FirebaseFirestore.instance
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .add({
        'senderId': currentUser.uid,
        'receiverId': widget.receiverId,
        'message': _messageController.text.trim(),
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Update the last message in the chat document
      await FirebaseFirestore.instance
          .collection('chats')
          .doc(chatId)
          .set({
        'lastMessage': _messageController.text.trim(),
        'lastMessageTime': FieldValue.serverTimestamp(),
        'lastMessageSenderId': currentUser.uid,
        'users': [currentUser.uid, widget.receiverId],
        'userIds': {
          currentUser.uid: true,
          widget.receiverId: true,
        },
      }, SetOptions(merge: true));

      _messageController.clear();
      _scrollToBottom();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to send message')),
        );
      }
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    print('Building MessagesScreen with chatId: $chatId');
    print('Current user ID: ${currentUser.uid}');
    print('Receiver ID: ${widget.receiverId}');
    
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage(widget.receiverImage),
            ),
            const SizedBox(width: 10),
            Text(
              widget.receiverName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.blue,
        centerTitle: false,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .doc(chatId)
                  .collection('messages')
                  .orderBy('timestamp', descending: false)
                  .snapshots()
                  .handleError((error) {
                    print('Error fetching messages: $error');
                    // Return an empty query snapshot on error
                    return FirebaseFirestore.instance
                        .collection('chats')
                        .doc(chatId)
                        .collection('messages')
                        .limit(0)
                        .get()
                        .asStream();
                  })
                  .map((snapshot) {
                    print('Received ${snapshot.docs.length} messages');
                    if (snapshot.docs.isNotEmpty) {
                      print('First message: ${snapshot.docs.first.data()}');
                    } else {
                      print('No messages found in the snapshot');
                    }
                    return snapshot;
                  }),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData) {
                  return const Center(child: Text('Loading messages...'));
                }

                if (snapshot.hasError) {
                  print('Error in stream: ${snapshot.error}');
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (snapshot.data!.docs.isEmpty) {
                  print('No messages found in the chat');
                  return const Center(
                    child: Text('No messages yet. Say hello!'),
                  );
                }

                WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final message = snapshot.data!.docs[index];
                    final messageData = message.data() as Map<String, dynamic>;
                    print('Message data: $messageData');
                    final isMe = messageData['senderId'] == currentUser.uid;
                    print('Message from ${isMe ? 'me' : 'other'}: ${messageData['message']}');


                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        mainAxisAlignment: isMe 
                            ? MainAxisAlignment.end 
                            : MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (!isMe) ...[  // Show receiver's avatar for received messages
                            CircleAvatar(
                              radius: 16,
                              backgroundImage: NetworkImage(widget.receiverImage),
                            ),
                            const SizedBox(width: 8),
                          ],
                          Flexible(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: isMe 
                                    ? Colors.blue[500] 
                                    : Colors.grey[200],
                                borderRadius: BorderRadius.only(
                                  topLeft: const Radius.circular(20),
                                  topRight: const Radius.circular(20),
                                  bottomLeft: Radius.circular(isMe ? 20 : 4),
                                  bottomRight: Radius.circular(isMe ? 4 : 20),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: isMe 
                                    ? CrossAxisAlignment.end 
                                    : CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    messageData['message'] ?? 'No message text',
                                    style: TextStyle(
                                      color: isMe ? Colors.white : Colors.black87,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    messageData['timestamp'] != null 
                                        ? DateFormat('h:mm a').format((messageData['timestamp'] as Timestamp).toDate())
                                        : 'No time',
                                    style: TextStyle(
                                      color: isMe 
                                          ? Colors.white70 
                                          : Colors.black54,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (isMe) ...[  // Show read status for sent messages
                            const SizedBox(width: 8),
                            Icon(
                              Icons.done_all,
                              size: 16,
                              color: Colors.blue[700],
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                    ),
                    textCapitalization: TextCapitalization.sentences,
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
