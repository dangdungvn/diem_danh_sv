import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/attendance_history_model.dart';
import '../providers/attendance_provider.dart';

class AttendanceDetailPage extends StatefulWidget {
  const AttendanceDetailPage({super.key});

  @override
  State<AttendanceDetailPage> createState() => _AttendanceDetailPageState();
}

class _AttendanceDetailPageState extends State<AttendanceDetailPage> {
  String _search = '';
  String _statusFilter = 'Tất cả';
  String _courseFilter = 'Tất cả';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: Consumer<AttendanceProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, color: colorScheme.error, size: 48),
                  const SizedBox(height: 16),
                  Text('Không thể tải dữ liệu điểm danh',
                      style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => provider.fetchAttendanceHistory(),
                    child: const Text('Thử lại'),
                  ),
                ],
              ),
            );
          }
          final history = provider.attendanceHistory;
          if (history.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, color: colorScheme.outline, size: 48),
                  const SizedBox(height: 16),
                  Text('Chưa có dữ liệu điểm danh',
                      style: theme.textTheme.titleMedium),
                ],
              ),
            );
          }

          // Lấy danh sách môn học để filter
          final courses = [
            'Tất cả',
            ...{...history.map((e) => e.scheduleDetail.courseName)}
          ];

          // Lọc dữ liệu
          List<AttendanceHistoryModel> filtered = history.where((a) {
            final matchSearch = _search.isEmpty ||
                a.scheduleDetail.courseName
                    .toLowerCase()
                    .contains(_search.toLowerCase()) ||
                a.scheduleDetail.className
                    .toLowerCase()
                    .contains(_search.toLowerCase()) ||
                a.scheduleDetail.teacherName
                    .toLowerCase()
                    .contains(_search.toLowerCase()) ||
                a.scheduleDetail.room
                    .toLowerCase()
                    .contains(_search.toLowerCase());
            final matchStatus = _statusFilter == 'Tất cả' ||
                (_statusFilter == 'Đúng giờ' && a.isPresent && !a.isLate) ||
                (_statusFilter == 'Muộn' && a.isLate) ||
                (_statusFilter == 'Vắng' && !a.isPresent);
            final matchCourse = _courseFilter == 'Tất cả' ||
                a.scheduleDetail.courseName == _courseFilter;
            return matchSearch && matchStatus && matchCourse;
          }).toList();

          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                expandedHeight: 140,
                floating: false,
                pinned: true,
                backgroundColor: colorScheme.primary,
                surfaceTintColor: Colors.transparent,
                leading: Padding(
                  padding: const EdgeInsets.only(left: 0.0),
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          colorScheme.primary,
                          colorScheme.primary.withOpacity(0.8),
                        ],
                      ),
                    ),
                    child: SafeArea(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 32),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.list_alt,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Lịch sử điểm danh',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon:
                            const Icon(Icons.filter_list, color: Colors.white),
                        onPressed: () {
                          _showFilterBottomSheet(context, courses);
                        },
                      ),
                    ),
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Tìm kiếm theo môn, lớp, giáo viên, phòng...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: colorScheme.surfaceContainer,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 16),
                    ),
                    onChanged: (value) => setState(() => _search = value),
                  ),
                ),
              ),
              if (_statusFilter != 'Tất cả' || _courseFilter != 'Tất cả')
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                    child: Wrap(
                      spacing: 8,
                      children: [
                        if (_statusFilter != 'Tất cả')
                          FilterChip(
                            label: Text(_statusFilter),
                            onSelected: (value) =>
                                setState(() => _statusFilter = 'Tất cả'),
                          ),
                        if (_courseFilter != 'Tất cả')
                          FilterChip(
                            label: Text(_courseFilter),
                            onSelected: (value) =>
                                setState(() => _courseFilter = 'Tất cả'),
                          ),
                      ],
                    ),
                  ),
                ),
              filtered.isEmpty
                  ? SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.history,
                                color: colorScheme.outline, size: 48),
                            const SizedBox(height: 16),
                            Text('Không tìm thấy kết quả',
                                style: theme.textTheme.titleMedium),
                          ],
                        ),
                      ),
                    )
                  : SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final attendance = filtered[index];
                          return GestureDetector(
                            onTap: () =>
                                _showAttendanceDetailModal(context, attendance),
                            child:
                                _AttendanceDetailItem(attendance: attendance),
                          );
                        },
                        childCount: filtered.length,
                      ),
                    ),
            ],
          );
        },
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context, List<String> courses) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Lọc theo trạng thái',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                children: [
                  ChoiceChip(
                    label: const Text('Tất cả'),
                    selected: _statusFilter == 'Tất cả',
                    onSelected: (_) => setState(() => _statusFilter = 'Tất cả'),
                  ),
                  ChoiceChip(
                    label: const Text('Đúng giờ'),
                    selected: _statusFilter == 'Đúng giờ',
                    onSelected: (_) =>
                        setState(() => _statusFilter = 'Đúng giờ'),
                  ),
                  ChoiceChip(
                    label: const Text('Muộn'),
                    selected: _statusFilter == 'Muộn',
                    onSelected: (_) => setState(() => _statusFilter = 'Muộn'),
                  ),
                  ChoiceChip(
                    label: const Text('Vắng'),
                    selected: _statusFilter == 'Vắng',
                    onSelected: (_) => setState(() => _statusFilter = 'Vắng'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text('Lọc theo môn học',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                children: courses
                    .map((course) => ChoiceChip(
                          label: Text(course),
                          selected: _courseFilter == course,
                          onSelected: (_) =>
                              setState(() => _courseFilter = course),
                        ))
                    .toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAttendanceDetailModal(
      BuildContext context, AttendanceHistoryModel attendance) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: (attendance.isPresent
                                ? colorScheme.primary
                                : colorScheme.error)
                            .withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        attendance.isPresent
                            ? Icons.check_circle
                            : Icons.cancel,
                        color: attendance.isPresent
                            ? colorScheme.primary
                            : colorScheme.error,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        attendance.scheduleDetail.courseName,
                        style: theme.textTheme.titleLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildDetailRow(
                    Icons.class_, 'Lớp', attendance.scheduleDetail.className),
                _buildDetailRow(Icons.meeting_room, 'Phòng',
                    attendance.scheduleDetail.room),
                _buildDetailRow(Icons.person, 'Giáo viên',
                    attendance.scheduleDetail.teacherName),
                _buildDetailRow(Icons.schedule, 'Thời gian học',
                    '${DateFormat('HH:mm dd/MM/yyyy').format(attendance.scheduleDetail.startTime)} - ${DateFormat('HH:mm').format(attendance.scheduleDetail.endTime)}'),
                _buildDetailRow(
                    Icons.access_time,
                    'Thời gian điểm danh',
                    DateFormat('HH:mm dd/MM/yyyy')
                        .format(attendance.timestamp)),
                if (attendance.isLate &&
                    attendance.minutesLate != null &&
                    attendance.minutesLate! > 0)
                  _buildDetailRow(Icons.timer_off, 'Số phút muộn',
                      '${attendance.minutesLate} phút',
                      color: Colors.orange),
                _buildDetailRow(Icons.info_outline, 'Trạng thái',
                    attendance.attendanceStatus),
                if (attendance.location != null &&
                    attendance.location!.isNotEmpty)
                  _buildDetailRow(
                      Icons.location_on, 'Vị trí', attendance.location!),
                if (attendance.deviceInfo.isNotEmpty)
                  _buildDetailRow(
                      Icons.devices, 'Thiết bị', attendance.deviceInfo),
                const SizedBox(height: 16),
                Center(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.close),
                    label: const Text('Đóng'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value,
      {Color? color}) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: color ?? theme.colorScheme.primary),
          const SizedBox(width: 10),
          Text('$label: ',
              style: theme.textTheme.bodyMedium
                  ?.copyWith(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value, style: theme.textTheme.bodyMedium)),
        ],
      ),
    );
  }
}

