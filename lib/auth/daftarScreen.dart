import 'package:SmartHajj/auth/loginScreen.dart';
import 'package:SmartHajj/auth/lupaPasswordScreen.dart';
import 'package:flutter/material.dart';
import 'package:SmartHajj/BottomNavigationBar.dart';
import 'package:flutter/services.dart';
import 'dart:ui';

class DaftarScreen extends StatefulWidget {
  @override
  _DaftarScreenState createState() => _DaftarScreenState();
}

class _DaftarScreenState extends State<DaftarScreen> {
  bool isChecked = false;
  final primaryColor = Color.fromRGBO(43, 69, 112, 1);
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
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: 'Alamat',
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
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: 'Nomor Telepon',
                      labelStyle: TextStyle(fontSize: 14.0),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 18.0,
                        horizontal: 20.0,
                      ),
                    ),
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
                    color: Color(0xFFf4f4f4), // Warna latar belakang email
                    borderRadius: BorderRadius.circular(70.0), // Border radius
                  ),
                  child: TextField(
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
                    color: Color(0xFFf4f4f4), // Warna latar belakang password
                    borderRadius: BorderRadius.circular(70.0), // Border radius
                  ),
                  child: TextField(
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
                    // Tambahkan logika otentikasi Anda di sini
                    // Jika otentikasi berhasil, arahkan pengguna ke DashboardScreen
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ),
                    );
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
