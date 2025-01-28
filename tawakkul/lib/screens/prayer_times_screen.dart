import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../controllers/prayer_times_controller.dart';
import '../widgets/prayer_timer_widget.dart';
import '../widgets/prayer_list_widget.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/ramadan_countdown_widget.dart'; // ✅ Import Ramadan Countdown Widget

class PrayerTimesScreen extends StatelessWidget {
  const PrayerTimesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<PrayerTimesController>(context);

    /// 🔹 Determine if the selected date is past, present, or future
    final bool isToday =
        DateUtils.isSameDay(controller.selectedDate, DateTime.now());
    final bool isFuture = controller.selectedDate.isAfter(DateTime.now());
    final bool isPast = controller.selectedDate.isBefore(
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
    );

    return Scaffold(
      backgroundColor: const Color(0xFF040C23),
      body: controller.isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : SafeArea(
              child: Stack(
                children: [
                  /// 🔹 Main Column (Prayer Timer & List)
                  Column(
                    children: [
                      const SizedBox(height: 30), // Maintain spacing for the circle

                      /// 🔹 Prayer Timer Widget
                      PrayerTimerWidget(
                        timeLeftPercentage: controller.getTimeLeftPercentage(),
                        prayerName: controller.getNextPrayerName(),
                        timeLeft: controller.timeLeftNotifier.value,
                      ),

                      const Spacer(), // Push everything else down

                      /// 🔹 "Today | City" Box
                      Center(
                        child: InkWell(
                          onTap: () {
                            if (!isToday) {
                              controller.resetToToday();
                            }
                          },
                          borderRadius: BorderRadius.circular(4),
                          child: AnimatedOpacity(
                            duration: const Duration(milliseconds: 300),
                            opacity: isToday ? 1.0 : 0.5,
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: const Color(0xFFA44AFF), width: 1.5),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (isFuture) ...[
                                    const Icon(Icons.arrow_back, size: 12, color: Color(0xFFA44AFF)),
                                    const SizedBox(width: 4),
                                  ],
                                  const Text(
                                    'TODAY',
                                    style: TextStyle(
                                      color: Color(0xFFA44AFF),
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                  Text(
                                    ' | ${controller.currentCity ?? "Unknown"}',
                                    style: const TextStyle(
                                      color: Color(0xFFA44AFF),
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                  if (isPast) ...[
                                    const SizedBox(width: 4),
                                    const Icon(Icons.arrow_forward, size: 12, color: Color(0xFFA44AFF)),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 8), // Adjusted space below "Today" box

                      /// 🔹 Date Selector
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.chevron_left, color: Color(0xFFA44AFF), size: 22),
                            onPressed: () => controller.changeDate(-1),
                          ),
                          Column(
                            children: [
                              Text(
                                DateFormat('dd MMMM yyyy').format(controller.selectedDate),
                                style: const TextStyle(
                                  color: Color(0xFFA44AFF),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              Text(
                                controller.getIslamicDate(controller.selectedDate),
                                style: TextStyle(
                                  color: const Color(0xFFA44AFF).withOpacity(0.8),
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(Icons.chevron_right, color: Color(0xFFA44AFF), size: 22),
                            onPressed: () => controller.changeDate(1),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20), // Pushed down for better alignment

                      /// 🔹 Prayer Times List (Remains at the bottom)
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.45,
                        child: PrayerListWidget(prayerTimes: controller.prayerTimes!),
                      ),
                    ],
                  ),

                  /// 🔹 **New Ramadan Countdown Widget (Top Left)**
                  Positioned(
                    top: 20,
                    left: 20,
                    child: Consumer<PrayerTimesController>(
                      builder: (context, controller, child) {
                        return RamadanCountdownWidget(selectedDate: controller.selectedDate); // ✅ Pass selectedDate
                      },
                    ),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
