import 'package:diem_danh_sv/models/attendance_history_model.dart';
import 'package:diem_danh_sv/models/qr_attendance_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:io';
import 'dart:convert';

class AttendanceService {
  final Dio _dio = Dio();
  late final String _baseUrl;
  AttendanceService() {
    _baseUrl = dotenv.env['API_URL'] ??
        'http://34.143.254.122'; // Lấy URL từ .env hoặc dùng giá trị mặc định
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
        try {
          if (response.data is List) {
            final List<dynamic> dataList = response.data;
            // In dữ liệu để debug
            print('Dữ liệu JSON trả về: $dataList');
            return dataList
                .map((item) => AttendanceHistoryModel.fromJson(item))
                .toList();
          } else {
            final List<dynamic> results = response.data['results'] ?? [];
            print('Dữ liệu JSON trả về: $results');
            return results
                .map((item) => AttendanceHistoryModel.fromJson(item))
                .toList();
          }
        } catch (parseError) {
          print('Lỗi khi phân tích dữ liệu JSON: $parseError');
          throw Exception('Lỗi khi xử lý dữ liệu: $parseError');
        }
      } else {
        throw Exception(
            'Không thể lấy lịch sử điểm danh. Mã lỗi: ${response.statusCode}');
      }
    } catch (e) {
      print('Chi tiết lỗi lấy lịch sử điểm danh: $e');
      throw Exception('Đã xảy ra lỗi khi lấy lịch sử điểm danh: $e');
    }
  }

  // Điểm danh bằng mã QR
  Future<QrAttendanceResponseModel> attendanceByQR(String token,
      QrAttendanceModel qrData, Map<String, dynamic> locationData) async {
    try {
      // Đảm bảo gửi đúng định dạng mà API yêu cầu
      final Map<String, dynamic> requestData = {
        'qr_data':
            qrData.rawData, // Sử dụng chuỗi gốc (với nháy đơn) như API yêu cầu
        'schedule': qrData.scheduleId,
        'latitude': locationData['latitude'],
        'longitude': locationData['longitude'],
        'device_info': locationData['device_info'] ?? Platform.operatingSystem,
      };
      print('Gửi yêu cầu điểm danh: $requestData');
      print('JSON của qr_data: ${qrData.rawData}');
      print('Kiểu dữ liệu của qr_data: ${qrData.rawData.runtimeType}');

      // Hiển thị chuỗi JSON cuối cùng để debug
      final formattedJson = json.encode(requestData);
      print('Chuỗi JSON gửi đi: $formattedJson');

      try {
        final response = await _dio.post(
          '$_baseUrl/api/attendance/qr-attendance/',
          data: requestData,
          options: Options(
            headers: {'Authorization': 'Bearer $token'},
            validateStatus: (status) =>
                true, // Chấp nhận tất cả status code để xử lý lỗi
          ),
        );
        print('Phản hồi từ server [${response.statusCode}]: ${response.data}');

        if (response.statusCode == 200) {
          final responseData = response.data;
          // Kiểm tra xem response có phải là thành công không
          final bool isSuccess = responseData['success'] == true ||
              responseData['status'] == 'success';

          if (isSuccess) {
            return QrAttendanceResponseModel.fromJson(responseData);
          } else {
            return QrAttendanceResponseModel(
              success: false,
              message: responseData['message'] ?? 'Điểm danh thất bại',
              data: responseData['data'] ?? responseData['attendance'],
            );
          }
        } else {
          String errorMessage =
              'Điểm danh thất bại. Mã lỗi: ${response.statusCode}';
          if (response.data != null && response.data is Map) {
            final responseData = response.data as Map;
            if (responseData.containsKey('non_field_errors') &&
                responseData['non_field_errors'] is List &&
                responseData['non_field_errors'].isNotEmpty) {
              // Xử lý lỗi từ format { "non_field_errors": ["Thông báo lỗi"] }
              errorMessage = responseData['non_field_errors'][0];
            } else if (responseData.containsKey('detail')) {
              errorMessage = responseData['detail'];
            } else if (responseData.containsKey('message')) {
              errorMessage = responseData['message'];
            } else if (responseData.containsKey('error')) {
              errorMessage = responseData['error'];
            }
          }
          print('Chi tiết lỗi: ${response.data}');
          return QrAttendanceResponseModel(
            success: false,
            message: errorMessage,
          );
        }
      } on DioException catch (dioError) {
        // Xử lý riêng cho lỗi Dio
        print('DioException: ${dioError.toString()}');

        // Nếu có response thì xử lý response error
        if (dioError.response != null) {
          var responseData = dioError.response!.data;
          String errorMessage =
              'Điểm danh thất bại. Mã lỗi: ${dioError.response!.statusCode}';

          if (responseData != null && responseData is Map) {
            if (responseData.containsKey('non_field_errors') &&
                responseData['non_field_errors'] is List &&
                responseData['non_field_errors'].isNotEmpty) {
              errorMessage = responseData['non_field_errors'][0];
            } else if (responseData.containsKey('detail')) {
              errorMessage = responseData['detail'];
            } else if (responseData.containsKey('message')) {
              errorMessage = responseData['message'];
            } else if (responseData.containsKey('error')) {
              errorMessage = responseData['error'];
            }
          }

          print('Chi tiết lỗi: $responseData');
          return QrAttendanceResponseModel(
            success: false,
            message: errorMessage,
          );
        }

        return QrAttendanceResponseModel(
          success: false,
          message: 'Lỗi kết nối đến máy chủ: ${dioError.message}',
        );
      }
    } catch (e) {
      print('Lỗi khi điểm danh: $e');
      return QrAttendanceResponseModel(
        success: false,
        message: 'Đã xảy ra lỗi khi điểm danh: ${e.toString()}',
      );
    }
  }

  // Lấy thông tin chi tiết buổi học theo ID
  Future<Map<String, dynamic>> getScheduleDetails(
      String token, int scheduleId) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/api/core/schedules/$scheduleId/',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Không thể lấy thông tin buổi học');
      }
    } catch (e) {
      throw Exception('Đã xảy ra lỗi khi lấy thông tin buổi học: $e');
    }
  }
}
