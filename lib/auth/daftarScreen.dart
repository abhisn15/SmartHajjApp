import 'dart:convert';
import 'dart:io';

import 'package:SmartHajj/auth/loginScreen.dart';
// import 'package:SmartHajj/auth/lupaPasswordScreen.dart';
import 'package:flutter/material.dart';
// import 'package:SmartHajj/BottomNavigationBar.dart';
import 'package:flutter/services.dart';
import 'dart:ui';

import 'package:shared_preferences/shared_preferences.dart';

class DaftarScreen extends StatefulWidget {
  @override
  _DaftarScreenState createState() => _DaftarScreenState();
}

class _DaftarScreenState extends State<DaftarScreen> {
  bool isChecked = false;
  final primaryColor = Color.fromRGBO(43, 69, 112, 1);

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void showAlert(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("SignUp"),
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

  void signup(String name, String email, String phone, String password,
      String isAgent) async {
    if (name.isEmpty || email.isEmpty || phone.isEmpty || password.isEmpty) {
      showAlert("Signup anda tidak valid. Harap isi semua kolom.");
      return;
    }

    try {
      print(
          'Request Body: name=$name&email=$email&phone=$phone&password=$password&isAgent=1');

      HttpClient httpClient = new HttpClient();
      httpClient.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;

      HttpClientRequest request = await httpClient.postUrl(
        Uri.parse('https://smarthajj.coffeelabs.id/api/signUp'),
      );

      // Add headers and body to the request
      request.headers.set('Content-Type', 'application/x-www-form-urlencoded');
      request.write(
          'name=$name&email=$email&phone=$phone&password=$password&isAgent=1'); // Always set isAgent to 1

      HttpClientResponse response = await request.close();

      if (response.statusCode == 200) {
        // Reading response data
        String responseBody = await response.transform(utf8.decoder).join();
        var data = jsonDecode(responseBody);
        print('Signup successfully');

        // Show success alert
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Signup Successful"),
              content: Text("Akun anda berhasil terdaftar!!"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                    Navigator.pushReplacement(
                      // Navigate to login screen
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ),
                    );
                  },
                  child: Text("OK"),
                ),
              ],
            );
          },
        );

        // Navigate to login screen after showing the alert
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => LoginScreen(),
        //   ),
        // );
      } else {
        print('Signup Failed: ${response.statusCode}');

        // Show error alert
        showAlert("Signup anda tidak valid. Silakan coba lagi.");
      }
    } catch (e) {
      print('Error during signup: $e');

      // Show error alert
      showAlert("Signup anda tidak valid. Terjadi kesalahan.");
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
                  "SIGNUP",
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
                    controller: nameController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: 'Nama',
                      labelStyle: TextStyle(fontSize: 14.0),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 18.0,
                        horizontal: 20.0,
                      ),
                    ),
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
                      labelText: 'Email',
                      labelStyle: TextStyle(fontSize: 14.0),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 18.0,
                        horizontal: 20.0,
                      ),
                    ),
                    onChanged: (text) {
                      if (!text.contains('@')) {
                        // Tambahkan logika untuk menampilkan pesan kesalahan jika tidak ada "@" di email.
                      } else {
                        // Email valid dengan simbol "@".
                      }
                    },
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
                    controller: phoneController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: 'Nomor Telepon',
                      labelStyle: TextStyle(fontSize: 14.0),
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
                padding: EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 16.0,
                ),
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
              Container(
                margin: EdgeInsets.only(top: 16, bottom: 38),
                child: Row(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isChecked = !isChecked;
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.only(
                          left: 30,
                          right: 8,
                        ),
                        width: 20.0,
                        height: 20.0,
                        decoration: BoxDecoration(
                          color: isChecked ? primaryColor : Colors.grey,
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: isChecked
                            ? Container(
                                width: 20.0,
                                height: 20.0,
                                decoration: BoxDecoration(
                                  color: primaryColor,
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                child: Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              )
                            : null,
                      ),
                    ),
                    Container(
                      child: Text(
                        "Term & Conditions",
                        style: TextStyle(color: primaryColor, fontSize: 16),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 16.0),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton(
                  onPressed: () {
                    if (!isChecked) {
                      showAlert(
                          "Harap centang Term & Conditions terlebih dahulu.");
                      return;
                    }
                    // Call the signup function only if the form is filled
                    if (nameController.text.isEmpty ||
                        emailController.text.isEmpty ||
                        phoneController.text.isEmpty ||
                        passwordController.text.isEmpty) {
                      showAlert(
                          "Signup anda tidak valid. Harap isi semua kolom.");
                    } else {
                      // Call the signup function
                      signup(nameController.text, emailController.text,
                          phoneController.text, passwordController.text, "1");
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
                    'SIGNUP',
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
                  'Already Have an account?',
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
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(),
                        ),
                        (route) =>
                            false, // Ini akan menghapus semua halaman di atas LoginScreen
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 30.0),
                      child: Text(
                        'Sign In',
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
