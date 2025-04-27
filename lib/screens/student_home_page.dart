import 'package:flutter/material.dart';
import '../components/attendance_stats_card.dart';
import '../widgets/app_bar/student_app_bar.dart';
import '../widgets/home/attendance_button.dart';
import '../widgets/home/feature_grid.dart';
import '../widgets/home/section_title.dart';
import '../widgets/home/support_info_footer.dart';

class StudentHomePage extends StatefulWidget {
  const StudentHomePage({super.key});

  @override
  State<StudentHomePage> createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<StudentHomePage> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              colorScheme.background,
              colorScheme.surface,
              colorScheme.tertiary.withOpacity(0.05),
            ],
          ),
        ),
        child: const CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: [
            // Header với thiết kế hiện đại
            StudentAppBar(),

            // Nút điểm danh chính
            SliverToBoxAdapter(
              child: AttendanceButton(),
            ),

            // Thống kê điểm danh
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              sliver: SliverToBoxAdapter(
                child: AttendanceStatsCard(),
              ),
            ),

            // Tiêu đề Tính năng
            SliverPadding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
              sliver: SliverToBoxAdapter(
                child: SectionTitle(
                  title: 'Tính năng',
                  icon: Icons.dashboard_customize,
                ),
              ),
            ),

            // Grid tính năng
            SliverPadding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
              sliver: FeatureGrid(),
            ),

            // Phần footer
            SliverToBoxAdapter(
              child: SupportInfoFooter(),
            ),

            // Padding cuối cùng
            SliverToBoxAdapter(
              child: SizedBox(height: 16),
            ),
          ],
        ),
      ),
    );
  }
}
