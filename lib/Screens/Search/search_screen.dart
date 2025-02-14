import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:courses_app/Screens/Add%20courses/model/courses-model.dart';
import 'package:courses_app/Screens/home/widget/course_item.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CoursesSearchPage extends StatefulWidget {
  static const String routeName = '/services-search';
  const CoursesSearchPage({super.key});

  @override
  _CoursesSearchPageState createState() => _CoursesSearchPageState();
}

class _CoursesSearchPageState extends State<CoursesSearchPage> {
  String query = "";
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search Courses",
            style: GoogleFonts.roboto(
              fontSize: 30,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            )),
        backgroundColor: Color(0xFF90E0EF),
        elevation: 5,
        shadowColor: Color(0xff03045E),
        centerTitle: true,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFADE8F4),
              Color(0xFFCAF0F8),
              Color(0xFF90E0EF),
              Color(0xFF90E0EF),
              Color(0xFF48CAE4),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              // Search TextField
              TextField(
                onChanged: (value) {
                  setState(() {
                    query = value.toLowerCase();
                  });
                },
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: "Search for courses...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // StreamBuilder to search in the courses collection
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _firestore.collection('courses').snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(child: Text("No courses found."));
                    }

                    final results = snapshot.data!.docs.where((doc) {
                      final name = doc['name']?.toString().toLowerCase() ??
                          ''; // Handle null values
                      final description =
                          doc['description']?.toString().toLowerCase() ??
                              ''; // Handle null values
                      return name.contains(query) ||
                          description.contains(query);
                    }).toList();

                    if (results.isEmpty) {
                      return const Center(
                          child: Text("No matching courses found."));
                    }

                    return ListView.builder(
                      itemCount: results.length,
                      itemBuilder: (context, index) {
                        final courseDoc = results[index];

                        final coursesModel = CoursesModel.fromJson(
                            courseDoc.data() as Map<String, dynamic>);

                        return CourseItem(course: coursesModel);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
