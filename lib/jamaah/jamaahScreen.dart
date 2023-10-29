import 'package:Harmoni/jamaah/tambahJamaahScreen.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

class JamaahScreen extends StatefulWidget {
  const JamaahScreen({Key? key}) : super(key: key);

  @override
  _JamaahScreenState createState() => _JamaahScreenState();
}

class _JamaahScreenState extends State<JamaahScreen> {
  bool isTargetVisible = false;
  double targetTabunganBorderRadius = 20.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color.fromRGBO(43, 69, 112, 1),
        child: ListView(
          padding: const EdgeInsets.only(top: 30.0),
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 40.0, bottom: 10.0),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color.fromRGBO(43, 69, 112, 1),
              ),
              child: Center(
                child: Text(
                  "DAFTAR JAMAAH",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20.0),
              padding: EdgeInsets.only(top: 10.0, left: 24),
              width: double.infinity,
              height: 1000,
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Column(
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TambahJamaahScreen(),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "+ Tambah Jamaah",
                          style: TextStyle(
                            fontSize: 18,
                            color: Color.fromRGBO(43, 69, 112, 1),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        top: 0, left: 10, right: 24, bottom: 10),
                    padding: EdgeInsets.only(left: 10.0, top: 10.0, bottom: 10),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Color.fromRGBO(141, 148, 168, 1),
                    ),
                    child: Row(
                      children: [
                        Image.asset("assets/jemaah/papakhan.png"),
                        Container(
                          margin: EdgeInsets.only(top: 0, left: 20),
                          padding: EdgeInsets.only(top: 12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Ilham Rafi',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              Text(
                                "NIK: 31740829088",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Kota / Provinsi:",
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Color.fromRGBO(255, 255, 255, 1),
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                    Text(
                                      "Jakarta / Jakarta",
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Color.fromRGBO(255, 255, 255, 1),
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      // Tindakan yang akan dilakukan saat tombol "Detail" ditekan
                                    },
                                    child: Text("Detail"),
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: Size(85, 25),
                                      primary: Color.fromRGBO(43, 69, 112,
                                          1), // Warna latar belakang
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            14.0), // Border radius sebesar 14
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                      width:
                                          10), // Memberikan jarak antara tombol "Detail" dan "Edit"
                                  ElevatedButton(
                                    onPressed: () {
                                      // Tindakan yang akan dilakukan saat tombol "Edit" ditekan
                                    },
                                    child: Text("Edit"),
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: Size(85, 24),
                                      primary: Color.fromRGBO(43, 69, 112,
                                          1), // Warna latar belakang
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            14.0), // Border radius sebesar 14
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        top: 0, left: 10, right: 24, bottom: 10),
                    padding: EdgeInsets.only(left: 10.0, top: 10.0, bottom: 10),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Color.fromRGBO(141, 148, 168, 1),
                    ),
                    child: Row(
                      children: [
                        Image.asset("assets/jemaah/papakhan.png"),
                        Container(
                          margin: EdgeInsets.only(top: 0, left: 20),
                          padding: EdgeInsets.only(top: 12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Ilham Rafi',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              Text(
                                "NIK: 31740829088",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Kota / Provinsi:",
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Color.fromRGBO(255, 255, 255, 1),
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                    Text(
                                      "Jakarta / Jakarta",
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Color.fromRGBO(255, 255, 255, 1),
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      // Tindakan yang akan dilakukan saat tombol "Detail" ditekan
                                    },
                                    child: Text("Detail"),
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: Size(85, 25),
                                      primary: Color.fromRGBO(43, 69, 112,
                                          1), // Warna latar belakang
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            14.0), // Border radius sebesar 14
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                      width:
                                          10), // Memberikan jarak antara tombol "Detail" dan "Edit"
                                  ElevatedButton(
                                    onPressed: () {
                                      // Tindakan yang akan dilakukan saat tombol "Edit" ditekan
                                    },
                                    child: Text("Edit"),
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: Size(85, 24),
                                      primary: Color.fromRGBO(43, 69, 112,
                                          1), // Warna latar belakang
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            14.0), // Border radius sebesar 14
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        top: 0, left: 10, right: 24, bottom: 10),
                    padding: EdgeInsets.only(left: 10.0, top: 10.0, bottom: 10),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Color.fromRGBO(141, 148, 168, 1),
                    ),
                    child: Row(
                      children: [
                        Image.asset("assets/jemaah/papakhan.png"),
                        Container(
                          margin: EdgeInsets.only(top: 0, left: 20),
                          padding: EdgeInsets.only(top: 12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Ilham Rafi',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              Text(
                                "NIK: 31740829088",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Kota / Provinsi:",
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Color.fromRGBO(255, 255, 255, 1),
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                    Text(
                                      "Jakarta / Jakarta",
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Color.fromRGBO(255, 255, 255, 1),
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      // Tindakan yang akan dilakukan saat tombol "Detail" ditekan
                                    },
                                    child: Text("Detail"),
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: Size(85, 25),
                                      primary: Color.fromRGBO(43, 69, 112,
                                          1), // Warna latar belakang
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            14.0), // Border radius sebesar 14
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                      width:
                                          10), // Memberikan jarak antara tombol "Detail" dan "Edit"
                                  ElevatedButton(
                                    onPressed: () {
                                      // Tindakan yang akan dilakukan saat tombol "Edit" ditekan
                                    },
                                    child: Text("Edit"),
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: Size(85, 24),
                                      primary: Color.fromRGBO(43, 69, 112,
                                          1), // Warna latar belakang
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            14.0), // Border radius sebesar 14
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        top: 0, left: 10, right: 24, bottom: 10),
                    padding: EdgeInsets.only(left: 10.0, top: 10.0, bottom: 10),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Color.fromRGBO(141, 148, 168, 1),
                    ),
                    child: Row(
                      children: [
                        Image.asset("assets/jemaah/papakhan.png"),
                        Container(
                          margin: EdgeInsets.only(top: 0, left: 20),
                          padding: EdgeInsets.only(top: 12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Ilham Rafi',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              Text(
                                "NIK: 31740829088",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Kota / Provinsi:",
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Color.fromRGBO(255, 255, 255, 1),
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                    Text(
                                      "Jakarta / Jakarta",
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Color.fromRGBO(255, 255, 255, 1),
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      // Tindakan yang akan dilakukan saat tombol "Detail" ditekan
                                    },
                                    child: Text("Detail"),
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: Size(85, 25),
                                      primary: Color.fromRGBO(43, 69, 112,
                                          1), // Warna latar belakang
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            14.0), // Border radius sebesar 14
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                      width:
                                          10), // Memberikan jarak antara tombol "Detail" dan "Edit"
                                  ElevatedButton(
                                    onPressed: () {
                                      // Tindakan yang akan dilakukan saat tombol "Edit" ditekan
                                    },
                                    child: Text("Edit"),
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: Size(85, 24),
                                      primary: Color.fromRGBO(43, 69, 112,
                                          1), // Warna latar belakang
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            14.0), // Border radius sebesar 14
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        top: 0, left: 10, right: 24, bottom: 10),
                    padding: EdgeInsets.only(left: 10.0, top: 10.0, bottom: 10),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Color.fromRGBO(141, 148, 168, 1),
                    ),
                    child: Row(
                      children: [
                        Image.asset("assets/jemaah/papakhan.png"),
                        Container(
                          margin: EdgeInsets.only(top: 0, left: 20),
                          padding: EdgeInsets.only(top: 12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Ilham Rafi',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              Text(
                                "NIK: 31740829088",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Kota / Provinsi:",
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Color.fromRGBO(255, 255, 255, 1),
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                    Text(
                                      "Jakarta / Jakarta",
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Color.fromRGBO(255, 255, 255, 1),
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      // Tindakan yang akan dilakukan saat tombol "Detail" ditekan
                                    },
                                    child: Text("Detail"),
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: Size(85, 25),
                                      primary: Color.fromRGBO(43, 69, 112,
                                          1), // Warna latar belakang
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            14.0), // Border radius sebesar 14
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                      width:
                                          10), // Memberikan jarak antara tombol "Detail" dan "Edit"
                                  ElevatedButton(
                                    onPressed: () {
                                      // Tindakan yang akan dilakukan saat tombol "Edit" ditekan
                                    },
                                    child: Text("Edit"),
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: Size(85, 24),
                                      primary: Color.fromRGBO(43, 69, 112,
                                          1), // Warna latar belakang
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            14.0), // Border radius sebesar 14
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
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
