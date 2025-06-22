import 'package:courses_app/Screens/Add%20courses/model/courses-model.dart';
import 'package:courses_app/Screens/Courses/courses_screen.dart';
import 'package:courses_app/backend/firebase_functions.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Categories extends StatelessWidget {
  Categories({
    super.key,
  });
  final List<String> _courseFields = [
    'Computer Science',
    'Engineering',
    'Business Administration',
    'Medicine',
    'Law',
    'Arts',
    'Education',
    'Psychology',
    'Biotechnology',
    'Finance',
    'Others'
  ];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map<String, int>>(
      stream: FirebaseFunctions.getCourseCountsByField(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }
        if (!snapshot.hasData) {
          return Center(child: Text("No data available"));
        }

        final courseCounts = snapshot.data ?? {};

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: 70, // Fixed height for horizontal ListView
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _courseFields.length,
              itemBuilder: (context, index) {
                String field = _courseFields[index];
                int count = courseCounts[field] ?? 0; // Default to 0 if no data

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, CoursesScreen.routeName,
                          arguments: _courseFields[index]);
                    },
                    child: CtigoriesItem(
                      name: field,
                      numberOfCourses: "${count} Courses",
                      icon: "assets/images/categories/$field.png",
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class CtigoriesItem extends StatelessWidget {
  String name;
  String numberOfCourses;
  String icon;
  CtigoriesItem({
    super.key,
    required this.name,
    required this.icon,
    required this.numberOfCourses,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: 175, // Adjust width for a better layout
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                name,
                style: GoogleFonts.roboto(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                numberOfCourses,
                style: GoogleFonts.roboto(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          SizedBox(width: 20), // Add spacing between icon and text
          Image.asset(
            icon,
            height: 40,
            color: Color(0xFF6E5DE7),
          )
        ],
      ),
    );
  }
}
