import 'package:cached_network_image/cached_network_image.dart';
import 'package:courses_app/Screens/Add%20courses/model/courses-model.dart';
import 'package:courses_app/Screens/course%20info/widget/lecture.dart';
import 'package:courses_app/Screens/course%20info/widget/overview.dart';
import 'package:courses_app/Screens/course%20owner/course_owner_profile.dart';
import 'package:courses_app/Screens/shared%20courses/widget/share_lecture.dart';
import 'package:courses_app/Screens/shared%20courses/widget/share_overview.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SharesCourseInfoScreen extends StatefulWidget {
  static const String routeName = 'shared-course-info-screen';
  SharesCourseInfoScreen({super.key});

  @override
  State<SharesCourseInfoScreen> createState() => _SharesCourseInfoScreenState();
}

class _SharesCourseInfoScreenState extends State<SharesCourseInfoScreen> {
  @override
  Widget build(BuildContext context) {
    var courseInfo = ModalRoute.of(context)!.settings.arguments as CoursesModel;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                height: 300,
                imageUrl: courseInfo.image,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(courseInfo.name,
                      style: GoogleFonts.roboto(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xff3F3F3F))),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Row(
                        children: [
                          Text('${courseInfo.rating}',
                              style: GoogleFonts.roboto(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xff3F3F3F))),
                          const SizedBox(width: 5),
                          const Icon(
                            Icons.star,
                            color: Color(0xffFF9900),
                          )
                        ],
                      ),
                      const SizedBox(width: 22),
                      Text("${courseInfo.numberOfLearners} Learners",
                          style: GoogleFonts.roboto(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xff3F3F3F)))
                    ],
                  ),
                  const SizedBox(height: 15),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, CourseOwnerProfile.routeName,
                          arguments: courseInfo.userId);
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: CachedNetworkImageProvider(
                              courseInfo.courseOwnerImage),
                        ),
                        const SizedBox(width: 10),
                        Text(courseInfo.courseOwnerName,
                            style: GoogleFonts.roboto(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xff3F3F3F)))
                      ],
                    ),
                  )
                ],
              ),
            ),
            // const SizedBox(height: 10),
            TabBar(
              indicatorColor: Colors.deepPurple,
              indicatorWeight: 3.0,
              labelColor: Colors.deepPurple,
              unselectedLabelColor: Colors.black,
              labelStyle: GoogleFonts.roboto(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              tabs: const [
                Tab(text: 'Overview'),
                Tab(text: 'Lectures'),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TabBarView(
                  children: [
                    SharedOverview(courseInfo: courseInfo),
                    SharedLecture(courseInfo: courseInfo),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
    // LayoutBuilder(
    //         builder: (context, constraints) {
    //           final text =
    //               "What will I learn? \n ${courseInfo.whatWillYouLearn}";
    //           final textSpan = TextSpan(
    //             text: text,
    //             style: GoogleFonts.roboto(
    //               fontSize: 14,
    //               fontWeight: FontWeight.normal,
    //               color: const Color(0xff3F3F3F),
    //             ),
    //           );
    
    //           final textPainter = TextPainter(
    //             text: textSpan,
    //             maxLines:
    //                 4, // Show up to 4 lines before truncating
    //             textDirection: TextDirection.ltr,
    //           )..layout(maxWidth: constraints.maxWidth);
    
    //           final isOverflowing =
    //               textPainter.didExceedMaxLines;
    
    //           return RichText(
    //             text: TextSpan(
    //               style: GoogleFonts.roboto(
    //                 fontSize: 14,
    //                 fontWeight: FontWeight.normal,
    //                 color: const Color(0xff3F3F3F),
    //               ),
    //               children: [
    //                 TextSpan(
    //                   text: isExpanded || !isOverflowing
    //                       ? text
    //                       : text.substring(
    //                               0,
    //                               textPainter.getOffsetBefore(
    //                                       150) ??
    //                                   text.length) +
    //                           "... ",
    //                 ),
    //                 if (isOverflowing)
    //                   WidgetSpan(
    //                     child: GestureDetector(
    //                       onTap: () {
    //                         setState(() {
    //                           isExpanded = !isExpanded;
    //                         });
    //                       },
    //                       child: Text(
    //                         isExpanded
    //                             ? " Show Less"
    //                             : " Read More",
    //                         style: GoogleFonts.roboto(
    //                           fontSize: 14,
    //                           fontWeight: FontWeight.bold,
    //                           color: Colors.blue,
    //                         ),
    //                       ),
    //                     ),
    //                   ),
    //               ],
    //             ),
    //           );
    //         },
    //       ),
