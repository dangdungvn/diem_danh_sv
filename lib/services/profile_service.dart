import 'dart:io';
import 'package:diem_danh_sv/models/profile_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/user_model.dart';

class ProfileService {
  final Dio _dio = Dio();
  late final String _baseUrl;

  ProfileService() {
    _baseUrl = dotenv.env['API_URL'] ??
        'http://34.143.254.122'; // Lấy URL từ .env hoặc dùng giá trị mặc định
  }

  // Lấy thông tin người dùng hiện tại
  Future<User> getCurrentUser(String token) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/api/users/me/',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> userData = response.data;

        // Fix: Kiểm tra và sửa URL avatar nếu cần
        if (userData['avatar_url'] != null &&
            userData['avatar_url'].isNotEmpty) {
          // Kiểm tra xem avatarUrl đã có http:// hoặc https:// chưa
          String avatarUrl = userData['avatar_url'];
          if (!avatarUrl.startsWith('http://') &&
              !avatarUrl.startsWith('https://')) {
            // Nếu là đường dẫn tương đối, thêm baseUrl
            userData['avatar_url'] =
                '$_baseUrl${avatarUrl.startsWith('/') ? '' : '/'}$avatarUrl';
          }

          // Đảm bảo chuỗi truy vấn có mốc thời gian để tránh cache
          if (!userData['avatar_url'].contains('?')) {
            userData['avatar_url'] =
                '${userData['avatar_url']}?t=${DateTime.now().millisecondsSinceEpoch}';
          } else {
            userData['avatar_url'] =
                '${userData['avatar_url']}&t=${DateTime.now().millisecondsSinceEpoch}';
          }
        }

        return User.fromJson(userData);
      } else {
        throw Exception('Không thể lấy thông tin người dùng');
      }
    } catch (e) {
      throw Exception('Đã xảy ra lỗi: $e');
    }
  }

  Future<ProfileModel> getCurrentUserInfo(String token) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/api/user-info/',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> userData = response.data;

        // Fix: Kiểm tra và sửa URL avatar nếu cần
        if (userData['avatar_url'] != null &&
            userData['avatar_url'].isNotEmpty) {
          // Kiểm tra xem avatarUrl đã có http:// hoặc https:// chưa
          String avatarUrl = userData['avatar_url'];
          if (!avatarUrl.startsWith('http://') &&
              !avatarUrl.startsWith('https://')) {
            // Nếu là đường dẫn tương đối, thêm baseUrl
            userData['avatar_url'] =
                '$_baseUrl${avatarUrl.startsWith('/') ? '' : '/'}$avatarUrl';
          }

          // Đảm bảo chuỗi truy vấn có mốc thời gian để tránh cache
          if (!userData['avatar_url'].contains('?')) {
            userData['avatar_url'] =
                '${userData['avatar_url']}?t=${DateTime.now().millisecondsSinceEpoch}';
          } else {
            userData['avatar_url'] =
                '${userData['avatar_url']}&t=${DateTime.now().millisecondsSinceEpoch}';
          }
        }

        return ProfileModel.fromJson(userData);
      } else {
        throw Exception('Không thể lấy thông tin người dùng');
      }
    } catch (e) {
      throw Exception('Đã xảy ra lỗi: $e');
    }
  }

  // Cập nhật thông tin cá nhân
  Future<User> updateProfile(
      String token, Map<String, dynamic> profileData) async {
    try {
      final response = await _dio.patch(
        '$_baseUrl/api/users/update-profile/',
        data: profileData,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> userData = response.data;

        // Fix: Kiểm tra và sửa URL avatar nếu cần
        if (userData['avatar_url'] != null &&
            userData['avatar_url'].isNotEmpty) {
          String avatarUrl = userData['avatar_url'];
          if (!avatarUrl.startsWith('http://') &&
              !avatarUrl.startsWith('https://')) {
            userData['avatar_url'] =
                '$_baseUrl${avatarUrl.startsWith('/') ? '' : '/'}$avatarUrl';
          }

          // Đảm bảo chuỗi truy vấn có mốc thời gian để tránh cache
          if (!userData['avatar_url'].contains('?')) {
            userData['avatar_url'] =
                '${userData['avatar_url']}?t=${DateTime.now().millisecondsSinceEpoch}';
          } else {
            userData['avatar_url'] =
                '${userData['avatar_url']}&t=${DateTime.now().millisecondsSinceEpoch}';
          }
        }

        return User.fromJson(userData);
      } else {
        throw Exception('Không thể cập nhật thông tin người dùng');
      }
    } catch (e) {
      throw Exception('Đã xảy ra lỗi khi cập nhật thông tin: $e');
    }
  }

  // Tải lên avatar
  Future<User> uploadAvatar(String token, File avatarFile) async {
    try {
      String fileName = avatarFile.path.split('/').last;
      FormData formData = FormData.fromMap({
        'avatar': await MultipartFile.fromFile(
          avatarFile.path,
          filename: fileName,
        ),
      });

      final response = await _dio.post(
        '$_baseUrl/api/users/upload-avatar/',
        data: formData,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> userData = response.data;

        // Fix: Kiểm tra và sửa URL avatar nếu cần
        if (userData['avatar_url'] != null &&
            userData['avatar_url'].isNotEmpty) {
          String avatarUrl = userData['avatar_url'];
          if (!avatarUrl.startsWith('http://') &&
              !avatarUrl.startsWith('https://')) {
            userData['avatar_url'] =
                '$_baseUrl${avatarUrl.startsWith('/') ? '' : '/'}$avatarUrl';
          }

          // Đảm bảo chuỗi truy vấn có mốc thời gian để tránh cache
          if (!userData['avatar_url'].contains('?')) {
            userData['avatar_url'] =
                '${userData['avatar_url']}?t=${DateTime.now().millisecondsSinceEpoch}';
          } else {
            userData['avatar_url'] =
                '${userData['avatar_url']}&t=${DateTime.now().millisecondsSinceEpoch}';
          }
        }

        return User.fromJson(userData);
      } else {
        throw Exception('Không thể tải lên avatar');
      }
    } catch (e) {
      throw Exception('Đã xảy ra lỗi khi tải lên avatar: $e');
    }
  }

  // Xóa avatar
  Future<bool> removeAvatar(String token) async {
    try {
      final response = await _dio.delete(
        '$_baseUrl/api/users/remove-avatar/',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      return response.statusCode == 204;
    } catch (e) {
      throw Exception('Đã xảy ra lỗi khi xóa avatar: $e');
    }
  }

  // Đổi mật khẩu
  Future<bool> changePassword(
      String token, String currentPassword, String newPassword) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/api/users/change-password/',
        data: {
          'current_password': currentPassword,
          'new_password': newPassword,
        },
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      return response.statusCode == 200;
    } catch (e) {
      if (e is DioException && e.response?.statusCode == 400) {
        throw Exception('Mật khẩu hiện tại không đúng');
      }
      throw Exception('Đã xảy ra lỗi khi đổi mật khẩu: $e');
    }
  }
}
