import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'legend_item.dart';

class OverviewStatisticsCard extends StatelessWidget {
  const OverviewStatisticsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        elevation: 6,
        shadowColor: colorScheme.primary.withOpacity(0.3),
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
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
                          Icons.pie_chart,
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
                  // Dropdown chọn môn học
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Tất cả môn học',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.keyboard_arrow_down,
                          size: 18,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Biểu đồ tròn với tỉ lệ điểm danh
              Row(
                children: [
                  // Biểu đồ tròn
                  SizedBox(
                    height: 160,
                    width: 160,
                    child: Stack(
                      children: [
                        PieChart(
                          PieChartData(
                            sections: [
                              PieChartSectionData(
                                value: 85,
                                color: colorScheme.primary,
                                radius: 40,
                                title: '',
                                showTitle: false,
                              ),
                              PieChartSectionData(
                                value: 15,
                                color: colorScheme.error.withOpacity(0.8),
                                radius: 30,
                                title: '',
                                showTitle: false,
                              ),
                            ],
                            sectionsSpace: 0,
                            centerSpaceRadius: 50,
                            centerSpaceColor: Colors.transparent,
                            borderData: FlBorderData(show: false),
                          ),
                        ),
                        // Hiển thị tỉ lệ ở giữa biểu đồ
                        Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '85%',
                                style: theme.textTheme.headlineMedium
                                    ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.primary,
                                ),
                              ),
                              Text(
                                'Tỉ lệ điểm danh',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Thông tin thống kê bên phải
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildStatisticsItem(
                          context,
                          icon: Icons.check_circle,
                          title: 'Có mặt',
                          value: '17 buổi',
                          color: colorScheme.primary,
                        ),
                        const SizedBox(height: 16),
                        _buildStatisticsItem(
                          context,
                          icon: Icons.cancel,
                          title: 'Vắng mặt',
                          value: '3 buổi',
                          color: colorScheme.error,
                        ),
                        const SizedBox(height: 16),
                        _buildStatisticsItem(
                          context,
                          icon: Icons.calendar_month,
                          title: 'Tổng buổi học',
                          value: '20 buổi',
                          color: colorScheme.tertiary,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Chú thích biểu đồ
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    LegendItem(
                      color: colorScheme.primary,
                      label: 'Có mặt (85%)',
                    ),
                    LegendItem(
                      color: colorScheme.error.withOpacity(0.8),
                      label: 'Vắng mặt (15%)',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatisticsItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            size: 16,
            color: color,
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            Text(
              value,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ],
    );
  }
}