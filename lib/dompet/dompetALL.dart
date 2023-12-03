import 'dart:convert';
import 'dart:io';

import 'package:SmartHajj/dashboard/topup/topupTabunganScreen.dart';
import 'package:SmartHajj/dompet/ProgressPaunter.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DompetALL extends StatefulWidget {
  const DompetALL({Key? key}) : super(key: key);

  @override
  _DompetALLState createState() => _DompetALLState();
}

class _DompetALLState extends State<DompetALL> {
  late Future<Map<String, dynamic>> apiData;

  @override
  void initState() {
    super.initState();
    apiData = fetchData(); // Call your API function
  }

  Future<Map<String, dynamic>> fetchData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        // Handle the case where the token is not available
        throw Exception('Token not available');
      }

      HttpClient httpClient = new HttpClient();
      httpClient.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;

      // Use httpClient.get instead of httpClient.getUrl
      HttpClientRequest request = await httpClient.getUrl(
        Uri.parse('https://smarthajj.coffeelabs.id/api/user'),
      );

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
        backgroundColor: primaryColor,
        title: Container(
          margin: EdgeInsets.only(right: 50),
          child: Center(
            child: Text(
              'DOMPET',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        leading: BackButton(color: Colors.white),
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
            return Stack(
              children: <Widget>[
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
                        child: Image.asset('assets/dompet/profile.png'),
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
                      Container(
                        clipBehavior: Clip.none,
                        margin: EdgeInsets.only(top: 15),
                        child: Text(
                          'Rp. 100.000.000',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Container(
                        clipBehavior: Clip.none,
                        margin: EdgeInsets.only(top: 24),
                        child: Image.asset('assets/dompet/info.png'),
                      ),
                    ],
                  ),
                ),
                DraggableScrollableSheet(
                  initialChildSize: 0.3,
                  minChildSize:
                      MediaQuery.of(context).size.width < 400 ? 0.3 : 0.4,
                  maxChildSize: 1.0,
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
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.only(bottom: 16),
                            child: Text(
                              "____",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              controller: scrollController,
                              itemCount: totalSaldoTabungan.length +
                                  listSaldoJamaah.length,
                              itemBuilder: (BuildContext context, int index) {
                                if (index < totalSaldoTabungan.length) {
                                  final item = totalSaldoTabungan[index];
                                  return buildTotalSaldoTabunganItem(item);
                                } else {
                                  final item = listSaldoJamaah[
                                      index - totalSaldoTabungan.length];
                                  return buildListSaldoJamaahItem(item);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            );
          }
        },
      ),
    );
  }

  // Fungsi untuk membuat tampilan item "Total Saldo Tabungan"
  Widget buildTotalSaldoTabunganItem(Map<String, dynamic> item) {
    return ListTile(
      title: Container(
        margin: EdgeInsets.only(left: 5),
        child: Text(
          item['name'],
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      subtitle: Container(
        margin: EdgeInsets.only(
          top: 15,
          left: 5,
          right: 5,
          bottom: 10,
        ),
        padding: EdgeInsets.all(10),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(2)),
          color: Color.fromRGBO(77, 101, 172, 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(bottom: 5),
              child: Text(
                item['totalSaldoTabungan'],
                style: TextStyle(
                  fontSize: 32,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 5, bottom: 5),
              width: double.infinity,
              height: 4,
              color: Colors.green,
              child: Container(
                child: CustomPaint(
                  painter: ProgressPainter(),
                ),
              ),
            ),
            Text(
              "Dari Target ${item['target']}",
              style: TextStyle(
                fontSize: 16,
                color: Color.fromRGBO(250, 208, 208, 1),
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.left,
            ),
          ],
        ),
      ),
    );
  }

  // Fungsi untuk membuat tampilan item "List Saldo Jamaah"
  Widget buildListSaldoJamaahItem(Map<String, dynamic> item) {
    return ListTile(
      title: Container(
        margin: EdgeInsets.only(bottom: 10, left: 5),
        child: Text(
          item['title'],
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      subtitle: Container(
        margin: EdgeInsets.only(
          top: 15,
          left: 5,
          right: 5,
        ),
        padding: EdgeInsets.only(left: 20, right: 10, top: 10, bottom: 5),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(2)),
          color: Color.fromRGBO(141, 148, 168, 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(bottom: 5),
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 15),
                    child: Image.asset(item["img"]),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 5),
                    child: Text(
                      item['totalSaldoTabungan'],
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
              margin: EdgeInsets.only(left: 52, bottom: 10),
              color: Colors.green,
              width: double.infinity,
              height: 4,
              child: Container(
                margin: EdgeInsets.only(left: 150),
                child: CustomPaint(
                  painter: ProgressPainter(),
                ),
              ),
            ),
            Text(
              "Nomor Virtual Akun",
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              item['nomorVirtualAkun'],
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              children: [
                Text(
                  item['name'],
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20),
                  child: Text(
                    "NIK: ${item['nik']}",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
            Text(
              "${item['paketTabunganUmrah']}",
              style: TextStyle(
                fontSize: 13,
                color: Colors.white,
                fontWeight: FontWeight.w400,
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 30, right: 30),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TopupTabunganScreen(),
                    ),
                  );
                },
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(
                    Size(double.infinity, 30),
                  ),
                  backgroundColor: MaterialStateProperty.all(primaryColor),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                child: Text(
                  "Tambah Saldo",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
