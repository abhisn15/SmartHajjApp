import 'package:flutter/material.dart';
import 'dart:ui';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isTargetVisible = false;
  double targetTabunganBorderRadius = 20.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
                    'ILHAM RAFI',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 8),
                    child: Text(
                      '0853 2387 0429',
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
                              fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: ElevatedButton(
                      onPressed: () {
                        // Tambahkan logika otentikasi Anda di sini
                        // Jika otentikasi berhasil, arahkan pengguna ke DashboardScreen
                        // Navigator.pushReplacement(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => BottomNavigation(),
                        //   ),
                        // );
                      },
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        primary: Color(0xFFf4f4f4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        minimumSize: Size(350, 58),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        // Navigator.pushReplacement(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => BottomNavigation(),
                        //   ),
                        // );
                      },
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        primary: Color(0xFFf4f4f4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        minimumSize: Size(350, 58),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: ElevatedButton(
                      onPressed: () {
                        // Tambahkan logika otentikasi Anda di sini
                        // Jika otentikasi berhasil, arahkan pengguna ke DashboardScreen
                        // Navigator.pushReplacement(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => BottomNavigation(),
                        //   ),
                        // );
                      },
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        primary: Color(0xFFf4f4f4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        minimumSize: Size(350, 58),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        // Navigator.pushReplacement(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => BottomNavigation(),
                        //   ),
                        // );
                      },
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        primary: Color(0xFFf4f4f4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        minimumSize: Size(350, 58),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              child: Image.asset(
                                  "assets/profile/syarat_ketentuan.png")),
                          Container(
                            margin: EdgeInsets.only(right: 60),
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
                        // Navigator.pushReplacement(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => BottomNavigation(),
                        //   ),
                        // );
                      },
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        primary: Color(0xFFf4f4f4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        minimumSize: Size(350, 58),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              child: Image.asset("assets/profile/faq.png")),
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
                        // Navigator.pushReplacement(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => BottomNavigation(),
                        //   ),
                        // );
                      },
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        primary: Color(0xFFf4f4f4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        minimumSize: Size(350, 58),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              child: Image.asset("assets/profile/bantuan.png")),
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
                      onPressed: () {
                        // Tambahkan logika otentikasi Anda di sini
                        // Jika otentikasi berhasil, arahkan pengguna ke DashboardScreen
                        // Navigator.pushReplacement(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => BottomNavigation(),
                        //   ),
                        // );
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
                        child: Image.asset('assets/profile/partner.png'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
