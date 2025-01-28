import 'package:flutter/material.dart';

class DawnTheme extends StatelessWidget {
  const DawnTheme({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFFA8072), Color(0xFFFFDAB9)], // Soft pink-orange hues
        ),
      ),
    );
  }
}
