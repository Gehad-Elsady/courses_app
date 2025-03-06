// ignore_for_file: unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:courses_app/Screens/Add%20courses/model/courses-model.dart';
import 'package:courses_app/Screens/Auth/model/usermodel.dart';
import 'package:courses_app/Screens/Profile/model/profilemodel.dart';
import 'package:courses_app/Screens/contact/model/contact-model.dart';
import 'package:courses_app/Screens/my%20enroll%20courses/model/enroll_courses_model.dart';
import 'package:courses_app/Screens/my%20requestes/model/request_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseFunctions {
  //-----------------------------------------User Authentication--------------------------------
  static SignUp(String emailAddress, String password,
      {required Function onSuccess,
      required Function onError,
      required String userName,
      required String role,
      required int age}) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );

      credential.user?.sendEmailVerification();
      UserModel userModel = UserModel(
        age: age,
        email: emailAddress,
        name: userName,
        id: credential.user!.uid,
        role: role,
      );
      addUser(userModel);

      onSuccess();
    } on FirebaseAuthException catch (e) {
      onError(e.message);
    } catch (e) {
      print(e);
    }
  }

  static Login(
    String emailAddress,
    String password, {
    required Function onSuccess,
    required Function onError,
  }) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: emailAddress, password: password);
      onSuccess();
    } on FirebaseAuthException catch (e) {
      onError(e.message);
    }
  }

  static CollectionReference<UserModel> getUserCollection() {
    return FirebaseFirestore.instance
        .collection("Users")
        .withConverter<UserModel>(
      fromFirestore: (snapshot, options) {
        return UserModel.fromJason(snapshot.data()!);
      },
      toFirestore: (user, _) {
        return user.toJason();
      },
    );
  }

  static Future<void> addUser(UserModel user) {
    var collection = getUserCollection();
    var docRef = collection.doc(user.id);
    return docRef.set(user);
  }

  static Future<UserModel?> readUserData() async {
    var collection = getUserCollection();

    DocumentSnapshot<UserModel> docUser =
        await collection.doc(FirebaseAuth.instance.currentUser!.uid).get();
    return docUser.data();
  }

  static signOut() {
    FirebaseAuth.instance.signOut();
  }
  //-----------------------------------------User profile--------------------------------

  static CollectionReference<ProfileModel> getUserProfileCollection() {
    return FirebaseFirestore.instance
        .collection("UsersProfile")
        .withConverter<ProfileModel>(
      fromFirestore: (snapshot, options) {
        return ProfileModel.fromJson(snapshot.data()!);
      },
      toFirestore: (user, _) {
        return user.toJson();
      },
    );
  }

  static Future<void> addUserProfile(ProfileModel user) {
    var collection = getUserProfileCollection();
    var docRef = collection.doc(user.id);
    return docRef.set(user);
  }

  static Stream<ProfileModel?> getUserProfile(String uid) {
    return FirebaseFirestore.instance
        .collection('UsersProfile')
        .doc(uid)
        .snapshots()
        .map((userProfileSnapshot) {
      if (userProfileSnapshot.exists) {
        var data = userProfileSnapshot.data() as Map<String, dynamic>;
        return ProfileModel.fromJson(
            data); // Assuming ProfileModel has a fromJson constructor
      } else {
        print('User profile not found');
        return null; // Return null if the document does not exist
      }
    }).handleError((e) {
      print('Error fetching user profile: $e');
      return null; // Handle errors by returning null
    });
  }

  //-------------------------------Courses--------------------------------

  static Stream<List<CoursesModel>> getCourses() {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    try {
      // Query the collection without any filters
      return _firestore.collection('courses').snapshots().map((snapshot) {
        return snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return CoursesModel(
            userId: data['userId'] ?? "no id",
            name: data['name'] ?? 'No Name',
            image: data['image'] ?? 'default_image.png',
            description: data['description'] ?? 'No Description',
            price: data['price'] ?? 'No Price',
            afterCourse: data['afterCourse'] ?? 'No After Course',
            courseDuration: data['courseDuration'] ?? 'No Course Duration',
            courseLevel: data['courseLevel'] ?? 'No Course Level',
            courseField: data['courseField'] ?? 'No Course Field',
            courseLanguage: data['courseLanguage'] ?? 'No Course Language',
            courseOwnerName: data['courseOwnerName'] ?? 'No Course Owner Name',
            requirements: data['requirements'] ?? 'No Requirements',
            rating: data['rating'] ?? 'No Rating',
            numberOfLearners: data['numberOfLearners'] ?? 'No Learners',
            courseOwnerImage: data['courseOwnerImage'] ?? 'default_image.png',
            lectureDuration: data['lectureDuration'] ?? 'No Lecture Duration',
            numberOfLectures: data['numberOfLectures'] ?? 'No Lectures',
            whatWillYouLearn:
                data['whatWillYouLearn'] ?? 'No What Will You Learn',
            numberOfLecturesInWeek:
                data['numberOfLecturesInWeek'] ?? 'No Lectures In Week',
            createdAt: data['createdAt'] ?? 'No Created At',
            ableToShare: data['ableToShare'] ?? 'No Shared',
            courseLink: data['courseLink'] ?? 'No Course Link',
          );
        }).toList();
      });
    } catch (e) {
      print('Error fetching services: $e');
      // Return an empty stream or handle the error more specifically
      return Stream.error(
          'Error fetching courses: $e'); // You can replace this with custom error handling
    }
  }

  static Stream<List<CoursesModel>> getCategoryCourses(String category) {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    try {
      // Query the collection without any filters
      return _firestore
          .collection('courses')
          .where("courseField", isEqualTo: category)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return CoursesModel(
            userId: data['userId'] ?? "no id",
            name: data['name'] ?? 'No Name',
            image: data['image'] ?? 'default_image.png',
            description: data['description'] ?? 'No Description',
            price: data['price'] ?? 'No Price',
            afterCourse: data['afterCourse'] ?? 'No After Course',
            courseDuration: data['courseDuration'] ?? 'No Course Duration',
            courseLevel: data['courseLevel'] ?? 'No Course Level',
            courseField: data['courseField'] ?? 'No Course Field',
            courseLanguage: data['courseLanguage'] ?? 'No Course Language',
            courseOwnerName: data['courseOwnerName'] ?? 'No Course Owner Name',
            requirements: data['requirements'] ?? 'No Requirements',
            rating: data['rating'] ?? 'No Rating',
            numberOfLearners: data['numberOfLearners'] ?? 'No Learners',
            courseOwnerImage: data['courseOwnerImage'] ?? 'default_image.png',
            lectureDuration: data['lectureDuration'] ?? 'No Lecture Duration',
            numberOfLectures: data['numberOfLectures'] ?? 'No Lectures',
            whatWillYouLearn:
                data['whatWillYouLearn'] ?? 'No What Will You Learn',
            numberOfLecturesInWeek:
                data['numberOfLecturesInWeek'] ?? 'No Lectures In Week',
            createdAt: data['createdAt'] ?? 'No Created At',
            ableToShare: data['ableToShare'] ?? 'No Shared',
            courseLink: data['courseLink'] ?? 'No Course Link',
          );
        }).toList();
      });
    } catch (e) {
      print('Error fetching services: $e');
      // Return an empty stream or handle the error more specifically
      return Stream.error(
          'Error fetching courses: $e'); // You can replace this with custom error handling
    }
  }

  static Stream<Map<String, int>> getCourseCountsByField() {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final List<String> _courseFields = [
      'Computer Science',
      'Engineering',
      'Business Administration',
      'Medicine',
      'Law',
      'Arts',
      'Education',
      'Psychology',
      'Biotechnology',
      'Finance',
      'Others'
    ];

    try {
      return _firestore.collection('courses').snapshots().map((snapshot) {
        Map<String, int> courseFieldCounts = {
          for (var field in _courseFields) field: 0
        };

        for (var doc in snapshot.docs) {
          final data = doc.data() as Map<String, dynamic>;
          String courseField = data['courseField'] ?? 'Others';

          if (courseFieldCounts.containsKey(courseField)) {
            courseFieldCounts[courseField] =
                courseFieldCounts[courseField]! + 1;
          } else {
            courseFieldCounts['Others'] = courseFieldCounts['Others']! + 1;
          }
        }

        return courseFieldCounts;
      });
    } catch (e) {
      print('Error fetching course counts: $e');
      return Stream.error('Error fetching course counts: $e');
    }
  }

  static Stream<List<CoursesModel>> getMyCourses(String userId) {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    try {
      // Query the collection without any filters
      return _firestore
          .collection('courses')
          .where("userId", isEqualTo: userId)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return CoursesModel(
            userId: data['userId'] ?? "no id",
            name: data['name'] ?? 'No Name',
            image: data['image'] ?? 'default_image.png',
            description: data['description'] ?? 'No Description',
            price: data['price'] ?? 'No Price',
            afterCourse: data['afterCourse'] ?? 'No After Course',
            courseDuration: data['courseDuration'] ?? 'No Course Duration',
            courseLevel: data['courseLevel'] ?? 'No Course Level',
            courseField: data['courseField'] ?? 'No Course Field',
            courseLanguage: data['courseLanguage'] ?? 'No Course Language',
            courseOwnerName: data['courseOwnerName'] ?? 'No Course Owner Name',
            requirements: data['requirements'] ?? 'No Requirements',
            rating: data['rating'] ?? 'No Rating',
            numberOfLearners: data['numberOfLearners'] ?? 'No Learners',
            courseOwnerImage: data['courseOwnerImage'] ?? 'default_image.png',
            lectureDuration: data['lectureDuration'] ?? 'No Lecture Duration',
            numberOfLectures: data['numberOfLectures'] ?? 'No Lectures',
            whatWillYouLearn:
                data['whatWillYouLearn'] ?? 'No What Will You Learn',
            numberOfLecturesInWeek:
                data['numberOfLecturesInWeek'] ?? 'No Lectures In Week',
            createdAt: data['createdAt'] ?? 'No Created At',
            ableToShare: data['ableToShare'] ?? 'No Shared',
            courseLink: data['courseLink'] ?? 'No Course Link',
          );
        }).toList();
      });
    } catch (e) {
      print('Error fetching services: $e');
      // Return an empty stream or handle the error more specifically
      return Stream.error(
          'Error fetching courses: $e'); // You can replace this with custom error handling
    }
  }

  static Future<void> deleteCourse(Timestamp timestamp) async {
    final String uid = FirebaseAuth.instance.currentUser?.uid ?? '';

    if (uid.isEmpty) {
      print('User is not authenticated.');
      return;
    }

    try {
      // Get the document(s) that match the userId and itemId
      final querySnapshot = await FirebaseFirestore.instance
          .collection('courses')
          .where('createdAt', isEqualTo: timestamp)
          .where('userId',
              isEqualTo: uid) // Ensure the item belongs to the current user
          .get();

      if (querySnapshot.docs.isEmpty) {
        print('No items found to delete.');
        return;
      }

      // Delete each document found
      for (var doc in querySnapshot.docs) {
        await doc.reference.delete();
      }

      print('Courses deleted successfully!');
    } catch (e) {
      print('Error deleting Courses: $e');
    }
  }

  //---------------------------Contact---------------------------

  static Future<void> addProblem(ContactModel problem) async {
    try {
      await FirebaseFirestore.instance
          .collection('Problem')
          .doc()
          .withConverter<ContactModel>(
        fromFirestore: (snapshot, options) {
          return ContactModel.fromJson(snapshot.data()!);
        },
        toFirestore: (value, options) {
          return value.toJson();
        },
      ).set(problem);
      print('problem added successfully!');
    } catch (e) {
      print('Error adding problem: $e');
    }
  }

  //---------------------------Ratings---------------------------

  static Future<void> ratingCourse(
      Timestamp _createdAt, String rating, String userId) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('courses')
        .where('userId', isEqualTo: userId)
        .where('createdAt', isEqualTo: _createdAt)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // If the document exists, update it
      final docId = querySnapshot.docs.first.id;
      await FirebaseFirestore.instance
          .collection('courses')
          .doc(docId)
          .update({'rating': rating});
    }
  }

