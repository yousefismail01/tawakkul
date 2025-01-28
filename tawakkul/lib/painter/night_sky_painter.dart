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
    final Paint moonGlowPaint = Paint()..color = Colors.white.withOpacity(0.2);
    final Paint starPaint = Paint();

    /// 🔹 Draw Moon (Top Right)
    final double moonRadius = size.width * 0.15;
    final Offset moonCenter = Offset(size.width * 0.85, size.height * 0.12);

    // Moon pulsating glow effect
    canvas.drawCircle(moonCenter, moonRadius * (1.3 + moonGlowSize), moonGlowPaint);
    canvas.drawCircle(moonCenter, moonRadius, moonPaint);

    /// 🔹 Draw Twinkling Stars
    for (int i = 0; i < starPositions.length; i++) {
      starPaint.color = Colors.white.withOpacity(starOpacities[i]);
      canvas.drawCircle(starPositions[i], 1.5, starPaint);
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
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);

    final Random random = Random();

    /// 🔹 Generate Star Positions & Opacity (For Twinkling Effect)
    _starPositions = List.generate(15, (index) {
      return Offset(
        random.nextDouble() * 400, // Random width
        random.nextDouble() * 250, // Upper part of screen
      );
    });

    /// 🔹 Ensure `_starOpacities` is initialized
    _starOpacities = List.generate(15, (index) => random.nextDouble() * 0.5 + 0.5);

    /// 🔹 Randomly change star opacities over time (Twinkling effect)
    _controller.addListener(() {
      if (mounted) {
        setState(() {
          for (int i = 0; i < _starOpacities.length; i++) {
            if (random.nextDouble() > 0.97) { // Some stars randomly flicker
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
