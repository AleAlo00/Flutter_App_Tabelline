import 'package:flutter/material.dart';
import '../pages/home_page.dart';
import '../pages/test_page.dart';
import '../pages/profile_page.dart';

class MainMenu extends StatefulWidget {
  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    TestPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tabelline', style: TextStyle(color: Colors.white)),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue[900],  // Icone selezionate blu scuro
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',  // Icona senza testo
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle),
            label: '',  // Icona senza testo
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '',  // Icona senza testo
          ),
        ],
      ),
    );
  }
}
