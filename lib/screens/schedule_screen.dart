import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        title: Text(
          'Thời khóa biểu',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            elevation: 6,
            shadowColor: colorScheme.primary.withOpacity(0.3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
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
                      Icons.calendar_today,
                      color: colorScheme.primary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tuần hiện tại',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      Text(
                        '${DateFormat('dd/MM').format(DateTime.now())} - ${DateFormat('dd/MM').format(DateTime.now().add(const Duration(days: 6)))}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: const [
                _DayScheduleCard(
                  day: 'Thứ 2',
                  classes: [
                    _ClassSchedule(
                      subject: 'Lập trình di động',
                      time: '7:30 - 9:30',
                      room: 'A2.01',
                      teacher: 'Nguyễn Văn A',
                    ),
                    _ClassSchedule(
                      subject: 'Cơ sở dữ liệu',
                      time: '9:45 - 11:45',
                      room: 'A3.02',
                      teacher: 'Trần Thị B',
                    ),
                  ],
                ),
                SizedBox(height: 16),
                _DayScheduleCard(
                  day: 'Thứ 3',
                  classes: [
                    _ClassSchedule(
                      subject: 'Lập trình Web',
                      time: '13:30 - 15:30',
                      room: 'B2.03',
                      teacher: 'Lê Văn C',
                    ),
                  ],
                ),
                SizedBox(height: 16),
                _DayScheduleCard(
                  day: 'Thứ 4',
                  classes: [
                    _ClassSchedule(
                      subject: 'An toàn mạng',
                      time: '7:30 - 9:30',
                      room: 'A1.01',
                      teacher: 'Phạm Thị D',
                    ),
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
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
    );
  }
}

class _DayScheduleCard extends StatelessWidget {
  final String day;
  final List<_ClassSchedule> classes;

  const _DayScheduleCard({
    required this.day,
    required this.classes,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 6,
      shadowColor: Colors.black.withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.primary.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                day,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            ...classes.map((classSchedule) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 6,
                      height: 80,
                      decoration: BoxDecoration(
                        color: colorScheme.primary,
                        borderRadius: BorderRadius.circular(3),
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.primary.withOpacity(0.3),
                            blurRadius: 4,
                            offset: const Offset(1, 0),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            classSchedule.subject,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              _ClassInfoItem(
                                icon: Icons.access_time,
                                text: classSchedule.time,
                                theme: theme,
                              ),
                              const SizedBox(width: 16),
                              _ClassInfoItem(
                                icon: Icons.room,
                                text: classSchedule.room,
                                theme: theme,
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          _ClassInfoItem(
                            icon: Icons.person,
                            text: classSchedule.teacher,
                            theme: theme,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}

class _ClassSchedule {
  final String subject;
  final String time;
  final String room;
  final String teacher;

  const _ClassSchedule({
    required this.subject,
    required this.time,
    required this.room,
    required this.teacher,
  });
}

class _ClassInfoItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final ThemeData theme;

  const _ClassInfoItem({
    required this.icon,
    required this.text,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 16,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
