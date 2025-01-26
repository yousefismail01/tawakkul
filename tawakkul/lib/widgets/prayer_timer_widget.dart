import 'package:flutter/material.dart';
import '../widgets/timer_circle_painter.dart';

class PrayerTimerWidget extends StatelessWidget {
  final double timeLeftPercentage;
  final String prayerName;
  final String timeLeft;

  const PrayerTimerWidget({
    super.key,
    required this.timeLeftPercentage,
    required this.prayerName,
    required this.timeLeft,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 200,
      child: Stack(
        children: [
          CustomPaint(
            size: const Size(200, 200),
            painter: TimerCirclePainter(
              timeLeft: timeLeftPercentage,
              color: Colors.white.withOpacity(0.3),
              boldColor: Colors.white,
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Time until',
                    style: TextStyle(color: Colors.white, fontSize: 16)),
                Text(prayerName,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                Text(timeLeft,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
