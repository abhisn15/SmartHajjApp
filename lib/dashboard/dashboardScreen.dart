import 'package:Harmoni/Dashboard/CustomCategoryButton.dart';
import 'package:Harmoni/Dashboard/CustomInformationButton.dart';
import 'package:Harmoni/dashboard/kategori/tabunganHaji.dart';
import 'package:Harmoni/dashboard/kategori/tabunganLangsung.dart';
import 'package:Harmoni/dashboard/kategori/tabunganQurban.dart';
import 'package:Harmoni/dashboard/kategori/tabunganUmroh.dart';
import 'package:Harmoni/dashboard/topup/topupScreen.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:Harmoni/dashboard/productDetail/productDetailScreen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final List<Map<String, dynamic>> listProduct = [
    {
      "id": 1,
      "img": "assets/home/products/tabungan_qurban.png",
      "name": "Tabungan Qurban",
      "jadwal": "Berangkat Januari 2029",
      "detailImg": "assets/home/detail_products/product_umroh.png",
      "tabungan": "Rp. 27.000,00",
    },
    {
      "id": 2,
      "img": "assets/home/products/tabungan_umroh.png",
      "name": "Tabungan Umroh",
      "jadwal": "Berangkat Januari 2029",
      "detailImg": "assets/home/detail_products/product_umroh.png",
      "tabungan": "Rp. 27.000,00",
    },
    {
      "id": 3,
      "img": "assets/home/products/tabungan_qurban.png",
      "name": "Tabungan Haji",
      "jadwal": "Berangkat Januari 2029",
      "detailImg": "assets/home/detail_products/product_umroh.png",
      "tabungan": "Rp. 27.000,00",
    },
    {
      "id": 4,
      "img": "assets/home/products/tabungan_umroh.png",
      "name": "Tabungan Haji",
      "jadwal": "Berangkat Januari 2029",
      "detailImg": "assets/home/detail_products/product_umroh.png",
      "tabungan": "Rp. 27.000,00",
    }
  ];

  final List<Map<String, dynamic>> listKategori = [
    {
      "id": 1,
      "img": "assets/home/kategori/berangkat_langsung.png",
      "name": "Tabungan Langsung",
    },
    {
      "id": 2,
      "img": "assets/home/kategori/tabungan_umroh.png",
      "name": "Tabungan Umroh",
    },
    {
      "id": 3,
      "img": "assets/home/kategori/tabungan_haji.png",
      "name": "Tabungan Haji",
    },
    {
      "id": 4,
      "img": "assets/home/kategori/tabungan_qurban.png",
      "name": "Tabungan Qurban",
    }
  ];

  final List<Map<String, dynamic>> listInformasi = [
    {
      "id": 1,
      "img": "assets/home/informasi/info_pasport.png",
      "name": "Info Pasport",
    },
    {
      "id": 2,
      "img": "assets/home/informasi/info_visa.png",
      "name": "Info Visa",
    },
    {
      "id": 3,
      "img": "assets/home/informasi/info_pesawat.png",
      "name": "Info Pesawat",
    },
    {
      "id": 4,
      "img": "assets/home/informasi/info_hotel.png",
      "name": "Info Hotel",
    }
  ];

  final List<Map<String, dynamic>> listInformasi2 = [
    {
      "id": 1,
      "img": "assets/home/informasi/info_maktab.png",
      "name": "Info Maktab",
    },
    {
      "id": 2,
      "img": "assets/home/informasi/info_umroh.png",
      "name": "Manasik Umroh",
    },
    {
      "id": 3,
      "img": "assets/home/informasi/haji.png",
      "name": "Manasik Haji",
    },
    {
      "id": 4,
      "img": "assets/home/informasi/info_qurban.png",
      "name": "Hewan Qurban",
    }
  ];

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
              padding: EdgeInsets.only(top: 30.0, bottom: 20.0),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color.fromRGBO(43, 69, 112, 1),
              ),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 24.0),
                        child: Image.asset('assets/home/profile.png'),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 0.0, left: 13.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: Text(
                                "PAPA KHAN",
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Text(
                              "0853 1481 8119",
                              style: TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF8D94A8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: 100.0,
              decoration: BoxDecoration(
                color: Color(0xFF8D94A8),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
              margin: const EdgeInsets.only(
                top: 20.0,
                left: 24.0,
                right: 24.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 25.0,
                          left: 30.0,
                        ),
                        child: Text(
                          "SALDO TOTAL",
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 12.0,
                          left: 30.0,
                        ),
                        child: Text(
                          "Rp. 100.000,00",
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TopupScreen(),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                            bottom: 16.0,
                            right: 37.0,
                          ),
                          child: Column(
                            children: [
                              Image.asset("assets/home/topup.png"),
                              Text(
                                'Topup',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Color(0xEEEEE2DF),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ClipRRect(
              child: InkWell(
                onTap: () {
                  setState(() {
                    isTargetVisible = !isTargetVisible;
                    targetTabunganBorderRadius = isTargetVisible ? 0.0 : 20.0;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.only(
                    right: 24.0,
                    left: 24.0,
                  ),
                  padding: EdgeInsets.all(16.0),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(238, 226, 223, 1),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(targetTabunganBorderRadius),
                      bottomRight: Radius.circular(targetTabunganBorderRadius),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "TARGET TABUNGAN",
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2B4570),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 20.0),
                        child: Image.asset('assets/home/dropdown.png'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Visibility(
              visible: isTargetVisible,
              child: Container(
                margin: const EdgeInsets.only(
                  right: 24.0,
                  left: 24.0,
                ),
                padding: const EdgeInsets.all(16.0),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(238, 226, 223, 1),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20.0),
                    bottomRight: Radius.circular(20.0),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Rp. 100.000.000,00",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Bagian daftar produk
            Container(
              margin: EdgeInsets.only(top: 20.0),
              padding: EdgeInsets.only(top: 30.0),
              width: double.infinity,
              height: 680.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 24),
                    child: Text(
                      "Produk Terbaru",
                      style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.black,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  Container(
                    height: 200.0,
                    margin:
                        const EdgeInsets.only(top: 20.0, bottom: 20, left: 0),
                    child: ListView(
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      children: listProduct.map((product) {
                        return Container(
                          width: 150.0,
                          margin: EdgeInsets.only(left: 10),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 255, 255, 255),
                            borderRadius: BorderRadius.all(
                              Radius.circular(20.0),
                            ),
                          ),
                          child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ProductDetailScreen(product: product),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.all(0),
                                  primary: Colors.transparent,
                                  elevation: 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Image.asset(
                                    product["img"],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          product["name"],
                                          style: TextStyle(
                                            fontSize: 12.5,
                                            color: Color(0xFF2B4570),
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                        SizedBox(height: 5.0),
                                        Text(
                                          product["jadwal"],
                                          style: TextStyle(
                                            fontSize: 11.0,
                                            color: Color.fromRGBO(
                                                141, 148, 168, 1),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )),
                        );
                      }).toList(),
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.only(left: 24),
                      child: Text(
                        'Kategori',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w700),
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment
                        .center, //Center Row contents horizontally,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomCategoryButton(
                        image: "assets/home/kategori/berangkat_langsung.png",
                        text: "Tabungan Langsung",
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TabunganLangsung(),
                            ),
                          );
                        },
                      ),
                      CustomCategoryButton(
                        image: "assets/home/kategori/tabungan_umroh.png",
                        text: "Tabungan Umroh",
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TabunganUmroh(),
                            ),
                          );
                        },
                      ),
                      CustomCategoryButton(
                        image: "assets/home/kategori/tabungan_haji.png",
                        text: "Tabungan Haji",
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TabunganHaji(),
                            ),
                          );
                        },
                      ),
                      CustomCategoryButton(
                        image: "assets/home/kategori/tabungan_qurban.png",
                        text: "Tabungan Qurban",
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TabunganQurban(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  Container(
                      margin: EdgeInsets.only(left: 24),
                      child: Text(
                        'Informasi',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w700),
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment
                        .center, //Center Row contents horizontally,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomInformationButton(
                        image: "assets/home/informasi/info_pasport.png",
                        text: "Info Pasport",
                        onPressed: () {
                          // Implement logic for handling the "Tabungan Langsung" category click
                        },
                      ),
                      CustomInformationButton(
                        image: "assets/home/informasi/info_visa.png",
                        text: "Info Visa",
                        onPressed: () {
                          // Implement logic for handling the "Tabungan Umroh" category click
                        },
                      ),
                      CustomInformationButton(
                        image: "assets/home/informasi/info_pesawat.png",
                        text: "Info Pesawat",
                        onPressed: () {
                          // Implement logic for handling the "Tabungan Haji" category click
                        },
                      ),
                      CustomInformationButton(
                        image: "assets/home/informasi/info_hotel.png",
                        text: "Info Hotel",
                        onPressed: () {
                          // Implement logic for handling the "Tabungan Qurban" category click
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment
                        .center, //Center Row contents horizontally,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomInformationButton(
                        image: "assets/home/informasi/info_maktab.png",
                        text: "Info Maktab",
                        onPressed: () {
                          // Implement logic for handling the "Tabungan Langsung" category click
                        },
                      ),
                      CustomInformationButton(
                        image: "assets/home/informasi/info_umroh.png",
                        text: "Manasik Umroh",
                        onPressed: () {
                          // Implement logic for handling the "Tabungan Umroh" category click
                        },
                      ),
                      CustomInformationButton(
                        image: "assets/home/informasi/haji.png",
                        text: "Manasik Haji",
                        onPressed: () {
                          // Implement logic for handling the "Tabungan Haji" category click
                        },
                      ),
                      CustomInformationButton(
                        image: "assets/home/informasi/info_qurban.png",
                        text: "Hewan Qurban",
                        onPressed: () {
                          // Implement logic for handling the "Tabungan Qurban" category click
                        },
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
