import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:SmartHajj/BottomNavigationDompet.dart';
import 'package:SmartHajj/Dashboard/CustomCategoryButton.dart';
import 'package:SmartHajj/Dashboard/CustomInformationButton.dart';
import 'package:SmartHajj/dashboard/checkoutDP.dart';
import 'package:SmartHajj/dashboard/informasi/hewanQurban/hewanQurban.dart';
import 'package:SmartHajj/dashboard/informasi/infoHotel/infoHotel.dart';
import 'package:SmartHajj/dashboard/informasi/infoMaktab/infoMaktab.dart';
import 'package:SmartHajj/dashboard/informasi/infoPassport/infoPasport.dart';
import 'package:SmartHajj/dashboard/informasi/infoPesawat/infoPesawat.dart';
import 'package:SmartHajj/dashboard/informasi/infoVisa/infoVisa.dart';
import 'package:SmartHajj/dashboard/informasi/manasikHaji/manasikHaji.dart';
import 'package:SmartHajj/dashboard/informasi/manasikUmroh/manasikUmroh.dart';
import 'package:SmartHajj/dashboard/kategori/tabunganHaji.dart';
import 'package:SmartHajj/dashboard/kategori/tabunganLangsung.dart';
import 'package:SmartHajj/dashboard/kategori/tabunganQurban.dart';
import 'package:SmartHajj/dashboard/kategori/tabunganUmroh.dart';
import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:SmartHajj/dashboard/productDetail/productDetailScreen.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late HttpClientRequest request;
  late Future<Map<String, dynamic>> apiData;
  late Future<Map<String, dynamic>> apiSaldo;
  late Future<List<Map<String, dynamic>>> apiDataProduct;
  late Future<List<Map<String, dynamic>>> apiDataProductId;
  int? selectedTotal;

  @override
  void initState() {
    super.initState();
    apiData = fetchData(); // Call your user API function
    apiSaldo = fetchDataSaldo(); // Call your user API function
    apiDataProduct = fetchDataProduct(); // Call your product API function
    apiDataProductId = fetchDataProductId();
    print(apiDataProductId);
  }

  Future<Map<String, dynamic>> fetchData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? apiUser = dotenv.env['API_USER'];
      String? token = prefs.getString('token');

      if (token == null) {
        // Handle the case where the token is not available
        throw Exception('Token not available');
      }

      HttpClient httpClient = HttpClient();
      httpClient.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;

      if (apiUser != null) {
        var request = await httpClient.getUrl(
          Uri.parse(apiUser),
        );
        request.headers.add('Authorization', 'Bearer $token');

        var response = await request.close();
        var responseBody = await utf8.decodeStream(response);

        if (response.statusCode == 200) {
          return jsonDecode(responseBody);
        } else {
          print('Response Body: $responseBody');
          print('Response Status Code: ${response.statusCode}');
          throw Exception('Failed to load user data: ${response.statusCode}');
        }
      } else {
        throw Exception('API_USER is not defined in the .env file');
      }
    } catch (e) {
      print('Error fetching user data: $e');
      throw Exception('Failed to load user data');
    }
  }

  Future<List<Map<String, dynamic>>> fetchDataProduct() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? apiProduct = dotenv.env['API_PRODUCT'];
      String? token = prefs.getString('token');
      String? agentId = prefs.getString('users');

      if (token == null) {
        throw Exception('Token not available');
      }

      HttpClient httpClient = new HttpClient();
      httpClient.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;

      if (apiProduct != null) {
        request = await httpClient.getUrl(Uri.parse(apiProduct));
      }

      request.headers.add('Authorization', 'Bearer $token');

      HttpClientResponse response = await request.close();

      String responseBody = await response.transform(utf8.decoder).join();
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(jsonDecode(responseBody));
      } else {
        print('Response Body: $responseBody');
        print('Response Status Code: ${response.statusCode}');
        throw Exception('Failed to load product data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching product data: $e');
      throw Exception('Failed to load product data');
    }
  }

  Future<Map<String, dynamic>> fetchDataSaldo() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      String? agentId = prefs.getString('agentId');

      if (token == null || agentId == null) {
        throw Exception('Token or Agent ID not available');
      }

      Dio dio = Dio();
      dio.options.headers['Authorization'] = 'Bearer $token';

      Response response = await dio.get(
        'https://smarthajj.coffeelabs.id/api/getPayment/$agentId',
      );

      print('Dio Response Status Code: ${response.statusCode}');

      if (response.statusCode == 200) {
        var responseData = response.data as Map<String, dynamic>;
        setState(() {
          // Assuming 'total' is meant to be a String
          selectedTotal = (responseData['total']);
        });
        print('Dio Response Data: ${responseData['data']}');
        return response.data;
      } else {
        throw Exception('Failed to load user data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching user data: $e');
      throw Exception('Failed to load user data');
    }
  }

  Future<List<Map<String, dynamic>>> fetchDataProductId() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? apiProduct = dotenv.env['API_PRODUCT_ID'];
      String? token = prefs.getString('token');
      String? agentId = prefs.getString('users');

      if (token == null) {
        throw Exception('Token not available');
      }

      HttpClient httpClient = new HttpClient();
      httpClient.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;

      if (apiProduct != null) {
        request = await httpClient.getUrl(Uri.parse(apiProduct));
      }

      request.headers.add('Authorization', 'Bearer $token');

      HttpClientResponse response = await request.close();

      String responseBody = await response.transform(utf8.decoder).join();
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(jsonDecode(responseBody));
      } else {
        print('Response Body: $responseBody');
        print('Response Status Code: ${response.statusCode}');
        throw Exception('Failed to load product data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching product data: $e');
      throw Exception('Failed to load product data');
    }
  }

  final List<Map<String, dynamic>> listKategori = [
    {
      "id": 1,
      "img": "assets/home/kategori/berangkat_langsung.png",
      "name": "Tabungan Langsung",
    },
    {
      "id": 2,
      "img": "assets/home/kategori/tabungan_umroh.png",
      "name": "Tabungan Umroh",
    },
    {
      "id": 3,
      "img": "assets/home/kategori/tabungan_haji.png",
      "name": "Tabungan Haji",
    },
    {
      "id": 4,
      "img": "assets/home/kategori/tabungan_qurban.png",
      "name": "Tabungan Qurban",
    }
  ];

  final List<Map<String, dynamic>> listInformasi = [
    {
      "id": 1,
      "img": "assets/home/informasi/info_pasport.png",
      "name": "Info Pasport",
    },
    {
      "id": 2,
      "img": "assets/home/informasi/info_visa.png",
      "name": "Info Visa",
    },
    {
      "id": 3,
      "img": "assets/home/informasi/info_pesawat.png",
      "name": "Info Pesawat",
    },
    {
      "id": 4,
      "img": "assets/home/informasi/info_hotel.png",
      "name": "Info Hotel",
    }
  ];

  final List<Map<String, dynamic>> listInformasi2 = [
    {
      "id": 1,
      "img": "assets/home/informasi/info_maktab.png",
      "name": "Info Maktab",
    },
    {
      "id": 2,
      "img": "assets/home/informasi/info_umroh.png",
      "name": "Manasik Umroh",
    },
    {
      "id": 3,
      "img": "assets/home/informasi/haji.png",
      "name": "Manasik Haji",
    },
    {
      "id": 4,
      "img": "assets/home/informasi/info_qurban.png",
      "name": "Hewan Qurban",
    }
  ];

  bool isTargetVisible = false;
  double targetTabunganBorderRadius = 20.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: apiData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // If the Future is still running, display a loading indicator
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              // If an error occurred, display the error message
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.data == null) {
              return Center(
                  child: Text(
                      'Data is null')); // Handle the case when data is null
            } else {
              Map<String, dynamic> userData =
                  snapshot.data as Map<String, dynamic>;
              return Container(
                color: Color.fromRGBO(43, 69, 112, 1),
                child: ListView(
                  padding: const EdgeInsets.only(top: 30.0),
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(top: 30.0, bottom: 20.0),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(43, 69, 112, 1),
                      ),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(left: 24.0),
                                child: ClipOval(
                                  child: Image.asset(
                                    'assets/home/profile.jpg',
                                    width: 70,
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 0.0, left: 13.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 0),
                                      child: Text(
                                        userData['name'],
                                        style: TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      userData['email'],
                                      style: TextStyle(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.bold,
                                        color:
                                            Color.fromARGB(255, 190, 194, 204),
                                      ),
                                    ),
                                    Text(
                                      userData['phone'],
                                      style: TextStyle(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF8D94A8),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    Container(
                      width: double.infinity,
                      height: 100.0,
                      decoration: BoxDecoration(
                        color: Color(0xFF8D94A8),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0),
                        ),
                      ),
                      margin: const EdgeInsets.only(
                        top: 20.0,
                        left: 24.0,
                        right: 24.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          FutureBuilder(
                            future: apiSaldo,
                            builder: (context,
                                AsyncSnapshot<Map<String, dynamic>> snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                // Print detailed error information
                                print('Error Details: ${snapshot.error}');
                                print('Stack Trace: ${snapshot.stackTrace}');
                                return Center(
                                    child: Text('Error: ${snapshot.error}'));
                              } else if (snapshot.data == null ||
                                  snapshot.data!.isEmpty) {
                                return Center(
                                    child: Text('Data is null or empty'));
                              } else {
                                // Print the complete response
                                print('Complete Response: ${snapshot.data}');

                                int? totalSaldo =
                                    snapshot.data!['total'] as int?;
                                String formattedTotalSaldo =
                                    NumberFormat.currency(
                                            locale: 'id_ID',
                                            symbol: 'Rp ',
                                            decimalDigits: 0)
                                        .format(totalSaldo);

                                if (totalSaldo == null) {
                                  return Center(
                                      child: Text('Total saldo is null'));
                                }
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 25.0, left: 30.0),
                                      child: Text(
                                        "SALDO TOTAL",
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 12.0, left: 30.0),
                                      child: Text(
                                        formattedTotalSaldo,
                                        style: TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }
                            },
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          BottomNavigationDompet(),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: 16.0,
                                    right: 37.0,
                                  ),
                                  child: Column(
                                    children: [
                                      Image.asset(
                                        "assets/home/topup.png",
                                        color: const Color.fromARGB(
                                            255, 219, 219, 219),
                                      ),
                                      Text(
                                        'Topup',
                                        style: TextStyle(
                                          fontSize: 18.0,
                                          color: Color(0xEEEEE2DF),
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
                    ClipRRect(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            isTargetVisible = !isTargetVisible;
                            targetTabunganBorderRadius =
                                isTargetVisible ? 0.0 : 20.0;
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.only(
                            right: 24.0,
                            left: 24.0,
                          ),
                          padding: EdgeInsets.all(16.0),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(238, 226, 223, 1),
                            borderRadius: BorderRadius.only(
                              bottomLeft:
                                  Radius.circular(targetTabunganBorderRadius),
                              bottomRight:
                                  Radius.circular(targetTabunganBorderRadius),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "TARGET TABUNGAN",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2B4570),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 20.0),
                                child: Image.asset(
                                  'assets/home/dropdown.png',
                                  color: primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: isTargetVisible,
                      child: Container(
                        margin: const EdgeInsets.only(
                          right: 24.0,
                          left: 24.0,
                        ),
                        padding: const EdgeInsets.all(16.0),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(238, 226, 223, 1),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20.0),
                            bottomRight: Radius.circular(20.0),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Rp. 100.000.000,00",
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Bagian daftar produk
                    Container(
                      margin: EdgeInsets.only(top: 20.0),
                      padding: EdgeInsets.only(top: 30.0),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(left: 24),
                            child: Text(
                              "Produk Terbaru",
                              style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                          Container(
                            height: 240.0,
                            margin: const EdgeInsets.only(
                                top: 20.0, bottom: 20, left: 0),
                            child: FutureBuilder<List<Map<String, dynamic>>>(
                              future: fetchDataProduct(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  // If the Future is still running, display a loading indicator
                                  return Center(
                                      child: CircularProgressIndicator());
                                } else if (snapshot.hasError) {
                                  // If an error occurred, display the error message
                                  return Center(
                                      child: Text('Error: ${snapshot.error}'));
                                } else if (snapshot.data == null) {
                                  return Center(child: Text('Data is null'));
                                } else {
                                  List<Map<String, dynamic>> productList =
                                      snapshot.data!;
                                  return ListView.builder(
                                    physics: BouncingScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    itemCount: productList.length,
                                    itemBuilder: (context, index) {
                                      final product = productList[index];
                                      final productId =
                                          product['package_id'].toString();
                                      return Container(
                                        margin: EdgeInsets.only(
                                          left: 20,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                              255, 255, 255, 255),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(20.0),
                                          ),
                                        ),
                                        child: ElevatedButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ProductDetailScreen(
                                                  product: product,
                                                  packageId: productId,
                                                  // departId:
                                                  //     product['depart_id'],
                                                ),
                                              ),
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            padding: EdgeInsets.all(0),
                                            primary: Colors.transparent,
                                            elevation: 0,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Container(
                                                child: Image.network(
                                                  'https://smarthajj.coffeelabs.id/storage/${product["image"]}',
                                                  width: 160,
                                                  height: 190,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 5.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Container(
                                                      width: 150,
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(
                                                        product["name"],
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          color:
                                                              Color(0xFF2B4570),
                                                          fontWeight:
                                                              FontWeight.w800,
                                                        ),
                                                      ),
                                                    ),
                                                    // Text(
                                                    //   "Berangkat ${product['date']}-${product['month']}-${product['year']}",
                                                    //   style: TextStyle(
                                                    //     fontSize: 14.0,
                                                    //     color: Color.fromRGBO(
                                                    //         141, 148, 168, 1),
                                                    //   ),
                                                    // ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                }
                              },
                            ),
                          ),
                          Container(
                              margin: EdgeInsets.only(left: 24),
                              child: Text(
                                'Kategori',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w700),
                              )),
                          Row(
                            mainAxisAlignment: MainAxisAlignment
                                .center, //Center Row contents horizontally,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CustomCategoryButton(
                                image:
                                    "assets/home/kategori/berangkat_langsung.png",
                                text: "Berangkat Langsung",
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => TabunganLangsung(),
                                    ),
                                  );
                                },
                              ),
                              CustomCategoryButton(
                                image:
                                    "assets/home/kategori/tabungan_umroh.png",
                                text: "Tabungan Umroh",
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => TabunganUmroh(),
                                    ),
                                  );
                                },
                              ),
                              CustomCategoryButton(
                                image: "assets/home/kategori/tabungan_haji.png",
                                text: "Tabungan Haji",
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => TabunganHaji(),
                                    ),
                                  );
                                },
                              ),
                              CustomCategoryButton(
                                image:
                                    "assets/home/kategori/tabungan_qurban.png",
                                text: "Tabungan Qurban",
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => TabunganQurban(),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          Container(
                              margin: EdgeInsets.only(left: 24),
                              child: Text(
                                'Informasi',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w700),
                              )),
                          Row(
                            mainAxisAlignment: MainAxisAlignment
                                .center, //Center Row contents horizontally,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CustomInformationButton(
                                image: "assets/home/informasi/info_pasport.png",
                                text: "Info Passport",
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => InfoPasport()));
                                },
                              ),
                              CustomInformationButton(
                                image: "assets/home/informasi/info_visa.png",
                                text: "Info Visa",
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => InfoVisa()));
                                },
                              ),
                              CustomInformationButton(
                                image: "assets/home/informasi/info_pesawat.png",
                                text: "Info Pesawat",
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => InfoPesawat()));
                                },
                              ),
                              CustomInformationButton(
                                image: "assets/home/informasi/info_hotel.png",
                                text: "Info Hotel",
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => InfoHotel()));
                                },
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment
                                .center, //Center Row contents horizontally,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CustomInformationButton(
                                image: "assets/home/informasi/info_maktab.png",
                                text: "Info Maktab",
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => InfoMaktab()));
                                },
                              ),
                              CustomInformationButton(
                                image: "assets/home/informasi/info_umroh.png",
                                text: "Manasik Umroh",
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ManasikUmroh()));
                                },
                              ),
                              CustomInformationButton(
                                image: "assets/home/informasi/haji.png",
                                text: "Manasik Haji",
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ManasikHaji()));
                                },
                              ),
                              CustomInformationButton(
                                image: "assets/home/informasi/info_qurban.png",
                                text: "Hewan Qurban",
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => HewanQurban()));
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
          }),
    );
  }
}
