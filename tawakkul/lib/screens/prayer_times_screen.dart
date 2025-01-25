import 'package:flutter/material.dart';
import 'package:adhan/adhan.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';
import 'package:tawakkul/services/prayer_times_cache.dart';
import 'package:tawakkul/widgets/timer_circle_painter.dart';
import '../services/prayer_service.dart';
import 'dart:async';

class PrayerTimesScreen extends StatefulWidget {
  const PrayerTimesScreen({super.key});

  @override
  State<PrayerTimesScreen> createState() => _PrayerTimesScreenState();
}

class _PrayerTimesScreenState extends State<PrayerTimesScreen> {
  PrayerTimes? _prayerTimes;
  bool _loading = true;
  DateTime _selectedDate = DateTime.now();
  Timer? _timer;
  PrayerTimes? _timerPrayerTimes;

  @override
  void initState() {
    super.initState();
    _getPrayerTimes();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) setState(() {});
    });
  }

  Future<void> _getPrayerTimes() async {
    final position = await PrayerService.getCurrentLocation();
    if (position != null) {
      _timerPrayerTimes = PrayerService.calculatePrayerTimes(
        position.latitude,
        position.longitude,
        DateTime.now(),
      );

      final selectedPrayers = PrayerService.calculatePrayerTimes(
        position.latitude,
        position.longitude,
        _selectedDate,
      );

      setState(() {
        _prayerTimes = selectedPrayers;
        _loading = false;
      });
    }
  }

  String _getTimeUntilNextPrayer() {
    if (_timerPrayerTimes == null) return '';
    final now = DateTime.now();
    final nextPrayer = _timerPrayerTimes!.nextPrayer();
    final nextPrayerTime =
        PrayerService.getNextPrayerTime(_timerPrayerTimes!, nextPrayer);

    if (nextPrayerTime == null) return '';

    final difference = nextPrayerTime.difference(now);
    final hours = difference.inHours;
    final minutes = difference.inMinutes % 60;
    final seconds = difference.inSeconds % 60;

    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void _changeDate(int days) {
    setState(() {
      _selectedDate = _selectedDate.add(Duration(days: days));
      _loading = true;
    });
    _getPrayerTimes();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF2E7D32), Color(0xFF1B5E20)],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: _loading
            ? const Center(
                child: CircularProgressIndicator(color: Colors.white))
            : SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  children: [
                                    Icon(Icons.brightness_2,
                                        color: Colors.white),
                                    Text(
                                      'Moon Phase',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white),
                                ),
                                child: Text(
                                  '36',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              Text(
                                'Ramadan\nCountdown',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12),
                              ),
                            ],
                          ),
                          if (_prayerTimes != null) ...[
                            SizedBox(
                              width: 200,
                              height: 200,
                              child: Stack(
                                children: [
                                  CustomPaint(
                                    size: const Size(200, 200),
                                    painter: TimerCirclePainter(
                                      timeLeft: _getTimeLeftPercentage(),
                                      color: Colors.white.withOpacity(0.3),
                                      boldColor: Colors.white,
                                    ),
                                  ),
                                  Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Time until',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          PrayerService.getPrayerName(
                                              _timerPrayerTimes!),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          _getTimeUntilNextPrayer(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.chevron_left,
                              color: Colors.white),
                          onPressed: () => _changeDate(-1),
                        ),
                        Column(
                          children: [
                            Text(
                              DateFormat('dd MMMM yyyy').format(_selectedDate),
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            Text(
                              getIslamicDate(_selectedDate),
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.chevron_right,
                              color: Colors.white),
                          onPressed: () => _changeDate(1),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: 7,
                        itemBuilder: (context, index) {
                          if (index < 6) {
                            return Container(
                              margin: EdgeInsets.symmetric(vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ListTile(
                                title: Text(
                                  [
                                    'Fajr',
                                    'Sunrise',
                                    'Dhuhr',
                                    'Asr',
                                    'Maghrib',
                                    'Isha'
                                  ][index],
                                  style: TextStyle(color: Colors.white),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      PrayerService.formatTime(
                                          _prayerTimes!.fajr),
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    SizedBox(width: 8),
                                    Icon(Icons.notifications,
                                        color: Colors.white),
                                  ],
                                ),
                              ),
                            );
                          } else {
                            return Container(
                              margin: EdgeInsets.only(top: 10),
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  _buildNightSection('First third', '9:24 PM'),
                                  _buildNightSection('Midnight', '11:32 PM'),
                                  _buildNightSection('Last third', '1:39 AM'),
                                ],
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
        // bottomNavigationBar: BottomNavigationBar(
        //   backgroundColor: Colors.transparent,
        //   type: BottomNavigationBarType.fixed,
        //   items: const [
        //     BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
        //     BottomNavigationBarItem(icon: Icon(Icons.mosque), label: ''),
        //     BottomNavigationBarItem(icon: Icon(Icons.place), label: ''),
        //     BottomNavigationBarItem(icon: Icon(Icons.castle), label: ''),
        //     BottomNavigationBarItem(icon: Icon(Icons.settings), label: ''),
        //   ],
        //   selectedItemColor: Colors.white,
        //   unselectedItemColor: Colors.white.withOpacity(0.5),
        // ),
      ),
    );
  }

  Widget _buildNightSection(String title, String time) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(color: Colors.white, fontSize: 12),
        ),
        Text(
          time,
          style: TextStyle(color: Colors.white),
        ),
      ],
    );
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

  double _getTimeLeftPercentage() {
    if (_timerPrayerTimes == null) return 0;
    final now = DateTime.now();
    final nextPrayer = _timerPrayerTimes!.nextPrayer();
    final nextPrayerTime =
        PrayerService.getNextPrayerTime(_timerPrayerTimes!, nextPrayer);

    // Get previous prayer time
    final previousPrayer = _timerPrayerTimes!.currentPrayer();
    final previousPrayerTime =
        PrayerService.getNextPrayerTime(_timerPrayerTimes!, previousPrayer);

    if (nextPrayerTime == null || previousPrayerTime == null) return 0;

    final totalDuration = nextPrayerTime.difference(previousPrayerTime);
    final elapsedDuration = now.difference(previousPrayerTime);

    return elapsedDuration.inSeconds / totalDuration.inSeconds;
  }

  List<Widget> _buildPrayerTimeCards() {
    if (_prayerTimes == null) return [];

    final prayers = {
      'Fajr': _prayerTimes!.fajr,
      'Sunrise': _prayerTimes!.sunrise,
      'Dhuhr': _prayerTimes!.dhuhr,
      'Asr': _prayerTimes!.asr,
      'Maghrib': _prayerTimes!.maghrib,
      'Isha': _prayerTimes!.isha,
    };

    return prayers.entries.map((prayer) {
      final isNext = PrayerService.isNextPrayer(prayer.key, _prayerTimes!);
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Container(
          decoration: BoxDecoration(
            gradient: isNext
                ? const LinearGradient(
                    colors: [Color(0xFF64B5F6), Color(0xFF2196F3)],
                  )
                : null,
            color: isNext ? null : Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(15),
          ),
          child: ListTile(
            title: Text(
              prayer.key,
              style: TextStyle(
                color: Colors.white,
                fontWeight: isNext ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            trailing: Text(
              PrayerService.formatTime(prayer.value),
              style: TextStyle(
                color: Colors.white,
                fontWeight: isNext ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      );
    }).toList();
  }
}