class _AttendanceDetailItem extends StatelessWidget {
  final AttendanceHistoryModel attendance;
  const _AttendanceDetailItem({required this.attendance});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final statusColor =
        attendance.isPresent ? colorScheme.primary : colorScheme.error;
    final lateColor = attendance.isLate ? Colors.orange : colorScheme.primary;
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    attendance.isPresent ? Icons.check_circle : Icons.cancel,
                    color: statusColor,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    attendance.scheduleDetail.courseName,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: lateColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    attendance.isLate ? 'Điểm danh muộn' : 'Đúng giờ',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: lateColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.class_, size: 18, color: colorScheme.primary),
                const SizedBox(width: 6),
                Text(attendance.scheduleDetail.className,
                    style: theme.textTheme.bodyMedium),
                const SizedBox(width: 16),
                Icon(Icons.meeting_room, size: 18, color: colorScheme.primary),
                const SizedBox(width: 6),
                Text(attendance.scheduleDetail.room,
                    style: theme.textTheme.bodyMedium),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.person, size: 18, color: colorScheme.primary),
                const SizedBox(width: 6),
                Text(attendance.scheduleDetail.teacherName,
                    style: theme.textTheme.bodyMedium),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.schedule, size: 18, color: colorScheme.primary),
                const SizedBox(width: 6),
                Text(
                  'Buổi học: ${DateFormat('HH:mm dd/MM/yyyy').format(attendance.scheduleDetail.startTime)} - ${DateFormat('HH:mm').format(attendance.scheduleDetail.endTime)}',
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.access_time, size: 18, color: colorScheme.primary),
                const SizedBox(width: 6),
                Text(
                  'Điểm danh: ${DateFormat('HH:mm dd/MM/yyyy').format(attendance.timestamp)}',
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (attendance.isLate &&
                attendance.minutesLate != null &&
                attendance.minutesLate! > 0)
              Row(
                children: [
                  const Icon(Icons.timer_off, size: 18, color: Colors.orange),
                  const SizedBox(width: 6),
                  Text('Muộn ${attendance.minutesLate} phút',
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(color: Colors.orange)),
                ],
              ),
            if (attendance.location != null && attendance.location!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  children: [
                    Icon(Icons.location_on,
                        size: 18, color: colorScheme.primary),
                    const SizedBox(width: 6),
                    Expanded(
                        child: Text(attendance.location!,
                            style: theme.textTheme.bodyMedium)),
                  ],
                ),
              ),
            if (attendance.deviceInfo.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  children: [
                    Icon(Icons.devices, size: 18, color: colorScheme.primary),
                    const SizedBox(width: 6),
                    Expanded(
                        child: Text(attendance.deviceInfo,
                            style: theme.textTheme.bodyMedium)),
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                children: [
                  Icon(Icons.info_outline,
                      size: 18, color: colorScheme.primary),
                  const SizedBox(width: 6),
                  Text(attendance.attendanceStatus,
                      style: theme.textTheme.bodyMedium),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
