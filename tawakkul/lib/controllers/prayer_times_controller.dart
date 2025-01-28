import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:adhan/adhan.dart';
import 'package:geolocator/geolocator.dart';
import '../services/prayer_service.dart';
import 'dart:async';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PrayerTimesController extends ChangeNotifier {
  PrayerTimes? prayerTimes;
  PrayerTimes? timerPrayerTimes;
  bool isLoading = true;
  DateTime selectedDate = DateTime.now();
  Position? cachedPosition;
  Timer? timer;
  final ValueNotifier<String> timeLeftNotifier = ValueNotifier('');
  String? currentCity; // 🔹 Store current city name
  String lastPrayer = ""; // Default value, will be updated in _getPrayerTimes()
  bool isToday = true; // Tracks if the user is on today's date
  int hijriMonthDays = 30; // Default value

  PrayerTimesController() {
    _initialize();
  }

  void _initialize() {
    _getPrayerTimes();
    _startTimer(); // 🔹 Add back _startTimer() call
  }

  /// 🔹 **Fetch Hijri Month Length from API**
  Future<void> fetchHijriMonthLength() async {
    try {
      final response = await http.get(Uri.parse(
          'https://api.aladhan.com/v1/gToH?date=1-9-${selectedDate.year}')); // Fetch 1st of Ramadan

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final int monthDays = int.parse(data['data']['hijri']['month']['days']);
        hijriMonthDays = monthDays;
        notifyListeners();
      }
    } catch (e) {
      print("Error fetching Hijri month length: $e");
    }
  }

  Future<void> _getPrayerTimes() async {
    try {
      cachedPosition ??= await PrayerService.getCurrentLocation();

      if (cachedPosition != null) {
        currentCity = await PrayerService.getCityFromCoordinates(
          cachedPosition!.latitude,
          cachedPosition!.longitude,
        );

        timerPrayerTimes = PrayerService.calculatePrayerTimes(
          cachedPosition!.latitude,
          cachedPosition!.longitude,
          DateTime.now(),
        );

        prayerTimes = PrayerService.calculatePrayerTimes(
          cachedPosition!.latitude,
          cachedPosition!.longitude,
          selectedDate,
        );

        /// 🔹 Check if selected date is today
        isToday = DateUtils.isSameDay(selectedDate, DateTime.now());

        /// 🔹 Highlight last prayer only if on the current day
        lastPrayer =
            isToday ? PrayerService.getLastPrayer(timerPrayerTimes!) : "";

        isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      print("Error fetching prayer times: $e");
    }
  }

  /// 🔹 **Re-added `_startTimer()`**
  void _startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timerPrayerTimes != null) {
        timeLeftNotifier.value = _getTimeUntilNextPrayer();
        notifyListeners(); // ✅ Ensure UI updates every second
      }
    });
  }

  void resetToToday() {
    selectedDate = DateTime.now(); // Set to today's date
    _getPrayerTimes(); // Reload prayer times
    notifyListeners(); // Ensure UI updates
  }

  String _getTimeUntilNextPrayer() {
    if (timerPrayerTimes == null) return '';
    final now = DateTime.now();
    var nextPrayer = timerPrayerTimes!.nextPrayer();
    var nextPrayerTime =
        PrayerService.getNextPrayerTime(timerPrayerTimes!, nextPrayer);

    if (nextPrayer == Prayer.none) {
      final tomorrow = now.add(const Duration(days: 1));
      final tomorrowPrayers = PrayerService.calculatePrayerTimes(
        cachedPosition!.latitude,
        cachedPosition!.longitude,
        tomorrow,
      );
      nextPrayerTime = tomorrowPrayers.fajr;
    }

    if (nextPrayerTime == null) return '';

    final difference = nextPrayerTime.difference(now);
    return '${difference.inHours.toString().padLeft(2, '0')}:'
        '${difference.inMinutes.remainder(60).toString().padLeft(2, '0')}:'
        '${difference.inSeconds.remainder(60).toString().padLeft(2, '0')}';
  }

  void changeDate(int days) {
    selectedDate = selectedDate.add(Duration(days: days));

    /// 🔹 Check if the selected date is today
    isToday = DateUtils.isSameDay(selectedDate, DateTime.now());

    /// 🔹 Highlight last prayer only if it's today, otherwise clear it
    lastPrayer = isToday ? PrayerService.getLastPrayer(timerPrayerTimes!) : "";

    _getPrayerTimes(); // Ensure prayer times update when date changes
    notifyListeners();
  }

  String getIslamicDate(DateTime date) {
    HijriCalendar islamicDate = HijriCalendar.fromDate(date);
    String monthName = _getIslamicMonthName(islamicDate.hMonth);
    return '${islamicDate.hDay} $monthName ${islamicDate.hYear}';
  }

  String _getIslamicMonthName(int month) {
    const months = [
      'Muharram',
      'Safar',
      'Rabi\' al-Awwal',
      'Rabi\' al-Thani',
      'Jumada al-Ula',
      'Jumada al-Thani',
      'Rajab',
      'Sha\'ban',
      'Ramadan',
      'Shawwal',
      'Dhu al-Qi\'dah',
      'Dhu al-Hijjah'
    ];
    return months[month - 1];
  }

  double getTimeLeftPercentage() {
  if (timerPrayerTimes == null) return 0;

  final now = DateTime.now();
  var nextPrayer = timerPrayerTimes!.nextPrayer();
  var nextPrayerTime = PrayerService.getNextPrayerTime(timerPrayerTimes!, nextPrayer);

  /// 🔹 Handle transition from Isha → Next day's Fajr
  if (nextPrayer == Prayer.none) {
    final tomorrow = now.add(const Duration(days: 1));
    final tomorrowPrayers = PrayerService.calculatePrayerTimes(
      cachedPosition!.latitude, cachedPosition!.longitude, tomorrow);
    nextPrayerTime = tomorrowPrayers.fajr;
  }

  /// 🔹 Check if it's a new day **before Fajr** (Use yesterday's Isha)
  bool isBeforeFajr = now.isBefore(timerPrayerTimes!.fajr);
  DateTime? previousPrayerTime;

  if (isBeforeFajr) {
    final yesterday = now.subtract(const Duration(days: 1));
    final yesterdayPrayers = PrayerService.calculatePrayerTimes(
      cachedPosition!.latitude, cachedPosition!.longitude, yesterday);
    previousPrayerTime = yesterdayPrayers.isha;
    // print("[DEBUG] Using YESTERDAY's Isha for calculation: $previousPrayerTime");
  } else {
    previousPrayerTime = PrayerService.getPreviousPrayerTime(timerPrayerTimes!, timerPrayerTimes!.currentPrayer());
  }

  if (previousPrayerTime == null || nextPrayerTime == null) return 0;

  /// 🔹 Calculate progress correctly
  final totalDuration = nextPrayerTime.difference(previousPrayerTime).inSeconds;
  final elapsedDuration = now.difference(previousPrayerTime).inSeconds;

  /// 🔹 Ensure progress is between 0 and 1
  double progress = elapsedDuration / totalDuration;
  progress = progress.clamp(0.0, 1.0);

  // print("[DEBUG] Current Time: $now");
  // print("[DEBUG] Previous Prayer (Before Fajr): $previousPrayerTime");
  // print("[DEBUG] Next Prayer: $nextPrayer at $nextPrayerTime");
  // print("[DEBUG] Progress: $progress");

  return progress;
}


  String getNextPrayerName() {
    if (timerPrayerTimes == null) return "Unknown";

    /// 🔹 Use the existing function to determine the next prayer name
    return PrayerService.getPrayerName(timerPrayerTimes!);
  }

  @override
  void dispose() {
    timer?.cancel();
    timeLeftNotifier.dispose();
    super.dispose();
  }
}
