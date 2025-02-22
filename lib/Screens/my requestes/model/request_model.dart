import 'package:courses_app/Screens/Add%20courses/model/courses-model.dart';

class RequestModel {
  String name;
  CoursesModel sharedCours;
  String userId;
  String onwerId;
  CoursesModel myCourse;

  RequestModel({
    required this.name,
    required this.sharedCours,
    required this.userId,
    required this.onwerId,
    required this.myCourse,
  });

  factory RequestModel.fromJson(Map<dynamic, dynamic> json) => RequestModel(
        name: json['name'],
        sharedCours: CoursesModel.fromJson(json['sharedCours']),
        userId: json['userId'],
        onwerId: json['onwerId'],
        myCourse: CoursesModel.fromJson(json['myCourse']),
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'sharedCours': sharedCours.toJson(),
        'userId': userId,
        'onwerId': onwerId,
        'myCourse': myCourse.toJson(),
      };
}
