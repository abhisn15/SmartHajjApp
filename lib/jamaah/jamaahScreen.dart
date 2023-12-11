import 'dart:convert';
import 'dart:io';
import 'package:SmartHajj/jamaah/editJamaahScreen.dart';
import 'package:flutter/material.dart';
import 'package:SmartHajj/jamaah/detailJamaahScreen.dart';
import 'package:SmartHajj/jamaah/tambahJamaahScreen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JamaahScreen extends StatefulWidget {
  const JamaahScreen({Key? key}) : super(key: key);

  @override
  _JamaahScreenState createState() => _JamaahScreenState();
}

class _JamaahScreenState extends State<JamaahScreen> {
  late HttpClientRequest request;
  late List<Map<String, dynamic>> daftarJamaah;

  @override
  void initState() {
    super.initState();
    // Fetch Jamaah data when the screen is initialized
    fetchDataJamaah();
  }

  Future<List<Map<String, dynamic>>> fetchDataJamaah() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? apiPilgrim = dotenv.env['API_PILGRIM'];
      String? token = prefs.getString('token');
      String? agentId = prefs.getString('users');

      if (token == null) {
        throw Exception('Token not available');
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
        List<Map<String, dynamic>> fetchedData =
            List<Map<String, dynamic>>.from(jsonDecode(responseBody));
        return fetchedData;
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

  final primaryColor = Color.fromRGBO(43, 69, 112, 1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: primaryColor,
        title: Center(
          child: Text(
            "DAFTAR JAMAAH",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
          ),
        ),
        elevation: 0,
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            TextButton(
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                String? agentId = prefs.getString('agentId');
                if (agentId == null) {
                  // Handle the case where agentId is not available
                  print('AgentId not available');
                  return;
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TambahJamaahScreen(
                      agentId: agentId,
                    ),
                  ),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "+ Tambah Jamaah",
                    style: TextStyle(
                      fontSize: 18,
                      color: Color.fromRGBO(43, 69, 112, 1),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: fetchDataJamaah(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // If the Future is still running, display a loading indicator
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    // If an error occurred, display the error message
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.data == null) {
                    return Center(child: Text('Data is null'));
                  } else {
                    List<Map<String, dynamic>> jamaahList = snapshot.data!;
                    return ListView.builder(
                      itemCount: jamaahList.length,
                      itemBuilder: (context, index) {
                        final item = jamaahList[index];
                        Color backgroundColor =
                            Color.fromRGBO(238, 226, 223, 1);
                        Color textColor = primaryColor;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 20.0),
                          padding: const EdgeInsets.only(
                              left: 20.0, top: 10, bottom: 10, right: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            color: backgroundColor,
                          ),
                          child: Row(
                            children: [
                              Image.network(
                                // Replace the placeholder with the actual image URL logic
                                'https://smarthajj.coffeelabs.id/storage/${item["f_pic"]}',
                                width: 100,
                                fit: BoxFit.cover,
                              ),
                              const SizedBox(width: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item["name"],
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: textColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Container(
                                    width: 200,
                                    child: Text(
                                      "NIK: ${item['nik']}",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: textColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Container(
                                    width: 200,
                                    child: Text(
                                      "VA: ${item['']}",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: textColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Kota / Provinsi:",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: primaryColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        item["city"],
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: primaryColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  DetailJamaahScreen(
                                                item: item,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Text(
                                          "Detail",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          minimumSize: Size(95, 25),
                                          primary:
                                              Color.fromRGBO(43, 69, 112, 1),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(14.0),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      ElevatedButton(
                                        onPressed: () async {
                                          SharedPreferences prefs =
                                              await SharedPreferences
                                                  .getInstance();
                                          String? agentId =
                                              prefs.getString('agentId');
                                          if (agentId == null) {
                                            // Handle the case where agentId is not available
                                            print('AgentId not available');
                                            return;
                                          }
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  EditJamaahScreen(
                                                agentId: agentId,
                                                pilgrimId: item["pilgrim_id"],
                                                item: item,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Text(
                                          "Edit",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          minimumSize: Size(95, 24),
                                          primary: primaryColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(14.0),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
