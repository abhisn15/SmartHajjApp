import 'dart:convert';
import 'dart:io';

import 'package:SmartHajj/auth/loginScreen.dart';
import 'package:SmartHajj/dashboard/productDetail/SnapToken.dart';
import 'package:SmartHajj/dashboard/topup/topupTabunganScreen.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class DetailJamaahScreen extends StatefulWidget {
  final Map<String, dynamic> item;

  DetailJamaahScreen({required this.item});

  final primaryColor = Color.fromRGBO(43, 69, 112, 1);
  final defaultColor = Colors.white;

  @override
  _DetailJamaahScreenState createState() => _DetailJamaahScreenState();
}

class _DetailJamaahScreenState extends State<DetailJamaahScreen> {
  late HttpClientRequest request;

  late String pilgrimId;

  @override
  void initState() {
    super.initState();
    pilgrimId = widget.item['pilgrim_id'].toString();
    print(pilgrimId);
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

  Future<Map<String, dynamic>> fetchDataJamaahProfile() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? apiDetailPilgrim = dotenv.env['API_PAYMENT_DETAIL_PILGRIM'];
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

      var request = "$apiDetailPilgrim$pilgrimId";
      var response = await http
          .get(Uri.parse(request), headers: {'Authorization': 'Bearer $token'});

      print(response);

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        int total = jsonResponse['total'];
        print("Total: $total");

        // Assuming you want to return the entire jsonResponse including 'data' and 'total'
        return jsonResponse;
      } else {
        print('Error: ${response.statusCode}');
        return {};
      }
    } catch (e) {
      print('Exception: $e');
      return {};
    }
  }

  Future<Map<String, dynamic>> fetchDataJamaah() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? apiDetailPilgrim = dotenv.env['API_PAYMENT_DETAIL_PILGRIM'];
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

      var request = "$apiDetailPilgrim$pilgrimId";
      var response = await http
          .get(Uri.parse(request), headers: {'Authorization': 'Bearer $token'});

      print(response);

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        List<dynamic> data = jsonResponse['data'];
        print("Data : $data");

        // Check if data is not empty and convert first element of list to map
        if (data.isNotEmpty && data[0] is Map<String, dynamic>) {
          return data[0];
        } else {
          return {};
        }
      } else {
        print('Error: ${response.statusCode}');
        return {};
      }
    } catch (e) {
      print('Exception: $e');
      return {};
    }
  }

  final primaryColor = Color.fromRGBO(43, 69, 112, 1);
  final defaultColor = Colors.white;
  final sedikitAbu = Color.fromRGBO(244, 244, 244, 1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Container(
          child: Text(
            'DETAIL JAMAAH',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        leading: const BackButton(
          color: Colors.white, // <-- SEE HERE
        ),
        elevation: 0,
      ),
      body: Stack(
        children: <Widget>[
          // Bagian atas
          Container(
            height: double.maxFinite,
            clipBehavior: Clip.none,
            padding: EdgeInsets.only(top: 20),
            width: double.infinity,
            decoration: BoxDecoration(
              color: primaryColor,
            ),
            child: FutureBuilder(
                future: fetchDataJamaah(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // If the Future is still running, display a loading indicator
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                        child: Text(
                      'Jamaah belum menabung!',
                      style: TextStyle(color: Colors.white),
                    ));
                  } else {
                    Map<String, dynamic> jamaah =
                        snapshot.data as Map<String, dynamic>;
                    if (jamaah == null || jamaah.isEmpty) {
                      return Center(child: Text('Jamaah data is empty'));
                    }
                    return ListView.builder(
                        itemCount: 1,
                        itemBuilder: (context, index) {
                          final pilgrimName = jamaah['pilgrim_name'];
                          String depositString = jamaah['deposit'] ?? '0';
                          double totalSaldo =
                              double.tryParse(depositString) ?? 0.0;
                          String deposit = NumberFormat.currency(
                                  locale: 'id_ID',
                                  symbol: 'Rp ',
                                  decimalDigits: 0)
                              .format(totalSaldo);
                          return Container(
                            child: Column(
                              children: <Widget>[
                                Container(
                                    padding: EdgeInsets.only(bottom: 15),
                                    child: ClipOval(
                                      child: Image.network(
                                        'https://smarthajj.coffeelabs.id/storage/${jamaah['f_pic']}',
                                        width: 150,
                                        height: 150,
                                        fit: BoxFit.cover,
                                      ),
                                    )),
                                Text(
                                  pilgrimName,
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
                                    jamaah['pilgrim_phone'].toString(),
                                    style: TextStyle(
                                      color: Color.fromRGBO(141, 148, 168, 1),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 8),
                                  child: Text(
                                    'NIK: ${jamaah['pilgrim_nik']}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                FutureBuilder(
                                  future: fetchDataJamaahProfile(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      // If the Future is still running, display a loading indicator
                                      return Center(
                                          child: CircularProgressIndicator());
                                    } else if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    } else if (!snapshot.hasData ||
                                        snapshot.data!.isEmpty) {
                                      return Center(
                                          child: Text(
                                        'Belum ada Jamaah yang menabung!',
                                        style: TextStyle(color: Colors.white),
                                      ));
                                    } else {
                                      Map<String, dynamic> total =
                                          snapshot.data as Map<String, dynamic>;
                                      if (total == null || total.isEmpty) {
                                        return Center(
                                            child:
                                                Text('Jamaah data is empty'));
                                      }
                                      var deposit = double.tryParse(
                                              total['total'].toString()) ??
                                          0.0;
                                      String formattedDeposit =
                                          NumberFormat.currency(
                                                  locale: 'id',
                                                  symbol: 'Rp ',
                                                  decimalDigits: 0)
                                              .format(deposit);
                                      return Container(
                                        clipBehavior: Clip.none,
                                        margin: EdgeInsets.only(top: 15),
                                        child: Text(
                                          formattedDeposit,
                                          style: TextStyle(
                                            fontSize: 24,
                                            color: Color.fromRGBO(
                                                255, 255, 255, 1),
                                            fontWeight: FontWeight.w700,
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
                          );
                        });
                  }
                }),
          ),

          // INI ADALAH UNTUK BILA DI REVISI
          // FutureBuilder(
          //     future: fetchDataJamaahProfile(),
          //     builder: (context, snapshot) {
          //       if (snapshot.connectionState == ConnectionState.waiting) {
          //         // If the Future is still running, display a loading indicator
          //         return Center(child: CircularProgressIndicator());
          //       } else if (snapshot.hasError) {
          //         return Text('Error: ${snapshot.error}');
          //       } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          //         return Center(
          //             child: Text(
          //           'Belum ada Jamaah yang menabung!',
          //           style: TextStyle(color: Colors.white),
          //         ));
          //       } else {
          //         Map<String, dynamic> jamaah =
          //             snapshot.data as Map<String, dynamic>;
          //         if (jamaah == null || jamaah.isEmpty) {
          //           return Center(child: Text('Jamaah data is empty'));
          //         }
          //         int total = jamaah['total'];
          //         String formattedTotal = NumberFormat.currency(
          //                 locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0)
          //             .format(total);
          //         return ListView.builder(
          //             itemCount: 1,
          //             itemBuilder: (context, index) {
          //               final pilgrimName = jamaah['pilgrim_name'];
          //               String depositString = jamaah['deposit'] ?? '0';
          //               double totalSaldo =
          //                   double.tryParse(depositString) ?? 0.0;
          //               String deposit = NumberFormat.currency(
          //                       locale: 'id_ID',
          //                       symbol: 'Rp ',
          //                       decimalDigits: 0)
          //                   .format(totalSaldo);
          //               return Container(
          //                 child: Column(
          //                   children: <Widget>[
          //                     Container(
          //                         padding: EdgeInsets.only(bottom: 15),
          //                         child: ClipOval(
          //                           child: Image.network(
          //                             'https://smarthajj.coffeelabs.id/storage/${jamaah['f_pic']}',
          //                             width: 150,
          //                             height: 150,
          //                             fit: BoxFit.cover,
          //                           ),
          //                         )),
          //                     Text(
          //                       formattedTotal,
          //                       style: TextStyle(
          //                         color: Colors.white,
          //                         fontSize: 18,
          //                         fontWeight: FontWeight.w700,
          //                       ),
          //                     ),
          //                     Container(
          //                       clipBehavior: Clip.none,
          //                       margin: EdgeInsets.only(top: 8),
          //                       child: Text(
          //                         'phone',
          //                         style: TextStyle(
          //                           color: Color.fromRGBO(141, 148, 168, 1),
          //                           fontSize: 12,
          //                           fontWeight: FontWeight.w700,
          //                         ),
          //                       ),
          //                     ),
          //                     Container(
          //                       margin: EdgeInsets.only(top: 8),
          //                       child: Text(
          //                         'Transfer on Dec 2, 2020',
          //                         style: TextStyle(
          //                           color: Colors.white,
          //                           fontSize: 12,
          //                           fontWeight: FontWeight.w700,
          //                         ),
          //                       ),
          //                     ),
          //                     Container(
          //                       clipBehavior: Clip.none,
          //                       margin: EdgeInsets.only(top: 15),
          //                       child: Text(
          //                         deposit,
          //                         style: TextStyle(
          //                           fontSize: 24,
          //                           color: Color.fromRGBO(255, 255, 255, 1),
          //                           fontWeight: FontWeight.w700,
          //                         ),
          //                       ),
          //                     ),
          //                     Container(
          //                       clipBehavior: Clip.none,
          //                       margin: EdgeInsets.only(top: 24),
          //                       child: Image.asset('assets/dompet/info.png'),
          //                     ),
          //                   ],
          //                 ),
          //               );
          //             });
          //       }
          //     }),

          DraggableScrollableSheet(
            initialChildSize: 0.1,
            minChildSize: 0.1,
            maxChildSize: 1,
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                ),
                child: FutureBuilder(
                    future: fetchDataJamaah(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        // If the Future is still running, display a loading indicator
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(
                            child: Text(
                          'Belum ada Jamaah yang menabung!',
                          style: TextStyle(color: Colors.white),
                        ));
                      } else {
                        Map<String, dynamic> jamaah =
                            snapshot.data as Map<String, dynamic>;
                        if (jamaah == null || jamaah.isEmpty) {
                          return Center(child: Text('Jamaah data is empty'));
                        }
                        return ListView.builder(
                            itemCount: 1,
                            itemBuilder: (context, index) {
                              final pilgrimName = jamaah['pilgrim_name'];
                              String depositString = jamaah['deposit'] ?? '0';
                              double totalSaldo =
                                  double.tryParse(depositString) ?? 0.0;
                              String deposit = NumberFormat.currency(
                                      locale: 'id_ID',
                                      symbol: 'Rp ',
                                      decimalDigits: 0)
                                  .format(totalSaldo);
                              return Container(
                                height: 800,
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: ListView(
                                        controller: scrollController,
                                        children: [
                                          Column(
                                            children: [
                                              Container(
                                                child: Text(
                                                  "____",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                margin:
                                                    EdgeInsets.only(top: 20),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 20),
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                    color: Color.fromRGBO(
                                                        141, 148, 168, 1),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                5))),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                        child: Image.network(
                                                      "https://smarthajj.coffeelabs.id/storage/package/1702581120_image-removebg-preview%20(5).png",
                                                      width: 140,
                                                      height: 140,
                                                    )),
                                                    Column(
                                                      children: [
                                                        Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  left: 10),
                                                          width: 200,
                                                          child: Column(
                                                            children: [
                                                              Text(
                                                                "Paket Tabungan ${jamaah['package_name']}",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                    color:
                                                                        defaultColor),
                                                              ),
                                                              Container(
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        top: 5),
                                                                child: Row(
                                                                  children: [
                                                                    Text(
                                                                      "Jumlah Tabungan: $deposit",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              11,
                                                                          fontWeight: FontWeight
                                                                              .w700,
                                                                          color:
                                                                              defaultColor),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Container(
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        top: 5),
                                                                child: Row(
                                                                  children: [
                                                                    Text(
                                                                      "VA: ${jamaah['va_number']}",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              13,
                                                                          fontWeight: FontWeight
                                                                              .w700,
                                                                          color:
                                                                              defaultColor),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Container(
                                                                    child:
                                                                        ElevatedButton(
                                                                      onPressed:
                                                                          () {
                                                                        AwesomeDialog(
                                                                            context:
                                                                                context,
                                                                            dialogType: DialogType
                                                                                .question,
                                                                            animType: AnimType
                                                                                .rightSlide,
                                                                            title:
                                                                                'Apakah anda yakin untuk melakukan Topup?',
                                                                            btnOkOnPress:
                                                                                () async {
                                                                              await storeSelectedJamaah(
                                                                                jamaah['savings_id'].toString(),
                                                                                jamaah['pilgrim_id'].toString(),
                                                                              );
                                                                              sendFormData();
                                                                            },
                                                                            btnCancelOnPress:
                                                                                () {},
                                                                            btnOkColor:
                                                                                Colors.green[600],
                                                                            btnCancelColor: Colors.red)
                                                                          ..show();
                                                                        // Simpan ID yang dipilih sebelum mengirim formulir
                                                                      },
                                                                      style:
                                                                          ButtonStyle(
                                                                        minimumSize: MaterialStateProperty.all(Size(
                                                                            30,
                                                                            30)),
                                                                        backgroundColor:
                                                                            MaterialStateProperty.all(primaryColor),
                                                                        shape: MaterialStateProperty
                                                                            .all(
                                                                          RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(20),
                                                                          ),
                                                                        ),
                                                                        // Sesuaikan properti lain sesuai kebutuhan
                                                                      ),
                                                                      child:
                                                                          Text(
                                                                        "Topup Tabungan",
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Colors.white,
                                                                          fontWeight:
                                                                              FontWeight.w600,
                                                                        ),
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
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            });
                      }
                    }),
              );
            },
          ),
        ],
      ),
    );
  }
}
