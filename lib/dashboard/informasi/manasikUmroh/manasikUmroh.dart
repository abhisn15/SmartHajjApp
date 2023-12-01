import 'package:flutter/material.dart';
import 'package:SmartHajj/dashboard/informasi/manasikUmroh/ArtikelManasikUmroh.dart';

class ManasikUmroh extends StatefulWidget {
  const ManasikUmroh({Key? key}) : super(key: key);

  @override
  _ManasikUmrohState createState() => _ManasikUmrohState();
}

class _ManasikUmrohState extends State<ManasikUmroh> {
  final List<Map<String, dynamic>> listArtikel = [
    {
      "article_id": "1",
      "slug": "ini-merupakan-headline-terkini-untuk-info-ini",
      "headline": "Ini Merupakan Headline Terkini untuk Info Ini",
      "detail":
          "<p>lorem ipsum Dolor sir amet,lorem ipsum Dolor sir amet,lorem ipsum Dolor sir amet,lorem ipsum Dolor sir amet,<\/p>\r\n\r\n<p>lorem ipsum Dolor sir amet,lorem ipsum Dolor sir amet,lorem ipsum Dolor sir amet,lorem ipsum Dolor sir amet,<\/p>\r\n\r\n<p>lorem ipsum Dolor sir amet,lorem ipsum Dolor sir amet,lorem ipsum Dolor sir amet,lorem ipsum Dolor sir amet,<\/p>\r\n\r\n<p>lorem ipsum Dolor sir amet,lorem ipsum Dolor sir amet,lorem ipsum Dolor sir amet,lorem ipsum Dolor sir amet,<\/p>\r\n\r\n<p>lorem ipsum Dolor sir amet,lorem ipsum Dolor sir amet,lorem ipsum Dolor sir amet,lorem ipsum Dolor sir amet,<\/p>",
      "pict":
          "article/1701386732_wallpapersden.com_valorant-fade-4k-art_2880x1800.jpg",
      "category_id": "2",
      "category_name": "Info Haji",
      "profile":
          "assets/profile.jpg", // Update this with your actual profile image
      "penulis": "John Doe",
      "tanggal_pembuatan": "2 hours ago",
    },
  ];

  final primaryColor = Color.fromRGBO(43, 69, 112, 1);
  final defaultColor = Colors.white;
  final abu = Color.fromRGBO(141, 148, 168, 1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(43, 69, 112, 1),
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Manasik Umroh",
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
      body: ListView.builder(
        itemCount: listArtikel.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(top: 10),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ArtikelManasikUmrohScreen(
                      artikelId: listArtikel[index]['article_id'],
                      listArtikel: listArtikel,
                      selectedArticle:
                          listArtikel[index], // Provide the selected article
                    ),
                  ),
                );
              },
              child: Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    Container(
                      child: Image.network(
                        listArtikel[index]['pict'],
                        height: 180,
                        width: 140 * 1,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 140,
                          child: Text(
                            listArtikel[index]['category_name'],
                            style: TextStyle(
                              color: Colors.orange,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          width: 180,
                          child: Text(
                            listArtikel[index]['headline'],
                            style: TextStyle(
                              color: primaryColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          width: 140,
                          child: Text(
                            listArtikel[index]['tanggal_pembuatan'],
                            style: TextStyle(
                              color: abu,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              style: ElevatedButton.styleFrom(
                primary: defaultColor,
                minimumSize: Size(double.infinity, 200),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
                elevation: 0,
              ),
            ),
          );
        },
      ),
    );
  }
}
