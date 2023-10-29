import 'package:flutter/material.dart';

class DompetScreen extends StatefulWidget {
  const DompetScreen({Key? key}) : super(key: key);

  @override
  _DompetScreenState createState() => _DompetScreenState();
}

class _DompetScreenState extends State<DompetScreen> {
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
      "paketTabunganUmrah": "35.000.000"
    },
    {
      "id": 2,
      "title": "",
      "img": "assets/home/topup.png",
      "name": "Ricky Setiawan",
      "totalSaldoTabungan": "Rp. 15.000.000",
      "nomorVirtualAkun": "9887146700043673",
      "nik": "3174082902345009",
      "paketTabunganUmrah": "Rp. 35.000.000"
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
                  'ILHAM RAFI',
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
                      color: primaryColor,
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
              initialChildSize: 0.4,
              minChildSize: MediaQuery.of(context).size.width < 400 ? 0.4 : 0.3,
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
                child: Row(
                  children: [
                    Container(
                        margin: EdgeInsets.only(right: 15),
                        child: Image.asset(item["img"])),
                    Text(
                      item['name'],
                      style: TextStyle(
                          fontWeight: FontWeight.w700, color: Colors.white),
                    ),
                  ],
                ),
              ),
              // Tambahkan tampilan lainnya seperti nomorVirtualAkun, nik, dan paketTabunganUmrah
              Text(
                item['totalSaldoTabungan'],
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Nomor Virtual Akun: ${item['nomorVirtualAkun']}",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "NIK: ${item['nik']}",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Paket Tabungan Umrah: ${item['paketTabunganUmrah']}",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
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
                child: Row(
                  children: [
                    Container(
                        margin: EdgeInsets.only(right: 15),
                        child: Image.asset(item["img"])),
                    Text(
                      item['totalSaldoTabungan'],
                      style: TextStyle(
                          fontWeight: FontWeight.w700, color: Colors.white),
                    ),
                  ],
                ),
              ),
              // Tambahkan tampilan lainnya seperti nomorVirtualAkun, nik, dan paketTabunganUmrah
              Text(
                item['name'],
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Nomor Virtual Akun: ${item['nomorVirtualAkun']}",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "NIK: ${item['nik']}",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Paket Tabungan Umrah: ${item['paketTabunganUmrah']}",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
