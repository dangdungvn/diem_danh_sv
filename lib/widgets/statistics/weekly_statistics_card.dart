import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../models/attendance_history_model.dart';
import '../../providers/attendance_provider.dart';

class WeeklyStatisticsCard extends StatefulWidget {
  const WeeklyStatisticsCard({super.key});

  @override
  State<WeeklyStatisticsCard> createState() => _WeeklyStatisticsCardState();
}

class _WeeklyStatisticsCardState extends State<WeeklyStatisticsCard> {
  int selectedIndex = 0;
  List<String> periods = ['Tuần này', '30 ngày qua'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
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
                          Icons.bar_chart,
                          color: colorScheme.primary,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Thống kê theo thời gian',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Buttons chọn khoảng thời gian
              Row(
                children: List.generate(
                  periods.length,
                  (index) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(periods[index]),
                      selected: selectedIndex == index,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            selectedIndex = index;
                          });
                        }
                      },
                      selectedColor: colorScheme.primary.withOpacity(0.2),
                      labelStyle: TextStyle(
                        color: selectedIndex == index
                            ? colorScheme.primary
                            : colorScheme.onSurfaceVariant,
                        fontWeight: selectedIndex == index
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Biểu đồ điểm danh
              SizedBox(
                height: 240,
                child: Consumer<AttendanceProvider>(
                  builder: (context, provider, child) {
                    final attendanceData = provider.attendanceHistory;
                    if (attendanceData.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.bar_chart,
                              color: colorScheme.outline,
                              size: 48,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Chưa có dữ liệu điểm danh',
                              style: theme.textTheme.titleMedium,
                            ),
                          ],
                        ),
                      );
                    }

                    // Lấy dữ liệu theo khoảng thời gian được chọn
                    List<AttendanceHistoryModel> filteredData = [];
                    final now = DateTime.now();

                    switch (selectedIndex) {
                      case 0: // Tuần này
                        final startOfWeek =
                            now.subtract(Duration(days: now.weekday - 1));
                        final startDate = DateTime(startOfWeek.year,
                            startOfWeek.month, startOfWeek.day);
                        filteredData = attendanceData
                            .where((a) => a.timestamp.isAfter(startDate))
                            .toList();
                        break;
                      case 1: // 30 ngày qua
                        final last30Days =
                            now.subtract(const Duration(days: 30));
                        filteredData = attendanceData
                            .where((a) => a.timestamp.isAfter(last30Days))
                            .toList();
                        break;
                    }

                    // Nếu không có dữ liệu trong khoảng thời gian đã chọn
                    if (filteredData.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.bar_chart,
                              color: colorScheme.outline,
                              size: 48,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Không có dữ liệu trong khoảng thời gian này',
                              style: theme.textTheme.titleMedium,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    }

                    return _buildChart(context, filteredData);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChart(BuildContext context, List<AttendanceHistoryModel> data) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Nhóm dữ liệu theo ngày
    final Map<String, Map<String, int>> dailyStats = {};

    for (var attendance in data) {
      final dateKey = DateFormat('yyyy-MM-dd').format(attendance.timestamp);
      dailyStats[dateKey] ??= {'present': 0, 'absent': 0, 'late': 0};

      if (attendance.isPresent) {
        if (attendance.isLate) {
          dailyStats[dateKey]!['late'] =
              (dailyStats[dateKey]!['late'] ?? 0) + 1;
        } else {
          dailyStats[dateKey]!['present'] =
              (dailyStats[dateKey]!['present'] ?? 0) + 1;
        }
      } else {
        dailyStats[dateKey]!['absent'] =
            (dailyStats[dateKey]!['absent'] ?? 0) + 1;
      }
    }

    // Sắp xếp các ngày
    final sortedDates = dailyStats.keys.toList()..sort();

    // Giới hạn hiển thị 7 ngày gần nhất nếu có quá nhiều dữ liệu
    if (sortedDates.length > 7) {
      sortedDates.removeRange(0, sortedDates.length - 7);
    }

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: _calculateMaxY(dailyStats, sortedDates),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value < 0 || value >= sortedDates.length) {
                  return const SizedBox();
                }

                final date = DateTime.parse(sortedDates[value.toInt()]);
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 0.0),
                  child: Text(
                    DateFormat('dd/MM').format(date),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (value, meta) {
                if (value == 0) {
                  return const SizedBox();
                }

                return Text(
                  value.toInt().toString(),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                );
              },
            ),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(
          show: false,
        ),
        barGroups: List.generate(
          sortedDates.length,
          (index) {
            final date = sortedDates[index];
            final stats = dailyStats[date]!;

            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: stats['present']!.toDouble(),
                  color: colorScheme.primary,
                  width: 12,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4),
                    topRight: Radius.circular(4),
                  ),
                ),
                BarChartRodData(
                  toY: stats['late']!.toDouble(),
                  color: Colors.orange,
                  width: 12,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4),
                    topRight: Radius.circular(4),
                  ),
                ),
                BarChartRodData(
                  toY: stats['absent']!.toDouble(),
                  color: colorScheme.error,
                  width: 12,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4),
                    topRight: Radius.circular(4),
                  ),
                ),
              ],
            );
          },
        ),
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: colorScheme.surface,
            tooltipRoundedRadius: 8,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              String status;
              switch (rodIndex) {
                case 0:
                  status = 'Có mặt';
                  break;
                case 1:
                  status = 'Đi trễ';
                  break;
                case 2:
                  status = 'Vắng mặt';
                  break;
                default:
                  status = '';
              }

              return BarTooltipItem(
                '$status: ${rod.toY.toInt()}',
                TextStyle(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  double _calculateMaxY(
      Map<String, Map<String, int>> dailyStats, List<String> dates) {
    double maxY = 0;
    for (var date in dates) {
      final stats = dailyStats[date]!;
      final total = stats['present']! + stats['late']! + stats['absent']!;
      if (total > maxY) {
        maxY = total.toDouble();
      }
    }

    // Thêm một khoảng nhỏ để biểu đồ trông đẹp hơn
    return maxY + 1;
  }
}
