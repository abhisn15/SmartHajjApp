import 'package:SmartHajj/dashboard/kategori/selengkapnya/selengkapnyaTabunganLangsung.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

class TabunganUmroh extends StatelessWidget {
  TabunganUmroh();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(43, 69, 112, 1),
        title: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Tabungan Umroh",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                Text(
                  "Kuatkan tekad, pasang niat, bismillah",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ],
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 10.0, left: 24),
          width: double.infinity,
          height: 700,
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0, left: 6),
                    child: TextButton(
                      onPressed: () {
                        // Tambahkan tindakan yang akan dilakukan saat tombol ditekan di sini
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image.asset('assets/home/kategori/filterUmroh.png'),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: TextButton(
                      onPressed: () {
                        // Tambahkan tindakan yang akan dilakukan saat tombol ditekan di sini
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image.asset('assets/home/kategori/filterUmroh.png'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: 0, left: 10, right: 24),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: Color.fromRGBO(238, 226, 223, 1),
                ),
                child: Row(
                  children: [
                    Image.asset(
                      "assets/home/kategori/img_haji.png",
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 0, left: 16),
                      padding: EdgeInsets.only(top: 12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 150,
                            child: Text(
                              'PAKET TABUNGAN UMROH RAMADHAN ...',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color.fromRGBO(43, 69, 112, 1),
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            child: Text(
                              "Rp. 35.000.000,00",
                              style: TextStyle(
                                fontSize: 15,
                                color: Color.fromRGBO(43, 69, 112, 1),
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.only(bottom: 10),
                                  width: 150,
                                  child: Text(
                                    "Periode Tabungan: Sekarang-Januari 2027",
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Color.fromRGBO(43, 69, 112, 1),
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                Container(
                                  width: 150,
                                  child: Text(
                                    "Berangkat: Musim Haji 1449H/Mei 2027",
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Color.fromRGBO(43, 69, 112, 1),
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            SelengkapnyaTabunganLangsung()),
                                  );
                                },
                                child: Text("Selengkapnya"),
                                style: ElevatedButton.styleFrom(
                                  minimumSize: Size(140, 25),
                                  primary: Color.fromRGBO(43, 69, 112, 1),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14.0),
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
      ),
    );
  }
}
