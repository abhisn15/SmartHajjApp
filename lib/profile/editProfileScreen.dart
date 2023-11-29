import 'dart:convert';

import 'package:SmartHajj/auth/loginScreen.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(43, 69, 112, 1),
          title: Align(
            alignment: Alignment.centerLeft, // Atur perataan teks ke tengah
            child: Text(
              "Edit Profile",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700),
            ),
          ),
          leading: const BackButton(
            color: Colors.white, // <-- SEE HERE
          ),
        ),
        body: Container(child: Text('Foto Profile')));
  }
}
