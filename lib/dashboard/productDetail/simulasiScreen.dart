import 'package:SmartHajj/dashboard/productDetail/setoranAwalScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
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

  const SimulasiScreen({required this.hajjId, Key? key}) : super(key: key);

  @override
  _SimulasiScreenState createState() => _SimulasiScreenState();
}

class _SimulasiScreenState extends State<SimulasiScreen> {
  late String hajjId;

  @override
  void initState() {
    super.initState();
    hajjId = widget.hajjId;
    print('Hajj ID: $hajjId');
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

  final TextEditingController _setoranAwalController = TextEditingController();
  final TextEditingController _setoranPerBulanController =
      TextEditingController();
  String _totalSetoran = '';
  String _harganya = '';

  void _calculateTotal() {
    if (_setoranAwalController.text.isNotEmpty &&
        _setoranPerBulanController.text.isNotEmpty) {
      try {
        final setoranAwal = NumberFormat.decimalPattern()
            .parse(_setoranAwalController.text.replaceAll(RegExp('[^0-9]'), ''))
            .toInt();
        final setoranPerBulan = NumberFormat.decimalPattern()
            .parse(_setoranPerBulanController.text
                .replaceAll(RegExp('[^0-9]'), ''))
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

  final websiteUri = Uri.parse('https://smarthajj.coffeelabs.id');

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
                          "PAKET TABUNGAN UMROH RAMADHAN",
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
                                controller: _setoranAwalController,
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
                                    _setoranAwalController.value =
                                        _setoranAwalController.value.copyWith(
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
                                controller: _setoranPerBulanController,
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
                                    _setoranPerBulanController.value =
                                        _setoranPerBulanController.value
                                            .copyWith(
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
                              "Uang akan terkumpul setelah  7 Bulan",
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
                            margin: EdgeInsets.only(top: 12),
                            padding: EdgeInsets.only(top: 5),
                            width: double.infinity,
                            height: 58,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(80)),
                              color: defaultColor,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(right: 8),
                                  child: DropdownButtonFormField<String>(
                                    icon: Container(
                                      margin: EdgeInsets.only(right: 16),
                                      child: Image.asset(
                                        "assets/home/dropdown.png",
                                        width: 10,
                                        height: 10,
                                      ),
                                    ),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                    value: _selectedValue,
                                    items: [
                                      DropdownMenuItem<String>(
                                        value: 'RAMADHAN 1448 H / 2024 M',
                                        child: Container(
                                          margin: EdgeInsets.only(left: 32),
                                          child: Text(
                                            'RAMADHAN 1448 H / 2024 M',
                                            style: TextStyle(
                                              color: _selectedValue ==
                                                      'RAMADHAN 1448 H / 2024 M'
                                                  ? abu
                                                  : null,
                                            ),
                                          ),
                                        ),
                                      ),
                                      DropdownMenuItem<String>(
                                        value: 'IDUL ADHA 1448 H / 2024 M',
                                        child: Container(
                                          margin: EdgeInsets.only(left: 34),
                                          child: Text(
                                            'IDUL ADHA 1448 H / 2024 M',
                                            style: TextStyle(
                                              color: _selectedValue ==
                                                      'IDUL ADHA 1448 H / 2024 M'
                                                  ? abu
                                                  : null,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                    onChanged: (String? selectedItem) {
                                      setState(() {
                                        _selectedValue = selectedItem;
                                      });
                                    },
                                    hint: Container(
                                      margin: EdgeInsets.only(left: 20),
                                      child: Text(
                                        _selectedValue ?? 'Select an option',
                                        style: TextStyle(
                                          color: _selectedValue == null
                                              ? abu
                                              : null,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
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
                      child: DropdownButtonFormField<String>(
                        icon: Container(
                          margin: EdgeInsets.only(right: 16),
                          child: Image.asset(
                            "assets/home/dropdown.png",
                            width: 10,
                            height: 10,
                          ),
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                        value: _selectedValueJamaah,
                        items: [
                          DropdownMenuItem<String>(
                            value: 'RICKI SETIAWAN - NIK 3216212305850001',
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                'RICKI SETIAWAN - NIK 3216212305850001',
                                style: TextStyle(
                                  color: _selectedValueJamaah ==
                                          'RICKI SETIAWAN - NIK 3216212305850001'
                                      ? abu
                                      : null,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                          DropdownMenuItem<String>(
                            value: 'PAPA KHAN - 3216212305850001',
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                'PAPA KHAN - NIK 3216212305850001',
                                style: TextStyle(
                                  color: _selectedValueJamaah ==
                                          'PAPA KHAN - NIK 3216212305850001'
                                      ? abu
                                      : null,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ],
                        onChanged: (String? selectedItem) {
                          setState(() {
                            _selectedValueJamaah = selectedItem;
                          });
                        },
                        hint: Container(
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            _selectedValueJamaah ?? 'Select an option',
                            style: TextStyle(
                              color: _selectedValueJamaah == null ? abu : null,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    )
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
                child: Row(
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
