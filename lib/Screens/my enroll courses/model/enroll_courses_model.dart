import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:courses_app/Screens/Add%20courses/model/courses-model.dart';

class EnrollCoursesModel {
  CoursesModel coursesModel;
  String userId;
  Timestamp createdAt;

  EnrollCoursesModel(
      {required this.coursesModel,
      required this.userId,
      required this.createdAt});

  EnrollCoursesModel.fromJson(Map<dynamic, dynamic> json)
      : this(
            coursesModel: CoursesModel.fromJson(json['coursesModel']),
            userId: json['userId'],
            createdAt: json['createdAt']);

  Map<String, dynamic> toJson() {
    return {
      "coursesModel": coursesModel.toJson(),
      "userId": userId,
      "createdAt": createdAt,
    };
  }
}
