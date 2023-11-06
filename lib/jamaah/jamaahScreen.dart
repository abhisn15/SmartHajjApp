import 'package:flutter/material.dart';
import 'package:SmartHajj/jamaah/detailJamaahScreen.dart';
import 'package:SmartHajj/jamaah/tambahJamaahScreen.dart';

class JamaahScreen extends StatefulWidget {
  const JamaahScreen({Key? key}) : super(key: key);

  @override
  _JamaahScreenState createState() => _JamaahScreenState();
}

class _JamaahScreenState extends State<JamaahScreen> {
  final List<Map<String, dynamic>> daftarJamaah = [
    {
      "id": 1,
      "name": "Ilham Rafi",
      "nik": "NIK : 31740829088",
      "location": "Jakarta / Jakarta",
    },
    {
      "id": 2,
      "name": "Papa Khan",
      "nik": "NIK : 31740829088",
      "location": "Jakarta / Jakarta",
    },
  ];
  final primaryColor = Color.fromRGBO(43, 69, 112, 1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Center(
          child: Text(
            "DAFTAR JAMAAH",
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
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
          Column(
            children: daftarJamaah.map((item) {
              Color backgroundColor = item["id"] > 1
                  ? Color.fromRGBO(238, 226, 223, 1)
                  : Color.fromRGBO(141, 148, 168, 1);
              Color textColor = item["id"] > 1 ? primaryColor : Colors.white;

              return Container(
                margin: const EdgeInsets.only(bottom: 20.0),
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: backgroundColor,
                ),
                child: Row(
                  children: [
                    Image.asset("assets/jemaah/papakhan.png"),
                    const SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item["name"],
                          style: TextStyle(
                            fontSize: 16,
                            color: textColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          item["nik"],
                          style: TextStyle(
                            fontSize: 16,
                            color: textColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Kota / Provinsi:",
                              style: TextStyle(
                                fontSize: 10,
                                color: item['id'] > 1
                                    ? primaryColor
                                    : Color.fromRGBO(255, 255, 255, 1),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              item["location"],
                              style: TextStyle(
                                fontSize: 10,
                                color: item['id'] > 1
                                    ? primaryColor
                                    : Color.fromRGBO(255, 255, 255, 1),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailJamaahScreen(
                                      item: item,
                                    ),
                                  ),
                                );
                              },
                              child: Text("Detail"),
                              style: ElevatedButton.styleFrom(
                                minimumSize: Size(85, 25),
                                primary: Color.fromRGBO(43, 69, 112, 1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14.0),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          TambahJamaahScreen(),
                                    ),
                                  );
                                },
                                child: Text("Edit"),
                                style: ElevatedButton.styleFrom(
                                  minimumSize: Size(85, 24),
                                  primary: primaryColor, // Warna latar belakang
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        14.0), // Border radius sebesar 14
                                  ),
                                )),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
