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
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: colorScheme.surface,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: colorScheme.onSurface,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          _buildWeekSummary(context),
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(16),
              children: const [
                _DayScheduleCard(
                  day: 'Thứ 2',
                  date: '06/05',
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
                  date: '07/05',
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
                  date: '08/05',
                  classes: [
                    _ClassSchedule(
                      subject: 'An toàn mạng',
                      time: '7:30 - 9:30',
                      room: 'A1.01',
                      teacher: 'Phạm Thị D',
                    ),
                  ],
                ),
                SizedBox(height: 16),
                _EmptyDayCard(
                  day: 'Thứ 5',
                  date: '09/05',
                ),
                SizedBox(height: 16),
                _EmptyDayCard(
                  day: 'Thứ 6',
                  date: '10/05',
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implement calendar view
        },
        elevation: 3,
        backgroundColor: colorScheme.primary,
        child: const Icon(Icons.calendar_month),
      ),
    );
  }

  Widget _buildWeekSummary(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Lấy ngày đầu tiên của tuần (thứ 2)
    final now = DateTime.now();
    final firstDayOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final lastDayOfWeek = firstDayOfWeek.add(const Duration(days: 6));

    final dateFormatter = DateFormat('dd/MM');
    final weekRange =
        '${dateFormatter.format(firstDayOfWeek)} - ${dateFormatter.format(lastDayOfWeek)}';

    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 3,
      shadowColor: Colors.black.withOpacity(0.1),
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
              ),
              child: Icon(
                Icons.date_range,
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
                  weekRange,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: colorScheme.tertiary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Tuần 18',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.tertiary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DayScheduleCard extends StatelessWidget {
  final String day;
  final String date;
  final List<_ClassSchedule> classes;

  const _DayScheduleCard({
    required this.day,
    required this.date,
    required this.classes,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 3,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        day.substring(day.length - 1),
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          day,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          date,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.secondary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${classes.length} môn',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.secondary,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(
              height: 24,
            ),
            ...classes.map((classSchedule) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildClassItem(context, classSchedule),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildClassItem(BuildContext context, _ClassSchedule classSchedule) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 4,
          height: 80,
          decoration: BoxDecoration(
            color: colorScheme.primary,
            borderRadius: BorderRadius.circular(2),
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
    );
  }
}

class _EmptyDayCard extends StatelessWidget {
  final String day;
  final String date;

  const _EmptyDayCard({
    required this.day,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 3,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    day.substring(day.length - 1),
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      day,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      date,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 24,
              ),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: colorScheme.surfaceContainerHighest.withOpacity(0.2),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.event_busy,
                    color: colorScheme.onSurfaceVariant.withOpacity(0.7),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Không có lịch học',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant.withOpacity(0.7),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
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
        Icon(
          icon,
          size: 16,
          color: theme.colorScheme.primary.withOpacity(0.7),
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
