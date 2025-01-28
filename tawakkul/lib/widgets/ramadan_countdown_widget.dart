import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tawakkul/widgets/ramadan_circle_painter.dart';
import '../controllers/prayer_times_controller.dart';

class RamadanCountdownWidget extends StatelessWidget {
  final DateTime selectedDate;

  const RamadanCountdownWidget({super.key, required this.selectedDate});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<PrayerTimesController>(context);

    /// 🔹 Get the total days in the Hijri year (354 or 355 days)
    final int hijriYearDays = (controller.hijriMonthDays == 30) ? 355 : 354;

    /// 🔹 Define Ramadan period
    final DateTime ramadanStart = DateTime(selectedDate.year, 3, 11); // Approximate start date
    final DateTime ramadanEnd = ramadanStart.add(const Duration(days: 29)); // Approximate 30-day month

    /// 🔹 Determine if we are before, during, or after Ramadan
    bool isBeforeRamadan = selectedDate.isBefore(ramadanStart);
    bool isDuringRamadan = selectedDate.isAfter(ramadanStart.subtract(const Duration(days: 1))) &&
        selectedDate.isBefore(ramadanEnd.add(const Duration(days: 1)));

    int displayDays;
    String mainText;
    String subText;

    if (isBeforeRamadan) {
      /// **Before Ramadan → Count days until it starts**
      displayDays = ramadanStart.difference(selectedDate).inDays;
      mainText = "Days Until";
      subText = "Ramadan";
    } else if (isDuringRamadan) {
      /// **During Ramadan → Count days until Ramadan ends**
      displayDays = ramadanEnd.difference(selectedDate).inDays;
      mainText = "Days Left In";
      subText = "Ramadan";
    } else {
      /// **After Ramadan → Reset for next year**
      displayDays = ramadanStart.add(const Duration(days: 355)).difference(selectedDate).inDays;
      mainText = "Days Until";
      subText = "Ramadan";
    }

    /// 🔹 Ensure progress starts from empty and fills as we get closer
    final double progress = isDuringRamadan
        ? 1 - (displayDays / 30) // **Fills up as Ramadan ends**
        : 1 - (displayDays / hijriYearDays); // **Fills up as next Ramadan approaches**
    final double clampedProgress = progress.clamp(0.01, 1.0); // Ensure visibility

    return Column(
      children: [
        SizedBox(
          width: 35,
          height: 35,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: const Size(35, 35),
                painter: RamadanCirclePainter(
                  progress: clampedProgress, // ✅ Now updates dynamically
                  color: Colors.white.withOpacity(0.2),
                  boldColor: Colors.white,
                ),
              ),
              Text(
                '$displayDays',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 2),

        /// 🔹 **New Two-Line Text Display**
        Column(
          children: [
            Text(
              mainText,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 8,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              subText,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 8,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
