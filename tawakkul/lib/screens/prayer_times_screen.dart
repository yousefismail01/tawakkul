import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../controllers/prayer_times_controller.dart';
import '../widgets/prayer_timer_widget.dart';
import '../widgets/prayer_list_widget.dart';
import '../widgets/bottom_nav_bar.dart';

class PrayerTimesScreen extends StatelessWidget {
  const PrayerTimesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<PrayerTimesController>(context);

    /// 🔹 Check if selected date is today
    final bool isToday =
        DateUtils.isSameDay(controller.selectedDate, DateTime.now());

    return Scaffold(
      backgroundColor: Colors.black,
      body: controller.isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  /// 🔹 Prayer Timer Widget
                  PrayerTimerWidget(
                    timeLeftPercentage: controller.getTimeLeftPercentage(),
                    prayerName: controller
                        .getNextPrayerName(), // Placeholder, replace with actual name
                    timeLeft: controller.timeLeftNotifier.value,
                  ),

                  const SizedBox(
                      height: 5), // Reduced space for better positioning

                  /// 🔹 Smaller "Today | Current City" Box
                  Center(
                    child: InkWell(
                      onTap: () {
                        if (!isToday) {
                          controller.resetToToday(); // Reset to today's date
                        }
                      },
                      borderRadius: BorderRadius.circular(6),
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 300),
                        opacity:
                            isToday ? 1.0 : 0.5, // Becomes opaque if not today
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 10), // Smaller padding
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(
                                0.1), // Slightly visible background
                            borderRadius: BorderRadius.circular(
                                6), // Smaller rounded corners
                            border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                                width: 0.8), // Subtle thin border
                          ),
                          child: Text(
                            'TODAY | ${controller.currentCity ?? "Unknown"}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12, // Smaller text size
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 5), // Reduced spacing

                  /// 🔹 Date Selector (Below Timer)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.chevron_left,
                            color: Colors.white, size: 22),
                        onPressed: () => controller.changeDate(-1),
                      ),
                      Column(
                        children: [
                          Text(
                            DateFormat('dd MMMM yyyy')
                                .format(controller.selectedDate),
                            style: const TextStyle(
                                color: Colors.white, fontSize: 18),
                          ),
                          Text(
                            controller.getIslamicDate(controller.selectedDate),
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 14),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.chevron_right,
                            color: Colors.white, size: 22),
                        onPressed: () => controller.changeDate(1),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  /// 🔹 Prayer Times List
                  Expanded(
                    child:
                        PrayerListWidget(prayerTimes: controller.prayerTimes!),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
