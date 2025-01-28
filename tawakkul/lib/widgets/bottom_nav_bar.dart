import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: const Color(0xFF121931),
      selectedItemColor: const Color(0xFFA44AFF),
      unselectedItemColor: const Color(0xFF9392AE),
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.mosque), label: 'Prayer'),
        BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Qibla'),
        BottomNavigationBarItem(icon: Icon(Icons.check), label: 'Tracker'),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
      ],
    );
  }
}
