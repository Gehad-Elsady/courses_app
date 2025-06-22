import 'package:courses_app/Screens/Profile/student-profile-screen.dart';
import 'package:courses_app/Screens/Search/search_screen.dart';
import 'package:courses_app/Screens/home/tabs/home_tab.dart';
import 'package:courses_app/Screens/home/tabs/settings_tab.dart';
import 'package:courses_app/Screens/home/test.dart';
import 'package:courses_app/Screens/home/widget/ads_part.dart';
import 'package:courses_app/Screens/home/widget/categories_part.dart';
import 'package:courses_app/Screens/home/widget/top_courses_part.dart';
import 'package:courses_app/Screens/my%20enroll%20courses/my_enroll_courses.dart';
import 'package:courses_app/backend/firebase_functions.dart';
import 'package:courses_app/photos/images.dart';
import 'package:courses_app/widget/Drawer/mydrawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:water_drop_nav_bar/water_drop_nav_bar.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = 'home-screen';
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 1; // Set default index to HomeTab()
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: selectedIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SizedBox(
        height: 60,
        child: WaterDropNavBar(
          bottomPadding: 15,
          iconSize: 30,
          waterDropColor: Color(0xFF6E5DE7),
          backgroundColor: Colors.white,
          onItemSelected: (index) {
            setState(() {
              selectedIndex = index;
            });
            if (pageController.hasClients) {
              pageController.animateToPage(
                selectedIndex,
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOutQuad,
              );
            }
          },
          selectedIndex: selectedIndex,
          barItems: [
            BarItem(
                filledIcon: Icons.search_rounded,
                outlinedIcon: Icons.search_outlined),
            BarItem(
              filledIcon: Icons.home_sharp,
              outlinedIcon: Icons.home_outlined,
            ),
            BarItem(
              filledIcon: Icons.ondemand_video_rounded,
              outlinedIcon: Icons.ondemand_video_rounded,
            ),
            BarItem(
                filledIcon: Icons.person_rounded,
                outlinedIcon: Icons.person_outline_rounded),
          ],
        ),
      ),
      body: PageView(
        controller: pageController, // Attach PageController
        children: screens,
        onPageChanged: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
      ),
    );
  }

  final List<Widget> screens = [
    CoursesSearchPage(),
    HomeTab(),
    MyEnrollCourses(), // HomeTab is at index 1
    SettingsTab(),
  ];
}
