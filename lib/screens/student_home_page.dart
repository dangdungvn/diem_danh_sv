import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../components/feature_card.dart';
import '../components/qr_scan_button.dart';
import '../components/attendance_stats_card.dart';
import 'statistics_screen.dart';
import 'schedule_screen.dart';
import 'profile_screen.dart';

class StudentHomePage extends StatefulWidget {
  const StudentHomePage({super.key});

  @override
  State<StudentHomePage> createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<StudentHomePage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            backgroundColor: colorScheme.surface,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Điểm Danh SV',
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
            ),
            actions: [
              IconButton(
                icon: Icon(
                  context.watch<ThemeProvider>().isDarkMode
                      ? Icons.light_mode
                      : Icons.dark_mode,
                  color: colorScheme.onSurface,
                ),
                onPressed: () {
                  context.read<ThemeProvider>().toggleTheme();
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.account_circle,
                  color: colorScheme.onSurface,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfileScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(width: 8),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const AttendanceStatsCard(),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.primary.withOpacity(0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.dashboard_customize,
                        color: colorScheme.primary,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Tính năng',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  children: [
                    FeatureCard(
                      icon: Icons.qr_code_scanner,
                      title: 'Điểm danh',
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) => const QRScanButton(),
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(24),
                            ),
                          ),
                        );
                      },
                      backgroundColor: colorScheme.primary.withOpacity(0.1),
                      iconColor: colorScheme.primary,
                    ),
                    FeatureCard(
                      icon: Icons.calendar_month,
                      title: 'Lịch học',
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
                      onTap: () {
                        // TODO: Implement notifications screen
                      },
                      backgroundColor: colorScheme.secondary.withOpacity(0.1),
                      iconColor: colorScheme.secondary,
                    ),
                    FeatureCard(
                      icon: Icons.school,
                      title: 'Môn học',
                      onTap: () {
                        // TODO: Implement courses screen
                      },
                      backgroundColor: colorScheme.primary.withOpacity(0.1),
                      iconColor: colorScheme.primary,
                    ),
                    FeatureCard(
                      icon: Icons.assessment,
                      title: 'Điểm số',
                      onTap: () {
                        // TODO: Implement grades screen
                      },
                      backgroundColor: colorScheme.tertiary.withOpacity(0.1),
                      iconColor: colorScheme.tertiary,
                    ),
                    FeatureCard(
                      icon: Icons.event_note,
                      title: 'Sự kiện',
                      onTap: () {
                        // TODO: Implement events screen
                      },
                      backgroundColor: colorScheme.secondary.withOpacity(0.1),
                      iconColor: colorScheme.secondary,
                    ),
                  ],
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
