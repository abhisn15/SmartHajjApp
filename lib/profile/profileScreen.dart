import 'dart:convert';
import 'dart:io';
import 'package:SmartHajj/auth/loginScreen.dart';
import 'package:SmartHajj/profile/Syarat&KetentuanScreen.dart';
import 'package:SmartHajj/profile/bantuanScreen.dart';
import 'package:SmartHajj/profile/faqScreen.dart';
import 'package:SmartHajj/profile/gantiPasswordScreen.dart';
import 'package:SmartHajj/profile/kebijakanPrivasiScreen.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'editProfileScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isTargetVisible = false;
  double targetTabunganBorderRadius = 20.0;
  late Future<Map<String, dynamic>> apiData;

  @override
  void initState() {
    super.initState();
    apiData = fetchData(); // Call your API function
  }

  Future<Map<String, dynamic>> fetchData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        // Handle the case where the token is not available
        throw Exception('Token not available');
      }

      HttpClient httpClient = new HttpClient();
      httpClient.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;

      // Use httpClient.get instead of httpClient.getUrl
      HttpClientRequest request = await httpClient.getUrl(
        Uri.parse('https://smarthajj.coffeelabs.id/api/user'),
      );

      // Add token to headers
      request.headers.add('Authorization', 'Bearer $token');

      HttpClientResponse response = await request.close();

      String responseBody = await response.transform(utf8.decoder).join();
      if (response.statusCode == 200) {
        // If the server returns a 200 OK response, parse the JSON
        return jsonDecode(responseBody);
      } else {
        // If the server did not return a 200 OK response,
        // throw an exception.
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      // Catch any exceptions that occur during the process
      print('Error: $e');
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    _logout() async {
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? token = prefs.getString('token');

        HttpClient httpClient = new HttpClient();
        httpClient.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;

        if (token != null) {
          HttpClientRequest request = await httpClient.postUrl(
            Uri.parse('https://smarthajj.coffeelabs.id/api/logout'),
          );

          request.headers.add('Authorization', 'Bearer $token');

          HttpClientResponse response = await request.close();

          if (response.statusCode == 200) {
            print('Logout successfully');
          } else {
            print('Logout failed');
          }
        }

        // Remove token from shared preferences
        prefs.remove('token');
      } catch (e) {
        print('Error during logout: $e');
      }
    }

    return Scaffold(
      body: FutureBuilder(
          future: apiData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // If the Future is still running, display a loading indicator
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              // If an error occurred, display the error message
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.data == null) {
              return Center(
                  child: Text(
                      'Data is null')); // Handle the case when data is null
            } else {
              // If the Future is complete and the data is available,
              // you can access the data through the snapshot.data
              Map<String, dynamic> userData =
                  snapshot.data as Map<String, dynamic>;
              return Container(
                color: Color.fromRGBO(43, 69, 112, 1),
                child: ListView(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 40.0, bottom: 10.0),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(43, 69, 112, 1),
                      ),
                      child: Center(
                          child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.only(bottom: 15),
                            child: Image.asset(
                              'assets/profile/profile.png',
                            ),
                          ),
                          Text(
                            userData['name'],
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w700),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 8),
                            child: Text(
                              userData['email'],
                              style: TextStyle(
                                color: Color.fromRGBO(141, 148, 168, 1),
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 8),
                            child: Text(
                              userData['phone'],
                              style: TextStyle(
                                color: Color.fromRGBO(141, 148, 168, 1),
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      )),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20.0),
                      padding: EdgeInsets.only(top: 10.0, left: 24, right: 24),
                      width: double.infinity,
                      height: 920,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20)),
                        color: Colors.white,
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.only(top: 30, bottom: 16),
                            child: Row(
                              children: [
                                Text(
                                  'Profile',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            child: ElevatedButton(
                              onPressed: () async {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                String? agentId = prefs.getString('agentId');
                                if (agentId == null) {
                                  // Handle the case where agentId is not available
                                  print('AgentId not available');
                                  return;
                                }
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditProfileScreen(
                                      agentId: agentId,
                                      userData: userData,
                                    ),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 16),
                                primary: Color(0xFFf4f4f4),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                minimumSize: Size(350, 58),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                      child: Image.asset(
                                          "assets/profile/edit_profile.png")),
                                  Container(
                                    margin: EdgeInsets.only(right: 140),
                                    child: Text(
                                      'Edit Profile',
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                  Image.asset('assets/profile/arrow.png'),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 16),
                            child: ElevatedButton(
                              onPressed: () {
                                // Tambahkan logika otentikasi Anda di sini
                                // Jika otentikasi berhasil, arahkan pengguna ke DashboardScreen
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => GantiPasswordScreen(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 16),
                                primary: Color(0xFFf4f4f4),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                minimumSize: Size(350, 58),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                      child: Image.asset(
                                          "assets/profile/ganti_password.png")),
                                  Container(
                                    margin: EdgeInsets.only(right: 100),
                                    child: Text(
                                      'Ganti Password',
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                  Image.asset('assets/profile/arrow.png'),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 30, bottom: 16),
                            child: Row(
                              children: [
                                Text(
                                  'Informasi',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            child: ElevatedButton(
                              onPressed: () {
                                // Tambahkan logika otentikasi Anda di sini
                                // Jika otentikasi berhasil, arahkan pengguna ke DashboardScreen
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        KebijakanPrivasiScreen(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 16),
                                primary: Color(0xFFf4f4f4),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                minimumSize: Size(350, 58),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                      child: Image.asset(
                                          "assets/profile/kebijakan_privasi.png")),
                                  Container(
                                    margin: EdgeInsets.only(right: 88),
                                    child: Text(
                                      'Kebijakan Privasi',
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                  Image.asset('assets/profile/arrow.png'),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 16),
                            child: ElevatedButton(
                              onPressed: () {
                                // Tambahkan logika otentikasi Anda di sini
                                // Jika otentikasi berhasil, arahkan pengguna ke DashboardScreen
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        SyaratKetentuanScreen(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 16),
                                primary: Color(0xFFf4f4f4),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                minimumSize: Size(350, 58),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                      child: Image.asset(
                                          "assets/profile/syarat_ketentuan.png")),
                                  Container(
                                    margin: EdgeInsets.only(right: 70 / 1),
                                    child: Text(
                                      'Syarat & Ketentuan',
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                  Image.asset('assets/profile/arrow.png'),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 16),
                            child: ElevatedButton(
                              onPressed: () {
                                // Tambahkan logika otentikasi Anda di sini
                                // Jika otentikasi berhasil, arahkan pengguna ke DashboardScreen
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FaqScreen(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 16),
                                primary: Color(0xFFf4f4f4),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                minimumSize: Size(350, 58),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                      child: Image.asset(
                                          "assets/profile/faq.png")),
                                  Container(
                                    margin: EdgeInsets.only(right: 175),
                                    child: Text(
                                      'F.A.Q',
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                  Image.asset('assets/profile/arrow.png'),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 16),
                            child: ElevatedButton(
                              onPressed: () {
                                // Tambahkan logika otentikasi Anda di sini
                                // Jika otentikasi berhasil, arahkan pengguna ke DashboardScreen
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BantuanScreen(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 16),
                                primary: Color(0xFFf4f4f4),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                minimumSize: Size(350, 58),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                      child: Image.asset(
                                          "assets/profile/bantuan.png")),
                                  Container(
                                    margin: EdgeInsets.only(right: 150),
                                    child: Text(
                                      'Bantuan',
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                  Image.asset('assets/profile/arrow.png'),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 24, bottom: 20),
                            child: ElevatedButton(
                              onPressed: () async {
                                await _logout();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoginScreen(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Color.fromRGBO(43, 69, 112, 1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                minimumSize: Size(350, 50),
                              ),
                              child: Text(
                                'KELUAR',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                          Column(
                            children: [
                              Container(
                                margin: EdgeInsets.only(bottom: 24),
                                child: Text(
                                  "Dioperasikan oleh PT Lazuardi Harmoni Tur untuk kalangan sendiri",
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w400,
                                      color: Color.fromRGBO(141, 148, 168, 1)),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(bottom: 5),
                                child: Text(
                                  "Kantor Pusat : Rukan Grand Soupomo Kav. B",
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w400,
                                      color: Color.fromRGBO(141, 148, 168, 1)),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(bottom: 14),
                                child: Text(
                                  "Jl. Prof. Dr. Soepomo SH No 73 Jakarta Selatan 12870",
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w400,
                                      color: Color.fromRGBO(141, 148, 168, 1)),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(bottom: 14),
                                child: Text(
                                  "Telepon : 021-83706200, 021-83706300 Fax : 021-83705900",
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w400,
                                      color: Color.fromRGBO(141, 148, 168, 1)),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(bottom: 5),
                                child: Text(
                                  "Izin Usaha : NIB No. 0220207221024",
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w400,
                                      color: Color.fromRGBO(141, 148, 168, 1)),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(bottom: 5),
                                child: Text(
                                  "Izin Haji :  02202072210240003",
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w400,
                                      color: Color.fromRGBO(141, 148, 168, 1)),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(bottom: 5),
                                child: Text(
                                  "Izin Umroh :  SK Kemenag No. U.79 Tahun 2020",
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w400,
                                      color: Color.fromRGBO(141, 148, 168, 1)),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(bottom: 20),
                                child: Text(
                                  "IATA code 15337151",
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w400,
                                      color: Color.fromRGBO(141, 148, 168, 1)),
                                ),
                              ),
                              Container(
                                child:
                                    Image.asset('assets/profile/partner.png'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
          }),
    );
  }
}
