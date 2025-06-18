import 'package:courses_app/backend/firebase_functions.dart';
import 'package:courses_app/Screens/chat/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatHome extends StatelessWidget {
  static const String routeName = 'chat-home';
  const ChatHome({super.key});

  @override
  Widget build(BuildContext context) {
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
        stream: FirebaseFunctions.getMyEnrollCourses(FirebaseAuth.instance.currentUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No enrolled courses found.'));
          }

          final courses = snapshot.data!;

          return ListView.builder(
            itemCount: courses.length,
            itemBuilder: (context, index) {
              final course = courses[index];

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 4,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(course.coursesModel.image),
                    ),
                    title: Text(
                      course.coursesModel.name,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "By: ${course.coursesModel.courseOwnerName}",
                      style: const TextStyle(fontSize: 14),
                    ),
                    trailing: const Icon(Icons.chat_bubble_outline),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(
                            courseOwner: course.coursesModel.courseOwnerName,
                            courseOwnerId: course.coursesModel.courseOwnerId ?? '',
                            courseId: course.coursesModel.courseId ?? '',
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
