import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/attendance_provider.dart';

class OverviewStatisticsCard extends StatelessWidget {
  const OverviewStatisticsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Card(
        elevation: 6,
        shadowColor: Colors.black.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tiêu đề section
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: colorScheme.primary.withOpacity(0.1),
                          blurRadius: 4,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.insert_chart_outlined,
                      color: colorScheme.primary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Tổng quan',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Thống kê tổng quan
              Consumer<AttendanceProvider>(
                builder: (context, provider, child) {
                  // Tính toán số liệu thống kê
                  final totalAttendance = provider.attendanceHistory.length;
                  final presentCount = provider.attendanceHistory
                      .where((a) => a.isPresent)
                      .length;
                  final absentCount = totalAttendance - presentCount;
                  final lateCount =
                      provider.attendanceHistory.where((a) => a.isLate).length;

                  // Tỷ lệ phần trăm
                  final presentRate = totalAttendance > 0
                      ? (presentCount / totalAttendance * 100)
                          .toStringAsFixed(1)
                      : '0.0';

                  final lateRate = totalAttendance > 0
                      ? (lateCount / totalAttendance * 100).toStringAsFixed(1)
                      : '0.0';

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // Có mặt
                      _buildStatItem(
                        context,
                        icon: Icons.check_circle,
                        iconColor: colorScheme.primary,
                        title: 'Có mặt',
                        value: '$presentCount',
                        subtitle: '$presentRate%',
                      ),

                      // Đi trễ
                      _buildStatItem(
                        context,
                        icon: Icons.watch_later,
                        iconColor: Colors.orange,
                        title: 'Đi trễ',
                        value: '$lateCount',
                        subtitle: '$lateRate%',
                      ),

                      // Vắng mặt
                      _buildStatItem(
                        context,
                        icon: Icons.cancel,
                        iconColor: colorScheme.error,
                        title: 'Vắng mặt',
                        value: '$absentCount',
                        subtitle: totalAttendance > 0
                            ? '${(absentCount / totalAttendance * 100).toStringAsFixed(1)}%'
                            : '0.0%',
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
    required String subtitle,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: iconColor,
            size: 24,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          value,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          subtitle,
          style: theme.textTheme.bodySmall?.copyWith(
            color: iconColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
