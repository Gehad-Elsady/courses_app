import 'package:courses_app/Screens/Auth/login-screen.dart';
import 'package:courses_app/Screens/home/home-screen.dart';
import 'package:courses_app/photos/images.dart';
import 'package:courses_app/provider/check-user.dart';
import 'package:flutter/material.dart';

import 'package:lottie/lottie.dart';

import 'dart:async';

import 'package:provider/provider.dart';

// import 'package:recycling_app/home-screen.dart'; // Import HomeScreen

class SplashScreen extends StatefulWidget {
  static const String routeName = 'splash-screen';

  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Remove the Provider access from initState
    // Delay navigation to allow context to be ready
    Future.delayed(Duration.zero, () {
      navigateToNextScreen();
    });
  }

  void navigateToNextScreen() {
    var user = Provider.of<CheckUser>(context,
        listen: false); // Updated to listen: false

    Timer(const Duration(seconds: 10), () {
      Navigator.pushReplacementNamed(
        context,
        user.firebaseUser != null ? HomeScreen.routeName : LoginPage.routeName,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get the screen height and width for responsive design
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF48CAE4),
              Color(0xFF90E0EF),
              Color(0xFFADE8F4),
              Color(0xFFCAF0F8),
            ],
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(height: size.height * 0.08), // Spacing
                  Lottie.asset(
                    Photos.splash,
                    height: size.height * 0.4,
                  ),

                  SizedBox(height: size.height * 0.08), // Spacing

                  // A simple welcome message with beautiful styling
                  ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(colors: [
                      Colors.black,
                      Colors.red,
                      Colors.green,
                      Colors.blue
                    ]).createShader(bounds),
                    child: Text(
                      "Welcome to SkillMart",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),

                  ShaderMask(
                    shaderCallback: (bounds) =>
                        LinearGradient(colors: [Colors.black, Colors.black])
                            .createShader(bounds),
                    child: Text(
                      textAlign: TextAlign.center,
                      "Find the best courses for you \n and share knowledge",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
