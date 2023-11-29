import 'package:flutter/material.dart';

class ManasikUmroh extends StatefulWidget {
  const ManasikUmroh({Key? key}) : super(key: key);

  @override
  _ManasikUmrohState createState() => _ManasikUmrohState();
}

class _ManasikUmrohState extends State<ManasikUmroh> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(43, 69, 112, 1),
        title: Align(
          alignment: Alignment.centerLeft, // Atur perataan teks ke tengah
          child: Text(
            "Manasik Umroh",
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
