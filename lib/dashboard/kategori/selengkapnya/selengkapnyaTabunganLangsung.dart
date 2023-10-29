import 'package:flutter/material.dart';

class SelengkapnyaTabunganLangsung extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(43, 69, 112, 1),
          title: Align(
            alignment: Alignment.centerLeft, // Atur perataan teks ke tengah
            child: Text(
              "Berangkat Langsung - Umroh",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Image.asset(
                    "assets/home/detail_products/product_umroh.png",
                    width: double.maxFinite,
                  ),
                  Positioned(
                    child: Container(
                      margin: EdgeInsets.only(top: 290),
                      padding: EdgeInsets.only(top: 24),
                      width: double.infinity,
                      height: 650.0,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 255, 255, 255),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Paket Berangkat Langsung - Umroh",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Color.fromRGBO(43, 69, 112, 1),
                            ),
                            textAlign: TextAlign.end,
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Jenis Tabungan",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Rp. 27.000,00",
                            style: TextStyle(
                                fontSize: 24,
                                color: Color.fromRGBO(43, 69, 112, 1),
                                fontWeight: FontWeight.w700),
                          ),
                          SizedBox(height: 20),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              "Lorem ipsum dolor sit amet consectetur. Vulputate dignissim accumsan pellentesque morbi tempus eget aliquam et diam. Enim id quis mauris velit vulputate aenean laoreet odio et. Pellentesque lacus elit enim integer. Quam purus porttitor congue libero at pellentesque eu sit.",
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                          SizedBox(height: 20),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            child: Align(
                              alignment: Alignment
                                  .centerLeft, // Atur perataan teks di sini
                              child: Text(
                                "Fitur",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromRGBO(43, 69, 112, 1),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            child: Align(
                              alignment: Alignment
                                  .centerLeft, // Atur perataan teks di sini
                              child: Text(
                                "• Lorem ipsum dolor sit amet consectetur. Ut eget turpis lorem enim duis nunc scelerisque amet mattis.",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            child: Align(
                              alignment: Alignment
                                  .centerLeft, // Atur perataan teks di sini
                              child: Text(
                                "• Lorem ipsum dolor sit amet consectetur. Ut eget turpis lorem enim duis nunc scelerisque amet mattis.",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            child: Align(
                              alignment: Alignment
                                  .centerLeft, // Atur perataan teks di sini
                              child: Text(
                                "Manfaat",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromRGBO(43, 69, 112, 1),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            child: Align(
                              alignment: Alignment
                                  .centerLeft, // Atur perataan teks di sini
                              child: Text(
                                "• Lorem ipsum dolor sit amet consectetur. Ut eget turpis lorem enim duis nunc scelerisque amet mattis.",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            child: Align(
                              alignment: Alignment
                                  .centerLeft, // Atur perataan teks di sini
                              child: Text(
                                "• Lorem ipsum dolor sit amet consectetur. Ut eget turpis lorem enim duis nunc scelerisque amet mattis.",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            child: Align(
                              alignment: Alignment
                                  .centerLeft, // Atur perataan teks di sini
                              child: Text(
                                "Persyaratan Yang Terkait",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromRGBO(43, 69, 112, 1),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            child: Align(
                              alignment: Alignment
                                  .centerLeft, // Atur perataan teks di sini
                              child: Text(
                                "• Lorem ipsum dolor sit amet consectetur. Ut eget turpis lorem enim duis nunc scelerisque amet mattis.",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            child: Align(
                              alignment: Alignment
                                  .centerLeft, // Atur perataan teks di sini
                              child: Text(
                                "• Lorem ipsum dolor sit amet consectetur. Ut eget turpis lorem enim duis nunc scelerisque amet mattis.",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 24),
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
                                'BUAT PEMBAYARARN',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              // Tambahkan informasi detail produk lainnya di sini
            ],
          ),
        ));
  }
}
