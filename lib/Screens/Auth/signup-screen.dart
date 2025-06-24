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

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  String? _selectedRole;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _ageController.dispose();
    super.dispose();
  }
   @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        barrierDismissible: false, // User must tap the button to close
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Important Notice'),
            content: SingleChildScrollView(
              child: Text(
                '''Welcome to SkillMart!

Dear Instructor/Student,

Thank you for choosing SkillMart, your premier destination for online learning and teaching. Before you complete your registration, please review the following important guidelines to ensure a great learning/teaching experience:

1. Account Types:
   - Instructors can create and manage courses
   - Students can enroll in courses and track their progress

2. For Instructors:
   - Create engaging course content with videos, quizzes, and assignments
   - Set your own pricing for courses
   - Platform commission: 10% fee on each course sale
   - Receive payments through our secure platform
   - Maintain a 4.0+ rating for better visibility

3. For Students:
   - Access all enrolled courses anytime, anywhere
   - Track your learning progress and achievements
   - Get certificates upon course completion
   - Interact with instructors and peers through discussion forums

4. Community Guidelines:
   - Respect all community members
   - Maintain academic integrity
   - Provide constructive feedback
   - Report any inappropriate content

5. Platform Features:
   - Progress tracking and analytics
   - Mobile and desktop access
   - Downloadable course materials
   - 24/7 customer support

6. Privacy and Security:
   - Your data is protected with industry-standard encryption
   - Secure payment processing
   - Control over your personal information

7. Support:
   - Visit our Help Center for FAQs
   - Contact support@skillmart.com for assistance
   - Check our community forums for peer support

By completing your registration, you agree to our Terms of Service and Privacy Policy.

We're excited to have you join our learning community!

— The SkillMart Team''',
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('I Agree'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    });
  }


  Future<void> _handleSignUp() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedRole == null) {
      _showErrorDialog('Please select a role (Instructor or Student)');
      return;
    }

    setState(() => _isLoading = true);

    try {
      await FirebaseFunctions.SignUp(
        _emailController.text.trim(),
        _passwordController.text,
        age: int.parse(_ageController.text),
        userName: _nameController.text,
        role: _selectedRole!,
        onSuccess: () {
          if (!mounted) return;
          _showSuccessDialog();
          Timer(
            const Duration(seconds: 3),
            () {
              if (mounted) {
                Navigator.pushReplacementNamed(context, LoginPage.routeName);
              }
            },
          );
        },
        onError: (e) {
          if (!mounted) return;
          _showErrorDialog(e.toString());
        },
      );
    } catch (e) {
      if (!mounted) return;
      _showErrorDialog('An unexpected error occurred. Please try again.');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset(Photos.create, height: 150),
            const SizedBox(height: 16),
            const Text(
              "Please verify your email address to login",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo
                Center(
                  child: Image.asset(
                    "assets/images/WhatsApp_Image_2025-06-22_at_05.02.10_7393ce7d-removebg-preview.png",
                    height: 150,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 32),
                
                // Title
                Align(
  alignment: Alignment.center,
  child: Padding(
    padding: EdgeInsets.symmetric(horizontal: 16.0),
    child: Text(
      'Create your account',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        height: 1.3,
      ),
    ),
  ),
),

             
                const SizedBox(height: 40),

                // Role Selection
                _buildRoleSelection(),
                const SizedBox(height: 20),

                // Name Field
                _buildNameField(),
                const SizedBox(height: 20),

                // Age Field
                _buildAgeField(),
                const SizedBox(height: 20),

                // Email Field
                _buildEmailField(),
                const SizedBox(height: 20),

                // Password Field
                _buildPasswordField(),
                const SizedBox(height: 24),

                // Sign Up Button
                _buildSignUpButton(),
                const SizedBox(height: 32),

                // Login Link
                _buildLoginLink(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 8.0, bottom: 8.0),
          child: Text(
            'Select Role',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildRoleButton(
              "Instructor",
              "assets/images/output-onlinegiftools (3).gif",
              _selectedRole == "Instructor",
            ),
            const SizedBox(width: 20),
            _buildRoleButton(
              "Student",
              "assets/images/output-onlinegiftools (2).gif",
              _selectedRole == "Student",
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRoleButton(String role, String assetPath, bool isSelected) {
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedRole = role),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF6E5DE7).withOpacity(0.1) : Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? const Color(0xFF6E5DE7) : Colors.grey[300]!,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              Image.asset(assetPath, height: 60),
              const SizedBox(height: 8),
              Text(
                role,
                style: TextStyle(
                  color: isSelected ? const Color(0xFF6E5DE7) : Colors.grey[800],
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNameField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: TextFormField(
        controller: _nameController,
        decoration: _buildInputDecoration('Full Name', Icons.person),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your name';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildAgeField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: TextFormField(
        controller: _ageController,
        keyboardType: TextInputType.number,
        decoration: _buildInputDecoration('Age', Icons.numbers),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your age';
          }
          final age = int.tryParse(value);
          if (age == null || age < 20) {
            return 'Age must be at least 20';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildEmailField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: TextFormField(
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
        decoration: _buildInputDecoration('Email', Icons.email),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your email';
          }
          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
            return 'Please enter a valid email';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildPasswordField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: TextFormField(
        controller: _passwordController,
        obscureText: _obscurePassword,
        decoration: _buildInputDecoration(
          'Password',
          Icons.lock,
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword ? Icons.visibility_off : Icons.visibility,
              color: Colors.grey,
            ),
            onPressed: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter a password';
          }
           final regex = RegExp(
                            r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$',
                          );
                          return regex.hasMatch(value)  ? null
                              : "Password must include an uppercase letter, a number, and a special character";
        },
      ),
    );
  }

  Widget _buildSignUpButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _isLoading ? null : _handleSignUp,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF6E5DE7),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: _isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : const Text(
                  'Sign Up',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildLoginLink() {
    return Center(
      child: TextButton(
        onPressed: _isLoading
            ? null
            : () {
                Navigator.pushReplacementNamed(context, LoginPage.routeName);
              },
        child: const Text.rich(
          TextSpan(
            text: "Already have an account? ",
            style: TextStyle(color: Colors.black87),
            children: [
              TextSpan(
                text: 'Log in',
                style: TextStyle(
                  color: Color(0xFF6E5DE7),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String label, IconData icon, {Widget? suffixIcon}) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.grey[600]),
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      filled: true,
      fillColor: Colors.grey[50],
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }
}