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
// afterCourse
// "🏆 Build your own websites from scratch🏆 Get hired as a junior web developer🏆 Deploy websites to the web using free hosting services🏆 Start freelancing or launch your own web-based projects"
// (string)


// courseDuration
// "8 Weeks"
// (string)


// courseField
// "Computer Science"
// (string)


// courseLanguage
// "English"
// (string)


// courseLevel
// "Beginner"
// (string)


// courseOwnerName
// "gehad elsady"
// (string)


// createdAt
// 1 February 2025 at 00:56:01 UTC+2
// (timestamp)


// description
// "Course Description: This course will teach you how to build professional, interactive, and responsive websites using HTML, CSS, and JavaScript. Whether you're looking to start your career in web development or want to build your own websites, this course covers everything from creating the structure of a webpage to adding dynamic features with JavaScript. By the end of the course, you'll have the skills to develop modern websites that work on desktops, tablets, and mobile devices. What You'll Learn: ✔️ Introduction to HTML: Learn the basics of structuring a webpage with HTML tags, attributes, and elements. ✔️ HTML5 New Features: Understand the latest HTML features like forms, multimedia, and semantic tags. ✔️ CSS Fundamentals: Learn how to style web pages, manage layouts, and create responsive designs. ✔️ JavaScript Basics: Master JavaScript to add interactivity to your websites, including handling events and manipulating the DOM. ✔️ Responsive Web Design: Learn techniques for building websites that look great on all devices using CSS media queries. ✔️ JavaScript for Dynamic Content: Understand how to use JavaScript for creating animations, handling user inputs, and updating content dynamically. ✔️ Web Forms: Learn how to create, validate, and manage forms for collecting data. ✔️ Using APIs in Web Apps: Learn how to fetch and display external data using JavaScript. ✔️ Publishing Your Website: Learn how to host your websites on platforms like GitHub Pages, Netlify, or any custom server."
// (string)


// image
// "https://firebasestorage.googleapis.com/v0/b/alarm-project-1e920.appspot.com/o/course_images%2F1738364158548.jpg?alt=media&token=9e8ec0a0-3388-4260-8b99-34770ea269df"
// (string)


// name
// "Web Development with HTML, CSS, and JavaScript"
// (string)


// numberOfLearners
// "0"
// (string)


// price
// "8000"
// (string)


// rating
// "0"
// (string)


// requirements
// "✅ Basic programming knowledge (recommended but not required)✅ Laptop/Computer with internet access✅ Text editor (e.g., VS Code, Sublime Text, or any IDE of your choice)✅ A passion for learning web development"
// (string)


// userId
// "YL5imOZaemfiEqefY6X4rE9ULop2"
// (string)


// Database location: nam5