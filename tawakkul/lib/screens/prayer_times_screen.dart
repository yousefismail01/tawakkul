import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../controllers/prayer_times_controller.dart';
import '../themes/prayer_theme_manager.dart'; // ✅ New Theme Manager
import '../widgets/prayer_timer_widget.dart';
import '../widgets/prayer_list_widget.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/ramadan_countdown_widget.dart';

class PrayerTimesScreen extends StatelessWidget {
  const PrayerTimesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<PrayerTimesController>(context);

    /// 🔹 Get screen height for dynamic scaling
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    /// 🔹 Determine if the selected date is today
    final bool isToday =
        DateUtils.isSameDay(controller.selectedDate, DateTime.now());

    return Scaffold(
      /// ✅ **Set the dynamic theme based on prayer time**
      body: SafeArea(
        child: Stack(
          children: [
            /// 🔹 **Dynamic Background Based on Prayer Time**
            Positioned.fill(
              child: AnimatedSwitcher(
                duration:
                    const Duration(milliseconds: 500), // Smooth transition
                child: PrayerThemeManager.getCurrentTheme(
                  controller.prayerTimes!,
                  controller.selectedDate,
                ),
              ),
            ),

            /// 🔹 **Main Column with Dynamic Scaling**
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: screenHeight * 0.03), // Adaptive spacing

                /// 🔹 **Prayer Timer Widget**
                SizedBox(
                  height: screenHeight * 0.22,
                  child: PrayerTimerWidget(
                    timeLeftPercentage: controller.getTimeLeftPercentage(),
                    prayerName: controller.getNextPrayerName(),
                    timeLeft: controller.timeLeftNotifier.value,
                  ),
                ),

                SizedBox(height: screenHeight * 0.015), // Adjusted spacing

                /// 🔹 **"Today | City" Box**
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
                        padding: EdgeInsets.symmetric(
                            vertical: screenHeight * 0.004,
                            horizontal: screenWidth * 0.02),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                              color: const Color(0xFFA44AFF), width: 1.5),
                        ),
                        child: Text(
                          'TODAY | ${controller.currentCity ?? "Unknown"}',
                          style: const TextStyle(
                            color: Color(0xFFA44AFF),
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: screenHeight * 0.015), // Adjusted spacing

                /// 🔹 **Date Selector (Restored)**
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left,
                          color: Color(0xFFA44AFF), size: 22),
                      onPressed: () => controller.changeDate(-1),
                    ),
                    Column(
                      children: [
                        Text(
                          DateFormat('dd MMMM yyyy')
                              .format(controller.selectedDate),
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
                      icon: const Icon(Icons.chevron_right,
                          color: Color(0xFFA44AFF), size: 22),
                      onPressed: () => controller.changeDate(1),
                    ),
                  ],
                ),

                SizedBox(height: screenHeight * 0.02), // Adjusted spacing

                /// 🔹 **Prayer Times List (Takes Remaining Space)**
                Expanded(
                  child: PrayerListWidget(prayerTimes: controller.prayerTimes!),
                ),
              ],
            ),

            /// 🔹 **Ramadan Countdown Widget (Top Left, Always Visible)**
            Positioned(
              top: screenHeight * 0.02, // ✅ Scales with device height
              left: screenWidth * 0.03, // ✅ Scales with device width
              child: Consumer<PrayerTimesController>(
                builder: (context, controller, child) {
                  return RamadanCountdownWidget(
                      selectedDate: controller.selectedDate);
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const SafeArea(child: BottomNavBar()),
    );
  }
}