//---------------------------update learners number---------------------------
  static Future<void> learnersCourseNumber(
      Timestamp createdAt, String userId) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('courses')
          .where('userId', isEqualTo: userId)
          .where('createdAt', isEqualTo: createdAt)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first;
        final docId = doc.id;

        // Get the current number of learners as String and convert to int
        int currentLearners =
            int.tryParse(doc.data()?['numberOfLearners']?.toString() ?? '0') ??
                0;

        // Increment by 1
        currentLearners += 1;

        // Update Firestore document with new count as String
        await FirebaseFirestore.instance
            .collection('courses')
            .doc(docId)
            .update({'numberOfLearners': currentLearners.toString()});

        print('Learners updated successfully to $currentLearners');
      } else {
        print('No course found for the provided userId and createdAt.');
      }
    } catch (e) {
      print('Error updating learners count: $e');
    }
  }

  //---------------------------Share---------------------------
  static Future<void> shareCourse(
      Timestamp _createdAt, bool rating, String userId) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('courses')
        .where('userId', isEqualTo: userId)
        .where('createdAt', isEqualTo: _createdAt)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // If the document exists, update it
      final docId = querySnapshot.docs.first.id;
      await FirebaseFirestore.instance
          .collection('courses')
          .doc(docId)
          .update({'ableToShare': rating});
    }
  }

  static Stream<List<CoursesModel>> getSharedCourses() {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    try {
      // Query the collection without any filters
      return _firestore
          .collection('courses')
          .where("ableToShare", isEqualTo: true)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return CoursesModel(
            userId: data['userId'] ?? "no id",
            name: data['name'] ?? 'No Name',
            image: data['image'] ?? 'default_image.png',
            description: data['description'] ?? 'No Description',
            price: data['price'] ?? 'No Price',
            afterCourse: data['afterCourse'] ?? 'No After Course',
            courseDuration: data['courseDuration'] ?? 'No Course Duration',
            courseLevel: data['courseLevel'] ?? 'No Course Level',
            courseField: data['courseField'] ?? 'No Course Field',
            courseLanguage: data['courseLanguage'] ?? 'No Course Language',
            courseOwnerName: data['courseOwnerName'] ?? 'No Course Owner Name',
            requirements: data['requirements'] ?? 'No Requirements',
            rating: data['rating'] ?? 'No Rating',
            numberOfLearners: data['numberOfLearners'] ?? 'No Learners',
            courseOwnerImage: data['courseOwnerImage'] ?? 'default_image.png',
            lectureDuration: data['lectureDuration'] ?? 'No Lecture Duration',
            numberOfLectures: data['numberOfLectures'] ?? 'No Lectures',
            whatWillYouLearn:
                data['whatWillYouLearn'] ?? 'No What Will You Learn',
            numberOfLecturesInWeek:
                data['numberOfLecturesInWeek'] ?? 'No Lectures In Week',
            createdAt: data['createdAt'] ?? 'No Created At',
            ableToShare: data['ableToShare'] ?? 'No Shared',
            courseLink: data['courseLink'] ?? 'No Course Link',
          );
        }).toList();
      });
    } catch (e) {
      print('Error fetching services: $e');
      // Return an empty stream or handle the error more specifically
      return Stream.error(
          'Error fetching courses: $e'); // You can replace this with custom error handling
    }
  }
  //-------------------------------Enroll the course--------------------------------

  static CollectionReference<EnrollCoursesModel>
      getUserEnrollCoursesCollection() {
    return FirebaseFirestore.instance
        .collection("UsersEnrollCourses")
        .withConverter<EnrollCoursesModel>(
      fromFirestore: (snapshot, options) {
        return EnrollCoursesModel.fromJson(snapshot.data()!);
      },
      toFirestore: (user, _) {
        return user.toJson();
      },
    );
  }

  static Future<void> addEnrollCourse(EnrollCoursesModel course) {
    var collection = getUserEnrollCoursesCollection();
    var docRef = collection.doc();
    return docRef.set(course);
  }

  static Stream<List<EnrollCoursesModel>> getMyEnrollCourses(String uid) {
    return FirebaseFirestore.instance
        .collection('UsersEnrollCourses')
        .where('userId', isEqualTo: uid)
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        return EnrollCoursesModel.fromJson(data);
      }).toList();
    }).handleError((e) {
      print('Error fetching enrolled courses: $e');
      return <EnrollCoursesModel>[]; // Return an empty list on error
    });
  }

