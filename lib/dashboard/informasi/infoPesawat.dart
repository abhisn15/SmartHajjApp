import 'package:flutter/material.dart';

class InfoPesawat extends StatefulWidget {
  const InfoPesawat({Key? key}) : super(key: key);

  @override
  _InfoPesawatState createState() => _InfoPesawatState();
}

class _InfoPesawatState extends State<InfoPesawat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(43, 69, 112, 1),
        title: Align(
          alignment: Alignment.centerLeft, // Atur perataan teks ke tengah
          child: Text(
            "Info Pesawat",
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
