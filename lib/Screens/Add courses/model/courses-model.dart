import 'package:cloud_firestore/cloud_firestore.dart';

class CoursesModel {
  String name;
  String image;
  String description;
  String price;
  String userId;
  String requirements;
  String afterCourse;
  String courseField;
  String courseDuration;
  String courseLanguage;
  String courseLevel;
  String courseOwnerName;
  String rating;
  String numberOfLearners;
  String whatWillYouLearn;
  String numberOfLectures;
  String lectureDuration;
  String courseOwnerImage;
  String numberOfLecturesInWeek;
  Timestamp createdAt;
  String ableToShare;

  CoursesModel(
      {required this.name,
      required this.image,
      required this.description,
      required this.userId,
      required this.courseLevel,
      required this.courseField,
      required this.courseDuration,
      required this.courseLanguage,
      required this.requirements,
      required this.afterCourse,
      required this.courseOwnerName,
      required this.rating,
      required this.numberOfLearners,
      required this.whatWillYouLearn,
      required this.numberOfLectures,
      required this.lectureDuration,
      required this.courseOwnerImage,
      required this.numberOfLecturesInWeek,
      required this.createdAt,
      required this.ableToShare,
      required this.price});
  factory CoursesModel.fromJson(Map<dynamic, dynamic> json) => CoursesModel(
        name: json['name'], //
        image: json['image'], //
        description: json['description'], //
        requirements: json['requirements'], //
        afterCourse: json['afterCourse'], //
        courseField: json['courseField'], //
        courseDuration: json['courseDuration'], //
        courseLanguage: json['courseLanguage'], //
        price: json['price'], //
        userId: json['userId'], //
        courseLevel: json['courseLevel'], //
        courseOwnerName: json['courseOwnerName'], //
        rating: json['rating'], //
        numberOfLearners: json['numberOfLearners'], //
        whatWillYouLearn: json['whatWillYouLearn'], //
        numberOfLectures: json['numberOfLectures'], //
        lectureDuration: json['lectureDuration'], //
        courseOwnerImage: json['courseOwnerImage'],
        numberOfLecturesInWeek: json['numberOfLecturesInWeek'], //
        createdAt: json['createdAt'], //
        ableToShare: json['ableToShare'], //
      );
  Map<String, dynamic> toJson() => {
        'name': name,
        'image': image,
        'description': description,
        'price': price,
        'userId': userId,
        'courseLevel': courseLevel,
        'courseField': courseField,
        'courseDuration': courseDuration,
        'courseLanguage': courseLanguage,
        'requirements': requirements,
        'afterCourse': afterCourse,
        'courseOwnerName': courseOwnerName,
        'rating': rating,
        'numberOfLearners': numberOfLearners,
        'whatWillYouLearn': whatWillYouLearn,
        'numberOfLectures': numberOfLectures,
        'lectureDuration': lectureDuration,
        'courseOwnerImage': courseOwnerImage,
        'numberOfLecturesInWeek': numberOfLecturesInWeek,
        'createdAt': createdAt,
        'ableToShare': ableToShare,
      };
}
