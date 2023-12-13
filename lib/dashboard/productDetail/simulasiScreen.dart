import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:SmartHajj/dashboard/productDetail/SnapToken.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:midtrans_sdk/midtrans_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NumberTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
    }

    final numericValue =
        int.tryParse(newValue.text.replaceAll(RegExp('[^0-9]'), ''));

    if (numericValue != null) {
      final formattedValue = NumberFormat.currency(
        locale: 'id',
        symbol: 'Rp',
        decimalDigits: 0,
      ).format(numericValue);

      return newValue.copyWith(
        text: formattedValue,
        selection: TextSelection.fromPosition(
          TextPosition(offset: formattedValue.length),
        ),
      );
    }

    // If parsing fails, return the old value
    return oldValue;
  }
}

class SimulasiScreen extends StatefulWidget {
  final String packageId;
  final String categoryId;
  final String name;
  final String agentId;

  const SimulasiScreen({
    required this.packageId,
    required this.categoryId,
    required this.name,
    required this.agentId,
    Key? key,
  }) : super(key: key);

  @override
  _SimulasiScreenState createState() => _SimulasiScreenState();
}

class DropdownItem {
  final String value;
  final String tanggal; // Additional data

  DropdownItem(this.value, this.tanggal);
}

class _SimulasiScreenState extends State<SimulasiScreen> {
  late HttpClientRequest request;
  late List<Map<String, dynamic>> jamaahList;
  MidtransSDK? _midtrans;

  @override
  void initState() {
    super.initState();
    // initSDK();
    widget.name;
    pilgrimIdController = TextEditingController();
    print('Package ID: ${widget.packageId}');
    print('category ID: ${widget.categoryId}');
    print('Agent ID: ${widget.agentId}');
  }

  String? hargaPerkiraan;
  String? departId;
  String? _selectedValueJamaah;
  String? selectedValue;

  final primaryColor = Color.fromRGBO(43, 69, 112, 1);
  final defaultColor = Colors.white;
  final abu = Color.fromRGBO(141, 148, 168, 1);
  final sedikitAbu = Color.fromRGBO(244, 244, 244, 1);
  final krems = Color.fromRGBO(238, 226, 223, 1);

  final List<String> items = [
    'Bank Transfer',
    'Payment Gate Away',
  ];

  void showAlert(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Pembayaran"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  TextEditingController departIdController = TextEditingController();
  TextEditingController pilgrimIdController = TextEditingController();
  TextEditingController depositController = TextEditingController();
  TextEditingController depositPlanController = TextEditingController();
  TextEditingController depositTargetController = TextEditingController();

  final websiteUri = Uri.parse('https://smarthajj.coffeelabs.id');

  Future<void> sendFormData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        throw Exception('Token not available');
      }

      print('Agent ID: ${widget.agentId}');
      print('Depart ID: ${departIdController.text}');
      print('Pilgrim ID: ${pilgrimIdController.text}');
      print('Package ID: ${widget.packageId}');
      print('Category ID: ${widget.categoryId}');
      print('Deposit : ${depositController.text}');
      print('Deposit Plan : ${depositPlanController.text}');
      print('Deposit Target : ${depositTargetController.text}');
      if (departIdController.text.isEmpty ||
          pilgrimIdController.text.isEmpty ||
          depositController.text.isEmpty ||
          depositPlanController.text.isEmpty ||
          depositTargetController.text.isEmpty) {
        List<String> emptyFields = [];
        if (departIdController.text.isEmpty) emptyFields.add('Depart ID');
        if (pilgrimIdController.text.isEmpty) emptyFields.add('Pilgrim ID');
        if (depositController.text.isEmpty) emptyFields.add('Deposit');
        if (depositPlanController.text.isEmpty) emptyFields.add('Deposit Plan');
        if (depositTargetController.text.isEmpty)
          emptyFields.add('Deposit Target');

        throw Exception(
            'Please fill in all required fields: ${emptyFields.join(', ')}');
      }

      // Prepare the data to be sent
      var data = FormData();

