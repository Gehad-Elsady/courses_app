import 'package:courses_app/Screens/Add%20courses/model/courses-model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';

class Overview extends StatelessWidget {
  const Overview({
    super.key,
    required this.courseInfo,
  });

  final CoursesModel courseInfo;

  @override
  Widget build(BuildContext context) {
    return Column(
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
                    Text(courseInfo.courseDuration,
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
                      AssetImage("assets/images/carbon_skill-level-basic.png"),
                      size: 30,
                    ),
                    const SizedBox(width: 25),
                    Text(courseInfo.courseLevel,
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
                    Text(courseInfo.price,
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
                    Text(courseInfo.courseField,
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
                    Text(courseInfo.courseLanguage,
                        style: GoogleFonts.roboto(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xff3F3F3F))),
                  ],
                ),
              ],
            )
          ],
        ),
        Spacer(),
        Row(
          children: [
            RatingBar.builder(
              initialRating: double.parse(courseInfo.rating),
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
                print(rating);
              },
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                // Handle rating logic
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Button color
                foregroundColor: Colors.white, // Text color
                padding: const EdgeInsets.symmetric(
                    horizontal: 24, vertical: 12), // Padding
                textStyle: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold), // Font styling
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
    );
  }
}

//  Rating use Stars
      // RatingBar.builder(
          //   initialRating: double.parse(courseInfo.rating) ??
          //       3, // Ensure it comes from courseInfo
          //   minRating: 1,
          //   direction: Axis.horizontal,
          //   allowHalfRating: true,
          //   itemCount: 5,
          //   itemBuilder: (context, _) =>
          //       const Icon(Icons.star, color: Colors.amber),
          //   onRatingUpdate: (rating) {
          //     print(rating);
          //   },
          // ),