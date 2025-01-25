import 'package:adhan/adhan.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

class PrayerService {
  static Future<Position?> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return null;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return null;
      }
    }

    return await Geolocator.getCurrentPosition();
  }

  static PrayerTimes calculatePrayerTimes(
      double latitude, double longitude, DateTime selectedDate) {
    final coordinates = Coordinates(latitude, longitude);
    final params = CalculationMethod.muslim_world_league.getParameters();
    params.madhab = Madhab.hanafi;

    final date =
        DateComponents(selectedDate.year, selectedDate.month, selectedDate.day);
    return PrayerTimes(coordinates, date, params);
  }

  static String formatTime(DateTime time) {
    return DateFormat.jm().format(time);
  }

  static bool isNextPrayer(String prayerName, PrayerTimes prayerTimes) {
    final now = DateTime.now();
    final currentPrayer = prayerTimes.currentPrayer();
    final nextPrayer = prayerTimes.nextPrayer();

    switch (prayerName.toLowerCase()) {
      case 'fajr':
        return nextPrayer == Prayer.fajr;
      case 'sunrise':
        return nextPrayer == Prayer.sunrise;
      case 'dhuhr':
        return nextPrayer == Prayer.dhuhr;
      case 'asr':
        return nextPrayer == Prayer.asr;
      case 'maghrib':
        return nextPrayer == Prayer.maghrib;
      case 'isha':
        return nextPrayer == Prayer.isha;
      default:
        return false;
    }
  }

  static String getPrayerName(PrayerTimes prayerTimes) {
    final now = DateTime.now();
    final prayers = {
      'Fajr': prayerTimes.fajr,
      'Dhuhr': prayerTimes.dhuhr,
      'Asr': prayerTimes.asr,
      'Maghrib': prayerTimes.maghrib,
      'Isha': prayerTimes.isha,
    };

    for (var entry in prayers.entries) {
      if (entry.value.isAfter(now)) {
        return entry.key;
      }
    }
    return 'Fajr';
  }

  static DateTime? getNextPrayerTime(PrayerTimes prayerTimes, Prayer prayer) {
    switch (prayer) {
      case Prayer.fajr:
        return prayerTimes.fajr;
      case Prayer.sunrise:
        return prayerTimes.sunrise;
      case Prayer.dhuhr:
        return prayerTimes.dhuhr;
      case Prayer.asr:
        return prayerTimes.asr;
      case Prayer.maghrib:
        return prayerTimes.maghrib;
      case Prayer.isha:
        return prayerTimes.isha;
      case Prayer.none:
        return null;
    }
  }
}
