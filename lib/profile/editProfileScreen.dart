import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class EditProfileScreen extends StatefulWidget {
  final String agentId;
  final Map<String, dynamic> userData;
  const EditProfileScreen(
      {Key? key, required this.userData, required this.agentId})
      : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfileScreen> {
  File? _image;
  final String defaultProfileImagePath = 'assets/profile/profile.png';

  // Function to pick an image from the gallery or camera
  Future _pickImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);

    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  // Inside your _EditProfileState class
  String _userName = '';
  String _nomorTelepon = '';
  String _email = '';

// Add this function to update the _userName variable
  void _updateUserName(String value) {
    setState(() {
      _userName = value;
      _nomorTelepon = value;
      _email = value;
    });
  }

  @override
  void initState() {
    super.initState();

    // Set initial values based on userData
    _userName = "${widget.userData['name']}";
    _nomorTelepon = "${widget.userData['phone']}";
    _email = "${widget.userData['email']}";
  }

  // Function to upload the selected image to update the profile picture on the server
  Future<void> _uploadImage() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (_image != null && token != null) {
        var request = http.MultipartRequest(
          'POST',
          Uri.parse(
              'https://smarthajj.coffeelabs.id/api/edit/${widget.userData['id']}'),
        );

        request.headers['Authorization'] = 'Bearer $token';

        // request.files.add(
        //   await http.MultipartFile.fromPath(
        //     'profile_picture',
        //     _image!.path,
        //   ),
        // );

        var response = await request.send();

        if (response.statusCode == 200) {
          print('Profile picture updated successfully');
        } else {
          print(
              'Failed to update profile picture. Status code: ${response.statusCode}');
        }
      }
    } catch (e) {
      print('Error during profile picture update: $e');
    }
  }

  // Function to update the user profile on the server
  Future<void> _updateProfile() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token != null) {
        var response = await http.post(
          Uri.parse(
              'https://smarthajj.coffeelabs.id/api/users/edit/${widget.userData['id']}'),
          headers: {'Authorization': 'Bearer $token'},
          body: {
            'name': _userName,
            'phone': _nomorTelepon,
            'email': _email,
          },
        );

        if (response.statusCode == 200) {
          print('Profile updated successfully');
        } else {
          print(
              'Failed to update profile. Status code: ${response.statusCode}');
        }
      }
    } catch (e) {
      print('Error during profile update: $e');
    }
  }

  // Function to handle saving both profile picture and profile update
  Future<void> _saveChanges() async {
    await _uploadImage();
    await _updateProfile();
  }

  final primaryColor = Color.fromRGBO(43, 69, 112, 1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(43, 69, 112, 1),
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Edit Profile",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        leading: const BackButton(
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 30, horizontal: 30),
          child: Column(
            children: [
              Center(
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[200],
                  ),
                  child: _image != null
                      ? ClipOval(
                          child: Image.file(
                            _image!,
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                          ),
                        )
                      : ClipOval(
                          child: Image.asset(
                            defaultProfileImagePath,
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return SafeArea(
                        child: Wrap(
                          children: [
                            ListTile(
                              leading: Icon(Icons.photo_library),
                              title: Text('Gallery'),
                              onTap: () {
                                _pickImage(ImageSource.gallery);
                                Navigator.pop(context);
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.camera_alt),
                              title: Text('Camera'),
                              onTap: () {
                                _pickImage(ImageSource.camera);
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                child: Text(
                  'Ubah Gambar',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  primary: primaryColor, // Set the background color here
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 30),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Nama Anda"),
                        SizedBox(height: 5),
                        TextFormField(
                          initialValue: _userName, // Set the initial value
                          onChanged:
                              _updateUserName, // Update the _userName on change
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter your name',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 30),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Nomor Telepon"),
                        SizedBox(height: 5),
                        TextFormField(
                          initialValue: _nomorTelepon, // Set the initial value
                          onChanged:
                              _updateUserName, // Update the _userName on change
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter your telepon',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 30),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Email anda"),
                        SizedBox(height: 5),
                        TextFormField(
                          initialValue: _email, // Set the initial value
                          onChanged:
                              _updateUserName, // Update the _userName on change
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter your email',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveChanges,
                child: Text(
                  'Save Changes',
                  style: TextStyle(
                      color: Colors.white), // Set text color if needed
                ),
                style: ElevatedButton.styleFrom(
                    primary: primaryColor, // Set the background color here
                    minimumSize: Size(double.infinity, 50)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
