import 'package:courses_app/Screens/Add%20courses/addscoursesscreen.dart';
import 'package:courses_app/Screens/Auth/login-screen.dart';
import 'package:courses_app/Screens/Profile/student-profile-screen.dart';
import 'package:courses_app/Screens/my%20courses/my_courses_screen.dart';
import 'package:courses_app/backend/firebase_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsTab extends StatelessWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFADE8F4),
              Color(0xFFCAF0F8),
              Color(0xFF90E0EF),
              Color(0xFF48CAE4),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 60.0),
              StreamBuilder(
                stream: FirebaseFunctions.getUserProfile(
                    FirebaseAuth.instance.currentUser?.uid ?? ''),
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data == null) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  var userData = snapshot.data!;
                  return Row(
                    children: [
                      CircleAvatar(
                        radius: 50.0,
                        backgroundImage: userData.profileImage.isNotEmpty
                            ? NetworkImage(userData.profileImage)
                            : const AssetImage('assets/default_profile.png')
                                as ImageProvider,
                      ),
                      const SizedBox(width: 18.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${userData.firstName} ${userData.lastName}',
                              style: const TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5.0),
                            Text(
                              userData.email,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 16.0,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 15.0),
              const Divider(color: Colors.grey, thickness: 1.5),
              Expanded(
                child: ListView(
                  children: [
                    _buildProfileOption(Icons.person, 'Profile', () {
                      Navigator.pushNamed(context, StudentProfile.routeName);
                    }),
                    _buildProfileOption(
                        Icons.my_library_add_outlined, 'Add Courses', () {
                      Navigator.pushNamed(context, AddCoursesPage.routeName);
                    }),
                    _buildProfileOption(Icons.book, 'My Courses', () {
                      Navigator.pushNamed(context, MyCoursesScreen.routeName);
                    }),
                    _buildProfileOption(
                        Icons.request_page, 'My Requests', () {}),
                    _buildProfileOption(
                        Icons.contact_mail, 'Contact Us', () {}),
                    _buildProfileOption(Icons.logout, 'Logout', () async {
                      await FirebaseAuth.instance.signOut();
                      Navigator.pushReplacementNamed(
                          context, LoginPage.routeName);
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileOption(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(
        icon,
        color: const Color(0xff03045E),
        size: 28,
      ),
      title: Text(
        title,
        style: GoogleFonts.roboto(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      trailing:
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black),
      onTap: onTap,
    );
  }
}
