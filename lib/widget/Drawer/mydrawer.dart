import 'package:courses_app/Screens/Add%20courses/addscoursesscreen.dart';
import 'package:courses_app/Screens/Auth/login-screen.dart';
import 'package:courses_app/Screens/Profile/student-profile-screen.dart';
import 'package:courses_app/Screens/home/home-screen.dart';
import 'package:courses_app/backend/firebase_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'social-media-icons.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              StreamBuilder(
                  stream: FirebaseFunctions.getUserProfile(
                      FirebaseAuth.instance.currentUser!.uid),
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data != null) {
                      return DrawerHeader(
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.black, width: 3),
                          ),
                          color: Colors.white,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundImage: NetworkImage(
                                snapshot.data!.profileImage,
                              ),
                            ),
                            Text(
                              snapshot.data!.email,
                              style: GoogleFonts.domine(
                                fontSize: 20,
                                color: Colors.black,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      );
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const DrawerHeader(
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    } else {
                      return const DrawerHeader(
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                        child: CircleAvatar(
                            radius: 40,
                            backgroundImage: NetworkImage(
                              'https://static.vecteezy.com/system/resources/thumbnails/005/720/408/small_2x/crossed-image-icon-picture-not-available-delete-picture-symbol-free-vector.jpg',
                            )),
                      );
                    }
                  }),
              ListTile(
                title: Text(
                  'Home',
                  style: GoogleFonts.domine(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                leading: const Icon(Icons.home, color: Colors.blue),
                onTap: () {
                  Navigator.pushReplacementNamed(
                      context, HomeScreen.routeName); // Navigate to Home
                },
              ),
              ListTile(
                title: Text(
                  'Cart',
                  style: GoogleFonts.domine(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                leading: const Icon(Icons.shopping_cart_outlined,
                    color: Colors.blue),
                onTap: () {
                  // Navigator.pop(context);
                  // Navigator.pushNamed(context, CartScreen.routeName);
                },
              ),
              ListTile(
                title: Text(
                  'History',
                  style: GoogleFonts.domine(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                leading: const Icon(Icons.history_toggle_off_outlined,
                    color: Colors.blue),
                onTap: () {
                  // Navigator.pop(context);
                  // Navigator.pushNamed(context, HistoryScreen.routeName);
                },
              ),
              ListTile(
                title: Text(
                  'Add Course',
                  style: GoogleFonts.domine(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                leading: const Icon(Icons.store, color: Colors.blue),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, AddCoursesPage.routeName);
                },
              ),
              // ListTile(
              //   title: Text(
              //     'Shared Land',
              //     style: GoogleFonts.domine(
              //       fontSize: 20,
              //       color: Colors.black,
              //       fontWeight: FontWeight.bold,
              //     ),
              //   ),
              //   leading: ImageIcon(
              //       AssetImage(
              //           "assets/images/environmental-stewardship_18455514.png"),
              //       color: Color(0xFF56ab91)),
              //   onTap: () {
              //     // Navigator.pop(context);
              //     // Navigator.pushNamed(context, AddLandPage.routeName);
              //   },
              // ),
              ListTile(
                title: Text(
                  'Settings',
                  style: GoogleFonts.domine(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                leading: const Icon(Icons.settings, color: Colors.blue),
                onTap: () {},
              ),
              ListTile(
                title: Text(
                  'Contact Us',
                  style: GoogleFonts.domine(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                leading: const Icon(Icons.contact_page, color: Colors.blue),
                onTap: () {
                  // Navigator.pop(context);
                  // Navigator.pushNamed(context, ContactScreen.routeName);
                },
              ),
              Divider(
                thickness: 2,
                color: Colors.black,
              ), // Adds a horizontal line
              ListTile(
                leading: const Icon(Icons.account_circle, color: Colors.blue),
                title: Text(
                  'Profile',
                  style: GoogleFonts.domine(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  // Handle navigation to Profile
                  Navigator.pop(context);
                  Navigator.pushNamed(context, StudentProfile.routeName);
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.blue),
                title: Text(
                  'Logout',
                  style: GoogleFonts.domine(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  FirebaseFunctions.signOut();
                  Navigator.pushReplacementNamed(context, LoginPage.routeName);
                },
              ),
              // Spacer(),
              SizedBox(height: 45),
              SocialMediaIcons(),
            ],
          ),
        ),
      ),
    );
  }
}
