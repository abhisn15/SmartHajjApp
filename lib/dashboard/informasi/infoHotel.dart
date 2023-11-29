import 'package:flutter/material.dart';

class InfoHotel extends StatefulWidget {
  const InfoHotel({Key? key}) : super(key: key);

  @override
  _InfoHotelState createState() => _InfoHotelState();
}

class _InfoHotelState extends State<InfoHotel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(43, 69, 112, 1),
        title: Align(
          alignment: Alignment.centerLeft, // Atur perataan teks ke tengah
          child: Text(
            "Info Hotel",
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
