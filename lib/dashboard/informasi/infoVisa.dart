import 'package:flutter/material.dart';

class InfoVisa extends StatefulWidget {
  const InfoVisa({Key? key}) : super(key: key);

  @override
  _InfoVisaState createState() => _InfoVisaState();
}

class _InfoVisaState extends State<InfoVisa> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(43, 69, 112, 1),
        title: Align(
          alignment: Alignment.centerLeft, // Atur perataan teks ke tengah
          child: Text(
            "Info Visa",
            style: TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
          ),
        ),
        leading: const BackButton(
          color: Colors.white, // <-- SEE HERE
        ),
      ),
    );
  }
}
