import 'dart:convert';
import 'dart:io';

import 'package:SmartHajj/auth/loginScreen.dart';
import 'package:SmartHajj/dashboard/productDetail/SnapToken.dart';
import 'package:SmartHajj/dashboard/topup/topupTabunganScreen.dart';
import 'package:SmartHajj/dompet/ProgressPaunter.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DompetScreen extends StatefulWidget {
  const DompetScreen({Key? key}) : super(key: key);

  @override
  _DompetScreenState createState() => _DompetScreenState();
}

class _DompetScreenState extends State<DompetScreen> {
  late HttpClientRequest request;
  late Future<Map<String, dynamic>> apiData;
  late Future<Map<String, dynamic>> apiSaldo;
  late Future<List<Map<String, dynamic>>> apiJamaah;
  int? selectedTotal;

  @override
  void initState() {
    super.initState();
    apiData = fetchData(); // Call your API function
    apiSaldo = fetchDataSaldo(); // Call your API function
    apiJamaah = fetchDataJamaah(); // Call your API function
  }

  Future<void> storeSelectedJamaah(String savingsId, String pilgrimId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedSavingsId', savingsId);
    await prefs.setString('selectedPilgrimId', pilgrimId);
  }

  Future<void> sendFormData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      String? savingsId = prefs.getString('selectedSavingsId');
      String? pilgrimId = prefs.getString('selectedPilgrimId');
      print("saving: $savingsId");
      print("pilgrim: $pilgrimId");

      if (token == null || savingsId == null || pilgrimId == null) {
        print("Required data is missing");
        return;
      }

      var data = FormData.fromMap({
        'saving_id': savingsId,
        'pilgrim_id': pilgrimId,
      });
      Dio dio = Dio();

