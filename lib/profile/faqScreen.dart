import 'package:flutter/material.dart';

class FaqScreen extends StatelessWidget {
  const FaqScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(43, 69, 112, 1),
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "F A Q",
            style: TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
          ),
        ),
        leading: const BackButton(
          color: Colors.white,
        ),
      ),
      body: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              ItemFaq(
                pertanyaan: 'Apa itu SmartHajj?',
                jawaban:
                    'SmartHajj adalah aplikasi seluler yang menyediakan informasi dan layanan terkait perjalanan ibadah Haji.',
              ),
              ItemFaq(
                pertanyaan: 'Bagaimana cara mengunduh aplikasi?',
                jawaban:
                    'Anda dapat mengunduh aplikasi SmartHajj dari App Store atau Google Play Store.',
              ),
              ItemFaq(
                pertanyaan: 'Apakah SmartHajj gratis?',
                jawaban:
                    'Ya, SmartHajj dapat diunduh dan digunakan secara gratis.',
              ),
              // Tambahkan lebih banyak item FAQ sesuai kebutuhan
            ],
          ),
        ),
      ),
    );
  }
}

class ItemFaq extends StatelessWidget {
  final String pertanyaan;
  final String jawaban;

  const ItemFaq({
    Key? key,
    required this.pertanyaan,
    required this.jawaban,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        pertanyaan,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(jawaban),
          ),
        ),
      ],
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: FaqScreen(),
  ));
}
