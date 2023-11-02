import 'package:Harmoni/dashboard/productDetail/setoranAwalScreen.dart';
import 'package:flutter/material.dart';

class SimulasiScreen extends StatefulWidget {
  const SimulasiScreen({Key? key}) : super(key: key);

  @override
  _SimulasiScreenState createState() => _SimulasiScreenState();
}

class _SimulasiScreenState extends State<SimulasiScreen> {
  final primaryColor = Color.fromRGBO(43, 69, 112, 1);
  final defaultColor = Colors.white;
  final abu = Color.fromRGBO(141, 148, 168, 1);
  final sedikitAbu = Color.fromRGBO(244, 244, 244, 1);
  final krems = Color.fromRGBO(238, 226, 223, 1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(43, 69, 112, 1),
        title: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Simulasi",
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
          padding: EdgeInsets.only(bottom: 20),
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 24),
                child: Column(
                  children: [
                    Text(
                      "Anda telah memilih",
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 18,
                          color: primaryColor),
                    ),
                    Container(
                        margin: EdgeInsets.only(top: 12, left: 20, right: 20),
                        width: double.infinity,
                        height: 58,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(80)),
                            color: sedikitAbu),
                        child: Center(
                          child: Text(
                            "PAKET TABUNGAN UMROH RAMADHAN",
                            style: TextStyle(color: abu),
                          ),
                        )),
                    Container(
                      margin: EdgeInsets.only(top: 14),
                      child: Text(
                        "Harga Perkiraan",
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 18,
                            color: primaryColor),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 12, left: 20, right: 20),
                      width: double.infinity,
                      height: 58,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(80)),
                          color: sedikitAbu),
                      child: Center(
                        child: Text(
                          "Rp 35.000.000,00",
                          style: TextStyle(color: abu),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 18),
                      color: primaryColor,
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                      width: double.infinity,
                      child: Column(
                        children: [
                          Text(
                            "SIMULASI",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: krems),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 14),
                            child: Text(
                              "Masukkan Setoran Awal",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: krems),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 12),
                            width: double.infinity,
                            height: 58,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(80)),
                                color: defaultColor),
                            child: Center(
                              child: Text(
                                "Rp 1.000.000,00",
                                style: TextStyle(fontSize: 16, color: abu),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 14),
                            child: Text(
                              "Rencana Setoran Per Bulan",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: krems),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 12),
                            width: double.infinity,
                            height: 58,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(80)),
                                color: defaultColor),
                            child: Center(
                              child: Text(
                                "Rp 500.000,00",
                                style: TextStyle(fontSize: 16, color: abu),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 20),
                            child: Text(
                              "Uang akan terkumpul setelah  7 Bulan",
                              style: TextStyle(
                                  color: krems,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16),
                            ),
                          ),
                          Container(
                            child: Text(
                              "Perkiraan Keberangkatan",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: krems),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 12),
                            width: double.infinity,
                            height: 58,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(80)),
                                color: defaultColor),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 50 * 1),
                                  child: Text(
                                    "RAMADHAN 1448  H / 2024 M",
                                    style: TextStyle(fontSize: 16, color: abu),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(right: 24 * 1),
                                  child: Image.asset(
                                    "assets/home/dropdown_down.png",
                                    color: primaryColor,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                      child: Column(
                        children: [
                          Container(
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Jamaah Atas Nama",
                                    style: TextStyle(
                                        color: primaryColor,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16),
                                  )))
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 24),
                      width: double.infinity,
                      height: 58,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(80)),
                          color: sedikitAbu),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 20 * 1),
                            child: Text(
                              "RICKI SETIAWAN - NIK 3216212305850001",
                              style: TextStyle(fontSize: 13, color: abu),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 24 * 1),
                            child: Image.asset(
                              "assets/home/dropdown_down.png",
                              color: primaryColor,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SetoranAwalScreen()),
                        );
                      },
                      child: Text(
                        "MULAI SETORAN AWAL",
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(350, 45),
                        primary: Color.fromRGBO(43, 69, 112, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
