import 'package:courses_app/Screens/Add%20courses/model/courses-model.dart';
import 'package:courses_app/backend/firebase_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class EnrollOverview extends StatefulWidget {
  EnrollOverview({super.key, required this.courseInfo, this.isShared});

  final CoursesModel courseInfo;
  bool? isShared = false;

  @override
  State<EnrollOverview> createState() => _EnrollOverviewState();
}

class _EnrollOverviewState extends State<EnrollOverview> {
  String rating = '';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 30,
                      ),
                      const SizedBox(width: 25),
                      Text(widget.courseInfo.courseDuration,
                          style: GoogleFonts.roboto(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xff3F3F3F))),
                    ],
                  ),
                  const SizedBox(height: 17),
                  Row(
                    children: [
                      ImageIcon(
                        AssetImage(
                            "assets/images/carbon_skill-level-basic.png"),
                        size: 30,
                      ),
                      const SizedBox(width: 25),
                      Text(widget.courseInfo.courseLevel,
                          style: GoogleFonts.roboto(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xff3F3F3F))),
                    ],
                  ),
                  const SizedBox(height: 17),
                  Row(
                    children: [
                      Icon(
                        Icons.price_check_rounded,
                        size: 30,
                      ),
                      const SizedBox(width: 25),
                      Text(widget.courseInfo.price,
                          style: GoogleFonts.roboto(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xff3F3F3F))),
                    ],
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ImageIcon(
                        AssetImage("assets/images/training-course.png"),
                        size: 30,
                      ),
                      const SizedBox(width: 25),
                      Text(widget.courseInfo.courseField,
                          style: GoogleFonts.roboto(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xff3F3F3F))),
                    ],
                  ),
                  const SizedBox(height: 17),
                  Row(
                    children: [
                      Icon(
                        Icons.language_outlined,
                        size: 30,
                      ),
                      const SizedBox(width: 25),
                      Text(widget.courseInfo.courseLanguage,
                          style: GoogleFonts.roboto(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xff3F3F3F))),
                    ],
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 40,
          ),
          GestureDetector(
            onTap: () async {
              final Uri url = Uri.parse(widget.courseInfo.courseLink);
              if (await canLaunchUrl(url)) {
                await launchUrl(url, mode: LaunchMode.externalApplication);
              } else {
                throw 'Could not launch ';
              }
            },
            child: Text(
              "Course Sessions Link",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.blue, // Make it look like a link
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          SizedBox(
            height: 40,
          ),
          Row(
            children: [
              RatingBar.builder(
                initialRating: 0,
                itemCount: 5,
                itemBuilder: (context, index) {
                  switch (index) {
                    case 0:
                      return const Icon(Icons.sentiment_very_dissatisfied,
                          color: Colors.red);
                    case 1:
                      return const Icon(Icons.sentiment_dissatisfied,
                          color: Colors.redAccent);
                    case 2:
                      return const Icon(Icons.sentiment_neutral,
                          color: Colors.amber);
                    case 3:
                      return const Icon(Icons.sentiment_satisfied,
                          color: Colors.lightGreen);
                    case 4:
                      return const Icon(Icons.sentiment_very_satisfied,
                          color: Colors.green);
                    default:
                      return const Icon(Icons.star, color: Colors.grey);
                  }
                },
                onRatingUpdate: (rating) {
                  setState(() {
                    this.rating = rating.toStringAsFixed(1);
                  });
                  print(rating);
                },
              ),
              Spacer(),
              ElevatedButton(
                onPressed: () {
                  // Handle rating logic
                  FirebaseFunctions.ratingCourse(widget.courseInfo.createdAt,
                      rating, widget.courseInfo.userId);
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Course Rated successfully')));

                  print(rating);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Button color
                  foregroundColor: Colors.white, // Text color
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 12), // Padding
                  textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold), // Font styling
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // Rounded corners
                  ),
                  elevation: 5, // Shadow effect
                ),
                child: const Text("Rate Now"),
              )
            ],
          )
        ],
      ),
    );
  }
}
