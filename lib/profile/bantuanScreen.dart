import 'package:flutter/material.dart';

class BantuanScreen extends StatefulWidget {
  const BantuanScreen({Key? key}) : super(key: key);

  @override
  _BantuanScreenState createState() => _BantuanScreenState();
}

class _BantuanScreenState extends State<BantuanScreen> {
  // Assume this list represents the help reports
  List<HelpReport> helpReports = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(43, 69, 112, 1),
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Bantuan",
            style: TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
          ),
        ),
        leading: const BackButton(
          color: Colors.white,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: helpReports.isNotEmpty
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Laporan Bantuan",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color.fromRGBO(43, 69, 112, 1),
                    ),
                  ),
                  SizedBox(height: 16),
                  // Display the list of help reports
                  for (HelpReport report in helpReports)
                    HelpItem(
                      title: report.title,
                      description: report.description,
                    ),
                ],
              )
            : Center(
                // Display message when there are no help reports
                child: Text(
                  "Belum Ada Laporan Bantuan",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ),
      ),
    );
  }
}

class HelpReport {
  final String title;
  final String description;

  HelpReport({required this.title, required this.description});
}

class HelpItem extends StatelessWidget {
  final String title;
  final String description;

  HelpItem({required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color.fromRGBO(43, 69, 112, 1),
          ),
        ),
        SizedBox(height: 8),
        Text(
          description,
          style: TextStyle(
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
        Divider(color: Colors.grey),
        SizedBox(height: 16),
      ],
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: BantuanScreen(),
  ));
}
