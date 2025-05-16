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
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Header với thiết kế hiện đại
            const StudentAppBar(),

            // Welcome header và tìm kiếm
            // SliverToBoxAdapter(
            //   child: Padding(
            //     padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            //     child: Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         // Tiêu đề chào mừng
            //         Row(
            //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //           children: [
            //             Column(
            //               crossAxisAlignment: CrossAxisAlignment.start,
            //               children: [
            //                 Text(
            //                   'Xin chào, Sinh viên',
            //                   style: TextStyle(
            //                     fontSize: 18,
            //                     fontWeight: FontWeight.bold,
            //                     color: colorScheme.onBackground,
            //                   ),
            //                 ),
            //                 const SizedBox(height: 4),
            //                 Text(
            //                   'Hôm nay bạn muốn học gì?',
            //                   style: TextStyle(
            //                     fontSize: 14,
            //                     color:
            //                         colorScheme.onBackground.withOpacity(0.7),
            //                   ),
            //                 ),
            //               ],
            //             ),
            //             // Notification button
            //             Container(
            //               padding: const EdgeInsets.all(8),
            //               decoration: BoxDecoration(
            //                 color:
            //                     colorScheme.primaryContainer.withOpacity(0.3),
            //                 borderRadius: BorderRadius.circular(12),
            //               ),
            //               child: Icon(
            //                 Icons.notifications_outlined,
            //                 color: colorScheme.primary,
            //                 size: 24,
            //               ),
            //             ),
            //           ],
            //         ),

            //         const SizedBox(height: 16),

            //         // Thanh tìm kiếm
            //         Container(
            //           padding: const EdgeInsets.symmetric(
            //               horizontal: 16, vertical: 12),
            //           decoration: BoxDecoration(
            //             color: colorScheme.surface,
            //             borderRadius: BorderRadius.circular(16),
            //             boxShadow: [
            //               BoxShadow(
            //                 color: Colors.black.withOpacity(0.05),
            //                 blurRadius: 10,
            //                 spreadRadius: 1,
            //               ),
            //             ],
            //           ),
            //           child: Row(
            //             children: [
            //               Icon(
            //                 Icons.search,
            //                 color: colorScheme.primary,
            //                 size: 22,
            //               ),
            //               const SizedBox(width: 10),
            //               Text(
            //                 'Tìm kiếm lớp học...',
            //                 style: TextStyle(
            //                   fontSize: 14,
            //                   color: colorScheme.onSurface.withOpacity(0.7),
            //                 ),
            //               ),
            //             ],
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),

            // Nút điểm danh chính
            const SliverToBoxAdapter(
              child: AttendanceButton(),
            ),

            // Thống kê điểm danh
            const SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              sliver: SliverToBoxAdapter(
                child: AttendanceStatsCard(),
              ),
            ),

            // Tiêu đề Tính năng
            const SliverPadding(
              padding: EdgeInsets.fromLTRB(16, 20, 16, 8),
              sliver: SliverToBoxAdapter(
                child: SectionTitle(
                  title: 'Tính năng',
                  icon: Icons.dashboard_customize_rounded,
                ),
              ),
            ),

            // Grid tính năng
            const SliverPadding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 24),
              sliver: FeatureGrid(),
            ),

            // Phần tiêu đề thông tin
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              sliver: SliverToBoxAdapter(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                  decoration: BoxDecoration(
                    color: colorScheme.secondaryContainer.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        color: colorScheme.secondary,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Thông tin hỗ trợ',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: colorScheme.onSecondaryContainer,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Phần footer
            const SliverToBoxAdapter(
              child: SupportInfoFooter(),
            ),

            // Padding cuối cùng
            const SliverToBoxAdapter(
              child: SizedBox(height: 20),
            ),
          ],
        ),
      ),
    );
  }
}
