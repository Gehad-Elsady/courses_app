import 'package:courses_app/Screens/home/widget/course_item.dart';
import 'package:courses_app/Screens/my%20enroll%20courses/inroll_course_info.dart';
import 'package:courses_app/Screens/my%20enroll%20courses/model/enroll_courses_model.dart';
import 'package:courses_app/backend/firebase_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyEnrollCourses extends StatelessWidget {
  const MyEnrollCourses({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Enroll Courses',
          style: GoogleFonts.domine(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 5,
        shadowColor: Color(0xff03045E),
        centerTitle: true,
      ),
      body: Container(
       
        child: StreamBuilder<List<EnrollCoursesModel>>(
          stream: FirebaseFunctions.getMyEnrollCourses(
              FirebaseAuth.instance.currentUser!.uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No enrolled courses found'));
            }

            final results = snapshot.data!;

            return ListView.builder(
              itemCount: results.length,
              itemBuilder: (context, index) {
                final coursesModel = results[index].coursesModel;
                return Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(
                            context, EnrollCourseInfoScreen.routeName,
                            arguments: coursesModel);
                      },
                      child: CourseItem(course: coursesModel)),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
