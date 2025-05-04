import 'package:diem_danh_sv/models/profile_model.dart';
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

      // Lưu thông tin người dùng dưới dạng JSON string
      await _storage.write(key: 'user_info', value: jsonEncode(user.toJson()));

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
    await _storage.delete(key: 'user_info_current');
    // Xóa tất cả dữ liệu trong secure storage
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

  Future<ProfileModel?> getUserInfoCurrent() async {
    final userInfoString = await _storage.read(key: 'user_info_current');
    if (userInfoString != null && userInfoString.isNotEmpty) {
      try {
        // Chuyển đổi chuỗi JSON thành Map
        final Map<String, dynamic> userMap = json.decode(userInfoString);
        // Tạo đối tượng ProfileModel từ Map
        return ProfileModel.fromJson(userMap);
      } catch (e) {
        print('Lỗi parse thông tin người dùng: $e');
        return null;
      }
    }
    return null;
  }
}
