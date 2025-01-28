import 'dart:math';
import 'package:flutter/material.dart';

/// 🔹 Night Sky Background Painter
class NightSkyPainter extends CustomPainter {
  final List<Offset> starPositions;
  final List<double> starOpacities;
  final double moonGlowSize;

  NightSkyPainter({
    required this.starPositions,
    required this.starOpacities,
    required this.moonGlowSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint moonPaint = Paint()..color = Colors.white.withOpacity(0.9);
    final Paint moonGlowPaint1 = Paint()..color = Colors.white.withOpacity(0.3);
    final Paint moonGlowPaint2 = Paint()
      ..color = Colors.white.withOpacity(0.15);
    final Paint starPaint = Paint();

    /// 🔹 Define Moon Position & Size (Now **Half the Previous Size**)
    final double moonRadius = size.width * 0.08; // 🔹 Smaller moon
    final Offset moonCenter =
        Offset(size.width - moonRadius - 5, moonRadius + 5); // Nested top-right

    // 🔹 Three-layered glow effect
    canvas.drawCircle(
        moonCenter, moonRadius * (1.5 + moonGlowSize), moonGlowPaint2);
    canvas.drawCircle(
        moonCenter, moonRadius * (1.3 + moonGlowSize), moonGlowPaint1);
    canvas.drawCircle(moonCenter, moonRadius, moonPaint);

    /// 🔹 Draw Twinkling Stars (Avoiding Moon Area)
    for (int i = 0; i < starPositions.length; i++) {
      final Offset starPos = starPositions[i];

      /// 🚀 **Ensure Stars Don't Overlap the Moon**
      final double distanceToMoon = (starPos - moonCenter).distance;
      if (distanceToMoon < moonRadius * 1.5) continue; // Skip stars near moon

      starPaint.color = Colors.white.withOpacity(starOpacities[i]);
      canvas.drawCircle(starPos, 1.8, starPaint);
    }
  }

  @override
  bool shouldRepaint(NightSkyPainter oldDelegate) => true;
}

/// 🔹 Animated Night Sky
class AnimatedNightSky extends StatefulWidget {
  const AnimatedNightSky({super.key});

  @override
  _AnimatedNightSkyState createState() => _AnimatedNightSkyState();
}

class _AnimatedNightSkyState extends State<AnimatedNightSky>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Offset> _starPositions;
  late List<double> _starOpacities;

  @override
  void initState() {
    super.initState();

    /// 🔹 Initialize Animation Controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8), // 🔹 Slower for subtle effects
    )..repeat(reverse: true);

    final Random random = Random();

    /// 🔹 Generate Star Positions & Opacity (More Stars)
    _starPositions = List.generate(30, (index) {
      return Offset(
        random.nextDouble() * 400, // Random width
        random.nextDouble() * 250, // Upper part of screen
      );
    });

    /// 🔹 Ensure `_starOpacities` is initialized
    _starOpacities =
        List.generate(30, (index) => random.nextDouble() * 0.5 + 0.5);

    /// 🔹 Randomly change star opacities over time (Flicker Less Often)
    _controller.addListener(() {
      if (mounted) {
        setState(() {
          for (int i = 0; i < _starOpacities.length; i++) {
            if (random.nextDouble() > 0.99) {
              // 🔹 Now flickers less often
              _starOpacities[i] = random.nextDouble() * 0.5 + 0.5;
            }
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: NightSkyPainter(
            starPositions: _starPositions,
            starOpacities: _starOpacities,
            moonGlowSize: sin(_controller.value * pi) * 0.1, // Pulsing moon
          ),
        );
      },
    );
  }
}
