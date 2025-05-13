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
    print('DEBUG accessToken: '
        '[32m$accessToken[0m'); // In ra accessToken khi kiểm tra
    if (accessToken == null) return false;
    if (accessToken.trim().isEmpty) return false;
    // Có thể kiểm tra thêm: accessToken có đúng định dạng JWT không?
    return true;
  }

  // Phương thức đăng xuất
  Future<void> logout() async {
    await _storage.delete(key: 'access_token');
    await _storage.delete(key: 'refresh_token');
    await _storage.delete(key: 'user_info');
    await _storage.delete(key: 'user_info_current');
    // Xóa tất cả dữ liệu trong secure storage
  }

  // Phương thức xóa access token
  Future<void> clearAccessToken() async {
    await _storage.delete(key: 'access_token');
    print('Access token đã được xóa');
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

  // Phương thức làm mới access token khi khởi động app
  Future<bool> refreshAccessToken() async {
    try {
      final refreshToken = await _storage.read(key: 'refresh_token');

      // Nếu không có refresh token thì không thể làm mới
      if (refreshToken == null || refreshToken.isEmpty) {
        print('Không có refresh token để làm mới phiên đăng nhập');
        await clearAccessToken(); // Đảm bảo xóa access token nếu không có refresh token
        return false;
      }

      // Gọi API để làm mới token
      final AuthModel newAuth = await _authService.refreshToken(refreshToken);

      // Kiểm tra accessToken mới có tồn tại không
      if (newAuth.accessToken.isEmpty) {
        print('Access token mới không hợp lệ');
        await clearAccessToken();
        return false;
      }

      // Lưu access token mới vào secure storage
      await _storage.write(key: 'access_token', value: newAuth.accessToken);

      try {
        // Cập nhật thông tin người dùng nếu cần
        final User user = await _authService.getUserInfo(newAuth.accessToken);
        await _storage.write(
            key: 'user_info', value: jsonEncode(user.toJson()));
      } catch (userError) {
        print('Không thể lấy thông tin người dùng: $userError');
        // Tiếp tục vì đã có access token mới
      }

      print('Access token đã được làm mới thành công');
      return true;
    } catch (e) {
      print('Lỗi khi làm mới access token: $e');
      // Xóa token cũ nếu refresh thất bại
      await clearAccessToken();
      return false;
    }
  }
}
