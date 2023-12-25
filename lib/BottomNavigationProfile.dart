import 'package:SmartHajj/dompet/dompetScreen.dart';
import 'package:SmartHajj/profile/profileScreen.dart';
import 'package:flutter/material.dart';
import 'package:SmartHajj/dashboard/dashboardScreen.dart';
import 'package:SmartHajj/jamaah/jamaahScreen.dart';

void main() => runApp(const BottomNavigationProfile());

class BottomNavigationProfile extends StatelessWidget {
  const BottomNavigationProfile({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const BottomNavigationBarExample(),
      title: "SmartHajj",
    );
  }
}

class BottomNavigationBarExample extends StatefulWidget {
  const BottomNavigationBarExample({Key? key});

  @override
  State<BottomNavigationBarExample> createState() =>
      _BottomNavigationBarExampleState();
}

class _BottomNavigationBarExampleState
    extends State<BottomNavigationBarExample> {
  int _selectedIndex = 3;
  bool _isDompetActive = false; // Tambahkan variabel ini

  static const List<Widget> _widgetOptions = <Widget>[
    DashboardScreen(),
    JamaahScreen(),
    DompetScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 2) {
        // Jika tombol "Dompet" diklik
        _isDompetActive = true;
      } else {
        _isDompetActive = false;
      }
    });
  }

  final primaryColor = Color.fromRGBO(43, 69, 112, 1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              size: 32,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.people,
              size: 30,
            ),
            label: 'Jamaah',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/dompet.png',
              color: _isDompetActive
                  ? primaryColor
                  : Color.fromRGBO(115, 115, 115, 1),
              width: 24,
              height: 24,
            ), // Menggunakan gambar ikon
            label: 'Dompet',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              size: 35,
            ),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Color.fromRGBO(43, 69, 112, 1),
        unselectedLabelStyle: TextStyle(
            color: Colors.grey), // Atur warna label yang belum dipilih
        onTap: _onItemTapped,
      ),
    );
  }
}
