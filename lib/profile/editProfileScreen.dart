import 'dart:convert';
import 'dart:io';

import 'package:SmartHajj/BottomNavigationProfile.dart';
import 'package:flutter/material.dart';
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

  // Function to pick an image from the gallery or camera
  // Inside your _EditProfileState class
  String agentId = '';
  String _userName = '';
  String _nomorTelepon = '';
  String _email = '';

// Add this function to update the _userName variable
  void _updateUserName(String value) {
    setState(() {
      _userName = value;
    });
  }

  void _updatePhone(String value) {
    setState(() {
      _nomorTelepon = value;
    });
  }

  void _updateEmail(String value) {
    setState(() {
      _email = value;
    });
  }

  @override
  void initState() {
    super.initState();

    // Set initial values based on userData
    agentId = widget.agentId;
    _userName = widget.userData['name'];
    _nomorTelepon = widget.userData['phone'];
    _email = widget.userData['email'];
  }

  // Function to update the user profile on the server
  Future<void> _updateProfile() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      String? agentId = prefs.getString('users');

      if (token != null) {
        var response = await http.post(
          Uri.parse('https://smarthajj.coffeelabs.id/api/editUser'),
          headers: {'Authorization': 'Bearer $token'},
          body: {
            'user_id': widget.agentId,
            'name': _userName,
            'phone': _nomorTelepon,
            'email': _email,
          },
        );

        if (response.statusCode == 200) {
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Ubah Data Berhasil!"),
                content: Text("Data kamu berhasil diubah"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        // Navigate to login screen
                        context,
                        MaterialPageRoute(
                          builder: (context) => BottomNavigationProfile(),
                        ),
                        (Route<dynamic> route) => false,
                      );
                    },
                    child: Text("OK"),
                  ),
                ],
              );
            },
          );
        } else {}
      }
    } catch (e) {}
  }

  // Function to handle saving both profile picture and profile update
  Future<void> _saveChanges() async {
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
              SizedBox(height: 20),
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
                              _updatePhone, // Update the _userName on change
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
                              _updateEmail, // Update the _userName on change
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
