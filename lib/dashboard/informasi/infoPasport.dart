import 'package:flutter/material.dart';

class InfoPasport extends StatefulWidget {
  const InfoPasport({Key? key}) : super(key: key);

  @override
  _InfoPasportState createState() => _InfoPasportState();
}

class _InfoPasportState extends State<InfoPasport> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(43, 69, 112, 1),
        title: Align(
          alignment: Alignment.centerLeft, // Atur perataan teks ke tengah
          child: Text(
            "Info Pasport",
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
