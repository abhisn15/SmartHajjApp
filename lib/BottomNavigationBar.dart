import 'package:Harmoni/dompet/dompetScreen.dart';
import 'package:Harmoni/profileScreen.dart';
import 'package:flutter/material.dart';
import 'package:Harmoni/dashboard/dashboardScreen.dart';
import 'package:Harmoni/jamaah/jamaahScreen.dart';

void main() => runApp(const BottomNavigation());

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const BottomNavigationBarExample(),
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
  int _selectedIndex = 0;
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
              _isDompetActive
                  ? 'assets/icon_dompet_active.png'
                  : 'assets/dompet.png',
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
