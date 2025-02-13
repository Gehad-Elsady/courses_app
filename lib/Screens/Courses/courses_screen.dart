import 'package:cached_network_image/cached_network_image.dart';
import 'package:courses_app/Screens/Add%20courses/model/courses-model.dart';
import 'package:courses_app/Screens/course%20info/course_info_screen.dart';
import 'package:courses_app/backend/firebase_functions.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class CoursesScreen extends StatelessWidget {
  static const String routeName = 'CoursesScreen';
  const CoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String? course =
        ModalRoute.of(context)?.settings.arguments as String?;

    if (course == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Courses'),
          centerTitle: true,
        ),
        body: const Center(
          child: Text("Invalid category selection."),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 5,
        shadowColor: Colors.grey,
        backgroundColor: Colors.white,
        title: Text(
          course,
          style: GoogleFonts.domine(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: StreamBuilder<List<CoursesModel>>(
        stream: FirebaseFunctions.getCategoryCourses(course),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error loading courses: ${snapshot.error}'),
            );
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Lottie.asset("assets/lottie/empty_list.json"),
            );
          }

          final courses = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            itemCount: courses.length,
            itemBuilder: (context, index) {
              final course = courses[index];

              return InkWell(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    CourseInfoScreen.routeName,
                    arguments: course,
                  );
                },
                child: Card(
                  elevation: 10,
                  shadowColor: const Color(0xFF723c70),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: const BorderSide(color: Colors.black),
                  ),
                  margin: const EdgeInsets.all(10),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        // Course Details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                course.name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.roboto(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Text(
                                    '${course.rating}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  const Icon(Icons.star,
                                      color: Color(0xffFF9900)),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${course.numberOfLearners} Learners',
                                style: GoogleFonts.roboto(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Course Image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: CachedNetworkImage(
                            imageUrl: course.image,
                            height: 110,
                            width: 86,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error, color: Colors.red),
                          ),
                        ),
                      ],
                    ),
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
