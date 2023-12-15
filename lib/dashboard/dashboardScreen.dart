import 'dart:convert';
import 'dart:io';

import 'package:SmartHajj/BottomNavigationDompet.dart';
import 'package:SmartHajj/Dashboard/CustomCategoryButton.dart';
import 'package:SmartHajj/Dashboard/CustomInformationButton.dart';
import 'package:SmartHajj/auth/loginScreen.dart';
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
import 'package:SmartHajj/dashboard/kategori/berangkatLangsung.dart';
import 'package:SmartHajj/dashboard/kategori/tabunganQurban.dart';
import 'package:SmartHajj/dashboard/kategori/tabunganUmroh.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
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
  late Future<List<Map<String, dynamic>>> futureData;
  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> allData = [];
  List<Map<String, dynamic>> filteredData = [];
  int currentPage = 0;
  int itemsPerPage = 3; // Number of items per page
  int? selectedTotal;

  @override
  void initState() {
    super.initState();
    apiData = fetchData(); // Call your user API function
    apiSaldo = fetchDataSaldo(); // Call your user API function
    apiDataProduct = fetchDataProduct(); // Call your product API function
    apiDataProductId = fetchDataProductId();
    print(apiDataProductId);
    futureData = fetchDataJamaah();
    futureData.then((data) {
      allData = data;
      filteredData = allData;
    });
  }

  void filterSearchResults(String query) {
    if (query.isNotEmpty) {
      List<Map<String, dynamic>> dummyListData = [];
      allData.forEach((item) {
        if (item['pilgrim_name']
            .toString()
            .toLowerCase()
            .contains(query.toLowerCase())) {
          dummyListData.add(item);
        }
      });
      setState(() {
        filteredData = dummyListData;
        currentPage = 0;
      });
    } else {
      setState(() {
        filteredData = allData;
        currentPage = 0;
      });
    }
  }

  Future<List<Map<String, dynamic>>> fetchDataJamaah() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? apiPilgrim = dotenv.env['API_PAYMENTBYID'];
      String? token = prefs.getString('token');
      String? agentId = prefs.getString('agentId');

      if (token == null) {
        AwesomeDialog(
            context: context,
            dialogType: DialogType.error,
            animType: AnimType.rightSlide,
            title: 'Token Expired',
            desc: 'Token anda sudah kadaluarsa, harap login kembali!',
            btnOkOnPress: () {
              Navigator.pushReplacement(
                // Navigate to sendMail screen
                context,
                MaterialPageRoute(
                  builder: (context) => LoginScreen(),
                ),
              );
            },
            btnOkColor: Colors.red)
          ..show();
        throw Exception('Token not available');
      }

      HttpClient httpClient = new HttpClient();
      httpClient.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;

      if (apiPilgrim != null) {
        request = await httpClient.getUrl(Uri.parse("$apiPilgrim$agentId"));
      }
      request.headers.add('Authorization', 'Bearer $token');

      HttpClientResponse response = await request.close();
      print(response);

      String responseBody = await response.transform(utf8.decoder).join();

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = jsonDecode(responseBody);
        List<dynamic> fetchedData =
            jsonResponse['data']; // Access the 'data' key
        return fetchedData.cast<Map<String, dynamic>>();
      } else if (response.statusCode == 429) {
        // Handle rate limiting: wait for the specified duration and retry
        int retryAfterSeconds =
            int.tryParse(response.headers.value('Retry-After') ?? '5') ?? 5;
        print('Rate limited. Retrying after $retryAfterSeconds seconds.');
        await Future.delayed(Duration(seconds: retryAfterSeconds));
        return fetchDataJamaah(); // Retry the request
      } else if (response.statusCode == 401) {
        // Handle unauthorized access (token expired, invalid, etc.)
        print('Unauthorized access: ${response.statusCode}');
        // Perform actions such as logging out the user or requesting a new token
        throw Exception('Unauthorized access: ${response.statusCode}');
      } else {
        print('Response Body: $responseBody');
        print('Response Status Code: ${response.statusCode}');
        throw Exception('Failed to load Jamaah data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching Jamaah data: $e');
      throw Exception('Failed to load Jamaah data');
    }
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
    final TextEditingController _searchController = TextEditingController();
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
                                "TOTAL TABUNGAN",
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
                        padding: const EdgeInsets.only(
                            left: 16.0, right: 16.0, bottom: 16.0),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(238, 226, 223, 1),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20.0),
                            bottomRight: Radius.circular(20.0),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            FutureBuilder(
                              future: apiSaldo,
                              builder: (context,
                                  AsyncSnapshot<Map<String, dynamic>>
                                      snapshot) {
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          formattedTotalSaldo,
                                          style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(
                                            top: 30, bottom: 15),
                                        child: Center(
                                            child: Text(
                                          'TABUNGAN SAAT INI',
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black,
                                          ),
                                        )),
                                      ),
                                      TextField(
                                        onChanged: (value) {
                                          filterSearchResults(value);
                                        },
                                        controller: searchController,
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.white,
                                          hintText: 'Search...',
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 0,
                                              horizontal: 0), // Adjust padding

                                          // Add a search icon or button to the search bar
                                          prefixIcon: IconButton(
                                            icon: Icon(Icons.search),
                                            onPressed: () {
                                              // Perform the search here
                                            },
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 200,
                                        child: Column(
                                          children: [
                                            Expanded(
                                                child:
                                                    FutureBuilder<
                                                            Map<String,
                                                                dynamic>>(
                                                        future: apiSaldo,
                                                        builder: (context,
                                                            snapshot) {
                                                          if (snapshot
                                                                  .connectionState ==
                                                              ConnectionState
                                                                  .waiting) {
                                                            // If the Future is still running, display a loading indicator
                                                            return Center(
                                                                child:
                                                                    CircularProgressIndicator());
                                                          } else if (snapshot
                                                              .hasError) {
                                                            // If an error occurred, display the error message
                                                            return Center(
                                                                child: Text(
                                                                    'Error: ${snapshot.error}'));
                                                          } else if (snapshot
                                                                      .data ==
                                                                  null ||
                                                              selectedTotal ==
                                                                  0) {
                                                            return Container(
                                                              child: Center(
                                                                  child: Text(
                                                                'Belum ada Jamaah yang menabung!',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black),
                                                              )),
                                                            );
                                                          } else {
                                                            int startIndex =
                                                                currentPage *
                                                                    itemsPerPage;
                                                            int endIndex =
                                                                startIndex +
                                                                    itemsPerPage;
                                                            endIndex = endIndex >
                                                                    filteredData
                                                                        .length
                                                                ? filteredData
                                                                    .length
                                                                : endIndex;
                                                            List<
                                                                    Map<String,
                                                                        dynamic>>
                                                                pagedData =
                                                                filteredData.sublist(
                                                                    startIndex,
                                                                    endIndex);

                                                            return ListView
                                                                .builder(
                                                                    itemCount:
                                                                        pagedData
                                                                            .length,
                                                                    itemBuilder:
                                                                        (context,
                                                                            index) {
                                                                      final item =
                                                                          pagedData[
                                                                              index];
                                                                      Color
                                                                          backgroundColor =
                                                                          Color.fromRGBO(
                                                                              238,
                                                                              226,
                                                                              223,
                                                                              1);
                                                                      Color
                                                                          textColor =
                                                                          primaryColor;
                                                                      var deposit =
                                                                          double.tryParse(item['deposit'].toString()) ??
                                                                              0.0;
                                                                      String formattedDeposit = NumberFormat.currency(
                                                                              locale: 'id',
                                                                              symbol: 'Rp ',
                                                                              decimalDigits: 0)
                                                                          .format(deposit);
                                                                      return Column(
                                                                        children: [
                                                                          Container(
                                                                            margin:
                                                                                EdgeInsets.only(bottom: 12),
                                                                            height:
                                                                                50,
                                                                            width:
                                                                                double.infinity,
                                                                            padding:
                                                                                EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              border: Border.all(
                                                                                color: const Color.fromARGB(255, 0, 0, 0), // Color of the border
                                                                                width: 1, // Width of the border
                                                                              ),
                                                                              borderRadius: BorderRadius.circular(10.0),
                                                                              color: Colors.white,
                                                                            ),
                                                                            child:
                                                                                Container(
                                                                              alignment: Alignment.centerLeft,
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                                children: [
                                                                                  Text(item['pilgrim_name'] ?? ''),
                                                                                  Text(formattedDeposit),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      );
                                                                    });
                                                          }
                                                        })),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          // Tombol panah kiri
                                          Visibility(
                                            visible: currentPage > 0,
                                            child: IconButton(
                                              icon: Icon(Icons.arrow_back),
                                              onPressed: () {
                                                if (currentPage > 0) {
                                                  setState(() {
                                                    currentPage--;
                                                  });
                                                }
                                              },
                                            ),
                                          ),

                                          // Nomor halaman di tengah
                                          Container(
                                            margin: EdgeInsets.only(
                                              left: currentPage > 0
                                                  ? 0
                                                  : 48, // Tambahkan padding kiri jika panah kiri tidak ada
                                              right: (currentPage + 1) *
                                                          itemsPerPage <
                                                      filteredData.length
                                                  ? 0
                                                  : 48, // Tambahkan padding kanan jika panah kanan tidak ada
                                            ),
                                            child: Container(
                                              margin:
                                                  EdgeInsets.only(right: 10),
                                              child: Text(
                                                  'Halaman ${currentPage + 1} dari ${(filteredData.length / itemsPerPage).ceil()}'),
                                            ),
                                          ),

                                          // Tombol panah kanan
                                          Visibility(
                                            visible: (currentPage + 1) *
                                                    itemsPerPage <
                                                filteredData.length,
                                            child: IconButton(
                                              icon: Icon(Icons.arrow_forward),
                                              onPressed: () {
                                                if ((currentPage + 1) *
                                                        itemsPerPage <
                                                    filteredData.length) {
                                                  setState(() {
                                                    currentPage++;
                                                  });
                                                }
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                }
                              },
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
                            height: 250.0,
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
                                          child: Container(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Container(
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    child: Image.network(
                                                      'https://smarthajj.coffeelabs.id/storage/${product["image"]}',
                                                      width: 160,
                                                      height: 190,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 5.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Container(
                                                        width: 160,
                                                        child: Text(
                                                          product["name"],
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            color: Color(
                                                                0xFF2B4570),
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
                                      builder: (context) => BerangkatLangsung(),
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
