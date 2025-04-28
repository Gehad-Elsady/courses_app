import 'package:courses_app/Screens/Add%20courses/model/courses-model.dart';
import 'package:courses_app/Screens/content/content_screen.dart';
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

  List<String> _sessionsThisWeek() {
    DateTime startDate =
        widget.courseInfo.createdAt.toDate(); // Convert Timestamp to DateTime
    int lecturesPerWeek =
        int.tryParse(widget.courseInfo.numberOfLecturesInWeek) ?? 1;

    int weeksPassed = DateTime.now().difference(startDate).inDays ~/ 7;
    int totalSessions = ((weeksPassed + 1) * lecturesPerWeek)
        .clamp(0, widget.courseInfo.sessionsLinks.length);

    return widget.courseInfo.sessionsLinks.sublist(0, totalSessions);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Course Details
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _infoRow(Icon(Icons.access_time),
                        widget.courseInfo.courseDuration),
                    SizedBox(height: 12),
                    _infoRow(
                        ImageIcon(AssetImage(
                            "assets/images/carbon_skill-level-basic.png")),
                        widget.courseInfo.courseLevel),
                    SizedBox(height: 12),
                    _infoRow(Icon(Icons.price_check_rounded),
                        widget.courseInfo.price),
                  ],
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _infoRow(
                        ImageIcon(
                            AssetImage("assets/images/training-course.png")),
                        widget.courseInfo.courseField),
                    SizedBox(height: 12),
                    _infoRow(Icon(Icons.language_outlined),
                        widget.courseInfo.courseLanguage),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 30),

          // Sessions List
          Text(
            'Available Sessions This Week',
            style: GoogleFonts.roboto(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: _sessionsThisWeek().length,
            itemBuilder: (context, index) {
              final link = _sessionsThisWeek()[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ElevatedButton.icon(
                  icon: Icon(Icons.play_circle_fill),
                  label: Text("Session ${index + 1}"),
                  onPressed: () async {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return ContentScreen(
                            videoUrl: _sessionsThisWeek()[index]);
                      },
                    ));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey[800],
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              );
            },
          ),

          SizedBox(height: 30),

          // Rating Bar
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
                onRatingUpdate: (value) {
                  setState(() {
                    rating = value.toStringAsFixed(1);
                  });
                },
              ),
              Spacer(),
              ElevatedButton(
                onPressed: () {
                  FirebaseFunctions.ratingCourse(
                    widget.courseInfo.createdAt,
                    rating,
                    widget.courseInfo.userId,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Course rated successfully')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                ),
                child: const Text("Rate Now"),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoRow(Widget icon, String text) {
    return Row(
      children: [
        icon is Icon ? icon : icon as Widget,
        SizedBox(width: 16),
        Flexible(
          child: Text(
            text,
            style: GoogleFonts.roboto(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: const Color(0xff3F3F3F),
            ),
          ),
        ),
      ],
    );
  }
}
