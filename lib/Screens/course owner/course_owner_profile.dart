import 'package:cached_network_image/cached_network_image.dart';
import 'package:courses_app/Screens/Profile/model/profilemodel.dart';
import 'package:courses_app/Screens/home/widget/course_item.dart';
import 'package:courses_app/backend/firebase_functions.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CourseOwnerProfile extends StatelessWidget {
  static const String routeName = 'course-owner-profile';
  const CourseOwnerProfile({super.key});

  @override
  Widget build(BuildContext context) {
    var userId = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
        appBar: AppBar(
            // title: Text('Course Owner Profile'),
            ),
        body: StreamBuilder(
          stream: FirebaseFunctions.getUserProfile(userId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (!snapshot.hasData || snapshot.data == null) {
              return Center(child: Text('User profile not found'));
            }

            ProfileModel userProfile = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Stack(
                    alignment: AlignmentDirectional.bottomStart,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(40),
                        child: Image.network(
                          "https://images.unsplash.com/photo-1519389950473-47ba0277781c?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                          width: double
                              .infinity, // Ensure the image takes full width
                          height: 250, // Adjust the height as needed
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(40),
                        ),

                        height: 250, // Match the image height
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Align(
                          alignment: Alignment
                              .bottomLeft, // Position in the bottom right
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 60,
                                backgroundImage: CachedNetworkImageProvider(
                                    userProfile.profileImage),
                              ),
                              SizedBox(width: 10),
                              Text(
                                "${userProfile.firstName} ${userProfile.lastName}",
                                style: GoogleFonts.roboto(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                              text: 'Bio:\n',
                              style: GoogleFonts.roboto(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xff3F3F3F))),
                          TextSpan(
                              text: userProfile.bio,
                              style: GoogleFonts.roboto(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xff3F3F3F)))
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Text("Study Field:   ${userProfile.studyFiled}",
                        style: GoogleFonts.roboto(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xff3F3F3F))),
                  ),
                  SizedBox(height: 20),
                  Divider(
                    thickness: 2,
                    color: Colors.grey[500],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Text("Contact Information",
                        style: GoogleFonts.roboto(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xff3F3F3F))),
                  ),
                  Divider(
                    thickness: 2,
                    color: Colors.grey[500],
                  ),
                  SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Text("Address:   ${userProfile.address}",
                        style: GoogleFonts.roboto(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xff3F3F3F))),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Text("Phone Number:   ${userProfile.phoneNumber}",
                        style: GoogleFonts.roboto(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xff3F3F3F))),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Text("Contact Email:   ${userProfile.email}",
                        style: GoogleFonts.roboto(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xff3F3F3F))),
                  ),
                  SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Text("Owned Courses",
                        style: GoogleFonts.roboto(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xff3F3F3F))),
                  ),
                  Divider(
                    thickness: 2,
                    color: Colors.grey[500],
                  ),
                  StreamBuilder(
                      stream: FirebaseFunctions.getMyCourses(userId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else if (snapshot.data == null ||
                            snapshot.data!.isEmpty) {
                          return Center(child: Text('No services available'));
                        } else {
                          return SizedBox(
                            height:
                                200, // Slightly increased height for better spacing
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                final course = snapshot.data![index];
                                return CourseItem(course: course);
                              },
                            ),
                          );
                        }
                      }),
                  SizedBox(height: 20),
                ],
              ),
            );
          },
        ));
  }
}
