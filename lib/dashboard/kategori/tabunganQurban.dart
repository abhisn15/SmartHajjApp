import 'package:SmartHajj/dashboard/kategori/selengkapnya/selengkapnyaTabunganLangsung.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

class TabunganQurban extends StatelessWidget {
  TabunganQurban();

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
                  "Tabungan Qurban",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700),
                ),
                Text(
                  "Kuatkan tekad, pasang niat, bismillah",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ],
        ),
        leading: const BackButton(
          color: Colors.white, // <-- SEE HERE
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 10.0, left: 24),
          width: double.infinity,
          height: 720,
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                        right: 10,
                        left: 10,
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //       builder: (context) =>
                          //           SelengkapnyaTabunganLangsung()),
                          // );
                        },
                        child: Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(right: 6),
                              child: Image.asset(
                                'assets/home/dropdown_filter.png',
                                width: 12,
                              ),
                            ),
                            Text(
                              "Filter | Umroh",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ],
                        ),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(140, 25),
                          primary: Color.fromRGBO(43, 69, 112, 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14.0),
                          ),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //       builder: (context) =>
                        //           SelengkapnyaTabunganLangsung()),
                        // );
                      },
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 6),
                            child: Image.asset(
                              'assets/home/dropdown_filter.png',
                              width: 12,
                            ),
                          ),
                          Text(
                            "Filter | Travel Agent",
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(140, 25),
                        primary: Color.fromRGBO(43, 69, 112, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.0),
                        ),
                      ),
                    ),
                  ],
                ),
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
                              'PAKET TABUNGAN QURBAN ...',
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
                                child: Text(
                                  "Selengkapnya",
                                  style: TextStyle(color: Colors.white),
                                ),
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
