import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/auth_model.dart';
import '../models/user_model.dart';

class AuthService {
  final Dio _dio = Dio();
  late final String _baseUrl;

  AuthService() {
    _baseUrl = dotenv.env['API_URL'] ??
        'http://34.143.254.122'; // Lấy URL từ .env hoặc dùng giá trị mặc định
  }

  // Đăng nhập
  Future<AuthModel> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/auth/jwt/create/',
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        return AuthModel.fromJson(response.data);
      } else {
        throw Exception('Đăng nhập thất bại');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Email hoặc mật khẩu không đúng');
      }
      throw Exception('Lỗi kết nối: ${e.message}');
    } catch (e) {
      throw Exception('Đã xảy ra lỗi: $e');
    }
  }

  // Lấy thông tin người dùng
  Future<User> getUserInfo(String token) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/api/users/me/',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200) {
        return User.fromJson(response.data);
      } else {
        throw Exception('Không thể lấy thông tin người dùng');
      }
    } on DioException catch (e) {
      throw Exception('Lỗi lấy thông tin người dùng: ${e.message}');
    } catch (e) {
      throw Exception('Đã xảy ra lỗi: $e');
    }
  }

  // Làm mới token
  Future<AuthModel> refreshToken(String refreshToken) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/auth/jwt/refresh/',
        data: {
          'refresh': refreshToken,
        },
      );

      if (response.statusCode == 200) {
        return AuthModel.fromJson(response.data);
      } else {
        throw Exception('Không thể làm mới token');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Refresh token hết hạn hoặc không hợp lệ');
      }
      throw Exception('Lỗi kết nối: ${e.message}');
    } catch (e) {
      throw Exception('Đã xảy ra lỗi: $e');
    }
  }
}
