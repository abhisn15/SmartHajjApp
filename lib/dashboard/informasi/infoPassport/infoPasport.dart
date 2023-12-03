import 'dart:convert';
import 'dart:io';
import 'package:SmartHajj/dashboard/informasi/infoPassport/ArtikelPasportScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InfoPasport extends StatefulWidget {
  const InfoPasport({Key? key}) : super(key: key);

  @override
  _InfoPasportState createState() => _InfoPasportState();
}

class _InfoPasportState extends State<InfoPasport> {
  final primaryColor = Color.fromRGBO(43, 69, 112, 1);
  final defaultColor = Colors.white;
  final abu = Color.fromRGBO(141, 148, 168, 1);
  final sedikitAbu = Color.fromRGBO(244, 244, 244, 1);
  final krems = Color.fromRGBO(238, 226, 223, 1);

  late HttpClientRequest request;
  late Future<List<Map<String, dynamic>>> listArtikel;

  @override
  void initState() {
    super.initState();
    listArtikel = fetchData();
  }

  Future<List<Map<String, dynamic>>> fetchData() async {
    try {
      String? apiArtikelPassport = dotenv.env['API_ARTICLE_PASSPORT'];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        throw Exception('Token not available');
      }

      HttpClient httpClient = new HttpClient();
      httpClient.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;

      if (apiArtikelPassport != null) {
        request = await httpClient.getUrl(Uri.parse(apiArtikelPassport));
      }

      request.headers.add('Authorization', 'Bearer $token');

      HttpClientResponse response = await request.close();

      String responseBody = await response.transform(utf8.decoder).join();
      if (response.statusCode == 200) {
        final List<Map<String, dynamic>> data =
            List<Map<String, dynamic>>.from(jsonDecode(responseBody));
        return data;
      } else {
        print('Response Body: $responseBody');
        print('Response Status Code: ${response.statusCode}');
        throw Exception('Failed to load user data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching user data: $e');
      throw Exception('Failed to load artikel');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Info Passport",
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
      body: Container(
        child: FutureBuilder(
          future: listArtikel,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.data == []) {
              return Center(child: Text('Data is null'));
            } else if (snapshot.data == null ||
                snapshot.data?.isEmpty == true) {
              return Center(child: Text('Artikel belum tersedia saat ini.'));
            } else {
              List<Map<String, dynamic>> artikelList =
                  snapshot.data as List<Map<String, dynamic>>;
              return ListView.builder(
                itemCount: artikelList.length,
                itemBuilder: (context, index) {
                  final listArtikel = artikelList[index];
                  return Container(
                    margin: EdgeInsets.only(top: 20),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ArtikelInfoPasportScreen(
                              artikelId: int.parse(listArtikel['article_id']),
                              listArtikel: artikelList,
                            ),
                          ),
                        );
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            child: Image.network(
                              "https://smarthajj.coffeelabs.id/storage/${listArtikel['pict']}",
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
                                  listArtikel['category_name'],
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
                                  listArtikel['headline'],
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              // Container(
                              //   margin: EdgeInsets.only(top: 10),
                              //   width: 140,
                              //   child: Text(
                              //     listArtikel[index]['waktu'],
                              //     style: TextStyle(
                              //       color: abu,
                              //       fontSize: 10,
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                        ],
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
              );
            }
          },
        ),
      ),
    );
  }
}
