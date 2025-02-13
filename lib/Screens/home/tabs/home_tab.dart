import 'package:courses_app/Screens/Profile/student-profile-screen.dart';
import 'package:courses_app/Screens/Search/search_screen.dart';
import 'package:courses_app/Screens/home/home-screen.dart';
import 'package:courses_app/Screens/home/widget/ads_part.dart';
import 'package:courses_app/Screens/home/widget/categories_part.dart';
import 'package:courses_app/Screens/home/widget/top_courses_part.dart';
import 'package:courses_app/backend/firebase_functions.dart';
import 'package:courses_app/photos/images.dart';
import 'package:courses_app/widget/Drawer/mydrawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:water_drop_nav_bar/water_drop_nav_bar.dart';

class HomeTab extends StatefulWidget {
  static const String routeName = 'HomeMain';
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              Photos.logo,
              scale: 12,
            ),
            const SizedBox(width: 10),
            Text(
              'Courses Home',
              style: GoogleFonts.domine(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
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
        child: SingleChildScrollView(
          child: StreamBuilder(
              stream: FirebaseFunctions.getUserProfile(
                  FirebaseAuth.instance.currentUser!.uid),
              builder: (context, snapshot) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Hello ${snapshot.data?.firstName} ${snapshot.data?.lastName}!" ??
                                "User",
                            style: GoogleFonts.roboto(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    AdsPart(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Text(
                        'Categories',
                        style: GoogleFonts.roboto(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    // Categories ListView
                    Categories(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Text(
                        'Top Courses',
                        style: GoogleFonts.roboto(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    TopCoursesPart(),
                    SizedBox(height: 20),
                  ],
                );
              }),
        ),
      ),
    );
  }

  List<Widget> screens = [
    HomeScreen(),
    StudentProfile(),
  ];
}
