import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/schedule_model.dart';

class ScheduleService {
  final Dio _dio = Dio();
  late final String _baseUrl;

  ScheduleService() {
    _baseUrl = dotenv.env['API_URL'] ??
        'http://34.143.254.122'; // Get URL from .env or use default value
  }

  // Fetch student schedule
  Future<List<ScheduleModel>> getStudentSchedule(String token) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/api/core/schedules/student_schedule/',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> scheduleData = response.data;
        return scheduleData
            .map((json) => ScheduleModel.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to load schedule');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Authentication error. Please log in again.');
      }
      throw Exception('Connection error: ${e.message}');
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }

  // Fetch schedule for a specific date range
  Future<List<ScheduleModel>> getScheduleByDateRange(
      String token, DateTime startDate, DateTime endDate) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/api/core/schedules/student_schedule/',
        queryParameters: {
          'start_date': startDate.toIso8601String().split('T')[0],
          'end_date': endDate.toIso8601String().split('T')[0],
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> scheduleData = response.data;
        return scheduleData
            .map((json) => ScheduleModel.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to load schedule for specified date range');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Authentication error. Please log in again.');
      }
      throw Exception('Connection error: ${e.message}');
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }
}
