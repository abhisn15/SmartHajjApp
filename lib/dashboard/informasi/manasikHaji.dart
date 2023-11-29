import 'package:flutter/material.dart';

class ManasikHaji extends StatefulWidget {
  const ManasikHaji({Key? key}) : super(key: key);

  @override
  _ManasikHajiState createState() => _ManasikHajiState();
}

class _ManasikHajiState extends State<ManasikHaji> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(43, 69, 112, 1),
        title: Align(
          alignment: Alignment.centerLeft, // Atur perataan teks ke tengah
          child: Text(
            "Manasik Haji",
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
