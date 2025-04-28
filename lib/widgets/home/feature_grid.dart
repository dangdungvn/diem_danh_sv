import 'package:flutter/material.dart';
import '../../components/feature_card.dart';
import '../../views/profile_screen.dart';
import '../../views/schedule_screen.dart';
import '../../views/statistics_screen.dart';

class FeatureGrid extends StatelessWidget {
  const FeatureGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1.1,
      ),
      delegate: SliverChildListDelegate([
        FeatureCard(
          icon: Icons.calendar_month,
          title: 'Lịch học',
          description: 'Xem lịch học hàng tuần',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ScheduleScreen(),
              ),
            );
          },
          backgroundColor: colorScheme.secondary.withOpacity(0.1),
          iconColor: colorScheme.secondary,
        ),
        FeatureCard(
          icon: Icons.bar_chart,
          title: 'Thống kê',
          description: 'Thống kê chi tiết',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const StatisticsScreen(),
              ),
            );
          },
          backgroundColor: colorScheme.tertiary.withOpacity(0.1),
          iconColor: colorScheme.tertiary,
        ),
        FeatureCard(
          icon: Icons.person,
          title: 'Hồ sơ',
          description: 'Thông tin cá nhân',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ProfileScreen(),
              ),
            );
          },
          backgroundColor: colorScheme.error.withOpacity(0.1),
          iconColor: colorScheme.error,
        ),
        FeatureCard(
          icon: Icons.notifications,
          title: 'Thông báo',
          description: 'Xem các thông báo mới',
          onTap: () {
            // TODO: Implement notifications screen
          },
          backgroundColor: colorScheme.secondary.withOpacity(0.1),
          iconColor: colorScheme.secondary,
        ),
        FeatureCard(
          icon: Icons.school,
          title: 'Môn học',
          description: 'Danh sách các môn học',
          onTap: () {
            // TODO: Implement courses screen
          },
          backgroundColor: colorScheme.primary.withOpacity(0.1),
          iconColor: colorScheme.primary,
        ),
        FeatureCard(
          icon: Icons.assessment,
          title: 'Điểm số',
          description: 'Xem điểm các môn học',
          onTap: () {
            // TODO: Implement grades screen
          },
          backgroundColor: colorScheme.tertiary.withOpacity(0.1),
          iconColor: colorScheme.tertiary,
        ),
      ]),
    );
  }
}
