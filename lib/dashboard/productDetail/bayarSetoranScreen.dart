import 'package:SmartHajj/dashboard/topup/topupTabunganScreen.dart';
import 'package:flutter/material.dart';

class BayaranSetoranScreen extends StatefulWidget {
  const BayaranSetoranScreen({Key? key}) : super(key: key);

  @override
  _BayaranSetoranScreenState createState() => _BayaranSetoranScreenState();
}

class _BayaranSetoranScreenState extends State<BayaranSetoranScreen> {
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
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Container(
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
        leading: const BackButton(
          color: Colors.white, // <-- SEE HERE
        ),
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
              children: [
                Container(
                  clipBehavior: Clip.none,
                  padding: EdgeInsets.only(bottom: 15),
                  child: Image.asset('assets/dompet/profile.png'),
                ),
                Text(
                  'PAPA KHAN',
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
          Expanded(
            child: DraggableScrollableSheet(
              initialChildSize: 0.5,
              minChildSize: MediaQuery.of(context).size.width < 400 ? 0.5 : 0.4,
              maxChildSize: 1.0,
              builder:
                  (BuildContext context, ScrollController scrollController) {
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
          ),
        ],
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
              child: LinearProgressIndicator(
                value: (double.tryParse(item['totalSaldoTabungan']
                            .replaceAll('Rp. ', '')
                            .replaceAll(',', '')) ??
                        0) /
                    (double.tryParse(item['target']
                            .replaceAll('Rp. ', '')
                            .replaceAll(',', '')) ??
                        1),
                backgroundColor: Color.fromRGBO(250, 208, 208, 1),
                valueColor: AlwaysStoppedAnimation(Colors.green),
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
  // Fungsi untuk membuat tampilan item "List Saldo Jamaah"
  Widget buildListSaldoJamaahItem(Map<String, dynamic> item) {
    if (item['id'] == 1) {
      return ListTile(
        title: Container(
          child: Text("List Saldo Jamaah"),
          margin: EdgeInsets.only(left: 5),
        ),
        subtitle: Container(
          margin: EdgeInsets.only(
            top: 15,
            left: 5,
            right: 5,
            bottom: 10,
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
                        child: Image.asset(item["img"])),
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
              ),
              // Tambahkan tampilan lainnya seperti nomorVirtualAkun, nik, dan paketTabunganUmrah
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
                    minimumSize: MaterialStateProperty.all(Size(double.infinity,
                        30)), // Mengganti maximumSize ke minimumSize
                    backgroundColor: MaterialStateProperty.all(primaryColor),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
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
      );
    } else {
      // Jika id bukan 1, kembalikan widget kosong
      return ListTile(
        subtitle: Container(
          margin: EdgeInsets.only(
            top: 15,
            left: 5,
            right: 5,
            bottom: 10,
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
                        child: Image.asset(item["img"])),
                    Container(
                      padding: EdgeInsets.only(bottom: 5),
                      child: Text(
                        item['totalSaldoTabungan'],
                        style: TextStyle(
                            fontSize: 24,
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
                    minimumSize: MaterialStateProperty.all(Size(double.infinity,
                        30)), // Mengganti maximumSize ke minimumSize
                    backgroundColor: MaterialStateProperty.all(primaryColor),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
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
      );
    }
  }
}
