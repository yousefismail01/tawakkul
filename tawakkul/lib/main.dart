import 'package:flutter/material.dart';
import 'screens/prayer_times_screen.dart';
import 'screens/qibla_screen.dart';
import 'screens/quran_screen.dart';

void main() => runApp(const IslamicApp());

class IslamicApp extends StatelessWidget {
  const IslamicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.green),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final _screens = const [
    PrayerTimesScreen(),
    QiblaScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index < 2) setState(() => _currentIndex = index);
        },
        backgroundColor: Colors.transparent,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('assets/home_icon.png')),
              label: 'Prayer'),
          BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('assets/kaaba_icon.png')),
              label: 'Qibla'),
          BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('assets/mosque_icon.png')),
              label: 'Coming Soon'),
          BottomNavigationBarItem(
              icon: Icon(Icons.castle), label: 'Coming Soon'),
          // BottomNavigationBarItem(
          //     icon: ImageIcon(AssetImage('assets/settings_icon.png')),
          //     label: 'Coming Soon'),
        ],
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withOpacity(0.5),
      ),
    );
  }
}
