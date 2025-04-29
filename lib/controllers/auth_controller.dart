import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import '../services/auth_service.dart';
import '../models/auth_model.dart';
import '../models/user_model.dart';

class AuthController {
  final AuthService _authService = AuthService();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Phương thức đăng nhập
  Future<bool> login(String email, String password) async {
    try {
      final AuthModel auth = await _authService.login(email, password);

      // Lưu token vào secure storage
      await _storage.write(key: 'access_token', value: auth.accessToken);
      await _storage.write(key: 'refresh_token', value: auth.refreshToken);

      // Lấy thông tin người dùng
      final User user = await _authService.getUserInfo(auth.accessToken);

      // Lưu thông tin người dùng
      await _storage.write(key: 'user_info', value: user.toJson().toString());

      return true;
    } catch (e) {
      print('Lỗi đăng nhập: $e');
      return false;
    }
  }

  // Phương thức kiểm tra đã đăng nhập chưa
  Future<bool> isLoggedIn() async {
    final accessToken = await _storage.read(key: 'access_token');
    return accessToken != null && accessToken.isNotEmpty;
  }

  // Phương thức đăng xuất
  Future<void> logout() async {
    await _storage.delete(key: 'access_token');
    await _storage.delete(key: 'refresh_token');
    await _storage.delete(key: 'user_info');
  }

  // Phương thức lấy token
  Future<String?> getAccessToken() async {
    return await _storage.read(key: 'access_token');
  }

  // Phương thức lấy thông tin người dùng đã lưu
  Future<User?> getUserInfo() async {
    final userInfoString = await _storage.read(key: 'user_info');
    if (userInfoString != null && userInfoString.isNotEmpty) {
      try {
        // Chuyển đổi chuỗi JSON thành Map
        final Map<String, dynamic> userMap = json.decode(userInfoString);
        // Tạo đối tượng User từ Map
        return User.fromJson(userMap);
      } catch (e) {
        print('Lỗi parse thông tin người dùng: $e');
        return null;
      }
    }
    return null;
  }
}
