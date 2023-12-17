import 'dart:convert';
import 'dart:io';

import 'package:SmartHajj/dashboard/productDetail/productDetailScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:ui';

import 'package:shared_preferences/shared_preferences.dart';

class BerangkatLangsung extends StatefulWidget {
  const BerangkatLangsung({Key? key}) : super(key: key);

  @override
  _BerangkatLangsungState createState() => _BerangkatLangsungState();
}

class _BerangkatLangsungState extends State<BerangkatLangsung> {
  final primaryColor = Color.fromRGBO(43, 69, 112, 1);
  final defaultColor = Colors.white;
  final abu = Color.fromRGBO(141, 148, 168, 1);
  final sedikitAbu = Color.fromRGBO(244, 244, 244, 1);
  final krems = Color.fromRGBO(238, 226, 223, 1);

  late HttpClientRequest request;
  late Future<List<Map<String, dynamic>>> listKategori;

  @override
  void initState() {
    super.initState();
    listKategori = fetchData();
  }

  Future<List<Map<String, dynamic>>> fetchData() async {
    try {
      String? apiKategoriBerangkatLangsung =
          dotenv.env['API_KATEGORI_BERANGKATLANGSUNG'];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        throw Exception('Token not available');
      }

      HttpClient httpClient = new HttpClient();
      httpClient.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;

      if (apiKategoriBerangkatLangsung != null) {
        request =
            await httpClient.getUrl(Uri.parse(apiKategoriBerangkatLangsung));
      }
      request.headers.add('Authorization', 'Bearer $token');

      HttpClientResponse response = await request.close();

      String responseBody = await response.transform(utf8.decoder).join();
      if (response.statusCode == 200) {
        final List<Map<String, dynamic>> data =
            List<Map<String, dynamic>>.from(jsonDecode(responseBody));
        return data;
      } else {
        throw Exception('Failed to load user data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load kaetogri');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(43, 69, 112, 1),
        title: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Paket Berangkat Langsung",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700),
                ),
                Text(
                  "Kuatkan tekad, pasang niat, bismillah",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ],
        ),
        leading: const BackButton(
          color: Colors.white, // <-- SEE HERE
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(left: 24),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            children: [
              // Container(
              //   margin: EdgeInsets.only(bottom: 10),
              //   child: Row(
              //     children: [
              //       Container(
              //         margin: EdgeInsets.only(
              //           right: 10,
              //           left: 10,
              //         ),
              //         child: ElevatedButton(
              //           onPressed: () {
              //             // Navigator.push(
              //             //   context,
              //             //   MaterialPageRoute(
              //             //       builder: (context) =>
              //             //           SelengkapnyaTabunganLangsung()),
              //             // );
              //           },
              //           child: Row(
              //             children: [
              //               Container(
              //                 margin: EdgeInsets.only(right: 6),
              //                 child: Image.asset(
              //                   'assets/home/dropdown_filter.png',
              //                   width: 12,
              //                 ),
              //               ),
              //               Text(
              //                 "Filter | Umroh",
              //                 style:
              //                     TextStyle(color: Colors.white, fontSize: 12),
              //               ),
              //             ],
              //           ),
              //           style: ElevatedButton.styleFrom(
              //             minimumSize: Size(140, 25),
              //             primary: Color.fromRGBO(43, 69, 112, 1),
              //             shape: RoundedRectangleBorder(
              //               borderRadius: BorderRadius.circular(14.0),
              //             ),
              //           ),
              //         ),
              //       ),
              //       ElevatedButton(
              //         onPressed: () {
              //           // Navigator.push(
              //           //   context,
              //           //   MaterialPageRoute(
              //           //       builder: (context) =>
              //           //           SelengkapnyaTabunganLangsung()),
              //           // );
              //         },
              //         child: Row(
              //           children: [
              //             Container(
              //               margin: EdgeInsets.only(right: 6),
              //               child: Image.asset(
              //                 'assets/home/dropdown_filter.png',
              //                 width: 12,
              //               ),
              //             ),
              //             Text(
              //               "Filter | Travel Agent",
              //               style: TextStyle(color: Colors.white, fontSize: 12),
              //             ),
              //           ],
              //         ),
              //         style: ElevatedButton.styleFrom(
              //           minimumSize: Size(140, 25),
              //           primary: Color.fromRGBO(43, 69, 112, 1),
              //           shape: RoundedRectangleBorder(
              //             borderRadius: BorderRadius.circular(14.0),
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              Container(
                  margin: EdgeInsets.only(left: 0, right: 24),
                  height: 800,
                  child: FutureBuilder(
                      future: listKategori,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else if (snapshot.data == null) {
                          return Center(
                              child: Text(
                            'Kategori Produk Berangkat Langsung belum tersedia!',
                            style: TextStyle(color: Colors.black),
                            textAlign: TextAlign.center,
                          ));
                        } else if (snapshot.data == null ||
                            snapshot.data?.isEmpty == true) {
                          return Center(
                            child: Text(
                                textAlign: TextAlign.center,
                                'Kategori Produk Berangkat Langsung belum tersedia saat ini.'),
                          );
                        } else {
                          List<Map<String, dynamic>> kategori =
                              snapshot.data as List<Map<String, dynamic>>;

                          return ListView.builder(
                              itemCount: kategori.length,
                              itemBuilder: (context, index) {
                                final kategoriList = kategori[index];
                                final productId =
                                    kategoriList['packages_id'].toString();
                                String detail = kategoriList['detail'] ??
                                    ''; // Replace with your actual map access
                                List<String> words = detail.split(' ');
                                String splitText = words.length >= 7
                                    ? '${words[0]} ${words[1]} ${words[2]} ${words[3]} ${words[4]} ${words[5]}.....'
                                    : detail;
                                return Container(
                                  margin: EdgeInsets.only(top: 20, bottom: 30),
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    color: Color.fromRGBO(238, 226, 223, 1),
                                  ),
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                        child: Image.network(
                                          "https://smarthajj.coffeelabs.id/storage/${kategoriList['image']}",
                                          height: 140,
                                        ),
                                      ),
                                      Container(
                                        margin:
                                            EdgeInsets.only(top: 0, left: 16),
                                        padding: EdgeInsets.only(top: 12),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: 150,
                                              child: Text(
                                                '${kategoriList['name']}',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Color.fromRGBO(
                                                      43, 69, 112, 1),
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                textAlign: TextAlign.left,
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(top: 5),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    padding: EdgeInsets.only(
                                                        bottom: 10),
                                                    width: 150,
                                                    child: Text(
                                                      "Detail Paket: $splitText",
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: Color.fromRGBO(
                                                            43, 69, 112, 1),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      textAlign: TextAlign.left,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ProductDetailScreen(
                                                                product:
                                                                    kategoriList,
                                                                packageId:
                                                                    kategoriList[
                                                                        'packages_id'],
                                                              )),
                                                    );
                                                  },
                                                  child: Text(
                                                    "Selengkapnya",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    minimumSize: Size(140, 25),
                                                    primary: Color.fromRGBO(
                                                        43, 69, 112, 1),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              14.0),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              });
                        }
                      }))
            ],
          ),
        ),
      ),
    );
  }
}
