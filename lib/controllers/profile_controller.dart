import 'dart:io';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/profile_service.dart';
import '../controllers/auth_controller.dart';
import '../models/user_model.dart';

class ProfileController {
  final ProfileService _profileService = ProfileService();
  final AuthController _authController = AuthController();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Lấy thông tin người dùng từ API
  Future<User?> getUserProfile() async {
    try {
      final token = await _authController.getAccessToken();

      if (token == null) {
        return null;
      }

      final user = await _profileService.getCurrentUser(token);

      // Cập nhật thông tin trong storage
      await _storage.write(key: 'user_info', value: json.encode(user.toJson()));

      return user;
    } catch (e) {
      print('Lỗi lấy thông tin profile: $e');
      // Nếu có lỗi, thử lấy từ bộ nhớ đệm
      return await _authController.getUserInfo();
    }
  }

  // Cập nhật thông tin cá nhân
  Future<User?> updateProfile({
    String? name,
    String? phoneNumber,
    String? address,
    String? dateOfBirth,
    String? gender,
    String? bio,
  }) async {
    try {
      final token = await _authController.getAccessToken();

      if (token == null) {
        return null;
      }

      // Tạo Map dữ liệu cần cập nhật
      final Map<String, dynamic> updateData = {};

      if (name != null) updateData['name'] = name;
      if (phoneNumber != null) updateData['phone_number'] = phoneNumber;
      if (address != null) updateData['address'] = address;
      if (dateOfBirth != null) updateData['date_of_birth'] = dateOfBirth;
      if (gender != null) updateData['gender'] = gender;
      if (bio != null) updateData['bio'] = bio;

      // Nếu không có dữ liệu để cập nhật
      if (updateData.isEmpty) {
        return await getUserProfile();
      }

      // Gọi API cập nhật
      final updatedUser =
          await _profileService.updateProfile(token, updateData);

      // Lưu thông tin mới vào storage
      await _storage.write(
          key: 'user_info', value: json.encode(updatedUser.toJson()));

      return updatedUser;
    } catch (e) {
      print('Lỗi cập nhật profile: $e');
      throw Exception('Cập nhật thông tin cá nhân thất bại: $e');
    }
  }

  // Tải lên ảnh đại diện
  Future<User?> uploadAvatar(File avatarFile) async {
    try {
      final token = await _authController.getAccessToken();

      if (token == null) {
        return null;
      }

      // Gọi API upload avatar
      final updatedUser = await _profileService.uploadAvatar(token, avatarFile);

      // Lưu thông tin mới vào storage
      await _storage.write(
          key: 'user_info', value: json.encode(updatedUser.toJson()));

      return updatedUser;
    } catch (e) {
      print('Lỗi upload avatar: $e');
      throw Exception('Tải lên ảnh đại diện thất bại: $e');
    }
  }

  // Xóa ảnh đại diện
  Future<bool> removeAvatar() async {
    try {
      final token = await _authController.getAccessToken();

      if (token == null) {
        return false;
      }

      // Gọi API xóa avatar
      final success = await _profileService.removeAvatar(token);

      if (success) {
        // Cập nhật lại thông tin người dùng từ API
        final updatedUser = await _profileService.getCurrentUser(token);
        await _storage.write(
            key: 'user_info', value: json.encode(updatedUser.toJson()));
      }

      return success;
    } catch (e) {
      print('Lỗi xóa avatar: $e');
      throw Exception('Xóa ảnh đại diện thất bại: $e');
    }
  }

  // Đổi mật khẩu
  Future<bool> changePassword(
      String currentPassword, String newPassword) async {
    try {
      final token = await _authController.getAccessToken();

      if (token == null) {
        return false;
      }

      return await _profileService.changePassword(
          token, currentPassword, newPassword);
    } catch (e) {
      print('Lỗi đổi mật khẩu: $e');
      throw Exception('$e');
    }
  }
}
