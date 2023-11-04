import 'package:Harmoni/dashboard/checkoutDP.dart';
import 'package:Harmoni/dashboard/productDetail/setoranAwalScreen.dart';
import 'package:flutter/material.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

final primaryColor = Color.fromRGBO(43, 69, 112, 1);
final defaultColor = Colors.white;
final abu = Color.fromRGBO(141, 148, 168, 1);
final sedikitAbu = Color.fromRGBO(244, 244, 244, 1);
final krems = Color.fromRGBO(238, 226, 223, 1);

class _CheckoutScreenState extends State<CheckoutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: defaultColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: primaryColor,
          title: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Checkout",
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
        ),
        body: Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Anda telah memilih",
                    style: TextStyle(
                        color: primaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 12),
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                      color: sedikitAbu,
                      borderRadius: BorderRadius.all(Radius.circular(70))),
                  child: Center(
                    child: Text(
                      "PAKET BERANGKAT LANGSUNG UMROH RAMADHAN",
                      style: TextStyle(
                          fontSize: 12,
                          color: abu,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Rencana Keberangkatan",
                    style: TextStyle(
                        color: primaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 12),
                  width: double.infinity,
                  height: 58,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(80)),
                      color: sedikitAbu),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 50 * 1),
                        child: Text(
                          "RAMADHAN 1448 H / 2024 M",
                          style: TextStyle(fontSize: 16, color: abu),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 24 * 1),
                        child: Image.asset(
                          "assets/home/dropdown_down.png",
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Harga",
                    style: TextStyle(
                        color: primaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 12),
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                      color: sedikitAbu,
                      borderRadius: BorderRadius.all(Radius.circular(70))),
                  child: Center(
                    child: Text(
                      "Rp 35.000.000,00",
                      style: TextStyle(
                          fontSize: 18,
                          color: abu,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Jemaah Atas Nama",
                    style: TextStyle(
                        color: primaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 12),
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
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Dp / Cash",
                    style: TextStyle(
                        color: primaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 12),
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                      color: sedikitAbu,
                      borderRadius: BorderRadius.all(Radius.circular(70))),
                  child: Center(
                    child: Text(
                      "DP -  Rp.10.000.000,00",
                      style: TextStyle(
                          fontSize: 18,
                          color: abu,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CheckoutDP()),
                          );
                        },
                        child: Text(
                          "BAYAR",
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
            )));
  }
}
