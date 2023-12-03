import 'dart:convert';
import 'dart:io';

import 'package:SmartHajj/dashboard/productDetail/setoranAwalScreen.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

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
  final String hajjId;
  final String departId;
  final String packageType;
  final String packageId;
  final String price;
  final String name;
  final String agentId;

  const SimulasiScreen({
    required this.hajjId,
    required this.departId,
    required this.packageType,
    required this.packageId,
    required this.price,
    required this.name,
    required this.agentId,
    Key? key,
  }) : super(key: key);

  @override
  _SimulasiScreenState createState() => _SimulasiScreenState();
}

class _SimulasiScreenState extends State<SimulasiScreen> {
  late HttpClientRequest request;
  late String hajjId;
  late String departId;
  late String packageType;
  late String packageId;
  late String pilgrimId;
  late String agentId;
  late String name;
  late List<Map<String, dynamic>> jamaahList;

  @override
  void initState() {
    super.initState();
    hajjId = widget.hajjId;
    departId = widget.departId;
    packageType = widget.packageType;
    packageId = widget.packageId;
    agentId = widget.agentId;
    agentId = widget.name;
    print('Hajj ID: $hajjId');
    print('Depart ID: $departId');
    print('PackageType: $packageType');
    print('Package ID: $packageId');
    print('Agent ID: $agentId');
  }

  String? _selectedValue;
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

  final TextEditingController deposit = TextEditingController();
  final TextEditingController deposit_plan = TextEditingController();
  String _totalSetoran = '';
  String _harganya = '';

  void _calculateTotal() {
    if (deposit.text.isNotEmpty && deposit_plan.text.isNotEmpty) {
      try {
        final setoranAwal = NumberFormat.decimalPattern()
            .parse(deposit.text.replaceAll(RegExp('[^0-9]'), ''))
            .toInt();
        final setoranPerBulan = NumberFormat.decimalPattern()
            .parse(deposit_plan.text.replaceAll(RegExp('[^0-9]'), ''))
            .toInt();
        final totalSetoran = setoranAwal + setoranPerBulan;
        final hargaPerkiraan = 35000000;
        final harganya = hargaPerkiraan - totalSetoran;

        setState(() {
          _totalSetoran = NumberFormat.currency(
            locale: 'id_ID',
            symbol: 'Rp ',
            decimalDigits: 0,
          ).format(totalSetoran);

          _harganya = NumberFormat.currency(
            locale: 'id_ID',
            symbol: 'Rp ',
            decimalDigits: 0,
          ).format(harganya);
        });
      } catch (e) {
        print("Error: $e");
        // Handle the error, for example, by showing a message to the user
      }
    }
  }

