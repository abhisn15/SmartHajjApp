import 'dart:convert';
import 'dart:io';

import 'package:SmartHajj/auth/loginScreen.dart';
import 'package:SmartHajj/dashboard/productDetail/SnapToken.dart';
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

      if (token == null || savingsId == null || pilgrimId == null) {
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

        var paymentUrl = Uri.parse(
            'https://smarthajj.coffeelabs.id/pay/mobile/${responseData['data']}');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  SnapToken(paymentUrl: paymentUrl.toString())),
        );
      } else {
        // Handle the case where the API response status code is not 200
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
      } else {
        // Something went wrong in setting up or sending the request
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
        await Future.delayed(Duration(seconds: retryAfterSeconds));
        return fetchDataJamaah(); // Retry the request
      } else if (response.statusCode == 401) {
        // Handle unauthorized access (token expired, invalid, etc.)
        // Perform actions such as logging out the user or requesting a new token
        throw Exception('Unauthorized access: ${response.statusCode}');
      } else {
        throw Exception('Failed to load Jamaah data: ${response.statusCode}');
      }
    } catch (e) {
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

      if (response.statusCode == 200) {
        var responseData = response.data as Map<String, dynamic>;
        setState(() {
          // Assuming 'total' is meant to be a String
          selectedTotal = (responseData['total']);
        });
        return response.data;
      } else {
        throw Exception('Failed to load user data: ${response.statusCode}');
      }
    } catch (e) {
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
      throw Exception('Failed to load data');
    }
  }

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
                    padding: const EdgeInsets.only(top: 20),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: primaryColor,
                    ),
                    child: Column(
                      children: [
                        Container(
                          clipBehavior: Clip.none,
                          padding: const EdgeInsets.only(bottom: 15),
                          child: ClipOval(
                              child: Image.asset(
                            'assets/home/profile.jpg',
                            width: 130,
                          )),
                        ),
                        Text(
                          snapshot.data!['name'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Container(
                          clipBehavior: Clip.none,
                          margin: const EdgeInsets.only(top: 8),
                          child: Text(
                            snapshot.data!['email'],
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Container(
                          clipBehavior: Clip.none,
                          margin: const EdgeInsets.only(top: 8),
                          child: Text(
                            snapshot.data!['phone'],
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 8),
                          child: const Text(
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
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              // Print detailed error information
                              return Center(
                                  child: Text('Error: ${snapshot.error}'));
                            } else if (snapshot.data == null ||
                                snapshot.data!.isEmpty) {
                              return const Center(
                                  child: Text('Data is null or empty'));
                            } else {
                              // Print the complete response

                              int? totalSaldo = snapshot.data!['total'] as int?;
                              String formattedTotalSaldo =
                                  NumberFormat.currency(
                                          locale: 'id_ID',
                                          symbol: 'Rp ',
                                          decimalDigits: 0)
                                      .format(totalSaldo);

                              if (totalSaldo == null) {
                                return const Center(
                                    child: Text('Total saldo is null'));
                              }
                              return Container(
                                margin: const EdgeInsets.only(top: 16),
                                child: Text(
                                  formattedTotalSaldo,
                                  style: const TextStyle(
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
                            alignment: Alignment.center,
                            clipBehavior: Clip.none,
                            margin: const EdgeInsets.only(
                                top: 24, left: 40, right: 40),
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              height: 84,
                              width: double.infinity,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: const Color.fromARGB(82, 217, 217, 217),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(bottom: 25),
                                    child: Image.asset(
                                      'assets/dompet/pemberitahuan.png',
                                      height: 40,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Transfer made to bank account \ncould take a few minutes',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w300),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )),
                      ],
                    ),
                  ),

                  FutureBuilder(
                      future: apiData,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else if (snapshot.data == null) {
                          return const Center(child: Text('Data is null'));
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
                                      decoration: const BoxDecoration(
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

                                                        if ((item['pilgrim_name'] ??
                                                                    '')
                                                                .isEmpty ||
                                                            (item['deposit'] ??
                                                                    '')
                                                                .isEmpty ||
                                                            (item['va_number'] ??
                                                                    '')
                                                                .isEmpty) {
                                                          return SizedBox
                                                              .shrink(); // Mengembalikan widget kosong jika kondisi terpenuhi
                                                        }

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

                                                        double persentaseBar =
                                                            depositValue /
                                                                depositTargetValue;

                                                        String persentaseTeks =
                                                            "${(persentaseBar * 100).toStringAsFixed(0)}%";

                                                        return ListTile(
                                                          title: index ==
                                                                  0 // Check if it's the first item
                                                              ? Container(
                                                                  margin:
                                                                      const EdgeInsets
                                                                          .only(
                                                                          bottom:
                                                                              0,
                                                                          left:
                                                                              5),
                                                                  child: Column(
                                                                    children: [
                                                                      Container(
                                                                        width: double
                                                                            .infinity,
                                                                        margin: const EdgeInsets
                                                                            .symmetric(
                                                                            horizontal:
                                                                                160),
                                                                        child:
                                                                            const Center(
                                                                          child:
                                                                              Divider(
                                                                            color:
                                                                                Colors.black, // Ganti dengan warna yang Anda inginkan
                                                                            thickness:
                                                                                2, // Atur ketebalan garis
                                                                            height:
                                                                                20, // Jarak vertikal garis dari widget lainnya
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      const Row(
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
                                                              : const SizedBox
                                                                  .shrink(),
                                                          subtitle: Container(
                                                            margin:
                                                                const EdgeInsets
                                                                    .only(
                                                              top: 15,
                                                              left: 5,
                                                              right: 5,
                                                            ),
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    left: 20,
                                                                    right: 10,
                                                                    top: 10,
                                                                    bottom: 5),
                                                            width:
                                                                double.infinity,
                                                            decoration:
                                                                const BoxDecoration(
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
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .only(
                                                                          bottom:
                                                                              5),
                                                                  child: Row(
                                                                    children: [
                                                                      Container(
                                                                        margin: const EdgeInsets
                                                                            .only(
                                                                            right:
                                                                                15),
                                                                        child: Image.asset(
                                                                            'assets/home/topup.png'),
                                                                      ),
                                                                      Container(
                                                                        child:
                                                                            Text(
                                                                          formattedDeposit,
                                                                          style: const TextStyle(
                                                                              fontSize: 26,
                                                                              fontWeight: FontWeight.w700,
                                                                              color: Colors.white),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Container(
                                                                  margin:
                                                                      const EdgeInsets
                                                                          .only(
                                                                          bottom:
                                                                              4),
                                                                  child: Row(
                                                                    children: [
                                                                      const Text(
                                                                        'Presentase Tabungan : ',
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Colors.white,
                                                                          fontWeight:
                                                                              FontWeight.w400,
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        "$persentaseTeks",
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Colors.white,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Container(
                                                                  margin: const EdgeInsets
                                                                      .symmetric(
                                                                      vertical:
                                                                          10),
                                                                  child:
                                                                      ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                    child:
                                                                        TweenAnimationBuilder(
                                                                      duration: Duration(
                                                                          seconds:
                                                                              1), // Durasi animasi
                                                                      tween: Tween<
                                                                              double>(
                                                                          begin:
                                                                              0,
                                                                          end:
                                                                              persentaseBar),
                                                                      builder: (context,
                                                                              double value,
                                                                              child) =>
                                                                          LinearProgressIndicator(
                                                                        value:
                                                                            value,
                                                                        backgroundColor:
                                                                            Colors.grey[300],
                                                                        valueColor:
                                                                            AlwaysStoppedAnimation<Color>(primaryColor),
                                                                        minHeight:
                                                                            10,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Container(
                                                                    margin: EdgeInsets.only(
                                                                        bottom:
                                                                            8),
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
                                                                            fontSize:
                                                                                15,
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
