import 'dart:convert';
import 'dart:io';
import 'package:SmartHajj/auth/daftarScreen.dart';
import 'package:SmartHajj/auth/lupaPasswordScreen.dart';
import 'package:flutter/material.dart';
import 'package:SmartHajj/BottomNavigationBar.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:ui';

import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late HttpClientRequest request;
  void showAlert(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Login"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      showAlert("Login anda tidak valid. Harap isi semua kolom.");
      return;
    }

    try {
      String? apiLogin = dotenv.env['API_LOGIN'];
      HttpClient httpClient = new HttpClient();
      httpClient.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;

      if (apiLogin != null) {
        request = await httpClient.postUrl(Uri.parse(apiLogin));
      }

      // Add headers and body to the request
      request.headers.set('Content-Type', 'application/x-www-form-urlencoded');
      request.write('email=$email&password=$password');

      HttpClientResponse response = await request.close();

      if (response.statusCode == 200) {
        // Reading response data
        String responseBody = await response.transform(utf8.decoder).join();
        var data = jsonDecode(responseBody);
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Login Berhasil"),
              content: Text("Login telah berhasil!"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      // Navigate to login screen
                      context,
                      MaterialPageRoute(
                        builder: (context) => BottomNavigation(),
                      ),
                    );
                  },
                  child: Text("OK"),
                ),
              ],
            );
          },
        );

        // Navigate to Dashboard on successful login
        // Navigator.pushAndRemoveUntil(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => BottomNavigation(),
        //   ),
        //   (route) => false,
        // );

        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('token', data['token']);
        prefs.setString('agentId', data['users'].toString());
        return;
      } else {
        showAlert("Login anda tidak valid. Silakan coba lagi.");
        return;
      }
    } catch (e) {
      showAlert("Login anda tidak valid. Terjadi Kesalahan.");
      return;
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
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 30.0),
                Container(
                  child: Image.asset(
                    'assets/icon_app.png',
                    width: 200,
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
                      borderRadius:
                          BorderRadius.circular(70.0), // Border radius
                    ),
                    child: TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: 'Email',
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
                      borderRadius:
                          BorderRadius.circular(70.0), // Border radius
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
                            builder: (context) => LupaPasswordScreen(),
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
      ),
    );
  }
}
