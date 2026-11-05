import 'package:flutter/material.dart';

class AppNavigationBar extends StatelessWidget {

  const AppNavigationBar({
    super.key,
    required this._selectedIndex,
    required this._onDestinationSelected
  });

  final int _selectedIndex;
  final ValueChanged<int> _onDestinationSelected;

  static const List<NavigationDestination> _destinations = [
    NavigationDestination(icon: Icon(Icons.map_outlined), label: "Carte"),
    NavigationDestination(icon: Icon(Icons.cable_outlined), label: "Trajets"),
    NavigationDestination(
      icon: Icon(Icons.notifications),
      label: "Notifications",
    ),
    NavigationDestination(icon: Icon(Icons.person), label: "Profil"),
  ];

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      destinations: _destinations,
      selectedIndex: _selectedIndex,
      onDestinationSelected: _onDestinationSelected,
    );
  }
}