      // Make the POST request using Dio
      var response = await dio.post(
        'https://smarthajj.coffeelabs.id/api/topupPayment',
        data: data,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      if (response.statusCode == 200) {
        var responseData = response.data;
        print('Snap Token: ${responseData['data']}');

        var paymentUrl = Uri.parse(
            'https://smarthajj.coffeelabs.id/pay/mobile/${responseData['data']}');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  SnapToken(paymentUrl: paymentUrl.toString())),
        );
        print('Payment process initiated successfully');
      } else {
        // Handle the case where the API response status code is not 200
        print(
            'Error: API Response - ${response.statusCode}, ${response.statusMessage}');
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.rightSlide,
          title: 'Transaksi Gagal',
          desc: 'Terdapat error saat melakukan transaksi',
          btnOkOnPress: () {},
          btnOkColor: Colors.red,
        )..show();
      }
    } on DioException catch (e) {
      // Something happened in setting up or sending the request that triggered an Error
      if (e.response != null) {
        // The request was made and the server responded with a status code
        // that falls out of the range of 2xx and is also not 304.
        print('DioError - Response Data: ${e.response!.data}');
        print('DioError - Status: ${e.response!.statusCode}');
      } else {
        // Something went wrong in setting up or sending the request
        print('DioError - Request: ${e.requestOptions}');
        print('DioError - Message: ${e.message}');
      }
      AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.rightSlide,
          title: 'Transaksi Gagal',
          desc: 'Terdapat error saat melakukan transaksi',
          btnOkOnPress: () {},
          btnOkColor: Colors.red)
        ..show();
    } catch (e) {
      // Handle generic exceptions
      print('Error: $e');
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.rightSlide,
        title: 'Transaksi Gagal',
        desc: 'Terdapat error saat melakukan transaksi',
        btnOkOnPress: () {},
        btnOkColor: Colors.red,
      )..show();
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
            dismissOnTouchOutside: false,
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

  Future<Map<String, dynamic>> fetchData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      String? apiUser = dotenv.env['API_USER'];

      if (token == null) {
        // Handle the case where the token is not available
        throw Exception('Token not available');
      }

      HttpClient httpClient = new HttpClient();
      httpClient.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;

      // Use httpClient.get instead of httpClient.getUrl
      if (apiUser != null) {
        request = await httpClient.getUrl(
          Uri.parse(apiUser),
        );
      }

      // Add token to headers
      request.headers.add('Authorization', 'Bearer $token');

      HttpClientResponse response = await request.close();

      String responseBody = await response.transform(utf8.decoder).join();
      if (response.statusCode == 200) {
        // If the server returns a 200 OK response, parse the JSON
        return jsonDecode(responseBody);
      } else {
        // If the server did not return a 200 OK response,
        // throw an exception.
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      // Catch any exceptions that occur during the process
      print('Error: $e');
      throw Exception('Failed to load data');
    }
  }

  final List<Map<String, dynamic>> totalSaldoTabungan = [
    {
      "id": 1,
      "name": "Total Saldo Tabungan",
      "totalSaldoTabungan": "Rp. 100.000.000",
      "target": "Rp. 277.000,00",
    },
  ];
  final List<Map<String, dynamic>> listSaldoJamaah = [
    {
      "id": 1,
      "title": "List Saldo Jamaah",
      "img": "assets/home/topup.png",
      "name": "Papa Khan",
      "totalSaldoTabungan": "Rp. 25.000.000",
      "nomorVirtualAkun": "9887146700043563",
      "nik": "3174082905005000",
      "paketTabunganUmrah": "Paket Tabungan Umrah Ramadhan (Rp.35.000.000)"
    },
    {
      "id": 2,
      "title": "",
      "img": "assets/home/topup.png",
      "name": "Ricky Setiawan",
      "totalSaldoTabungan": "Rp. 15.000.000",
      "nomorVirtualAkun": "9887146700043673",
      "nik": "3174082902345009",
      "paketTabunganUmrah": "Paket Tabungan Umrah Sya`ban (Rp. 35.000.000)"
    },
    // Tambahkan data lainnya di sini
  ];

  final primaryColor = Color.fromRGBO(43, 69, 112, 1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: primaryColor,
          title: Center(
            child: Text(
              'DOMPET',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          elevation: 0,
        ),
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
                  child: Text('Data is null'),
                ); // Handle the case when data is null
              } else {
                return Stack(children: <Widget>[
                  // Bagian atas
                  Container(
                    clipBehavior: Clip.none,
                    padding: EdgeInsets.only(top: 20),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: primaryColor,
                    ),
                    child: Column(
                      children: [
                        Container(
                          clipBehavior: Clip.none,
                          padding: EdgeInsets.only(bottom: 15),
                          child: ClipOval(
                              child: Image.asset(
                            'assets/home/profile.jpg',
                            width: 130,
                          )),
                        ),
                        Text(
                          snapshot.data!['name'],
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Container(
                          clipBehavior: Clip.none,
                          margin: EdgeInsets.only(top: 8),
                          child: Text(
                            snapshot.data!['email'],
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Container(
                          clipBehavior: Clip.none,
                          margin: EdgeInsets.only(top: 8),
                          child: Text(
                            snapshot.data!['phone'],
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 8),
                          child: Text(
                            'Transfer on Dec 2, 2020',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        FutureBuilder(
                          future: apiSaldo,
                          builder: (context,
                              AsyncSnapshot<Map<String, dynamic>> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
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

                              int? totalSaldo = snapshot.data!['total'] as int?;
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
                              return Container(
                                margin: EdgeInsets.only(top: 16),
                                child: Text(
                                  formattedTotalSaldo,
                                  style: TextStyle(
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                        Container(
                          clipBehavior: Clip.none,
                          margin: EdgeInsets.only(top: 24),
                          child: Image.asset('assets/dompet/info.png'),
                        ),
                      ],
                    ),
                  ),

                  FutureBuilder(
                      future: apiData,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else if (snapshot.data == null) {
                          return Center(child: Text('Data is null'));
                        } else {
                          return Stack(children: <Widget>[
                            // Your existing UI elements here...

                            // DraggableScrollableSheet
                            DraggableScrollableSheet(
                                initialChildSize:
                                    0.1, // Initial height of the sheet
                                minChildSize:
                                    0.1, // Minimum height of the sheet
                                maxChildSize: 1, // Maximum height of the sheet
                                builder: (BuildContext context,
                                    ScrollController scrollController) {
                                  return Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20.0),
                                          topRight: Radius.circular(20.0),
                                        ),
                                      ),
                                      child:
                                          FutureBuilder<
                                                  List<Map<String, dynamic>>>(
                                              future: apiJamaah,
                                              builder: (context, snapshot) {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return Center(
                                                      child:
                                                          CircularProgressIndicator());
                                                } else if (snapshot.hasError) {
                                                  return Center(
                                                      child: Text(
                                                          'Error: ${snapshot.error}'));
                                                } else if (snapshot.data ==
                                                        null ||
                                                    snapshot.data!.isEmpty) {
                                                  return Center(
                                                      child: Text(
                                                    'Belum ada Jamaah yang menabung!',
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  ));
                                                } else {
                                                  List<Map<String, dynamic>>
                                                      jamaahList =
                                                      snapshot.data!;

                                                  return ListView.builder(
                                                      controller:
                                                          scrollController,
                                                      itemCount:
                                                          jamaahList.length,
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              int index) {
                                                        // Build your list items
                                                        var item =
                                                            jamaahList[index];
                                                        double
                                                            depositTargetValue =
                                                            double.tryParse(
                                                                    item['deposit_target']
                                                                            ?.toString() ??
                                                                        '0') ??
                                                                0.0;

                                                        // Mengonversi depositValue ke format Rupiah
                                                        String
                                                            formattedDepositTarget =
                                                            NumberFormat.currency(
                                                                    locale:
                                                                        'id_ID',
                                                                    symbol:
                                                                        'Rp ',
                                                                    decimalDigits:
                                                                        0 // Gunakan 2 desimal untuk format rupiah
                                                                    )
                                                                .format(
                                                                    depositTargetValue);

                                                        double depositValue =
                                                            double.tryParse(
                                                                    item['deposit']
                                                                            ?.toString() ??
                                                                        '0') ??
                                                                0.0;

                                                        // Mengonversi depositValue ke format Rupiah
                                                        String
                                                            formattedDeposit =
                                                            NumberFormat.currency(
                                                                    locale:
                                                                        'id_ID',
                                                                    symbol:
                                                                        'Rp ',
                                                                    decimalDigits:
                                                                        0 // Gunakan 2 desimal untuk format rupiah
                                                                    )
                                                                .format(
                                                                    depositValue);

                                                        return ListTile(
                                                          title: index ==
                                                                  0 // Check if it's the first item
                                                              ? Container(
                                                                  margin: EdgeInsets
                                                                      .only(
                                                                          bottom:
                                                                              0,
                                                                          left:
                                                                              5),
                                                                  child: Column(
                                                                    children: [
                                                                      Container(
                                                                        child:
                                                                            Text(
                                                                          '____',
                                                                          style:
                                                                              TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.w800,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Row(
                                                                        children: [
                                                                          Text(
                                                                            'List Saldo Jamaah',
                                                                            style:
                                                                                TextStyle(
                                                                              fontWeight: FontWeight.w500,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                )
                                                              : SizedBox
                                                                  .shrink(),
                                                          subtitle: Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                              top: 15,
                                                              left: 5,
                                                              right: 5,
                                                            ),
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 20,
                                                                    right: 10,
                                                                    top: 10,
                                                                    bottom: 5),
                                                            width:
                                                                double.infinity,
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .all(Radius
                                                                          .circular(
                                                                              2)),
                                                              color: Color
                                                                  .fromRGBO(
                                                                      141,
                                                                      148,
                                                                      168,
                                                                      1),
                                                            ),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Container(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          bottom:
                                                                              5),
                                                                  child: Row(
                                                                    children: [
                                                                      Container(
                                                                        margin: EdgeInsets.only(
                                                                            right:
                                                                                15),
                                                                        child: Image.asset(
                                                                            'assets/home/topup.png'),
                                                                      ),
                                                                      Container(
                                                                        child:
                                                                            Text(
                                                                          formattedDeposit,
                                                                          style: TextStyle(
                                                                              fontSize: 26,
                                                                              fontWeight: FontWeight.w700,
                                                                              color: Colors.white),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Container(
                                                                    margin: EdgeInsets.only(
                                                                        left:
                                                                            52,
                                                                        bottom:
                                                                            10),
                                                                    child: Row(
                                                                      children: [
                                                                        Text(
                                                                          "Dari Harga Target: ",
                                                                          style: TextStyle(
                                                                              color: Colors.white,
                                                                              fontSize: 15),
                                                                        ),
                                                                        Text(
                                                                          "$formattedDepositTarget",
                                                                          style:
                                                                              TextStyle(
                                                                            color: Color.fromRGBO(
                                                                                203,
                                                                                255,
                                                                                113,
                                                                                1),
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    )),
                                                                Text(
                                                                  "Nomor Virtual Akun",
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  item[
                                                                      'va_number'],
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        20,
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    Text(
                                                                      item[
                                                                          'pilgrim_name'],
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            16,
                                                                        color: Colors
                                                                            .white,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      margin: EdgeInsets.only(
                                                                          left:
                                                                              20),
                                                                      child:
                                                                          Text(
                                                                        "NIK: ${item['nik']}",
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              14,
                                                                          color:
                                                                              Colors.white,
                                                                          fontWeight:
                                                                              FontWeight.w400,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                // Text(
                                                                //   "$item",
                                                                //   style: TextStyle(
                                                                //     fontSize: 13,
                                                                //     color: Colors
                                                                //         .white,
                                                                //     fontWeight:
                                                                //         FontWeight
                                                                //             .w400,
                                                                //   ),
                                                                // ),
                                                                ListTile(
                                                                    onTap: () {
                                                                      storeSelectedJamaah(
                                                                        item['savings_id']
                                                                            .toString(),
                                                                        item['pilgrim_id']
                                                                            .toString(),
                                                                      );
                                                                    },
                                                                    subtitle:
                                                                        Container(
                                                                      margin: EdgeInsets.only(
                                                                          left:
                                                                              30,
                                                                          right:
                                                                              30),
                                                                      child:
                                                                          ElevatedButton(
                                                                        onPressed:
                                                                            () {
                                                                          AwesomeDialog(
                                                                              context: context,
                                                                              dialogType: DialogType.question,
                                                                              animType: AnimType.rightSlide,
                                                                              title: 'Apakah anda yakin untuk melakukan Topup?',
                                                                              btnOkOnPress: () async {
                                                                                await storeSelectedJamaah(
                                                                                  item['savings_id'].toString(),
                                                                                  item['pilgrim_id'].toString(),
                                                                                );
                                                                                sendFormData();
                                                                              },
                                                                              btnOkText: 'Yakin',
                                                                              btnCancelText: 'Batal',
                                                                              btnCancelOnPress: () {},
                                                                              btnOkColor: Colors.green[600],
                                                                              btnCancelColor: Colors.red)
                                                                            ..show();
                                                                          // Simpan ID yang dipilih sebelum mengirim formulir
                                                                        },
                                                                        style:
                                                                            ButtonStyle(
                                                                          minimumSize:
                                                                              MaterialStateProperty.all(
                                                                            Size(double.infinity,
                                                                                30),
                                                                          ),
                                                                          backgroundColor:
                                                                              MaterialStateProperty.all(primaryColor),
                                                                          shape:
                                                                              MaterialStateProperty.all(
                                                                            RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(20),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        child:
                                                                            Text(
                                                                          "Tambah Saldo",
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.white,
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    )),
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      });
                                                }
                                              }));
                                })
                          ]);
                        }
                      })
                ]);
              }
            }));
  }
}
