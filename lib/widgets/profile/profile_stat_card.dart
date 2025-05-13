import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/attendance_provider.dart';

class ProfileStatCard extends StatelessWidget {
  const ProfileStatCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = colorScheme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color: isDark ? colorScheme.surfaceContainer : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withOpacity(0.2)
                  : Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 0,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Consumer<AttendanceProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (provider.error != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline,
                        color: colorScheme.error, size: 32),
                    const SizedBox(height: 8),
                    Text('Không thể tải dữ liệu điểm danh',
                        style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () => provider.fetchAttendanceHistory(),
                      child: const Text('Thử lại'),
                    ),
                  ],
                ),
              );
            }
            final totalAttendance = provider.attendanceHistory.length;
            final presentCount =
                provider.attendanceHistory.where((a) => a.isPresent).length;
            final absentCount = totalAttendance - presentCount;
            return IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStatItem(
                    context: context,
                    label: 'Buổi học',
                    value: '$totalAttendance',
                    icon: Icons.calendar_today,
                    iconColor: colorScheme.primary,
                  ),
                  VerticalDivider(
                    thickness: 1,
                    color: isDark
                        ? colorScheme.outlineVariant
                        : Colors.grey.withOpacity(0.2),
                  ),
                  _buildStatItem(
                    context: context,
                    label: 'Điểm danh',
                    value: '$presentCount',
                    icon: Icons.check_circle_outline,
                    iconColor: Colors.green,
                  ),
                  VerticalDivider(
                    thickness: 1,
                    color: isDark
                        ? colorScheme.outlineVariant
                        : Colors.grey.withOpacity(0.2),
                  ),
                  _buildStatItem(
                    context: context,
                    label: 'Vắng mặt',
                    value: '$absentCount',
                    icon: Icons.cancel_outlined,
                    iconColor: Colors.red,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required BuildContext context,
    required String label,
    required String value,
    required IconData icon,
    required Color iconColor,
  }) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: iconColor, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
