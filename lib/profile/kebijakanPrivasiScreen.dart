import 'package:flutter/material.dart';

class KebijakanPrivasiScreen extends StatefulWidget {
  const KebijakanPrivasiScreen({Key? key}) : super(key: key);

  @override
  _KebijakanPrivasiScreenState createState() => _KebijakanPrivasiScreenState();
}

class _KebijakanPrivasiScreenState extends State<KebijakanPrivasiScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(43, 69, 112, 1),
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Kebijakan Privasi",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        leading: const BackButton(
          color: Colors.white,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Privasi Pengguna",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                "Kami menghormati privasi Anda sebagai pengguna. Kebijakan privasi ini menjelaskan bagaimana kami mengumpulkan, menggunakan, dan melindungi informasi pribadi Anda.",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                "Informasi yang Kami Kumpulkan",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                "Kami dapat mengumpulkan informasi pribadi yang diberikan langsung oleh Anda, seperti nama, alamat email, dan informasi profil lainnya. Kami juga dapat mengumpulkan informasi non-pribadi seperti data penggunaan aplikasi.",
                style: TextStyle(fontSize: 16),
              ),
              // Tambahkan bagian Kebijakan Privasi lainnya sesuai dengan kebutuhan aplikasi Anda
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: KebijakanPrivasiScreen(),
  ));
}
