import 'package:SmartHajj/dashboard/topup/topupTabunganScreen.dart';
import 'package:SmartHajj/jamaah/tambahSaldoScreen.dart';
import 'package:flutter/material.dart';

class DetailJamaahScreen extends StatefulWidget {
  final Map<String, dynamic> item;

  DetailJamaahScreen({required this.item});

  final primaryColor = Color.fromRGBO(43, 69, 112, 1);
  final defaultColor = Colors.white;

  @override
  _DetailJamaahScreenState createState() => _DetailJamaahScreenState();
}

class _DetailJamaahScreenState extends State<DetailJamaahScreen> {
  String? _selectedValue;
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
        elevation: 0,
      ),
      body: Stack(
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
              children: <Widget>[
                Container(
                  clipBehavior: Clip.none,
                  padding: EdgeInsets.only(bottom: 15),
                  child: Image.asset('assets/dompet/profile.png'),
                ),
                Text(
                  widget.item["name"],
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
                    '0853 2387 0429',
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
                    'Rp. 2.000.000,00',
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
            initialChildSize: 0.5,
            minChildSize: MediaQuery.of(context).size.width < 400 ? 0.5 : 0.3,
            maxChildSize: 1.0,
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                ),
                child: ListView(
                  controller: scrollController,
                  children: [
                    Column(
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
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          width: double.infinity,
                          height: 75,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            color: Color.fromRGBO(141, 148, 168, 1),
                          ),
                          child: Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 20, right: 20),
                                child: Image.asset("assets/home/topup.png"),
                              ),
                              Expanded(
                                // Wrap the DropdownButtonFormField with Expanded
                                child: Container(
                                  padding: EdgeInsets.only(bottom: 10),
                                  child: DropdownButtonFormField<String>(
                                    isExpanded: true,
                                    icon: Container(
                                      margin: EdgeInsets.only(right: 30),
                                      child: Image.asset(
                                        "assets/home/dropdown_down.png",
                                        width: 20,
                                        height: 20,
                                      ),
                                    ),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      prefixIconColor: primaryColor,
                                    ),
                                    value: _selectedValue,
                                    items: [
                                      DropdownMenuItem<String>(
                                        value: 'Mastercard 8923******',
                                        child: Container(
                                          child: Column(
                                            children: [
                                              Text(
                                                'Mastercard\n8923******',
                                                style: TextStyle(
                                                  color: _selectedValue ==
                                                          'Mastercard 8923******'
                                                      ? sedikitAbu
                                                      : Colors.black,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      DropdownMenuItem<String>(
                                        value: 'Virtual Account BCA 8923******',
                                        child: Container(
                                          child: Column(
                                            children: [
                                              Text(
                                                'Virtual Account BCA\n8923******',
                                                style: TextStyle(
                                                  color: _selectedValue ==
                                                          'Virtual Account BCA 8923******'
                                                      ? sedikitAbu
                                                      : Colors.black,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                    onChanged: (String? selectedItem) {
                                      setState(() {
                                        _selectedValue = selectedItem;
                                        print('Selected item: $selectedItem');
                                      });
                                    },
                                    hint: Container(
                                      child: Text(
                                        _selectedValue ?? 'Select an option',
                                        style: TextStyle(
                                          color: _selectedValue == null
                                              ? defaultColor
                                              : null,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 20, left: 20, right: 20),
                          width: double.infinity,
                          height: 160,
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(141, 148, 168, 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          child: Row(
                            children: [
                              Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 25,
                                  ),
                                  child: Image.asset(
                                    "assets/tabunganUmroh.png",
                                  )),
                              Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(top: 20),
                                    width: 220,
                                    child: Column(
                                      children: [
                                        Text(
                                          "Paket Tabungan Umroh Ramadhan",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700,
                                              color: defaultColor),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(top: 5),
                                          child: Row(
                                            children: [
                                              Text(
                                                "Jumlah Tabungan: Rp. 15.000.000,00",
                                                style: TextStyle(
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w700,
                                                    color: defaultColor),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(top: 5),
                                          child: Row(
                                            children: [
                                              Text(
                                                "VA: 12384859503",
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w700,
                                                    color: defaultColor),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          child: ElevatedButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      TopupTabunganScreen(),
                                                ),
                                              );
                                            },
                                            style: ButtonStyle(
                                              minimumSize: MaterialStateProperty
                                                  .all(Size(double.infinity,
                                                      30)), // Mengganti maximumSize ke minimumSize
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      primaryColor),
                                              shape: MaterialStateProperty.all(
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                              ),
                                              // Sesuaikan properti lain sesuai kebutuhan
                                            ),
                                            child: Text(
                                              "Topup Tabungan",
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
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 20, left: 20, right: 20),
                          width: double.infinity,
                          height: 160,
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(141, 148, 168, 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          child: Row(
                            children: [
                              Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 25,
                                  ),
                                  child: Image.asset(
                                    "assets/tabunganUmroh.png",
                                  )),
                              Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(top: 20),
                                    width: 220,
                                    child: Column(
                                      children: [
                                        Text(
                                          "Paket Tabungan Umroh Ramadhan",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700,
                                              color: defaultColor),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(top: 5),
                                          child: Row(
                                            children: [
                                              Text(
                                                "Jumlah Tabungan: Rp. 15.000.000,00",
                                                style: TextStyle(
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w700,
                                                    color: defaultColor),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(top: 5),
                                          child: Row(
                                            children: [
                                              Text(
                                                "VA: 12384859503",
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w700,
                                                    color: defaultColor),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          child: ElevatedButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      TopupTabunganScreen(),
                                                ),
                                              );
                                            },
                                            style: ButtonStyle(
                                              minimumSize: MaterialStateProperty
                                                  .all(Size(double.infinity,
                                                      30)), // Mengganti maximumSize ke minimumSize
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      primaryColor),
                                              shape: MaterialStateProperty.all(
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                              ),
                                              // Sesuaikan properti lain sesuai kebutuhan
                                            ),
                                            child: Text(
                                              "Topup Tabungan",
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
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 20, left: 20, right: 20),
                          width: double.infinity,
                          height: 160,
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(141, 148, 168, 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          child: Row(
                            children: [
                              Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 25,
                                  ),
                                  child: Image.asset(
                                    "assets/tabunganUmroh.png",
                                  )),
                              Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(top: 20),
                                    width: 220,
                                    child: Column(
                                      children: [
                                        Text(
                                          "Paket Tabungan Umroh Ramadhan",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700,
                                              color: defaultColor),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(top: 10),
                                          child: Row(
                                            children: [
                                              Text(
                                                "Rp. 2.000.000,00",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w700,
                                                    color: defaultColor),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          child: ElevatedButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      TambahSaldoScreen(),
                                                ),
                                              );
                                            },
                                            style: ButtonStyle(
                                              minimumSize: MaterialStateProperty
                                                  .all(Size(double.infinity,
                                                      30)), // Mengganti maximumSize ke minimumSize
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      primaryColor),
                                              shape: MaterialStateProperty.all(
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                              ),
                                              // Sesuaikan properti lain sesuai kebutuhan
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
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
