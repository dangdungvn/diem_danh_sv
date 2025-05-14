// Model cho dữ liệu QR điểm danh
import 'dart:convert';

class QrAttendanceModel {
  final int scheduleId;
  final String courseName;
  final String teacher;
  final String className;
  final String room;
  final int lessonStart;
  final int lessonCount;
  final String startTime;
  final String endTime;
  final String rawData;

  QrAttendanceModel({
    required this.scheduleId,
    required this.courseName,
    required this.teacher,
    required this.className,
    required this.room,
    required this.lessonStart,
    required this.lessonCount,
    required this.startTime,
    required this.endTime,
    required this.rawData,
  });
  factory QrAttendanceModel.fromRawData(String rawData) {
    String cleanedData = rawData.trim();
    // Để parse trong code, thay nháy đơn bằng nháy kép
    String parseableData = cleanedData.replaceAll("'", "\"");

    print('Cleaned QR data: $cleanedData');
    print('Parseable QR data: $parseableData');

    try {
      // Parse bằng phiên bản với nháy kép
      final Map<String, dynamic> data = json.decode(parseableData);
      return QrAttendanceModel(
        scheduleId: data['schedule_id'] ?? 0,
        courseName: data['course_name'] ?? '',
        teacher: data['teacher'] ?? '',
        className: data['class_name'] ?? '',
        room: data['room'] ?? '',
        lessonStart: data['lesson_start'] ?? 0,
        lessonCount: data['lesson_count'] ?? 0,
        startTime: data['start_time'] ?? '',
        endTime: data['end_time'] ?? '',
        rawData:
            cleanedData, // Giữ nguyên chuỗi gốc với nháy đơn để gửi lên server
      );
    } catch (e) {
      print('Lỗi khi parse dữ liệu QR: $e');
      print('Dữ liệu QR gốc: $rawData');
      print('Dữ liệu QR đã xử lý: $cleanedData');
      throw Exception('Dữ liệu QR không hợp lệ. Chi tiết lỗi: $e');
    }
  }

  factory QrAttendanceModel.fromJson(Map<String, dynamic> json) {
    return QrAttendanceModel(
      scheduleId: json['schedule_id'] ?? 0,
      courseName: json['course_name'] ?? '',
      teacher: json['teacher'] ?? '',
      className: json['class_name'] ?? '',
      room: json['room'] ?? '',
      lessonStart: json['lesson_start'] ?? 0,
      lessonCount: json['lesson_count'] ?? 0,
      startTime: json['start_time'] ?? '',
      endTime: json['end_time'] ?? '',
      rawData: json.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'schedule_id': scheduleId,
        'course_name': courseName,
        'teacher': teacher,
        'class_name': className,
        'room': room,
        'lesson_start': lessonStart,
        'lesson_count': lessonCount,
        'start_time': startTime,
        'end_time': endTime,
      };
}

class QrAttendanceResponseModel {
  final bool success;
  final String message;
  final Map<String, dynamic>? data;

  QrAttendanceResponseModel({
    required this.success,
    required this.message,
    this.data,
  });
  factory QrAttendanceResponseModel.fromJson(Map<String, dynamic> json) {
    // Xử lý cả 2 format response:
    // Format 1: {"success": true, "message": "...", "data": {...}}
    // Format 2: {"status": "success", "message": "...", "attendance": {...}}
    final bool isSuccess =
        json['success'] == true || json['status'] == 'success';

    return QrAttendanceResponseModel(
      success: isSuccess,
      message: json['message'] ?? 'Không có thông tin',
      data: json['data'] ?? json['attendance'],
    );
  }
}
