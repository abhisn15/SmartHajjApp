import 'package:SmartHajj/auth/daftarScreen.dart';
import 'package:SmartHajj/auth/loginScreen.dart';
import 'package:flutter/material.dart';
import 'package:SmartHajj/BottomNavigationBar.dart';
import 'package:flutter/services.dart';
import 'dart:ui';

class ResetPasswordScreen extends StatefulWidget {
  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  bool passwordsMatch = true;

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
                  "RESET PASSWORD",
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(43, 69, 112, 1),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFf4f4f4),
                    borderRadius: BorderRadius.circular(70.0),
                  ),
                  child: TextField(
                    controller: passwordController,
                    onChanged: (value) {
                      setState(() {
                        if (confirmPasswordController.text.isNotEmpty &&
                            confirmPasswordController.text != value) {
                          passwordsMatch = false;
                        } else {
                          passwordsMatch = true;
                        }
                      });
                    },
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
                padding: EdgeInsets.all(16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFf4f4f4),
                    borderRadius: BorderRadius.circular(70.0),
                    border: Border.all(
                      color: (confirmPasswordController.text !=
                              passwordController.text)
                          ? Colors.red
                          : Colors.transparent,
                      width: 2.0,
                    ),
                  ),
                  child: TextField(
                    controller: confirmPasswordController,
                    onChanged: (value) {
                      setState(() {
                        if (passwordController.text.isEmpty ||
                            value != passwordController.text) {
                          passwordsMatch = false;
                        } else {
                          passwordsMatch = true;
                        }
                      });
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: 'Confirm Password',
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
              SizedBox(height: 16.0),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton(
                  onPressed: () {
                    // Tambahkan logika otentikasi Anda di sini
                    // Jika otentikasi berhasil, arahkan pengguna ke DashboardScreen
                    if (passwordController.text ==
                        confirmPasswordController.text) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(),
                        ),
                      );
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
                    'Change Password',
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
                      Navigator.pushReplacement(
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
