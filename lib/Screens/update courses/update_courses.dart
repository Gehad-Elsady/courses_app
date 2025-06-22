import 'dart:io';
import 'package:courses_app/Screens/Add%20courses/model/courses-model.dart';
import 'package:courses_app/Screens/Profile/model/profilemodel.dart';
import 'package:courses_app/Screens/my%20courses/my_courses_screen.dart';
import 'package:courses_app/backend/firebase_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateCoursesPage extends StatefulWidget {
  static const String routeName = 'UpdateCoursesPage';

  @override
  _UpdateCoursesPageState createState() => _UpdateCoursesPageState();
}

class _UpdateCoursesPageState extends State<UpdateCoursesPage> {
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
  Timestamp? _createdAt;

  File? _image;
  final ImagePicker _picker = ImagePicker();
  bool _isUploading = false;
  String? _imageUrl; // To hold network image URL

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

  @override

  void didChangeDependencies() {
    super.didChangeDependencies();
    // Retrieve arguments passed to the page
    final data = ModalRoute.of(context)!.settings.arguments as CoursesModel?;

    // Initialize controllers and image
    if (data != null) {
      _nameController.text = data.name ?? '';
      _descriptionController.text = data.description ?? '';
      _priceController.text = data.price?.toString() ?? '';
      _durationController.text = data.courseDuration?.toString() ?? '';
      _requirementsController.text = data.requirements ?? '';
      _afterCourseController.text = data.afterCourse ?? '';
      _courseLanguageController.text = data.courseLanguage ?? '';
      _whatWillLearnController.text = data.whatWillYouLearn ?? '';
      _numberOfLecturesController.text = data.numberOfLectures ?? '';
      _lectureDurationController.text = data.lectureDuration ?? '';
      _numberOfLearnersInWeekController.text =
          data.numberOfLecturesInWeek ?? '';
      _selectedCourseField = data.courseField;
      _selectedCourseLevel = data.courseLevel;
      _createdAt = data.createdAt;
      if (data.image != null && data.image!.isNotEmpty) {
        if (data.image!.startsWith('http')) {
          _imageUrl = data.image; // If the image URL is already a network image
        } else {
          _image = File(data.image!); // Otherwise, assume it's a local path
        }
      }
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _imageUrl = null; // Reset network image URL
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

  Future<void> _updateService() async {
    if (_formKey.currentState!.validate() &&
        (_image != null || _imageUrl != null)) {
      setState(() => _isUploading = true);
      String? imageUrl;

      // If the image is a new file, upload it, otherwise use the network URL
      if (_image != null) {
        imageUrl = await _uploadImage(_image!);
      } else {
        imageUrl = _imageUrl;
      }

      if (imageUrl != null) {
        // Query to find the document based on `id` and `createdAt`
        final querySnapshot = await FirebaseFirestore.instance
            .collection('courses')
            .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .where('createdAt', isEqualTo: _createdAt)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          ProfileModel? userProfile = await FirebaseFunctions.getUserProfile(
                  FirebaseAuth.instance.currentUser!.uid)
              .first;
          // If the document exists, update it
          final docId = querySnapshot.docs.first.id;
          await FirebaseFirestore.instance
              .collection('courses')
              .doc(docId)
              .update({
            'name': _nameController.text.trim(),
            'description': _descriptionController.text.trim(),
            'price': _priceController.text.trim(),
            'courseField': _selectedCourseField,
            'image': imageUrl,
            'courseLevel': _selectedCourseLevel,
            'courseDuration': _durationController.text.trim(),
            'requirements': _requirementsController.text.trim(),
            'afterCourse': _afterCourseController.text.trim(),
            'courseLanguage': _courseLanguageController.text.trim(),
            "whatWillYouLearn": _whatWillLearnController.text.trim(),
            "numberOfLectures": _numberOfLecturesController.text.trim(),
            "lectureDuration": _lectureDurationController.text.trim(),
            "numberOfLecturesInWeek":
                _numberOfLearnersInWeekController.text.trim(),
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('courses updated successfully'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pushReplacementNamed(context, MyCoursesScreen.routeName);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('courses not found or already updated'),
              backgroundColor: Colors.red,
            ),
          );
        }
        setState(() => _isUploading = false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to upload image'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 5,
          shadowColor: Color(0xff03045E),
          centerTitle: true,
          title: Text(
            'Update Course',
            style: GoogleFonts.domine(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          )),
      body: Stack(
        children: [
          // Image.network(
          //   "https://images.unsplash.com/photo-1542626991-cbc4e32524cc?q=80&w=2069&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
          //   height: double.infinity,
          //   width: double.infinity,
          //   fit: BoxFit.cover,
          // ),
          // Container(color: Colors.black.withOpacity(0.5)),
          Container(
            height: MediaQuery.of(context).size.height,
         
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  // crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 16.0),
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
                    SizedBox(height: 16),
                    _image == null && _imageUrl == null
                        ? Text(
                            'image-error',
                            style: TextStyle(color: Colors.grey),
                            textAlign: TextAlign.center,
                          )
                        : _imageUrl != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.network(
                                  _imageUrl!,
                                  height: 150,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.file(_image!, height: 150),
                              ),
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
                            onPressed: _updateService,
                            child: Text(
                              'Update',
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
        style: TextStyle(color: Colors.black, fontSize: 18),
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
              color: Color(0xFF6E5DE7), // Border color when focused
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
        style: TextStyle(color: Colors.black, fontSize: 18),
        dropdownColor:  Color(0xFF6E5DE7),
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
