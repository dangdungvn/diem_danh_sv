import 'package:flutter/material.dart';
import '../widgets/statistics/statistics_app_bar.dart';
import '../widgets/statistics/overview_statistics_card.dart';
import '../widgets/statistics/weekly_statistics_card.dart';
import '../widgets/statistics/attendance_detail_card.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: const CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          // Header với thiết kế hiện đại
          StatisticsAppBar(),

          // Tổng quan điểm danh
          SliverToBoxAdapter(
            child: OverviewStatisticsCard(),
          ),

          // Biểu đồ theo tuần
          SliverToBoxAdapter(
            child: WeeklyStatisticsCard(),
          ),

          // Chi tiết điểm danh gần đây
          SliverToBoxAdapter(
            child: AttendanceDetailCard(),
          ),
        ],
      ),
    );
  }
}
