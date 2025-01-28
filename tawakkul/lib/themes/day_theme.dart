import 'package:flutter/material.dart';

class DayTheme extends StatelessWidget {
  const DayTheme({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF87CEEB), Color(0xFFB0E0E6)], // Light blue sky
        ),
      ),
    );
  }
}
