import 'package:flutter/material.dart';
import '../themes/night_theme.dart';
import '../themes/dawn_theme.dart';
import '../themes/day_theme.dart';
import 'package:adhan/adhan.dart';

class PrayerThemeManager {
  static Widget getCurrentTheme(
      PrayerTimes prayerTimes, DateTime selectedDate) {
    final bool isToday = DateUtils.isSameDay(selectedDate, DateTime.now());
    final DateTime now = isToday
        ? DateTime.now()
        : DateTime(selectedDate.year, selectedDate.month, selectedDate.day, 12);

    if (now.isAfter(prayerTimes.isha) || now.isBefore(prayerTimes.fajr)) {
      debugPrint("🌙 Night Theme Loaded");
      return const NightTheme();
    } else if (now.isAfter(prayerTimes.fajr) &&
        now.isBefore(prayerTimes.sunrise)) {
      debugPrint("🌅 Dawn Theme Loaded");
      return const DawnTheme();
    } else {
      debugPrint("☀️ Day Theme Loaded");
      return const DayTheme();
    }
  }
}
