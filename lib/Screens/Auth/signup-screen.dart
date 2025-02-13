import 'dart:async';

import 'package:courses_app/Screens/Auth/login-screen.dart';
import 'package:courses_app/backend/firebase_functions.dart';
import 'package:courses_app/photos/images.dart';
import 'package:flutter/material.dart';

import 'package:lottie/lottie.dart';

class SignUpPage extends StatefulWidget {
  static const String routeName = "sign up";
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

String? role;

class _SignUpPageState extends State<SignUpPage> {
  final formKey = GlobalKey<FormState>(); // Moved inside _SignUpPageState
  final TextEditingController ageController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
// final TextEditingController phoneController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  void dispose() {
    ageController.dispose();
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();

    role = null;
    // Reset form on page dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color(0xFF48CAE4),
              Color(0xFF90E0EF),
              Color(0xFFADE8F4),
              Color(0xFFCAF0F8),
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(height: 80),
                Image.asset(Photos.signUp, height: 200),
                Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: role == "Instructor"
                                  ? MaterialStateProperty.all(Colors.blue[600])
                                  : MaterialStateProperty.all(
                                      Colors.transparent),
                            ),
                            onPressed: () {
                              setState(() {
                                role = "Instructor";
                              });
                            },
                            child: Container(
                              height: 100,
                              width: 100,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Image.asset(
                                    "assets/images/output-onlinegiftools (3).gif",
                                    height: 70,
                                  ),
                                  Text(
                                    "Instructor",
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: role == "Student"
                                  ? MaterialStateProperty.all(Colors.blue[600])
                                  : MaterialStateProperty.all(
                                      Colors.transparent),
                            ),
                            onPressed: () {
                              setState(() {
                                role = "Student";
                              });
                            },
                            child: Container(
                              height: 100,
                              width: 100,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Image.asset(
                                    "assets/images/output-onlinegiftools (2).gif",
                                    height: 70,
                                  ),
                                  Text(
                                    "Student",
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your name";
                          }
                          return null;
                        },
                        controller: nameController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          prefixIcon: Icon(
                            Icons.person,
                          ),
                          hintText: "Name",
                          hintStyle: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontSize: 15),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                color: Colors.black,
                              )),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your age";
                          }
                          if (int.parse(value) < 20) {
                            return "Sorry, age must be at least 20";
                          }
                          return null;
                        },
                        controller: ageController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          prefixIcon: Icon(
                            Icons.numbers,
                          ),
                          hintText: "Age",
                          hintStyle: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontSize: 15),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                color: Colors.black,
                              )),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your email";
                          }
                          final bool emailValid = RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z]+\.[a-zA-Z]+")
                              .hasMatch(value);
                          if (!emailValid) {
                            return "Please enter a valid email";
                          }
                          return null;
                        },
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          prefixIcon: Icon(
                            Icons.email,
                          ),
                          hintText: "Email",
                          hintStyle: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontSize: 15),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                color: Colors.black,
                              )),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        validator: (value) {
                          final RegExp regex = RegExp(
                              r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
                          if (value == null || value.isEmpty) {
                            return 'Please enter a password';
                          } else if (!regex.hasMatch(value)) {
                            return 'Password must include an uppercase letter, a number, and a special character';
                          }
                          return null;
                        },
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          prefixIcon: Icon(
                            Icons.lock,
                          ),
                          hintText: "Password",
                          hintStyle: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontSize: 15),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                color: Colors.black,
                              )),
                        ),
                      ),
                      SizedBox(height: 30),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[300],
                          fixedSize:
                              Size(MediaQuery.of(context).size.width, 50),
                        ),
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            FirebaseFunctions.SignUp(
                              emailController.text,
                              passwordController.text,
                              age: int.parse(ageController.text),
                              userName: nameController.text,
                              role: role!,
                              onSuccess: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Lottie.asset(Photos.create),
                                          SizedBox(height: 16),
                                          Text(
                                            "Please Verify Your Email Address to Login",
                                            style: TextStyle(fontSize: 20),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                                Timer(
                                  Duration(seconds: 3),
                                  () {
                                    Navigator.pushNamed(
                                        context, LoginPage.routeName);
                                  },
                                );
                              },
                              onError: (e) {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text("Error"),
                                    content: Text(e.toString()),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('OK'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          }
                        },
                        child: Text(
                          "Submit",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      SizedBox(height: 80),
                      InkWell(
                          onTap: () {
                            Navigator.pushReplacementNamed(
                                context, LoginPage.routeName);
                          },
                          child: Text.rich(
                            textAlign: TextAlign.center,
                            TextSpan(
                              text: "have an account?  ",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(fontSize: 15),
                              children: [
                                TextSpan(
                                  text: "Login",
                                  style: TextStyle(
                                    color: Colors.blue,
                                  ),
                                ),
                              ],
                            ),
                          ))
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
