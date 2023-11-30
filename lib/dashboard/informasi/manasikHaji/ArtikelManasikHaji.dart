import 'package:flutter/material.dart';

class ArtikelManasikHajiScreen extends StatelessWidget {
  final int artikelId;
  final List<Map<String, dynamic>> listArtikel;

  ArtikelManasikHajiScreen(
      {required this.artikelId, required this.listArtikel});

  final primaryColor = Color.fromRGBO(43, 69, 112, 1);
  final defaultColor = Colors.white;
  final abu = Color.fromRGBO(141, 148, 168, 1);

  @override
  Widget build(BuildContext context) {
    // Find the article with the specified ID
    Map<String, dynamic>? selectedArticle;
    for (var article in listArtikel) {
      if (article['id'] == artikelId) {
        selectedArticle = article;
        break;
      }
    }

    if (selectedArticle == null) {
      // Handle the case where the article with the specified ID is not found
      return Scaffold(
        appBar: AppBar(
          title: Text("Manasik Haji"),
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
            "Manasik Haji",
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
                  selectedArticle['judul-artikel'],
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
                      child: Image.asset(
                        selectedArticle['profile'],
                        width: 60,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment
                            .start, // Align content to the left
                        children: [
                          Text(
                            selectedArticle['penulis'],
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                          ),
                          Text(selectedArticle['tanggal-pembuatan']),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                  margin: EdgeInsets.only(top: 20, bottom: 20),
                  child: Image.asset(selectedArticle['img'])),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                child: Column(
                  children: [
                    Text(
                        "git pull, a combination of git fetch + git merge, updates some parts of your local repository with changes from the remote repository. To understand what is and isn't affected by git pull, you need to first understand the concept of remote tracking branches. When you clone a repository, you clone one working branch, main, and all of the remote tracking branches. git fetch updates the remote tracking branches. "),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                child: Column(
                  children: [
                    Text(
                        "git pull, a combination of git fetch + git merge, updates some parts of your local repository with changes from the remote repository. To understand what is and isn't affected by git pull, you need to first understand the concept of remote tracking branches. When you clone a repository, you clone one working branch, main, and all of the remote tracking branches. git fetch updates the remote tracking branches. "),
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
