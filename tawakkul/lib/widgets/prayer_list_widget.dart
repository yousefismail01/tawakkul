import 'package:flutter/material.dart';
import 'package:adhan/adhan.dart';
import '../services/prayer_service.dart';

class PrayerListWidget extends StatelessWidget {
  final PrayerTimes prayerTimes;

  const PrayerListWidget({super.key, required this.prayerTimes});

  @override
  Widget build(BuildContext context) {
    final prayerTimesList = {
      'Fajr': prayerTimes.fajr,
      'Sunrise': prayerTimes.sunrise,
      'Dhuhr': prayerTimes.dhuhr,
      'Asr': prayerTimes.asr,
      'Maghrib': prayerTimes.maghrib,
      'Isha': prayerTimes.isha,
    };

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      itemCount: prayerTimesList.length,
      itemBuilder: (context, index) {
        final prayerName = prayerTimesList.keys.elementAt(index);
        final prayerTime = prayerTimesList.values.elementAt(index);

        return Container(
          margin: const EdgeInsets.symmetric(
              vertical: 4), // Reduced vertical spacing
          padding: const EdgeInsets.symmetric(
              horizontal: 10, vertical: 6), // Smaller padding
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05), // Lighter background
            borderRadius: BorderRadius.circular(6), // Smaller rounded corners
            border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 0.7), // Thinner border
          ),
          child: ListTile(
            dense: true, // Reduces height
            visualDensity: const VisualDensity(
                horizontal: 0, vertical: -4), // Shrinks spacing further
            title: Text(
              prayerName,
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 14, // Smaller text size
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: Text(
              PrayerService.formatTime(prayerTime),
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 14, // Smaller text size
              ),
            ),
          ),
        );
      },
    );
  }
}
