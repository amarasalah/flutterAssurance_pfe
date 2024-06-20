import 'package:flutter/material.dart';
import 'package:insurance_pfe/views/editProfile.dart';
import 'package:insurance_pfe/views/homepage.dart';
import 'package:insurance_pfe/views/historique.dart';
import 'package:insurance_pfe/views/nos_agences.dart';

class RootScreen extends StatefulWidget {
  @override
  _RootScreenState createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    Homepage(),
    Nosagences(), // Replace with your desired widget for the map tab
    HistoriqueScreen()
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        selectedItemColor:
            const Color(0xFFF38F1D), // Change the color of selected item here
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Nos Agences',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Historique',
          ),
        ],
      ),
    );
  }
}

class PlaceholderWidget extends StatelessWidget {
  final Color color;

  const PlaceholderWidget({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF38F1D),
    );
  }
}
