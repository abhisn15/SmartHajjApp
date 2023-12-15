import 'dart:convert';
import 'dart:io';

import 'package:SmartHajj/auth/daftarScreen.dart';
import 'package:SmartHajj/auth/loginScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';

import 'package:flutter_dotenv/flutter_dotenv.dart';

class ResetPasswordScreen extends StatefulWidget {
  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  late HttpClientRequest request;
  void showAlert(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Reset Password"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {},
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  TextEditingController codeController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void sendResetPassword(String code, String password) async {
    if (code.isEmpty || password.isEmpty) {
      showAlert("Kode dan Password anda tidak valid. Harap isi semua kolom.");
      return;
    }

    try {
      String? apiResetPassword = dotenv.env['API_RESETPASSWORD'];
      HttpClient httpClient = new HttpClient();
      httpClient.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;

      if (apiResetPassword != null) {
        request = await httpClient.postUrl(Uri.parse(apiResetPassword));
      }

      // Add headers and body to the request
      request.headers.set('Content-Type', 'application/x-www-form-urlencoded');
      request.write('code=$code&password=$password');

      HttpClientResponse response = await request.close();

      if (response.statusCode == 200) {
        // Reading response data
        String responseBody = await response.transform(utf8.decoder).join();
        var data = jsonDecode(responseBody);
        print('Reset Password successfully');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Berhasil mereset password"),
              content: Text("Password anda berhasil tereset!"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      // Navigate to login screen and remove all previous routes
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                      (Route<dynamic> route) => false,
                    );
                  },
                  child: Text("OK"),
                ),
              ],
            );
          },
        );

        // Navigate to Dashboard on successful sendMail
        // Navigator.pushAndRemoveUntil(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => BottomNavigation(),
        //   ),
        //   (route) => false,
        // );

        return;
      } else {
        print('Login Failed: ${response.statusCode}');
        showAlert("Reset Password anda tidak valid. Silakan coba lagi.");
        return;
      }
    } catch (e) {
      print('Error during sendMail: $e');
      showAlert("Reset Password anda tidak valid. Terjadi Kesalahan.");
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 30,
              ),
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
                    controller: codeController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: 'Kode',
                      labelStyle: TextStyle(fontSize: 15.0),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 18.0,
                        horizontal: 20.0,
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: 'Password Baru',
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
                    try {
                      sendResetPassword(codeController.text.toString(),
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
                    'Change Password',
                    style: TextStyle(
                      fontSize: 24.0,
                      color: Color.fromRGBO(43, 69, 112, 1),
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
