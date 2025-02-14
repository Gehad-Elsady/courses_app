// ignore_for_file: unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:courses_app/Screens/Add%20courses/model/courses-model.dart';
import 'package:courses_app/Screens/Auth/model/usermodel.dart';
import 'package:courses_app/Screens/Profile/model/profilemodel.dart';
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

  // static Stream<List<ServiceModel>> getCrops() {
  //   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //   try {
  //     // Query the collection where type is "Seeds"
  //     return _firestore
  //         .collection('services')
  //         .where('type', isEqualTo: 'crops') // Add this filter
  //         .snapshots()
  //         .map((snapshot) {
  //       return snapshot.docs.map((doc) {
  //         final data = doc.data() as Map<String, dynamic>;
  //         return ServiceModel(
  //           userId: data['userId'] ?? "no id",
  //           name: data['name'] ?? 'No Name',
  //           image: data['image'] ?? 'default_image.png',
  //           description: data['description'] ?? 'No Description',
  //           price: data['price'] ?? 'No Price',
  //           type: data['type'] ?? 'No Type',
  //         );
  //       }).toList();
  //     });
  //   } catch (e) {
  //     print('Error fetching services: $e');
  //     return const Stream.empty(); // Return an empty stream in case of error
  //   }
  // }

  // static Stream<List<ServiceModel>> getEquipment() {
  //   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //   try {
  //     // Query the collection where type is "Seeds"
  //     return _firestore
  //         .collection('services')
  //         .where('type', isEqualTo: 'Equipment') // Add this filter
  //         .snapshots()
  //         .map((snapshot) {
  //       return snapshot.docs.map((doc) {
  //         final data = doc.data() as Map<String, dynamic>;
  //         return ServiceModel(
  //           userId: data['userId'] ?? "no id",
  //           name: data['name'] ?? 'No Name',
  //           image: data['image'] ?? 'default_image.png',
  //           description: data['description'] ?? 'No Description',
  //           price: data['price'] ?? 'No Price',
  //           type: data['type'] ?? 'No Type',
  //         );
  //       }).toList();
  //     });
  //   } catch (e) {
  //     print('Error fetching services: $e');
  //     return const Stream.empty(); // Return an empty stream in case of error
  //   }
  // }

  // //--------------------------engineers--------------------------
  // static Stream<List<EngModel>> getSEngineerStream() {
  //   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //   return _firestore.collection('engineers').snapshots().map((snapshot) {
  //     return snapshot.docs.map((doc) {
  //       final data = doc.data() as Map<String, dynamic>;
  //       return EngModel(
  //         userId: data['userId'] ?? "no id",
  //         name: data['name'] ?? 'No Name',
  //         image: data['image'] ?? 'default_image.png', // Adjust if needed
  //         bio: data['bio'] ?? 'No Description',
  //         price: data['price'] ?? 'No Price',
  //         createdAt: data['createdAt'] ?? 'No Date',
  //         phone: data['phone'] ?? 'No Phone',
  //         address: data['address'] ?? 'No Address',
  //       );
  //     }).toList();
  //   });
  // }

  // //---------------------------Contact---------------------------

  // static Future<void> addProblem(ContactModel problem) async {
  //   try {
  //     await FirebaseFirestore.instance
  //         .collection('Problem')
  //         .doc()
  //         .withConverter<ContactModel>(
  //       fromFirestore: (snapshot, options) {
  //         return ContactModel.fromJson(snapshot.data()!);
  //       },
  //       toFirestore: (value, options) {
  //         return value.toJson();
  //       },
  //     ).set(problem);
  //     print('problem added successfully!');
  //   } catch (e) {
  //     print('Error adding problem: $e');
  //   }
  // }

  // //---------------------------Cart---------------------------

  // static Stream<List<CartModel>> getCardStream() {
  //   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //   final String uid = FirebaseAuth.instance.currentUser?.uid ?? '';
  //   return _firestore
  //       .collection('cart')
  //       .where('userId', isEqualTo: uid)
  //       .snapshots()
  //       .map((snapshot) {
  //     return snapshot.docs.map((doc) {
  //       final data = doc.data() as Map<String, dynamic>;
  //       return CartModel(
  //         userId: data['userId'] ?? "no id",
  //         serviceModel: ServiceModel.fromJson(data['serviceModel']),
  //         itemId: data['itemId'] ?? "no id",
  //       );
  //     }).toList();
  //   });
  // }

  // static Future<void> addCartService(CartModel model) async {
  //   // Get the highest existing itemId and increment it
  //   final cartCollection = FirebaseFirestore.instance.collection('cart');
  //   final snapshot =
  //       await cartCollection.orderBy('itemId', descending: true).limit(1).get();

  //   int newId = 1; // Default to 1 if no items are in the collection
  //   if (snapshot.docs.isNotEmpty) {
  //     final lastId = int.parse(snapshot.docs.first['itemId']);
  //     newId = lastId + 1;
  //   }

  //   final cartItem = CartModel(
  //     itemId: newId.toString(),
  //     serviceModel: model.serviceModel,
  //     userId: model.userId,
  //   );

  //   await cartCollection.add(cartItem.toMap());
  // }

  // static Future<void> deleteCartService(String itemId) async {
  //   final String uid = FirebaseAuth.instance.currentUser?.uid ?? '';

  //   if (uid.isEmpty) {
  //     print('User is not authenticated.');
  //     return;
  //   }

  //   try {
  //     // Get the document(s) that match the userId and itemId
  //     final querySnapshot = await FirebaseFirestore.instance
  //         .collection('cart')
  //         .where('itemId', isEqualTo: itemId)
  //         .where('userId',
  //             isEqualTo: uid) // Ensure the item belongs to the current user
  //         .get();

  //     if (querySnapshot.docs.isEmpty) {
  //       print('No items found to delete.');
  //       return;
  //     }

  //     // Delete each document found
  //     for (var doc in querySnapshot.docs) {
  //       await doc.reference.delete();
  //     }

  //     print('Service deleted successfully!');
  //   } catch (e) {
  //     print('Error deleting service: $e');
  //   }
  // }

  // static Future<void> checkOut(
  //     int totalPrice, Function onSuccess, Function onError) async {
  //   final String uid = FirebaseAuth.instance.currentUser?.uid ?? '';

  //   // Listen to the user profile stream
  //   await for (var profileData in getUserProfile(uid)) {
  //     if (profileData != null) {
  //       onSuccess(); // Profile is valid, proceed with success
  //       return; // Exit after success is handled
  //     } else {
  //       onError(); // Handle the error if profile data is null
  //       return; // Exit after error is handled
  //     }
  //   }
  // }

  // static Future<void> clearCart(String uid) async {
  //   final cartCollection = FirebaseFirestore.instance
  //       .collection('cart')
  //       .where('userId', isEqualTo: uid);
  //   await cartCollection.get().then((querySnapshot) {
  //     for (var doc in querySnapshot.docs) {
  //       doc.reference.delete();
  //     }
  //   });
  // }

  // //---------------------------History---------------------------
  // static Future<void> orderHistory(HistoryModel order) async {
  //   try {
  //     // Reference to the 'History' collection
  //     final historyCollection =
  //         FirebaseFirestore.instance.collection('History');

  //     // Debug log: Check collection size
  //     print('Fetching the highest existing order ID...');

  //     // Get the highest existing order ID
  //     final snapshot = await historyCollection
  //         .orderBy('id', descending: true)
  //         .limit(1)
  //         .get();

  //     int newId = 1; // Default to 1 if no orders exist
  //     if (snapshot.docs.isNotEmpty) {
  //       final lastId = snapshot.docs.first.data()['id'];

  //       // Debug log: Output the last ID
  //       print('Last order ID retrieved: $lastId');

  //       // Parse last ID safely and increment
  //       newId = (int.tryParse(lastId?.toString() ?? '0') ?? 0) + 1;

  //       // Debug log: Output the new ID
  //       print('New order ID to be used: $newId');
  //     }

  //     // Fetch user profile asynchronously
  //     final userProfile =
  //         await getUserProfile(FirebaseAuth.instance.currentUser!.uid).first;

  //     if (userProfile == null) {
  //       print('User profile not found!');
  //       return;
  //     }

  //     // Debug log: Output user profile
  //     print('User profile retrieved: ${userProfile.firstName}');

  //     // Create a new order
  //     final newOrder = HistoryModel(
  //       id: newId.toString(),
  //       userId: FirebaseAuth.instance.currentUser!.uid,
  //       items: order.items,
  //       orderType: order.orderType,
  //       serviceModel: order.serviceModel,
  //       locationModel: order.locationModel,
  //       timestamp: DateTime.now().millisecondsSinceEpoch,
  //       orderStatus: "Pending",
  //       orderOwnerName: userProfile.firstName,
  //       orderOwnerPhone: userProfile.phoneNumber,
  //     );

  //     // Add the new order to Firestore
  //     await historyCollection.add(newOrder.toJson());

  //     // Clear the user's cart
  //     await clearCart(FirebaseAuth.instance.currentUser!.uid);

  //     print('Order added successfully with ID: $newId');
  //   } catch (e) {
  //     print('Error adding order: $e');
  //   }
  // }

  // static Stream<List<HistoryModel>> getHistoryStream() {
  //   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //   final String uid = FirebaseAuth.instance.currentUser?.uid ?? '';

  //   return _firestore
  //       .collection('History')
  //       .where('userId', isEqualTo: uid) // Filter by current user's ID
  //       .snapshots()
  //       .map((snapshot) {
  //     return snapshot.docs.map((doc) {
  //       final data = doc.data();
  //       return HistoryModel(
  //         timestamp: data['timestamp'] ?? 0,
  //         userId: data['userId'] ?? "no id",
  //         serviceModel: data['serviceModel'] != null
  //             ? ServiceModel.fromJson(data['serviceModel'])
  //             : null,
  //         locationModel: data['locationModel'] != null
  //             ? LocationModel.fromMap(data['locationModel'])
  //             : null,
  //         items: data['items'] != null
  //             ? (data['items'] as List<dynamic>)
  //                 .map((item) => CartModel.fromMap(item))
  //                 .toList()
  //             : [],
  //         orderType: data['OrderType'] ?? "No Order Type",
  //         id: data['id'] ?? "No Id",
  //         orderStatus: data['orderStatus'] ?? "No Status",
  //         orderOwnerName: data['orderOwnerName'] ?? "No Name",
  //         orderOwnerPhone: data['orderOwnerPhone'] ?? "No Phone",
  //       );
  //     }).toList();
  //   });
  // }

  // //-----------------------Add land-----------------------
  // static Future<void> addLand(AddLandModel land) async {
  //   try {
  //     await FirebaseFirestore.instance
  //         .collection('lands')
  //         .doc()
  //         .withConverter<AddLandModel>(
  //       fromFirestore: (snapshot, options) {
  //         return AddLandModel.fromJson(snapshot.data()!);
  //       },
  //       toFirestore: (value, options) {
  //         return value.toJson();
  //       },
  //     ).set(land);
  //     print('problem added successfully!');
  //   } catch (e) {
  //     print('Error adding problem: $e');
  //   }
  // }

  // static Stream<List<AddLandModel>> getLandStream() {
  //   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //   return _firestore.collection('lands').snapshots().map((snapshot) {
  //     return snapshot.docs.map((doc) {
  //       final data = doc.data();
  //       return AddLandModel(
  //         address: data['address'] ?? "No Address",
  //         description: data['description'] ?? "No Description",
  //         image: data['image'] ?? "No Image",
  //         price: data['price'] ?? "No Price",
  //         investmentType: data['investmentType'] ?? "No Investment Type",
  //         locationModel: data['locationModel'] != null
  //             ? LocationModel.fromMap(data['locationModel'])
  //             : null,
  //       );
  //     }).toList();
  //   });
  // }
}
