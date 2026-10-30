import 'package:flutter/material.dart';
import 'package:bonplein_flutter/ui/core/themes/app_colors.dart';
import 'package:bonplein_flutter/ui/core/themes/app_text_style.dart';
import 'package:bonplein_flutter/ui/page1/accueil.dart';
import 'package:bonplein_flutter/ui/page5_Profile/profile_page.dart';
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
    ProfilePage(),
  ];

  // Un Navigator par onglet : les pages ouvertes avec Navigator.push
  // s'affichent dans l'onglet, au-dessus de la barre de navigation.
  late final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    for (var i = 0; i < _pages.length; i++) GlobalKey<NavigatorState>(),
  ];

  void _onTabTapped(int index) {
    if (index == _selectedIndex) {
      // Toucher l'onglet déjà ouvert revient à sa première page.
      _navigatorKeys[index].currentState?.popUntil((route) => route.isFirst);
      return;
    }
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          for (var i = 0; i < _pages.length; i++)
            // Le bouton retour d'Android ferme d'abord la page de l'onglet.
            NavigatorPopHandler<Object?>(
              enabled: i == _selectedIndex,
              onPopWithResult: (_) =>
                  _navigatorKeys[i].currentState?.maybePop(),
              child: Navigator(
                key: _navigatorKeys[i],
                onGenerateRoute: (settings) => MaterialPageRoute<void>(
                  settings: settings,
                  builder: (_) => _pages[i],
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onTabTapped,
        selectedItemColor: AppColors.vert,
        unselectedItemColor: AppColors.neutral500,
        selectedLabelStyle: AppTextStyle.navLabel,
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
