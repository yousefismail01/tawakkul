import 'dart:math';
import 'package:flutter/material.dart';

class TimerCirclePainter extends CustomPainter {
  final double timeLeft;
  final Color color;
  final Color boldColor;

  TimerCirclePainter({
    required this.timeLeft,
    required this.color,
    required this.boldColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2;

    // Draw background circle
    final backgroundPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Draw progress arc
    final progressPaint = Paint()
      ..color = boldColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      2 * pi * timeLeft,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(TimerCirclePainter oldDelegate) => 
    timeLeft != oldDelegate.timeLeft;
}