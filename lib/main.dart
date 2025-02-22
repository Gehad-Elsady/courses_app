import 'package:courses_app/Screens/Add%20courses/addscoursesscreen.dart';
import 'package:courses_app/Screens/Auth/login-screen.dart';
import 'package:courses_app/Screens/Auth/signup-screen.dart';
import 'package:courses_app/Screens/Courses/courses_screen.dart';
import 'package:courses_app/Screens/Profile/student-profile-screen.dart';
import 'package:courses_app/Screens/Search/search_screen.dart';
import 'package:courses_app/Screens/SplashScreen/splash-screen.dart';
import 'package:courses_app/Screens/contact/contact-screen.dart';
import 'package:courses_app/Screens/course%20info/course_info_screen.dart';
import 'package:courses_app/Screens/course%20owner/course_owner_profile.dart';
import 'package:courses_app/Screens/home/home-screen.dart';
import 'package:courses_app/Screens/home/tabs/home_tab.dart';
import 'package:courses_app/Screens/my%20courses/my_courses_screen.dart';
import 'package:courses_app/Screens/my%20requestes/my_requeste.dart';
import 'package:courses_app/Screens/shared%20courses/shared_courses.dart';
import 'package:courses_app/Screens/shared%20courses/shares_course_info.dart';
import 'package:courses_app/Screens/update%20courses/update_courses.dart';
import 'package:courses_app/backend/firebase_options.dart';
import 'package:courses_app/provider/check-user.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => CheckUser()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: SplashScreen.routeName,
      routes: {
        SplashScreen.routeName: (context) => SplashScreen(),
        HomeScreen.routeName: (context) => HomeScreen(),
        LoginPage.routeName: (context) => LoginPage(),
        SignUpPage.routeName: (context) => SignUpPage(),
        StudentProfile.routeName: (context) => StudentProfile(),
        AddCoursesPage.routeName: (context) => AddCoursesPage(),
        CoursesScreen.routeName: (context) => CoursesScreen(),
        CourseInfoScreen.routeName: (context) => CourseInfoScreen(),
        CoursesSearchPage.routeName: (context) => CoursesSearchPage(),
        CourseOwnerProfile.routeName: (context) => CourseOwnerProfile(),
        HomeTab.routeName: (context) => HomeTab(),
        MyCoursesScreen.routeName: (context) => MyCoursesScreen(),
        UpdateCoursesPage.routeName: (context) => UpdateCoursesPage(),
        ContactScreen.routeName: (context) => ContactScreen(),
        SharedCourses.routeName: (context) => SharedCourses(),
        MyRequests.routeName: (context) => MyRequests(),
        SharesCourseInfoScreen.routeName: (context) => SharesCourseInfoScreen(),
      },
    );
  }
}
