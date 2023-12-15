import 'dart:convert';
import 'dart:io';

import 'package:SmartHajj/auth/daftarScreen.dart';
import 'package:SmartHajj/auth/loginScreen.dart';
import 'package:SmartHajj/auth/resetPasswordScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';

import 'package:flutter_dotenv/flutter_dotenv.dart';

class CheckCodeScreen extends StatefulWidget {
  @override
  _CheckCodeScreenState createState() => _CheckCodeScreenState();
}

class _CheckCodeScreenState extends State<CheckCodeScreen> {
  late HttpClientRequest request;
  void showAlert(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Kode"),
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

  void sendMail(String code) async {
    if (code.isEmpty) {
      showAlert("Kode anda tidak valid. Harap isi semua kolom.");
      return;
    }

    try {
      String? apiConfirmCode = dotenv.env['API_CONFIRMCODE'];
      HttpClient httpClient = new HttpClient();
      httpClient.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;

      if (apiConfirmCode != null) {
        request = await httpClient.postUrl(Uri.parse(apiConfirmCode));
      }

      // Add headers and body to the request
      request.headers.set('Content-Type', 'application/x-www-form-urlencoded');
      request.write('code=$code');

      HttpClientResponse response = await request.close();

      if (response.statusCode == 200) {
        // Reading response data
        String responseBody = await response.transform(utf8.decoder).join();
        var data = jsonDecode(responseBody);
        print('Confirm Code successfully');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Berhasil mengkonfirmasi kode"),
              content: Text("Kode anda valid!"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      // Navigate to sendMail screen
                      context,
                      MaterialPageRoute(
                        builder: (context) => ResetPasswordScreen(),
                      ),
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
        print('Kode Failed: ${response.statusCode}');
        showAlert("Kode anda tidak valid. Silakan coba lagi.");
        return;
      }
    } catch (e) {
      print('Error during sendMail: $e');
      showAlert("Kode anda tidak valid. Terjadi Kesalahan.");
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
                  "CEK KODE",
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
              SizedBox(height: 16.0),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton(
                  onPressed: () {
                    try {
                      sendMail(
                        codeController.text.toString(),
                      );
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
                    'KONFIRMASI KODE',
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
