import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/attendance_history_model.dart';
import '../services/attendance_service.dart';
import '../controllers/auth_controller.dart';

class AttendanceController {
  final AttendanceService _attendanceService = AttendanceService();
  final AuthController _authController = AuthController();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Lấy lịch sử điểm danh từ API
  Future<List<AttendanceHistoryModel>> getAttendanceHistory() async {
    try {
      final token = await _authController.getAccessToken();

      if (token == null) {
        return [];
      }

      final attendanceList =
          await _attendanceService.getAttendanceHistory(token);

      // Lưu vào cache
      await _storage.write(
          key: 'attendance_history',
          value: json
              .encode(attendanceList.map((item) => item.toJson()).toList()));

      return attendanceList;
    } catch (e) {
      print('Lỗi lấy lịch sử điểm danh: $e');

      // Thử lấy từ cache nếu có lỗi
      final cachedData = await _storage.read(key: 'attendance_history');
      if (cachedData != null && cachedData.isNotEmpty) {
        try {
          final List<dynamic> decoded = json.decode(cachedData);
          return decoded
              .map((item) => AttendanceHistoryModel.fromJson(item))
              .toList();
        } catch (e) {
          print('Lỗi parse dữ liệu cache: $e');
          return [];
        }
      }

      return [];
    }
  }
}