  void showAlert(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Login"),
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

  TextEditingController deposit_target = TextEditingController();
  TextEditingController depart_id = TextEditingController();
  TextEditingController agent_id = TextEditingController();

  final websiteUri = Uri.parse('https://smarthajj.coffeelabs.id');

  void payment(
    String deposit,
    String deposit_plan,
    String deposit_target,
  ) async {
    if (deposit.isEmpty || deposit_plan.isEmpty || deposit_target.isEmpty) {
      showAlert("Login anda tidak valid. Harap isi semua kolom.");
      return;
    }

    try {
      String? apiCreatePayment = dotenv.env['API_PAYMENT'];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      String? agentId = prefs.getString('users');

      HttpClient httpClient = new HttpClient();
      httpClient.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;

      if (apiCreatePayment != null) {
        request = await httpClient.postUrl(Uri.parse(apiCreatePayment));
      }

      // Add headers and body to the request
      request.headers.set('Content-Type', 'application/x-www-form-urlencoded');
      request.write(
          'deposit_target=$deposit_target&deposit=$deposit&deposit_plan=$deposit_plan&depart_id=$departId&agent_id=$agentId');

      HttpClientResponse response = await request.close();

      if (response.statusCode == 200) {
        // Reading response data
        String responseBody = await response.transform(utf8.decoder).join();
        var data = jsonDecode(responseBody);
        print(data['token']);
        print(data['users']);
        print('Login successfully');
        showAlert("Login Berhasil!");

        // Navigate to Dashboard on successful login
        // Navigator.pushAndRemoveUntil(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => BottomNavigation(),
        //   ),
        //   (route) => false,
        // );

        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('token', data['token']);
        prefs.setString('agentId', data['users'].toString());
        return;
      } else {
        print('Login Failed: ${response.statusCode}');
        showAlert("Login anda tidak valid. Silakan coba lagi.");
        return;
      }
    } catch (e) {
      print('Error during login: $e');
      showAlert("Login anda tidak valid. Terjadi Kesalahan.");
      return;
    }
  }

  // Future<Map<String, dynamic>> fetchData() async {
  //   try {
  //     String? apiAgentById = dotenv.env['API_AGENTBYID'];
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     String? token = prefs.getString('token');
  //     String? agentId = prefs.getString('users');
  //     // Ensure that token is not null before using it
  //     if (token == null) {
  //       throw Exception('Token not available');
  //     }

  //     print(apiAgentById);

  //     HttpClient httpClient = new HttpClient();
  //     httpClient.badCertificateCallback =
  //         (X509Certificate cert, String host, int port) => true;

  //     if (apiAgentById != null) {
  //       request = await httpClient.getUrl(Uri.parse(apiAgentById + '$agentId'));
  //     }

  //     request.headers.add('Authorization', 'Bearer $token');

  //     HttpClientResponse response = await request.close();

  //     String responseBody = await response.transform(utf8.decoder).join();
  //     if (response.statusCode == 200) {
  //       return jsonDecode(responseBody);
  //     } else {
  //       print('Response Body: $responseBody');
  //       print('Response Status Code: ${response.statusCode}');
  //       // Provide a more meaningful error message
  //       throw Exception(
  //           'Failed to load user data. Status Code: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     print('Error fetching user data: $e');
  //     // Provide a more user-friendly error message
  //     throw Exception('Failed to load user data. Please try again later.');
  //   }
  // }

  Future<List<Map<String, dynamic>>> fetchDataJamaah() async {
    try {
      String? apiPilgrim = dotenv.env['API_PILGRIM'];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      String? agentId = prefs.getString('users');
      // Ensure that token is not null before using it
      if (token == null || hajjId == null) {
        throw Exception('Token or Hajj ID not available');
      }

      HttpClient httpClient = new HttpClient();
      httpClient.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;

      if (apiPilgrim != null) {
        request = await httpClient.getUrl(Uri.parse(apiPilgrim));
      }

      request.headers.add('Authorization', 'Bearer $token');

      HttpClientResponse response = await request.close();

      String responseBody = await response.transform(utf8.decoder).join();
      if (response.statusCode == 200) {
        // Update jamaahList here
        jamaahList = List<Map<String, dynamic>>.from(jsonDecode(responseBody));
        return jamaahList;
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
      String? apiProduct = dotenv.env['API_PRODUCT'];
      String? token = prefs.getString('token');

      if (token == null) {
        throw Exception('Token not available');
      }

      HttpClient httpClient = new HttpClient();

      if (apiProduct != null) {
        request = await httpClient.getUrl(
          Uri.parse(apiProduct),
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
                      margin: EdgeInsets.only(top: 12, left: 20, right: 20),
                      width: double.infinity,
                      height: 58,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(80)),
                        color: sedikitAbu,
                      ),
                      child: Center(
                        child: Text(
                          _harganya,
                          style: TextStyle(
                              color: abu,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
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
                                controller: deposit,
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
                                onChanged: (value) {
                                  _calculateTotal();
                                  if (value.isNotEmpty) {
                                    final numericValue = int.parse(value);
                                    final formattedValue =
                                        NumberFormat.currency(
                                      locale: 'id',
                                      symbol: 'Rp ',
                                      decimalDigits: 0,
                                    ).format(numericValue);
                                    deposit.value = deposit.value.copyWith(
                                      text: formattedValue,
                                      selection: TextSelection.fromPosition(
                                        TextPosition(
                                            offset: formattedValue.length),
                                      ),
                                    );
                                  }
                                },
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
                                controller: deposit_plan,
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
                                onChanged: (value) {
                                  _calculateTotal();
                                  if (value.isNotEmpty) {
                                    final numericValue = int.parse(value);
                                    final formattedValue =
                                        NumberFormat.currency(
                                      locale: 'id',
                                      symbol: 'Rp ',
                                      decimalDigits: 0,
                                    ).format(numericValue);
                                    deposit_plan.value =
                                        deposit_plan.value.copyWith(
                                      text: formattedValue,
                                      selection: TextSelection.fromPosition(
                                        TextPosition(
                                            offset: formattedValue.length),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 20),
                            child: Text(
                              "Uang akan terkumpul setelah 7 Bulan",
                              style: TextStyle(
                                color: krems,
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Container(
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
                                        value: _selectedValue,
                                        items: keberangkatanList
                                            .asMap()
                                            .entries
                                            .map((entry) {
                                          int index = entry.key;
                                          Map<String, dynamic> keberangkatan =
                                              entry.value;
                                          return DropdownMenuItem<String>(
                                            value: keberangkatan[
                                                'depart_id'], // Set the value to "pilgrim_id"
                                            child: Container(
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 20),
                                              child: Text(
                                                '${keberangkatan['year']}',
                                                style: TextStyle(
                                                  color: _selectedValue ==
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
                                            _selectedValue = selectedItem;
                                            print(
                                                'Selected depart_id: $_selectedValue');

                                            // Add any additional logic here based on the selected value
                                            // For example, you can use a switch statement:
                                          });
                                        },
                                        hint: Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: Text(
                                            _selectedValue ??
                                                'Select an option',
                                            style: TextStyle(
                                              color: _selectedValue == null
                                                  ? abu
                                                  : null,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      )
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
                        padding: EdgeInsets.only(top: 5),
                        width: double.infinity,
                        height: 58,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(80)),
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
                              jamaahList = List<Map<String, dynamic>>.from(
                                  snapshot.data!);
                              return Column(
                                children: [
                                  DropdownButton<String>(
                                    value: _selectedValueJamaah,
                                    items:
                                        jamaahList.asMap().entries.map((entry) {
                                      int index = entry.key;
                                      Map<String, dynamic> jamaah = entry.value;
                                      return DropdownMenuItem<String>(
                                        value: jamaah[
                                            'pilgrim_id'], // Set the value to "pilgrim_id"
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
                                        print(
                                            'Selected pilgrim_id: $_selectedValueJamaah');

                                        // Add any additional logic here based on the selected value
                                        // For example, you can use a switch statement:
                                      });
                                    },
                                    hint: Container(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 20),
                                      child: Text(
                                        _selectedValueJamaah ??
                                            'Select an option',
                                        style: TextStyle(
                                          color: _selectedValueJamaah == null
                                              ? abu
                                              : null,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              );
                            } else {
                              return Text('No data available.');
                            }
                          },
                        )),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 24, bottom: 20),
                      child: Text(
                        "Pilih Pembayaran",
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 30),
                padding: EdgeInsets.symmetric(vertical: 10),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  color: Color.fromRGBO(141, 148, 168, 1),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 20, right: 20),
                      child: Image.asset("assets/home/topup.png"),
                    ),
                    DropdownButton<String>(
                      hint: Text(
                        'Select an option',
                        style: TextStyle(
                          fontSize: 14,
                          color: defaultColor,
                        ),
                      ),
                      dropdownColor: abu,
                      icon: Container(
                          margin: EdgeInsets.only(left: 80 * 1),
                          child: Image.asset("assets/home/dropdown_down.png")),
                      items: items
                          .map((String item) => DropdownMenuItem<String>(
                                value: item,
                                child: Row(
                                  children: [
                                    Text(
                                      item,
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: selectedValue == Text(item)
                                              ? Colors.white
                                              : Colors.white),
                                    ),
                                    SizedBox(
                                        width:
                                            10), // Beri jarak antara gambar dan teks
                                  ],
                                ),
                              ))
                          .toList(),
                      value: selectedValue,
                      onChanged: (String? value) {
                        setState(() {
                          selectedValue = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (selectedValue == 'Bank Transfer') {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => SetoranAwalScreen(),
                            ),
                          );
                        } else if (selectedValue == 'Payment Gate Away') {
                          launchUrl(websiteUri,
                              mode: LaunchMode.externalApplication);
                        } else if (selectedValue == 'Select an option') {
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.warning,
                            animType: AnimType.rightSlide,
                            title: 'Pilih Pembayaran',
                            desc: 'Harap pilih pembayaran yang diinginkan!!',
                            btnOkOnPress: () {},
                          )..show();
                        } else if (_selectedValue == 'Select an option' ||
                            _selectedValueJamaah == 'Select an option') {
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.error,
                            animType: AnimType.rightSlide,
                            title: 'Simulasi',
                            desc: 'Harap isi semua form!!',
                            btnOkOnPress: () {},
                          )..show();
                        }
                      },
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
