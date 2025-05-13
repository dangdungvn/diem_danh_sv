import 'package:flutter/material.dart';
import 'package:diem_danh_sv/models/qr_attendance_model.dart';
import 'package:diem_danh_sv/services/attendance_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class QrAttendanceResultPage extends StatefulWidget {
  final QrAttendanceResponseModel result;
  final int scheduleId;

  const QrAttendanceResultPage({
    Key? key,
    required this.result,
    required this.scheduleId,
  }) : super(key: key);

  @override
  State<QrAttendanceResultPage> createState() => _QrAttendanceResultPageState();
}

class _QrAttendanceResultPageState extends State<QrAttendanceResultPage> {
  final AttendanceService _attendanceService = AttendanceService();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  Map<String, dynamic>? scheduleDetails;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadScheduleDetails();
  }

  Future<void> _loadScheduleDetails() async {
    try {
      final token = await _secureStorage.read(key: 'access_token');
      if (token == null) {
        throw Exception('Bạn chưa đăng nhập');
      }

      final details =
          await _attendanceService.getScheduleDetails(token, widget.scheduleId);
      setState(() {
        scheduleDetails = details;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Không thể tải thông tin buổi học: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kết quả điểm danh'),
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildResultCard(),
            const SizedBox(height: 20),
            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else if (scheduleDetails != null)
              _buildScheduleDetailsCard()
            else
              const Center(
                child: Text('Không thể tải thông tin buổi học'),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Trở về trang chủ'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(
              widget.result.success ? Icons.check_circle : Icons.error,
              color: widget.result.success ? Colors.green : Colors.red,
              size: 80,
            ),
            const SizedBox(height: 16),
            Text(
              widget.result.success
                  ? 'Điểm danh thành công!'
                  : 'Điểm danh thất bại!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: widget.result.success ? Colors.green : Colors.red,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              widget.result.message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleDetailsCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Thông tin buổi học',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(),
            _buildDetailRow('Môn học', scheduleDetails?['course_name'] ?? ''),
            _buildDetailRow(
                'Giảng viên',
                scheduleDetails?['teacher_name'] ??
                    scheduleDetails?['teacher'] ??
                    ''),
            _buildDetailRow('Lớp', scheduleDetails?['class_name'] ?? ''),
            _buildDetailRow(
                'Phòng',
                scheduleDetails?['room_name'] ??
                    scheduleDetails?['room'] ??
                    ''),
            _buildDetailRow(
              'Thời gian',
              _formatScheduleTime(
                scheduleDetails?['start_time'],
                scheduleDetails?['end_time'],
              ),
            ),
            if (scheduleDetails?['lesson_start'] != null)
              _buildDetailRow(
                'Tiết học',
                'Tiết ${scheduleDetails?['lesson_start']} - ${scheduleDetails?['lesson_start'] + (scheduleDetails?['lesson_count'] ?? 0) - 1}',
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  String _formatScheduleTime(String? startTime, String? endTime) {
    if (startTime == null || endTime == null) {
      return 'Không xác định';
    }

    try {
      final start = DateTime.parse(startTime);
      final end = DateTime.parse(endTime);
      return '${start.hour}:${start.minute.toString().padLeft(2, '0')} - ${end.hour}:${end.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return '$startTime - $endTime';
    }
  }
}
