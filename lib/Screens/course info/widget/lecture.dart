import 'package:courses_app/Screens/Add%20courses/model/courses-model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Lecture extends StatefulWidget {
  Lecture({
    super.key,
    required this.courseInfo,
  });
  final CoursesModel courseInfo;

  @override
  State<Lecture> createState() => _LectureState();
}

class _LectureState extends State<Lecture> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final text =
                  "Description \n ${widget.courseInfo.whatWillYouLearn}";
              final textSpan = TextSpan(
                text: text,
                style: GoogleFonts.roboto(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xff3F3F3F),
                ),
              );

              final textPainter = TextPainter(
                text: textSpan,

                maxLines: 4, // Show up to 4 lines before truncating
                textDirection: TextDirection.ltr,
              )..layout(maxWidth: constraints.maxWidth);

              final isOverflowing = textPainter.didExceedMaxLines;

              return RichText(
                text: TextSpan(
                  style: GoogleFonts.roboto(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xff3F3F3F),
                  ),
                  children: [
                    TextSpan(
                      text: isExpanded || !isOverflowing
                          ? text
                          : text.substring(
                                  0,
                                  textPainter.getOffsetBefore(150) ??
                                      text.length) +
                              "... ",
                    ),
                    if (isOverflowing)
                      WidgetSpan(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              isExpanded = !isExpanded;
                            });
                          },
                          child: Text(
                            isExpanded ? " Show Less" : " Read More",
                            style: GoogleFonts.roboto(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 15),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                    text: 'Requirements: \n',
                    style: GoogleFonts.roboto(
                        fontSize: 20, color: const Color(0xff3F3F3F))),
                TextSpan(
                    text: widget.courseInfo.requirements,
                    style: GoogleFonts.roboto(
                        fontSize: 14, color: const Color(0xff3F3F3F)))
              ],
            ),
          ),
          const SizedBox(height: 15),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                    text: 'After Course: \n',
                    style: GoogleFonts.roboto(
                        fontSize: 20, color: const Color(0xff3F3F3F))),
                TextSpan(
                    text: widget.courseInfo.afterCourse,
                    style: GoogleFonts.roboto(
                        fontSize: 14, color: const Color(0xff3F3F3F)))
              ],
            ),
          ),
          const SizedBox(height: 15),
          Divider(
            thickness: 2,
            color: Colors.black,
          ),
          Text("Lectures",
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xff3F3F3F))),
          Divider(
            thickness: 2,
            color: Colors.black,
          ),
          const SizedBox(height: 10),

          Row(
            children: [
              ImageIcon(
                AssetImage("assets/images/lesson.png"),
                size: 30,
              ),
              const SizedBox(width: 25),
              Text(
                  "Number of Lectures:   ${widget.courseInfo.numberOfLectures}",
                  style: GoogleFonts.roboto(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xff3F3F3F))),
            ],
          ),
          SizedBox(height: 15),
          Row(
            children: [
              Icon(
                Icons.access_time_sharp,
                size: 30,
              ),
              const SizedBox(width: 25),
              Text("Lecture Time:    ${widget.courseInfo.lectureDuration}",
                  style: GoogleFonts.roboto(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xff3F3F3F))),
            ],
          ),
          SizedBox(height: 15),

          Row(
            children: [
              Icon(
                Icons.calendar_month_outlined,
                size: 30,
              ),
              const SizedBox(width: 25),
              Text(
                  "Lectures in a week:    ${widget.courseInfo.numberOfLecturesInWeek}",
                  style: GoogleFonts.roboto(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xff3F3F3F))),
            ],
          ),

          // Text("Requirements: \n ${courseInfo.requirements}"),
        ],
      ),
    );
  }
}
