import 'dart:math';
import 'package:flutter/material.dart';

class TimerCirclePainter extends CustomPainter {
  final double timeLeft;
  final Color color;
  final Color boldColor;
  final double strokeWidth;

  TimerCirclePainter({
    required this.timeLeft,
    required this.color,
    required this.boldColor,
    this.strokeWidth = 10.0, // Default stroke width
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double radius = min(size.width, size.height) / 2;

    final Paint backgroundPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawCircle(center, radius, backgroundPaint);

    final Paint progressPaint = Paint()
      ..color = boldColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final double sweepAngle = 2 * pi * timeLeft;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant TimerCirclePainter oldDelegate) {
    return timeLeft != oldDelegate.timeLeft ||
        color != oldDelegate.color ||
        boldColor != oldDelegate.boldColor ||
        strokeWidth != oldDelegate.strokeWidth;
  }
}