      data.fields.add(MapEntry('agent_id', "${widget.agentId}"));
      data.fields.add(MapEntry('depart_id', departIdController.text));
      data.fields.add(MapEntry('pilgrim_id', pilgrimIdController.text));
      data.fields.add(MapEntry('package_id', "${widget.packageId}"));
      data.fields.add(MapEntry('package_type', "${widget.categoryId}"));
      data.fields.add(MapEntry('deposit', depositController.text));
      data.fields.add(MapEntry('deposit_plan', depositPlanController.text));
      data.fields.add(MapEntry('deposit_target', "$hargaPerkiraan"));
      // Create Dio instance
      Dio dio = Dio();

      // Make the POST request using Dio
      var response = await dio.post(
        'https://smarthajj.coffeelabs.id/api/createPayment',
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
        Navigator.push(
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
      String? apiPilgrim = dotenv.env['API_AGENTBYID'];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      String? agentId = prefs.getString('agentId');
      // Ensure that token is not null before using it
      if (token == null || widget.packageId == null) {
        throw Exception('Token or Hajj ID not available');
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
        List<dynamic> jamaahList =
            jsonResponse['data']; // Access the 'data' key
        return jamaahList.cast<Map<String, dynamic>>();
      } else {
        print('Response Body: $responseBody');
        print('Response Status Code: ${response.statusCode}');
        // Provide a more meaningful error message
        throw Exception(
            'Failed to load user data. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching user data: $e');
      // Provide a more user-friendly error message
      throw Exception('Failed to load user data. Please try again later.');
    }
  }

  Future<List<Map<String, dynamic>>> fetchDataKeberangkatan() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? apiDepart = dotenv.env['API_DEPART'];
      String? token = prefs.getString('token');

      if (token == null) {
        throw Exception('Token not available');
      }

      HttpClient httpClient = new HttpClient();

      if (apiDepart != null) {
        request = await httpClient.getUrl(
          Uri.parse("$apiDepart" + "/${widget.packageId}"),
        );
      }

      httpClient.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;

      // HttpClientRequest request = await httpClient.getUrl(uri);
      request.headers.add('Authorization', 'Bearer $token');

      HttpClientResponse response = await request.close();

      String responseBody = await response.transform(utf8.decoder).join();
      if (response.statusCode == 200) {
        List<Map<String, dynamic>> keberangkatanList =
            List<Map<String, dynamic>>.from(jsonDecode(responseBody));
        return keberangkatanList;
      } else {
        throw Exception(
            'Failed to fetch departure data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching departure data: $e');
      throw Exception('Failed to fetch departure data');
    }
  }

  Future<List<Map<String, dynamic>>> fetchDataHarga() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? apiProduct = dotenv.env['API_DEPART'];
      String? token = prefs.getString('token');

      if (token == null) {
        throw Exception('Token not available');
      }

      HttpClient httpClient = new HttpClient();

      if (apiProduct != null) {
        request = await httpClient.getUrl(
          Uri.parse("$apiProduct" + "/${widget.packageId}" + "/$departId"),
        );
      }

      httpClient.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;

      // HttpClientRequest request = await httpClient.getUrl(uri);
      request.headers.add('Authorization', 'Bearer $token');

      HttpClientResponse response = await request.close();

