import 'package:flutter/material.dart';

class TopupScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color.fromRGBO(43, 69, 112, 1),
        title: Container(
          padding: EdgeInsets.only(right: 60),
          child: Center(
            child: Text(
              "Topup",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ),
      body: Container(
        color: Color.fromRGBO(43, 69, 112, 1),
        width: double.infinity,
        child: ListView(
          children: <Widget>[
            Container(
                height: 1000,
                margin: EdgeInsets.only(top: 20),
                padding: EdgeInsets.all(30),
                decoration: BoxDecoration(
                    color: Color.fromRGBO(255, 255, 255, 1),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "Total Saldo Tabungan",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                      width: double.infinity,
                      height: 140,
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(67, 115, 192, 1),
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      child: Column(
                        children: [
                          Row(
                            children: <Widget>[
                              Text(
                                "Rp. 100.000.000",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 34.6,
                                    fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 20),
                            width: double.infinity,
                            height: 5,
                            decoration: BoxDecoration(color: Colors.green),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            child: Row(
                              children: [
                                Text(
                                  "Dari Target: Rp.277.000.000",
                                  style: TextStyle(
                                      color: Color.fromRGBO(255, 455, 450, 1),
                                      fontWeight: FontWeight.w700,
                                      fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
