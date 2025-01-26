import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/prayer_times_screen.dart';
import 'screens/qibla_screen.dart';
import 'screens/quran_screen.dart';
import 'controllers/prayer_times_controller.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => PrayerTimesController()),
      ],
      child: const Tawakkul(),
    ),
  );
}

class Tawakkul extends StatelessWidget {
  const Tawakkul({super.key});

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

  static const List<Widget> _screens = [
    PrayerTimesScreen(),
    QiblaScreen(),
  ];

  void _onTabSelected(int index) {
    if (index != _currentIndex) {
      setState(() => _currentIndex = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      // Uncomment when ready to use the bottom nav bar
      // bottomNavigationBar: BottomNavigationBar(
      //   currentIndex: _currentIndex,
      //   onTap: _onTabSelected,
      //   backgroundColor: Colors.transparent,
      //   type: BottomNavigationBarType.fixed,
      //   items: const [
      //     BottomNavigationBarItem(
      //         icon: ImageIcon(AssetImage('assets/images/home_icon.png')),
      //         label: 'Prayer'),
      //     BottomNavigationBarItem(
      //         icon: ImageIcon(AssetImage('assets/images/kaaba_icon.png')),
      //         label: 'Qibla'),
      //     BottomNavigationBarItem(
      //         icon: ImageIcon(AssetImage('assets/images/mosque_icon.png')),
      //         label: 'Coming Soon'),
      //     BottomNavigationBarItem(
      //         icon: Icon(Icons.castle), label: 'Coming Soon'),
      //   ],
      //   selectedItemColor: Colors.white,
      //   unselectedItemColor: Colors.white.withOpacity(0.5),
      // ),
    );
  }
}
