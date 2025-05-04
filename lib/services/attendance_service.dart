import 'package:diem_danh_sv/models/attendance_history_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AttendanceService {
  final Dio _dio = Dio();
  late final String _baseUrl;

  AttendanceService() {
    _baseUrl = dotenv.env['API_URL'] ??
        'http://34.142.233.245'; // Lấy URL từ .env hoặc dùng giá trị mặc định
  }

  // Lấy lịch sử điểm danh
  Future<List<AttendanceHistoryModel>> getAttendanceHistory(
      String token) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/api/attendance/',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200) {
        if (response.data is List) {
          return (response.data as List)
              .map((item) => AttendanceHistoryModel.fromJson(item))
              .toList();
        } else {
          final List<dynamic> results = response.data['results'] ?? [];
          return results
              .map((item) => AttendanceHistoryModel.fromJson(item))
              .toList();
        }
      } else {
        throw Exception('Không thể lấy lịch sử điểm danh');
      }
    } catch (e) {
      throw Exception('Đã xảy ra lỗi khi lấy lịch sử điểm danh: $e');
    }
  }
}
