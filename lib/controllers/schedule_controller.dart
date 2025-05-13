import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/schedule_model.dart';
import '../services/schedule_service.dart';

class ScheduleController {
  final ScheduleService _scheduleService = ScheduleService();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // Get student schedule
  Future<List<ScheduleModel>> getStudentSchedule() async {
    try {
      final token = await _secureStorage.read(key: 'access_token');

      if (token == null) {
        throw Exception('Authentication token not found');
      }

      return await _scheduleService.getStudentSchedule(token);
    } catch (e) {
      throw Exception('Failed to get schedule: $e');
    }
  }

  // Get schedule for a specific date range
  Future<List<ScheduleModel>> getScheduleByDateRange(
      DateTime startDate, DateTime endDate) async {
    try {
      final token = await _secureStorage.read(key: 'access_token');

      if (token == null) {
        throw Exception('Authentication token not found');
      }

      return await _scheduleService.getScheduleByDateRange(
          token, startDate, endDate);
    } catch (e) {
      throw Exception('Failed to get schedule: $e');
    }
  }
}