//-------------------------------Send shared requests--------------------------------
  static CollectionReference<RequestModel> sharesCourseRequestCollection() {
    return FirebaseFirestore.instance
        .collection("SharesCourseRequest")
        .withConverter<RequestModel>(
      fromFirestore: (snapshot, options) {
        return RequestModel.fromJson(snapshot.data()!);
      },
      toFirestore: (user, _) {
        return user.toJson();
      },
    );
  }

  static Future<void> addSharedRequest(RequestModel course) {
    var collection = sharesCourseRequestCollection();
    var docRef = collection.doc();
    return docRef.set(course);
  }

  static Stream<List<RequestModel>> getMySharedRequestCourses(String uid) {
    return FirebaseFirestore.instance
        .collection('SharesCourseRequest')
        .where('onwerId', isEqualTo: uid)
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        return RequestModel.fromJson(data);
      }).toList();
    }).handleError((e) {
      print('Error fetching enrolled courses: $e');
      return <RequestModel>[]; // Return an empty list on error
    });
  }

//-------------------------------accept shared request--------------------------------
  static Future<void> acceptSharedRequest(
      EnrollCoursesModel myCourse, EnrollCoursesModel sharedCourse) async {
    try {
      // add the to my list
      EnrollCoursesModel course1 = EnrollCoursesModel(
        coursesModel: sharedCourse.coursesModel,
        userId: sharedCourse.userId,
        createdAt: sharedCourse.createdAt,
      );
      addEnrollCourse(course1);
      // add course to the requester list
      EnrollCoursesModel course2 = EnrollCoursesModel(
        coursesModel: myCourse.coursesModel,
        userId: myCourse.userId,
        createdAt: myCourse.createdAt,
      );
      addEnrollCourse(course2);
    } catch (e) {
      print('Error accepting request: $e');
    }
  }

  static Future<void> deleteRequestCourse(String ownerId, String userId) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('SharesCourseRequest')
          .where('onwerId', isEqualTo: ownerId)
          .where('userId', isEqualTo: userId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Get the document ID
        final docId = querySnapshot.docs.first.id;
        // Delete the document
        await FirebaseFirestore.instance
            .collection('SharesCourseRequest')
            .doc(docId)
            .delete();
        print('Course deleted successfully');
      } else {
        print('No matching course found');
      }
    } catch (e) {
      print('Error deleting course: $e');
    }
  }
}
