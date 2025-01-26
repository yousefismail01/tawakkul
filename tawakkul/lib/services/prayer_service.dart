import 'package:adhan/adhan.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

class PrayerService {
  static Future<Position?> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return null;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return null;
    }

    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      // print("Error getting location: $e");
      return null;
    }
  }

  static final Map<String, PrayerTimes> _prayerTimesCache = {};

  static PrayerTimes calculatePrayerTimes(
      double latitude, double longitude, DateTime selectedDate) {
    String cacheKey = "$latitude,$longitude,${selectedDate.toIso8601String()}";
    if (_prayerTimesCache.containsKey(cacheKey)) {
      return _prayerTimesCache[cacheKey]!;
    }

    final coordinates = Coordinates(latitude, longitude);
    final params = CalculationMethod.muslim_world_league.getParameters();
    params.madhab = Madhab.hanafi;

    final date =
        DateComponents(selectedDate.year, selectedDate.month, selectedDate.day);
    final prayerTimes = PrayerTimes(coordinates, date, params);

    _prayerTimesCache[cacheKey] = prayerTimes;
    return prayerTimes;
  }

  static String formatTime(DateTime time) {
    return DateFormat.jm().format(time);
  }

  static bool isNextPrayer(String prayerName, PrayerTimes prayerTimes) {
    final nextPrayer = prayerTimes.nextPrayer();
    Map<String, Prayer?> prayerMap = {
      'fajr': Prayer.fajr,
      'sunrise': Prayer.sunrise,
      'dhuhr': Prayer.dhuhr,
      'asr': Prayer.asr,
      'maghrib': Prayer.maghrib,
      'isha': Prayer.isha,
    };

    return prayerMap[prayerName.toLowerCase()] == nextPrayer;
  }

  static String getPrayerName(PrayerTimes prayerTimes) {
    final now = DateTime.now();
    final prayers = {
      'Fajr': prayerTimes.fajr,
      'Sunrise': prayerTimes.sunrise,
      'Dhuhr': prayerTimes.dhuhr,
      'Asr': prayerTimes.asr,
      'Maghrib': prayerTimes.maghrib,
      'Isha': prayerTimes.isha,
    };

    // Find the first prayer that is still upcoming
    for (var entry in prayers.entries) {
      if (entry.value.isAfter(now)) {
        return entry.key;
      }
    }

    // Default to Fajr for the next day if all prayers have passed
    return 'Fajr';
  }

  static DateTime? getNextPrayerTime(PrayerTimes prayerTimes, Prayer prayer) {
    Map<Prayer, DateTime> prayerMap = {
      Prayer.fajr: prayerTimes.fajr,
      Prayer.sunrise: prayerTimes.sunrise,
      Prayer.dhuhr: prayerTimes.dhuhr,
      Prayer.asr: prayerTimes.asr,
      Prayer.maghrib: prayerTimes.maghrib,
      Prayer.isha: prayerTimes.isha,
    };

    return prayerMap[prayer];
  }

  static DateTime? getPreviousPrayerTime(
      PrayerTimes prayerTimes, Prayer prayer) {
    Map<Prayer, DateTime> prayerMap = {
      Prayer.fajr: prayerTimes.fajr,
      Prayer.sunrise: prayerTimes.sunrise,
      Prayer.dhuhr: prayerTimes.dhuhr,
      Prayer.asr: prayerTimes.asr,
      Prayer.maghrib: prayerTimes.maghrib,
      Prayer.isha: prayerTimes.isha,
    };

    List<Prayer> prayers = prayerMap.keys.toList();
    int index = prayers.indexOf(prayer);
    if (index <= 0) return prayerMap[prayers.last];
    return prayerMap[prayers[index - 1]];
  }

  static Future<String?> getCityFromCoordinates(
      double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        return placemarks.first.locality; // Returns city name
      }
    } catch (e) {
      print("Error fetching city name: $e");
    }
    return null; // Return null if there's an error
  }
}
