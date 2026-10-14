import 'package:flutter/material.dart';
import 'package:bonplein_flutter/ui/page1/accueil.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    Center(child: Accueil()),
    Center(child: Text('Trajets')),
    Center(child: Text('Notifications')),
    Center(child: Text('Statistiques')),
    Center(child: Text('Profil')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        selectedItemColor: const Color(0xFF22C55E),
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.map_outlined), label: 'Carte'),
          BottomNavigationBarItem(icon: Icon(Icons.cable_outlined), label: 'Trajets'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Notifs'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart_outlined), label: 'Stats'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}