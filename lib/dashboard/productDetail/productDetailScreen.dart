import 'dart:convert';
import 'dart:io';

import 'package:SmartHajj/dashboard/productDetail/simulasiScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_html/flutter_html.dart';
import 'dart:ui';

import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductDetailScreen extends StatefulWidget {
  final Map<String, dynamic> product;
  final String packageId;

  ProductDetailScreen({required this.product, required this.packageId});

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late HttpClientRequest request;
  late Future<List<Map<String, dynamic>>> productData;

  @override
  void initState() {
    super.initState();
    productData = fetchDataProduct();
  }

  Future<List<Map<String, dynamic>>> fetchDataProduct() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? apiProduct = dotenv.env['API_PRODUCT_ID'];
      String? token = prefs.getString('token');

      if (token == null) {
        throw Exception('Token not available');
      }
      HttpClient httpClient = new HttpClient();

      if (apiProduct != null) {
        request = await httpClient.getUrl(
          Uri.parse(apiProduct + "/${widget.packageId}"),
        );
      }

      // Print the URI

      httpClient.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;

      // HttpClientRequest request = await httpClient.getUrl(uri);

      request.headers.add('Authorization', 'Bearer $token');

      HttpClientResponse response = await request.close();

      String responseBody = await response.transform(utf8.decoder).join();
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(jsonDecode(responseBody));
      } else {
        throw Exception('Failed to load product data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load product data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(43, 69, 112, 1),
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            widget.product["name"],
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        leading: BackButton(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Image.network(
                  'https://smarthajj.coffeelabs.id/storage/${widget.product["image"]}',
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  child: Container(
                    margin: EdgeInsets.only(top: 290),
                    padding: EdgeInsets.only(top: 24),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 255, 255, 255),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          widget.product["name"],
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Color.fromRGBO(43, 69, 112, 1),
                          ),
                          textAlign: TextAlign.end,
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Jenis Tabungan",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        SizedBox(height: 10),
                        // Text(
                        //   NumberFormat.currency(
                        //     locale: 'id_ID',
                        //     symbol: 'Rp ',
                        //   ).format(double.parse("200000")),
                        //   style: TextStyle(
                        //     fontSize: 24,
                        //     color: Color.fromRGBO(43, 69, 112, 1),
                        //     fontWeight: FontWeight.w700,
                        //   ),
                        // ),
                        SizedBox(height: 20),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          child: Html(
                            data: widget.product['detail'],
                            style: {
                              // You can customize the style here
                              'body': Style(
                                  fontSize: FontSize(12.0),
                                  fontWeight: FontWeight.w400),
                            },
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Fitur",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(43, 69, 112, 1),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Html(
                              data: widget.product['feature'],
                              style: {
                                // You can customize the style here
                                'body': Style(
                                    fontSize: FontSize(12.0),
                                    fontWeight: FontWeight.w400),
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Manfaat",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(43, 69, 112, 1),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Html(
                              data: widget.product['benefit'],
                              style: {
                                // You can customize the style here
                                'body': Style(
                                    fontSize: FontSize(12.0),
                                    fontWeight: FontWeight.w400),
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Persyaratan Yang Terkait",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(43, 69, 112, 1),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Html(
                              data: widget.product['terms'],
                              style: {
                                // You can customize the style here
                                'body': Style(
                                    fontSize: FontSize(12.0),
                                    fontWeight: FontWeight.w400),
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 24),
                          child: ElevatedButton(
                            onPressed: () async {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              String? agentId = prefs.getString('agentId');
                              if (agentId == null) {
                                // Handle the case where agentId is not available
                                return;
                              }
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SimulasiScreen(
                                    categoryId: '1',
                                    packageId: widget.product['packages_id'],
                                    name: widget.product['name'],
                                    agentId: agentId,
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Color.fromRGBO(43, 69, 112, 1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              minimumSize: Size(350, 50),
                            ),
                            child: Text(
                              'MULAI MENABUNG',
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
