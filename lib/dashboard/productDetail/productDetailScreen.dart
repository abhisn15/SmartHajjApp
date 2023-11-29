// import 'dart:convert';

// import 'package:SmartHajj/dashboard/productDetail/simulasiScreen.dart';
// import 'package:flutter/material.dart';
// import 'dart:ui';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

// class ProductDetailScreen extends StatefulWidget {
//   const ProductDetailScreen({Key? key}) : super(key: key);

//   @override
//   _ProductDetailScreen createState() => _ProductDetailScreen();
// }

// class _ProductDetailScreen extends State<ProductDetailScreen> {
//   late Future<Map<String, dynamic>> apiData;

//   @override
//   void initState() {
//     super.initState();
//     apiData = fetchData(); // Call your API function
//   }

//   Future<Map<String, dynamic>> fetchData() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? token = prefs.getString('token');
//     final response = await http.get(
//       Uri.parse('https://smarthajj.coffeelabs.id/api/getAllHajj'),
//       headers: {'Authorization': 'Bearer $token'},
//     );

//     if (response.statusCode == 200) {
//       // If the server returns a 200 OK response, parse the JSON
//       return jsonDecode(response.body);
//     } else {
//       // If the server did not return a 200 OK response,
//       // throw an exception.
//       throw Exception('Failed to load data');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           backgroundColor: Color.fromRGBO(43, 69, 112, 1),
//           title: Align(
//             alignment: Alignment.centerLeft, // Atur perataan teks ke tengah
//             child: Text(
//               product["name"],
//               style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 16,
//                   fontWeight: FontWeight.w700),
//             ),
//           ),
//           leading: BackButton(color: Colors.white),
//         ),
//         body: FutureBuilder(
//             future: apiData,
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 // If the Future is still running, display a loading indicator
//                 return Center(child: CircularProgressIndicator());
//               } else if (snapshot.hasError) {
//                 // If an error occurred, display the error message
//                 return Center(child: Text('Error: ${snapshot.error}'));
//               } else if (snapshot.data == null) {
//                 return Center(
//                     child: Text(
//                         'Data is null')); // Handle the case when data is null
//               } else {
//                 children:
//                 <Widget>[
//                   Stack(
//                     children: <Widget>[
//                       Image.asset(
//                         product["detailImg"],
//                         width: double.maxFinite,
//                       ),
//                       Positioned(
//                         child: Container(
//                           margin: EdgeInsets.only(top: 290),
//                           padding: EdgeInsets.only(top: 24),
//                           width: double.infinity,
//                           height: 720,
//                           decoration: BoxDecoration(
//                             color: Color.fromARGB(255, 255, 255, 255),
//                             borderRadius: BorderRadius.only(
//                               topLeft: Radius.circular(20.0),
//                               topRight: Radius.circular(20.0),
//                             ),
//                           ),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               Text(
//                                 product["name"],
//                                 style: TextStyle(
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.w700,
//                                   color: Color.fromRGBO(43, 69, 112, 1),
//                                 ),
//                                 textAlign: TextAlign.end,
//                               ),
//                               SizedBox(height: 10),
//                               Text(
//                                 "Jenis Tabungan",
//                                 style: TextStyle(
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.normal,
//                                 ),
//                               ),
//                               SizedBox(height: 10),
//                               Text(
//                                 product["tabungan"],
//                                 style: TextStyle(
//                                     fontSize: 24,
//                                     color: Color.fromRGBO(43, 69, 112, 1),
//                                     fontWeight: FontWeight.w700),
//                               ),
//                               SizedBox(height: 20),
//                               Container(
//                                 margin: EdgeInsets.symmetric(horizontal: 20),
//                                 child: Text(
//                                   "Lorem ipsum dolor sit amet consectetur. Vulputate dignissim accumsan pellentesque morbi tempus eget aliquam et diam. Enim id quis mauris velit vulputate aenean laoreet odio et. Pellentesque lacus elit enim integer. Quam purus porttitor congue libero at pellentesque eu sit.",
//                                   style: TextStyle(
//                                       fontSize: 12,
//                                       color: Colors.black,
//                                       fontWeight: FontWeight.w400),
//                                 ),
//                               ),
//                               SizedBox(height: 20),
//                               Container(
//                                 margin: EdgeInsets.symmetric(horizontal: 20),
//                                 child: Align(
//                                   alignment: Alignment
//                                       .centerLeft, // Atur perataan teks di sini
//                                   child: Text(
//                                     "Fitur",
//                                     style: TextStyle(
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.bold,
//                                       color: Color.fromRGBO(43, 69, 112, 1),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               Container(
//                                 margin: EdgeInsets.symmetric(
//                                     vertical: 10, horizontal: 20),
//                                 child: Align(
//                                   alignment: Alignment
//                                       .centerLeft, // Atur perataan teks di sini
//                                   child: Text(
//                                     "• Lorem ipsum dolor sit amet consectetur. Ut eget turpis lorem enim duis nunc scelerisque amet mattis.",
//                                     style: TextStyle(
//                                       fontSize: 12,
//                                       fontWeight: FontWeight.w400,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               Container(
//                                 margin: EdgeInsets.symmetric(horizontal: 20),
//                                 child: Align(
//                                   alignment: Alignment
//                                       .centerLeft, // Atur perataan teks di sini
//                                   child: Text(
//                                     "• Lorem ipsum dolor sit amet consectetur. Ut eget turpis lorem enim duis nunc scelerisque amet mattis.",
//                                     style: TextStyle(
//                                       fontSize: 12,
//                                       fontWeight: FontWeight.w400,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(height: 20),
//                               Container(
//                                 margin: EdgeInsets.symmetric(horizontal: 20),
//                                 child: Align(
//                                   alignment: Alignment
//                                       .centerLeft, // Atur perataan teks di sini
//                                   child: Text(
//                                     "Manfaat",
//                                     style: TextStyle(
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.bold,
//                                       color: Color.fromRGBO(43, 69, 112, 1),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               Container(
//                                 margin: EdgeInsets.symmetric(
//                                     vertical: 10, horizontal: 20),
//                                 child: Align(
//                                   alignment: Alignment
//                                       .centerLeft, // Atur perataan teks di sini
//                                   child: Text(
//                                     "• Lorem ipsum dolor sit amet consectetur. Ut eget turpis lorem enim duis nunc scelerisque amet mattis.",
//                                     style: TextStyle(
//                                       fontSize: 12,
//                                       fontWeight: FontWeight.w400,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               Container(
//                                 margin: EdgeInsets.symmetric(horizontal: 20),
//                                 child: Align(
//                                   alignment: Alignment
//                                       .centerLeft, // Atur perataan teks di sini
//                                   child: Text(
//                                     "• Lorem ipsum dolor sit amet consectetur. Ut eget turpis lorem enim duis nunc scelerisque amet mattis.",
//                                     style: TextStyle(
//                                       fontSize: 12,
//                                       fontWeight: FontWeight.w400,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(height: 20),
//                               Container(
//                                 margin: EdgeInsets.symmetric(horizontal: 20),
//                                 child: Align(
//                                   alignment: Alignment
//                                       .centerLeft, // Atur perataan teks di sini
//                                   child: Text(
//                                     "Persyaratan Yang Terkait",
//                                     style: TextStyle(
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.bold,
//                                       color: Color.fromRGBO(43, 69, 112, 1),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               Container(
//                                 margin: EdgeInsets.symmetric(
//                                     vertical: 10, horizontal: 20),
//                                 child: Align(
//                                   alignment: Alignment
//                                       .centerLeft, // Atur perataan teks di sini
//                                   child: Text(
//                                     "• Lorem ipsum dolor sit amet consectetur. Ut eget turpis lorem enim duis nunc scelerisque amet mattis.",
//                                     style: TextStyle(
//                                       fontSize: 12,
//                                       fontWeight: FontWeight.w400,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               Container(
//                                 margin: EdgeInsets.symmetric(horizontal: 20),
//                                 child: Align(
//                                   alignment: Alignment
//                                       .centerLeft, // Atur perataan teks di sini
//                                   child: Text(
//                                     "• Lorem ipsum dolor sit amet consectetur. Ut eget turpis lorem enim duis nunc scelerisque amet mattis.",
//                                     style: TextStyle(
//                                       fontSize: 12,
//                                       fontWeight: FontWeight.w400,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               Container(
//                                 padding: EdgeInsets.symmetric(
//                                     horizontal: 20, vertical: 24),
//                                 child: ElevatedButton(
//                                   onPressed: () {
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (context) => SimulasiScreen(),
//                                       ),
//                                     );
//                                   },
//                                   style: ElevatedButton.styleFrom(
//                                     primary: Color.fromRGBO(43, 69, 112, 1),
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(5.0),
//                                     ),
//                                     minimumSize: Size(350, 50),
//                                   ),
//                                   child: Text(
//                                     'MULAI MENABUNG',
//                                     style: TextStyle(
//                                       fontSize: 16.0,
//                                       color: Colors.white,
//                                       fontWeight: FontWeight.w700,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   )
//                   // Tambahkan informasi detail produk lainnya di sini
//                 ];
//               }
//             }));
//   }
// }
import 'package:SmartHajj/dashboard/productDetail/simulasiScreen.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

