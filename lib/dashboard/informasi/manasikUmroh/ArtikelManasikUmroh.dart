import 'package:flutter/material.dart';

class ArtikelManasikUmrohScreen extends StatelessWidget {
  final int artikelId;
  final List<Map<String, dynamic>> listArtikel;
  final Map<String, dynamic>
      selectedArticle; // Change the type to Map<String, dynamic>

  ArtikelManasikUmrohScreen(
      {required this.artikelId,
      required this.listArtikel,
      required this.selectedArticle});

  final primaryColor = Color.fromRGBO(43, 69, 112, 1);
  final defaultColor = Colors.white;
  final abu = Color.fromRGBO(141, 148, 168, 1);

  @override
  Widget build(BuildContext context) {
    // Find the article with the specified ID
    Map<String, dynamic>? selectedArticle;
    for (var article in listArtikel) {
      if (article['article_id'] == artikelId.toString()) {
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
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 20),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 20, left: 8),
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
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[200],
                      ),
                      child: Image.network(
                        selectedArticle['profile'],
                        width: 60,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            selectedArticle['penulis'],
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(selectedArticle['tanggal_pembuatan']),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20, bottom: 20),
                child: Image.network(selectedArticle['pict']),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                child: Column(
                  children: [
                    Text(
                      selectedArticle['detail'],
                      // Replace this with your actual article detail content
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
