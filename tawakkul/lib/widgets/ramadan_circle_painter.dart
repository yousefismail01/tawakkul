import 'dart:math';
import 'package:flutter/material.dart';

class RamadanCirclePainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color boldColor;
  final double strokeWidth;

  RamadanCirclePainter({
    required this.progress,
    required this.color,
    required this.boldColor,
    this.strokeWidth = 4.0, // ✅ Slightly thicker for visibility
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double radius = (min(size.width, size.height) / 2) - (strokeWidth / 2);

    /// 🔹 Draw background circle
    final Paint backgroundPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawCircle(center, radius, backgroundPaint);

    /// 🔹 Ensure at least a small segment is visible
    final double minAngle = 0.05; // ✅ Minimum visible segment
    final double sweepAngle = max(minAngle, 2 * pi * progress);

    /// 🔹 Draw progress arc
    final Paint progressPaint = Paint()
      ..color = boldColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant RamadanCirclePainter oldDelegate) {
    return progress != oldDelegate.progress ||
        color != oldDelegate.color ||
        boldColor != oldDelegate.boldColor ||
        strokeWidth != oldDelegate.strokeWidth;
  }
}
