import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:courses_app/Screens/Add%20courses/model/courses-model.dart';
import 'package:courses_app/Screens/course%20info/course_info_screen.dart';
import 'package:courses_app/Screens/home/widget/course_item.dart';
import 'package:courses_app/backend/firebase_functions.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TopCoursesPart extends StatelessWidget {
  const TopCoursesPart({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFunctions.getCourses(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.data == null || snapshot.data!.isEmpty) {
            return Center(child: Text('No services available'));
          } else {
            return SizedBox(
              height: 200, // Slightly increased height for better spacing
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final course = snapshot.data![index];
                  return InkWell(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        CourseInfoScreen.routeName,
                        arguments: course,
                      );
                    },
                    child: CourseItem(course: course)
                    );
                },
              ),
            );
          }
        });
  }
}
