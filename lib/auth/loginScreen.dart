import 'dart:convert';

import 'package:SmartHajj/auth/daftarScreen.dart';
import 'package:SmartHajj/auth/lupaPasswordScreen.dart';
import 'package:flutter/material.dart';
import 'package:SmartHajj/BottomNavigationBar.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:ui';

import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void login(String email, password) async {
    try {
      final response = await http.post(
          Uri.parse('https://smarthajj.coffeelabs.id/api/login'),
          body: {'email': email, 'password': password});

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        print(data['token']);
        print('Login successfully');
        // Navigate to Dashboard on successful login
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => BottomNavigation(),
          ),
          (route) => false,
        );
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('token', data['token']);
      } else {
        print('Login Failed');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color.fromRGBO(43, 69, 112, 1), // status bar color
    ));
    return Scaffold(
      backgroundColor: Colors.white,
      body: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 100.0),
              Padding(
                padding: EdgeInsets.only(bottom: 30.0),
                child: Image.asset(
                  'assets/icon_app.png',
                  width: 140,
                  height: 140,
                ),
              ),
              SizedBox(height: 16.0),
              Padding(
                padding: EdgeInsets.only(bottom: 30.0),
                child: Text(
                  "LOGIN",
                  style: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(43, 69, 112, 1),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 16.0,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFf4f4f4), // Warna latar belakang email
                    borderRadius: BorderRadius.circular(70.0), // Border radius
                  ),
                  child: TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: 'Email, Username, atau Nomor Telepon',
                      labelStyle: TextStyle(fontSize: 14.0),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 18.0,
                        horizontal: 20.0,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 0.0),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFf4f4f4), // Warna latar belakang password
                    borderRadius: BorderRadius.circular(70.0), // Border radius
                  ),
                  child: TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: 'Password',
                      labelStyle: TextStyle(fontSize: 15.0),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 18.0,
                        horizontal: 20.0,
                      ),
                    ),
                    obscureText: true,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  bottom: 10.0,
                  top: 0.0,
                ),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LupaPasswoardScreen(),
                        ),
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: 40.0,
                      ),
                      child: Text(
                        'Lupa Password?',
                        style: TextStyle(
                          color: Color.fromRGBO(43, 69, 112, 1),
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton(
                  onPressed: () {
                    try {
                      login(emailController.text.toString(),
                          passwordController.text.toString());
                    } catch (e) {
                      print('Error: $e');
                      // Handle the error or show a message to the user.
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFFf4f4f4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(70.0),
                    ),
                    minimumSize: Size(350, 58),
                  ),
                  child: Text(
                    'Masuk',
                    style: TextStyle(
                      fontSize: 24.0,
                      color: Color.fromRGBO(43, 69, 112, 1),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 30.0),
                child: Text(
                  'Belum punya akun? Klik di bawah.',
                  style: TextStyle(
                    color: Colors.black,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  bottom: 10.0,
                  top: 5.0,
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DaftarScreen(),
                        ),
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 30.0),
                      child: Text(
                        'Daftar Disini',
                        style: TextStyle(
                          color: Color.fromRGBO(43, 69, 112, 1),
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
