import 'package:flutter/material.dart';
import '../controllers/attendance_controller.dart';
import '../models/attendance_history_model.dart';

class AttendanceProvider extends ChangeNotifier {
  final AttendanceController _attendanceController = AttendanceController();
  List<AttendanceHistoryModel> _attendanceHistory = [];
  bool _isLoading = false;
  String? _error;

  List<AttendanceHistoryModel> get attendanceHistory => _attendanceHistory;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Lấy lịch sử điểm danh từ API
  Future<void> fetchAttendanceHistory() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _attendanceHistory = await _attendanceController.getAttendanceHistory();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Lấy danh sách điểm danh gần đây (n phần tử đầu tiên)
  List<AttendanceHistoryModel> getRecentAttendance(int count) {
    final sortedList = List<AttendanceHistoryModel>.from(_attendanceHistory);

    // Sắp xếp theo thời gian gần nhất
    sortedList.sort((a, b) => b.timestamp.compareTo(a.timestamp));

    // Trả về n phần tử đầu tiên hoặc tất cả nếu danh sách nhỏ hơn n
    return sortedList.take(count).toList();
  }

  // Xóa lỗi
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
