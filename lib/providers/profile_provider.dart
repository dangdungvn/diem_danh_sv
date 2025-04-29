import 'dart:io';
import 'package:flutter/material.dart';
import '../controllers/profile_controller.dart';
import '../models/user_model.dart';

class ProfileProvider extends ChangeNotifier {
  final ProfileController _profileController = ProfileController();
  User? _user;
  bool _isLoading = false;
  String? _error;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Lấy thông tin người dùng từ API
  Future<void> fetchUserProfile() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _user = await _profileController.getUserProfile();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Cập nhật thông tin profile
  Future<bool> updateProfile({
    String? name,
    String? phoneNumber,
    String? address,
    String? dateOfBirth,
    String? gender,
    String? bio,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _user = await _profileController.updateProfile(
        name: name,
        phoneNumber: phoneNumber,
        address: address,
        dateOfBirth: dateOfBirth,
        gender: gender,
        bio: bio,
      );
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Tải lên avatar mới
  Future<bool> uploadAvatar(File imageFile) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _user = await _profileController.uploadAvatar(imageFile);
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Xóa avatar
  Future<bool> removeAvatar() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final success = await _profileController.removeAvatar();
      if (success) {
        await fetchUserProfile(); // Cập nhật lại thông tin user
      }
      return success;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Đổi mật khẩu
  Future<bool> changePassword(
      String currentPassword, String newPassword) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final success = await _profileController.changePassword(
        currentPassword,
        newPassword,
      );
      return success;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Xóa lỗi
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
