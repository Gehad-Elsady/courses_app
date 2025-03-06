import 'dart:io';
import 'package:courses_app/Screens/Profile/model/profilemodel.dart';
import 'package:courses_app/Screens/my%20courses/my_courses_screen.dart';
import 'package:courses_app/backend/firebase_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddCoursesPage extends StatefulWidget {
  static const String routeName = 'AddServicePage';

  @override
  _AddCoursesPageState createState() => _AddCoursesPageState();
}

class _AddCoursesPageState extends State<AddCoursesPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _requirementsController = TextEditingController();
  final TextEditingController _afterCourseController = TextEditingController();
  final TextEditingController _courseLanguageController =
      TextEditingController();
  final TextEditingController _whatWillLearnController =
      TextEditingController();
  final TextEditingController _numberOfLecturesController =
      TextEditingController();
  final TextEditingController _lectureDurationController =
      TextEditingController();
  final TextEditingController _numberOfLearnersInWeekController =
      TextEditingController();
  final TextEditingController _courseLinkController = TextEditingController();

  File? _image;
  final ImagePicker _picker = ImagePicker();
  bool _isUploading = false;

  String? _selectedCourseField;
  String? _selectedCourseLevel;

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
    'Finance'
  ];

  final List<String> _courseLevels = [
    'Beginner',
    'Intermediate',
    'Advanced',
    'Expert',
    'Diploma',
    'Undergraduate',
    'Postgraduate',
    'Doctorate'
  ];

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<String?> _uploadImage(File image) async {
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('course_images/${DateTime.now().millisecondsSinceEpoch}.jpg');
      final uploadTask = await storageRef.putFile(image);
      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
  }

  Future<void> _saveCourse() async {
    if (_formKey.currentState!.validate() &&
        _image != null &&
        _selectedCourseField != null) {
      setState(() => _isUploading = true);
      final imageUrl = await _uploadImage(_image!);
      ProfileModel? userProfile = await FirebaseFunctions.getUserProfile(
              FirebaseAuth.instance.currentUser!.uid)
          .first;

      if (imageUrl != null) {
        await FirebaseFirestore.instance.collection('courses').add({
          'name': _nameController.text.trim(),
          'description': _descriptionController.text.trim(),
          'price': _priceController.text.trim(),
          'courseField': _selectedCourseField,
          'image': imageUrl,
          'createdAt': Timestamp.now(),
          'userId': FirebaseAuth.instance.currentUser!.uid,
          'courseLevel': _selectedCourseLevel,
          'courseDuration': _durationController.text.trim(),
          'requirements': _requirementsController.text.trim(),
          'afterCourse': _afterCourseController.text.trim(),
          'courseLanguage': _courseLanguageController.text.trim(),
          'courseOwnerName':
              "${userProfile?.firstName} ${userProfile?.lastName}",
          'rating': "0",
          'numberOfLearners': "0",
          "whatWillYouLearn": _whatWillLearnController.text.trim(),
          "numberOfLectures": _numberOfLecturesController.text.trim(),
          "lectureDuration": _lectureDurationController.text.trim(),
          "numberOfLecturesInWeek":
              _numberOfLearnersInWeekController.text.trim(),
          "courseOwnerImage": userProfile?.profileImage,
          "ableToShare": false,
          "sessionLink": _courseLinkController,
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Course added successfully')));

        _nameController.clear();
        _descriptionController.clear();
        _priceController.clear();
        _durationController.clear();
        _requirementsController.clear();
        _afterCourseController.clear();
        _courseLanguageController.clear();
        _whatWillLearnController.clear();
        _numberOfLecturesController.clear();
        _lectureDurationController.clear();
        _numberOfLearnersInWeekController.clear();
        _image = null;
        _selectedCourseField = null;
        _selectedCourseLevel = null;
        Navigator.pushReplacementNamed(context, MyCoursesScreen.routeName);
        // Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Failed to upload image')));
      }
      setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Color(0xFF90E0EF),
          elevation: 5,
          shadowColor: Color(0xff03045E),
          centerTitle: true,
          title: Text(
            'Add Course',
            style: GoogleFonts.domine(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          )),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFADE8F4),
                  Color(0xFFCAF0F8),
                  Color(0xFF90E0EF),
                  Color(0xFF90E0EF),
                  Color(0xFF48CAE4),
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  // crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildTextField(
                        _nameController, 'Course Name', "Course Name"),
                    _buildTextField(_descriptionController, 'Description',
                        "Course Description",
                        maxLines: 3),
                    _buildTextField(_whatWillLearnController,
                        'What Will You Learn', "Benefits Of The Course",
                        maxLines: 3),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            _numberOfLecturesController,
                            'Number of Lectures',
                            "Lectures of the Course",
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: _buildTextField(_lectureDurationController,
                              'Lecture Duration', "Duration in minutes "),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            _numberOfLearnersInWeekController,
                            'Lecture in Week',
                            "Number of Lectures",
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: _buildTextField(
                              _priceController, 'Price', "Total Price",
                              inputType: TextInputType.number),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: _buildTextField(_durationController,
                                'Duration', "Duration in days")),
                        SizedBox(width: 16),
                        Expanded(
                            child: _buildTextField(_courseLanguageController,
                                'Course Language', "Course Language")),
                      ],
                    ),
                    _buildDropdownField(
                        'Course Field',
                        _courseFields,
                        _selectedCourseField,
                        (value) =>
                            setState(() => _selectedCourseField = value)),
                    _buildDropdownField(
                        'Course Level',
                        _courseLevels,
                        _selectedCourseLevel,
                        (value) =>
                            setState(() => _selectedCourseLevel = value)),
                    _buildTextField(_requirementsController, 'Requirements',
                        "What needs to enroll"),
                    _buildTextField(_afterCourseController,
                        'After Course Benefits', "Benefits after the course"),
                    _buildTextField(_courseLinkController,
                        'Course Link Session', "Course Link Session"),
                    SizedBox(height: 16),
                    _image == null
                        ? _buildNoImageSelected()
                        : Image.file(_image!, height: 150, fit: BoxFit.cover),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _pickImage,
                      child: Text(
                        'Pick Image',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        textStyle: TextStyle(fontSize: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                    _isUploading
                        ? Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                            onPressed: _saveCourse,
                            child: Text(
                              'Add Course',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding: EdgeInsets.symmetric(vertical: 16),
                              textStyle: TextStyle(fontSize: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, String hintText,
      {int maxLines = 1, TextInputType inputType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: inputType,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.black, fontSize: 12),
          labelStyle: const TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          // Define the border
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0), // Rounded corners
            borderSide: const BorderSide(
              color: Colors.black, // Border color
              width: 2.0, // Border width
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(
              color: Colors.black, // Border color when enabled
              width: 2.0, // Border width
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(
              color: Colors.blue, // Border color when focused
              width: 2.0, // Border width
            ),
          ),
        ),
        validator: (value) => value!.isEmpty ? 'Please enter $label' : null,
      ),
    );
  }

  Widget _buildDropdownField(String label, List<String> items,
      String? selectedValue, ValueChanged<String?> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        style: TextStyle(color: Colors.white, fontSize: 16),
        dropdownColor: Color(0xff03045E),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          // Define the border
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0), // Rounded corners
            borderSide: const BorderSide(
              color: Colors.black, // Border color
              width: 2.0, // Border width
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(
              color: Colors.black, // Border color when enabled
              width: 2.0, // Border width
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(
              color: Colors.black, // Border color when focused
              width: 2.0, // w width
            ),
          ),
        ),
        value: selectedValue,
        items: items
            .map((item) => DropdownMenuItem(value: item, child: Text(item)))
            .toList(),
        onChanged: onChanged,
        validator: (value) => value == null ? 'Please select $label' : null,
      ),
    );
  }

  Widget _buildNoImageSelected() {
    return Text('No image selected',
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.grey, fontSize: 16, fontWeight: FontWeight.bold));
  }
}
