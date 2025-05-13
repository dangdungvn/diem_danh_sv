import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/schedule/schedule_app_bar.dart';
import '../widgets/schedule/week_info_card.dart';
import '../widgets/schedule/day_selector.dart';
import '../widgets/schedule/class_schedule_card.dart';
import '../widgets/schedule/empty_schedule_view.dart';
import '../providers/schedule_provider.dart';
import 'month_schedule_screen.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  int _selectedDay = DateTime.now().weekday - 1;
  final PageController _pageController =
      PageController(initialPage: DateTime.now().weekday - 1);

  @override
  void initState() {
    super.initState();
    // Fetch schedule data when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ScheduleProvider>(context, listen: false)
          .fetchStudentSchedule();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final scheduleProvider = Provider.of<ScheduleProvider>(context);

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: scheduleProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : scheduleProvider.error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 60,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Không thể tải lịch học',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        scheduleProvider.error!,
                        style: const TextStyle(color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () {
                          scheduleProvider.fetchStudentSchedule();
                        },
                        child: const Text('Thử lại'),
                      ),
                    ],
                  ),
                )
              : CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    // Header với thiết kế hiện đại
                    const ScheduleAppBar(),

                    // Thông tin tuần hiện tại
                    const SliverToBoxAdapter(
                      child: WeekInfoCard(),
                    ),

                    // Thanh chọn ngày trong tuần
                    SliverToBoxAdapter(
                      child: DaySelector(
                        selectedDay: _selectedDay,
                        onDaySelected: (index) {
                          setState(() {
                            _selectedDay = index;
                          });
                        },
                        pageController: _pageController,
                      ),
                    ),

                    // Lịch học theo ngày
                    SliverFillRemaining(
                      child: PageView(
                        controller: _pageController,
                        onPageChanged: (index) {
                          setState(() {
                            _selectedDay = index;
                          });
                        },
                        children: List.generate(7, (dayIndex) {
                          // Get schedules for the current day (add 1 because API uses 1-7 for weekdays)
                          final schedules =
                              scheduleProvider.getSchedulesForDay(dayIndex + 1);

                          if (schedules.isEmpty) {
                            return ListView(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              physics: const BouncingScrollPhysics(),
                              children: const [
                                EmptyScheduleView(),
                                SizedBox(height: 100),
                              ],
                            );
                          }

                          return ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            physics: const BouncingScrollPhysics(),
                            itemCount:
                                schedules.length + 1, // +1 for bottom space
                            itemBuilder: (context, index) {
                              if (index == schedules.length) {
                                return const SizedBox(
                                    height: 100); // Bottom space
                              }

                              final schedule = schedules[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: ClassScheduleCard(
                                  subject: schedule.courseName,
                                  time: schedule.getFormattedTime(),
                                  room: schedule.roomName,
                                  teacher: schedule.teacherName,
                                  type: schedule.getLessonType(),
                                  color: schedule.getSubjectColor(),
                                  className: schedule.className,
                                ),
                              );
                            },
                          );
                        }),
                      ),
                    ),
                  ],
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const MonthScheduleScreen(),
            ),
          );
        },
        icon: const Icon(Icons.calendar_month),
        label: const Text('Xem lịch tháng'),
        elevation: 6,
        backgroundColor: colorScheme.secondary,
        foregroundColor: colorScheme.onSecondary,
      ),
    );
  }
}
