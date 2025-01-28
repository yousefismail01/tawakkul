import 'package:flutter/material.dart';
import 'package:tawakkul/painter/night_sky_painter.dart';

class NightTheme extends StatelessWidget {
  const NightTheme({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: AnimatedNightSky()), // ✅ Now inside a Stack
      ],
    );
  }
}
