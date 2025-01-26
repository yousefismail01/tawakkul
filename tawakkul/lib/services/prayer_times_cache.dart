import 'package:adhan/adhan.dart';

class PrayerTimesCache {
  static final Map<String, PrayerTimes> _cache = {};

  static String _getKey(DateTime date, double lat, double lon) =>
      '${date.toIso8601String().split('T')[0]}_${lat}_$lon';

  static PrayerTimes? get(DateTime date, double lat, double lon) {
    return _cache[_getKey(date, lat, lon)];
  }

  static void set(DateTime date, double lat, double lon, PrayerTimes times) {
    _cache[_getKey(date, lat, lon)] = times;
  }

  static void clear() {
    _cache.clear();
  }
}
