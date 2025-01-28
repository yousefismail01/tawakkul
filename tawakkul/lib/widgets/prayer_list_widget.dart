import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:adhan/adhan.dart';
import '../services/prayer_service.dart';
import '../controllers/prayer_times_controller.dart';

class PrayerListWidget extends StatelessWidget {
  final PrayerTimes prayerTimes;

  const PrayerListWidget({super.key, required this.prayerTimes});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<PrayerTimesController>(context);
    final bool isToday = controller.isToday;
    final bool isPastDay = controller.selectedDate.isBefore(
      DateTime.now().subtract(const Duration(days: 1)),
    );
    final now = DateTime.now();

    /// 🔹 Get prayer times
    final prayerTimesList = {
      'Fajr': prayerTimes.fajr,
      'Sunrise': prayerTimes.sunrise,
      'Dhuhr': prayerTimes.dhuhr,
      'Asr': prayerTimes.asr,
      'Maghrib': prayerTimes.maghrib,
      'Isha': prayerTimes.isha,
    };

    /// 🔹 Determine if we're in a new day **before** Fajr
    final bool isBeforeFajr = isToday && now.isBefore(prayerTimes.fajr);

    /// 🔹 Get the last prayer (only if Fajr has passed)
    final String lastPrayer = isBeforeFajr ? "" : controller.lastPrayer;

    /// 🔹 Get the night thirds times
    final nightThirds = PrayerService.calculateNightThirds(prayerTimes);

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            itemCount: prayerTimesList.length,
            itemBuilder: (context, index) {
              final prayerName = prayerTimesList.keys.elementAt(index);
              final prayerTime = prayerTimesList.values.elementAt(index);

              /// 🔹 Properly check if this prayer has already happened today
              final bool isPastPrayer = isToday && prayerTime.isBefore(now);

              /// 🔹 Ensure last prayer stays bold only **if Fajr has passed**
              final bool isLastPrayer = isToday && (prayerName == lastPrayer) && !isBeforeFajr;

              return Container(
                margin: const EdgeInsets.symmetric(vertical: 4),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isLastPrayer ? Colors.white : Colors.white.withOpacity(0.3),
                    width: isLastPrayer ? 2.0 : 0.8,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    /// 🔹 Prayer Name (Bold if Last Prayer)
                    Text(
                      prayerName,
                      style: TextStyle(
                        color: isLastPrayer
                            ? Colors.white
                            : (isPastPrayer || isPastDay)
                                ? Colors.white.withOpacity(0.5)
                                : Colors.white.withOpacity(0.9),
                        fontSize: 16,
                        fontWeight: isLastPrayer ? FontWeight.bold : FontWeight.w500,
                        fontFamily: 'Poppins',
                      ),
                    ),

                    /// 🔹 Prayer Time (Bold if Last Prayer)
                    Text(
                      PrayerService.formatTime(prayerTime),
                      style: TextStyle(
                        color: isLastPrayer
                            ? Colors.white
                            : (isPastPrayer || isPastDay)
                                ? Colors.white.withOpacity(0.5)
                                : Colors.white.withOpacity(0.9),
                        fontSize: 16,
                        fontWeight: isLastPrayer ? FontWeight.bold : FontWeight.w500,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),

        /// 🔹 Night Thirds in a Single Row (Directly Below Isha)
        Container(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 15),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white.withOpacity(0.3), width: 0.8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildNightSection('First Third', nightThirds['First Third']!, isPastDay),
              _buildNightSection('Midnight', nightThirds['Midnight']!, isPastDay),
              _buildNightSection('Last Third', nightThirds['Last Third']!, isPastDay),
            ],
          ),
        ),
      ],
    );
  }

  /// 🔹 Helper method to build each night section inside the single row
  Widget _buildNightSection(String title, DateTime time, bool isPastDay) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              color: isPastDay ? Colors.white.withOpacity(0.5) : Colors.white, // 🔹 Gray only for past days
              fontSize: 14,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 4),
          Text(
            PrayerService.formatTime(time),
            style: TextStyle(
              color: isPastDay ? Colors.white.withOpacity(0.5) : Colors.white, // 🔹 Gray only for past days
              fontSize: 16,
              fontWeight: FontWeight.w500,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }
}