class ProductDetailScreen extends StatelessWidget {
  final Map<String, dynamic> product;

  ProductDetailScreen({required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(43, 69, 112, 1),
          title: Align(
            alignment: Alignment.centerLeft, // Atur perataan teks ke tengah
            child: Text(
              product["name"],
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700),
            ),
          ),
          leading: BackButton(color: Colors.white),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Image.asset(
                    product["detailImg"],
                    width: double.maxFinite,
                  ),
                  Positioned(
                    child: Container(
                      margin: EdgeInsets.only(top: 290),
                      padding: EdgeInsets.only(top: 24),
                      width: double.infinity,
                      height: 720,
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
                            product["name"],
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
                          Text(
                            product["tabungan"],
                            style: TextStyle(
                                fontSize: 24,
                                color: Color.fromRGBO(43, 69, 112, 1),
                                fontWeight: FontWeight.w700),
                          ),
                          SizedBox(height: 20),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              "Lorem ipsum dolor sit amet consectetur. Vulputate dignissim accumsan pellentesque morbi tempus eget aliquam et diam. Enim id quis mauris velit vulputate aenean laoreet odio et. Pellentesque lacus elit enim integer. Quam purus porttitor congue libero at pellentesque eu sit.",
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                          SizedBox(height: 20),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            child: Align(
                              alignment: Alignment
                                  .centerLeft, // Atur perataan teks di sini
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
                              alignment: Alignment
                                  .centerLeft, // Atur perataan teks di sini
                              child: Text(
                                "• Lorem ipsum dolor sit amet consectetur. Ut eget turpis lorem enim duis nunc scelerisque amet mattis.",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            child: Align(
                              alignment: Alignment
                                  .centerLeft, // Atur perataan teks di sini
                              child: Text(
                                "• Lorem ipsum dolor sit amet consectetur. Ut eget turpis lorem enim duis nunc scelerisque amet mattis.",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            child: Align(
                              alignment: Alignment
                                  .centerLeft, // Atur perataan teks di sini
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
                              alignment: Alignment
                                  .centerLeft, // Atur perataan teks di sini
                              child: Text(
                                "• Lorem ipsum dolor sit amet consectetur. Ut eget turpis lorem enim duis nunc scelerisque amet mattis.",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            child: Align(
                              alignment: Alignment
                                  .centerLeft, // Atur perataan teks di sini
                              child: Text(
                                "• Lorem ipsum dolor sit amet consectetur. Ut eget turpis lorem enim duis nunc scelerisque amet mattis.",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            child: Align(
                              alignment: Alignment
                                  .centerLeft, // Atur perataan teks di sini
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
                              alignment: Alignment
                                  .centerLeft, // Atur perataan teks di sini
                              child: Text(
                                "• Lorem ipsum dolor sit amet consectetur. Ut eget turpis lorem enim duis nunc scelerisque amet mattis.",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            child: Align(
                              alignment: Alignment
                                  .centerLeft, // Atur perataan teks di sini
                              child: Text(
                                "• Lorem ipsum dolor sit amet consectetur. Ut eget turpis lorem enim duis nunc scelerisque amet mattis.",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 24),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SimulasiScreen(),
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
              // Tambahkan informasi detail produk lainnya di sini
            ],
          ),
        ));
  }
}
