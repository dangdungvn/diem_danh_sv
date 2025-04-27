import 'package:flutter/material.dart';
import '../widgets/schedule/schedule_app_bar.dart';
import '../widgets/schedule/week_info_card.dart';
import '../widgets/schedule/day_selector.dart';
import '../widgets/schedule/class_schedule_card.dart';
import '../widgets/schedule/empty_schedule_view.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  int _selectedDay = DateTime.now().weekday - 1;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: CustomScrollView(
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
              children: [
                // Thứ 2
                ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  physics: const BouncingScrollPhysics(),
                  children: const [
                    ClassScheduleCard(
                      subject: 'Lập trình di động',
                      time: '7:30 - 9:30',
                      room: 'A2.01',
                      teacher: 'Nguyễn Văn A',
                      type: 'Lý thuyết',
                      color: Colors.blue,
                    ),
                    SizedBox(height: 16),
                    ClassScheduleCard(
                      subject: 'Cơ sở dữ liệu',
                      time: '9:45 - 11:45',
                      room: 'A3.02',
                      teacher: 'Trần Thị B',
                      type: 'Thực hành',
                      color: Colors.orange,
                    ),
                    SizedBox(height: 100), // Để tránh FAB che khuất
                  ],
                ),

                // Thứ 3
                ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  physics: const BouncingScrollPhysics(),
                  children: const [
                    ClassScheduleCard(
                      subject: 'Lập trình Web',
                      time: '13:30 - 15:30',
                      room: 'B2.03',
                      teacher: 'Lê Văn C',
                      type: 'Lý thuyết',
                      color: Colors.green,
                    ),
                    SizedBox(height: 100),
                  ],
                ),

                // Thứ 4
                ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  physics: const BouncingScrollPhysics(),
                  children: const [
                    ClassScheduleCard(
                      subject: 'An toàn mạng',
                      time: '7:30 - 9:30',
                      room: 'A1.01',
                      teacher: 'Phạm Thị D',
                      type: 'Lý thuyết',
                      color: Colors.purple,
                    ),
                    SizedBox(height: 100),
                  ],
                ),

                // Thứ 5, 6, 7, CN
                ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  physics: const BouncingScrollPhysics(),
                  children: const [
                    EmptyScheduleView(),
                    SizedBox(height: 100),
                  ],
                ),
                ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  physics: const BouncingScrollPhysics(),
                  children: const [
                    EmptyScheduleView(),
                    SizedBox(height: 100),
                  ],
                ),
                ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  physics: const BouncingScrollPhysics(),
                  children: const [
                    EmptyScheduleView(),
                    SizedBox(height: 100),
                  ],
                ),
                ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  physics: const BouncingScrollPhysics(),
                  children: const [
                    EmptyScheduleView(),
                    SizedBox(height: 100),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Implement calendar view
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