      String responseBody = await response.transform(utf8.decoder).join();
      if (response.statusCode == 200) {
        List<Map<String, dynamic>> keberangkatanList =
            List<Map<String, dynamic>>.from(jsonDecode(responseBody));
        return keberangkatanList;
      } else {
        throw Exception(
            'Failed to fetch departure data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching departure data: $e');
      throw Exception('Failed to fetch departure data');
    }
  }

  String _totalSetoran = '';
  String _harganya = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Simulasi",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              "Kuatkan tekad, pasang niat, bismillah",
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        leading: const BackButton(
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(bottom: 20),
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 24),
                child: Column(
                  children: [
                    Text(
                      "Anda telah memilih",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 18,
                        color: primaryColor,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 12, left: 20, right: 20),
                      width: double.infinity,
                      height: 58,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(80)),
                        color: sedikitAbu,
                      ),
                      child: Center(
                        child: Text(
                          "${widget.name}",
                          style: TextStyle(color: abu),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 14),
                      child: Text(
                        "Harga Perkiraan",
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 18,
                          color: primaryColor,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: 12, left: 20, right: 20),
                      width: double.infinity,
                      height: 58,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(80)),
                        color: sedikitAbu,
                      ),
                      child: Center(
                        child: TextField(
                          controller: depositTargetController,
                          readOnly: true,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            color: Color.fromRGBO(43, 69, 112, 1),
                            fontWeight: FontWeight.w700,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 18),
                      color: primaryColor,
                      padding: EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 24,
                      ),
                      width: double.infinity,
                      child: Column(
                        children: [
                          Text(
                            "SIMULASI",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: krems,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 14),
                            child: Text(
                              "Masukkan Setoran Awal",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: krems,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 12),
                            width: double.infinity,
                            height: 58,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(80)),
                              color: defaultColor,
                            ),
                            child: Center(
                              child: TextField(
                                controller: depositController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  labelText: 'Masukkan Setoran Awal',
                                  labelStyle: TextStyle(fontSize: 15.0),
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 10.0,
                                    horizontal: 40.0,
                                  ),
                                ),
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                onChanged: (value) {},
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 14),
                            child: Text(
                              "Rencana Setoran Per Bulan",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: krems,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 12),
                            width: double.infinity,
                            height: 58,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(80)),
                              color: defaultColor,
                            ),
                            child: Center(
                              child: TextField(
                                controller: depositPlanController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  labelText: 'Masukkan Setoran Per Bulan',
                                  labelStyle: TextStyle(fontSize: 15.0),
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 10.0,
                                    horizontal: 40.0,
                                  ),
                                ),
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                onChanged: (value) {},
                              ),
                            ),
                          ),
                          // Container(
                          //   margin: EdgeInsets.symmetric(vertical: 20),
                          //   child: Text(
                          //     "Uang akan terkumpul setelah 7 Bulan",
                          //     style: TextStyle(
                          //       color: krems,
                          //       fontWeight: FontWeight.w700,
                          //       fontSize: 16,
                          //     ),
                          //   ),
                          // ),
                          Container(
                            margin: EdgeInsets.only(top: 16),
                            child: Text(
                              "Perkiraan Keberangkatan",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: krems,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 5),
                            width: double.infinity,
                            height: 58,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(80)),
                              color: sedikitAbu,
                            ),
                            child: FutureBuilder(
                              future: fetchDataKeberangkatan(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return CircularProgressIndicator(
                                    color: Colors.transparent,
                                  );
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else if (snapshot.hasData) {
                                  List<Map<String, dynamic>> keberangkatanList =
                                      List<Map<String, dynamic>>.from(
                                          snapshot.data!);
                                  return Column(
                                    children: [
                                      DropdownButton<String>(
                                        value: departId,
                                        items: keberangkatanList
                                            .asMap()
                                            .entries
                                            .map((entry) {
                                          int index = entry.key;
                                          Map<String, dynamic> keberangkatan =
                                              entry.value;
                                          return DropdownMenuItem<String>(
                                            value: keberangkatan['depart_id'],
                                            child: Container(
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 20),
                                              child: Text(
                                                '${keberangkatan['tanggal']}',
                                                style: TextStyle(
                                                  color: departId ==
                                                          keberangkatan[
                                                              'depart_id']
                                                      ? abu
                                                      : null,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: (String? selectedItem) {
                                          setState(() {
                                            departId = selectedItem;
                                            Map<String, dynamic>?
                                                selectedKeberangkatan =
                                                keberangkatanList.firstWhere(
                                                    (keberangkatan) =>
                                                        keberangkatan[
                                                            'depart_id'] ==
                                                        departId,
                                                    orElse: () =>
                                                        Map<String, dynamic>());

                                            hargaPerkiraan =
                                                selectedKeberangkatan?['price'];
                                            // deposit_target = hargaPerkiraan;

                                            depositTargetController.text =
                                                "$hargaPerkiraan";
                                            departIdController.text =
                                                "$departId";

                                            print(
                                                'Selected depart_id: $departId');
                                            print(
                                                'Updated hargaPerkiraan: $hargaPerkiraan');
                                            // print(
                                            //     'Updated deposit_target: $deposit_target');
                                          });
                                        },
                                        hint: Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: Text(
                                            departId ?? 'Select an option',
                                            style: TextStyle(
                                              color:
                                                  departId == null ? abu : null,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                } else {
                                  return Text('No data available.');
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  children: [
                    Container(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Jamaah Atas Nama",
                          style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.only(top: 5),
                            width: double.infinity,
                            height: 58,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(80)),
                              color: sedikitAbu,
                            ),
                            child: FutureBuilder(
                              future: fetchDataJamaah(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return CircularProgressIndicator(
                                    color: sedikitAbu,
                                  );
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else if (snapshot.hasData) {
                                  List<Map<String, dynamic>> jamaahList =
                                      snapshot.data!;

                                  // Hapus duplikat dari jamaahList
                                  jamaahList = jamaahList.toSet().toList();

                                  return Column(
                                    children: [
                                      DropdownButton<String>(
                                        value: _selectedValueJamaah,
                                        items: jamaahList.map((jamaah) {
                                          return DropdownMenuItem<String>(
                                            value: jamaah['pilgrim_id'],
                                            child: Container(
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 20),
                                              child: Text(
                                                '${jamaah['name']} - NIK ${jamaah['nik']}',
                                                style: TextStyle(
                                                  color: _selectedValueJamaah ==
                                                          jamaah['pilgrim_id']
                                                      ? abu
                                                      : null,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: (String? selectedItem) {
                                          setState(() {
                                            _selectedValueJamaah = selectedItem;
                                            pilgrimIdController.text =
                                                _selectedValueJamaah
                                                        ?.toString() ??
                                                    '';
                                            print(
                                                'Selected pilgrim_id: $_selectedValueJamaah');
                                            // Add any additional logic here based on the selected value
                                            // For example, you can use a switch statement:
                                          });
                                        },
                                        hint: Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: Text(
                                            _selectedValueJamaah ??
                                                'Select an option',
                                            style: TextStyle(
                                              color:
                                                  _selectedValueJamaah == null
                                                      ? abu
                                                      : null,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                } else {
                                  return Text('No data available.');
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Container(
              //   margin: EdgeInsets.only(top: 20),
              //   child: Row(
              //     children: [
              //       Container(
              //         margin: EdgeInsets.only(left: 24, bottom: 20),
              //         child: Text(
              //           "Pilih Pembayaran",
              //           style: TextStyle(
              //             color: primaryColor,
              //             fontWeight: FontWeight.w500,
              //             fontSize: 16,
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              // Container(
              //   margin: EdgeInsets.symmetric(horizontal: 30),
              //   padding: EdgeInsets.symmetric(vertical: 10),
              //   width: double.infinity,
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.all(Radius.circular(5)),
              //     color: Color.fromRGBO(141, 148, 168, 1),
              //   ),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       Container(
              //         margin: EdgeInsets.only(left: 20, right: 20),
              //         child: Image.asset("assets/home/topup.png"),
              //       ),
              //       DropdownButton<String>(
              //         hint: Text(
              //           'Select an option',
              //           style: TextStyle(
              //             fontSize: 14,
              //             color: defaultColor,
              //           ),
              //         ),
              //         dropdownColor: abu,
              //         icon: Container(
              //             margin: EdgeInsets.only(left: 80 * 1),
              //             child: Image.asset("assets/home/dropdown_down.png")),
              //         items: items
              //             .map((String item) => DropdownMenuItem<String>(
              //                   value: item,
              //                   child: Row(
              //                     children: [
              //                       Text(
              //                         item,
              //                         style: TextStyle(
              //                             fontSize: 14,
              //                             color: selectedValue == Text(item)
              //                                 ? Colors.white
              //                                 : Colors.white),
              //                       ),
              //                       SizedBox(
              //                           width:
              //                               10), // Beri jarak antara gambar dan teks
              //                     ],
              //                   ),
              //                 ))
              //             .toList(),
              //         value: selectedValue,
              //         onChanged: (String? value) {
              //           setState(() {
              //             selectedValue = value;
              //           });
              //         },
              //       ),
              //     ],
              //   ),
              // ),
              Container(
                margin: EdgeInsets.only(top: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: sendFormData,
                      child: Text(
                        "MULAI SETORAN AWAL",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(350, 45),
                        primary: primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
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
