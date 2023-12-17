import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class ArtikelManasikUmrohScreen extends StatelessWidget {
  final int artikelId;
  final List<Map<String, dynamic>> listArtikel;

  ArtikelManasikUmrohScreen({
    required this.artikelId,
    required this.listArtikel,
  });

  final primaryColor = Color.fromRGBO(43, 69, 112, 1);

  @override
  Widget build(BuildContext context) {
    // Find the article with the specified ID
    Map<String, dynamic>? selectedArticle;
    for (Map<String, dynamic> article in listArtikel) {
      if (article['article_id'].toString() == artikelId.toString()) {
        selectedArticle = article;
        break;
      }
    }

    if (selectedArticle == null) {
      // Handle the case where the article with the specified ID is not found
      return Scaffold(
        appBar: AppBar(
          title: Text("Manasik Umroh"),
        ),
        body: Center(
          child: Text("Article not found."),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(
          "Manasik Umroh",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: const BackButton(
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 20, left: 8, right: 8),
                child: Text(
                  selectedArticle['headline'],
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Container(
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: primaryColor,
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/SmartHajj.png',
                            width: 60,
                          ),
                        )),
                    Container(
                      margin: EdgeInsets.only(left: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Admin SmartHajj',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text('Dec 01, 2023'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                  margin: EdgeInsets.only(top: 20, bottom: 20),
                  child: Center(
                    child: Image.network(
                      "https://smarthajj.coffeelabs.id/storage/${selectedArticle['pict']}",
                      width: double.infinity,
                    ),
                  )),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                child: Html(data: selectedArticle['detail'], style: {
                  "p": Style(
                    fontSize: FontSize(16),
                    color: Colors.black,
                  ),
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
