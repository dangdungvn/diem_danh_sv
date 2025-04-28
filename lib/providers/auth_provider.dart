import 'package:flutter/foundation.dart';
import '../controllers/auth_controller.dart';
import '../models/user_model.dart';

class AuthProvider with ChangeNotifier {
  final AuthController _authController = AuthController();
  bool _isLoggedIn = false;
  bool _isLoading = false;
  String? _error;
  User? _user;

  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
  String? get error => _error;
  User? get user => _user;

  AuthProvider() {
    // Kiểm tra trạng thái đăng nhập khi khởi tạo
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    _isLoading = true;
    notifyListeners();

    try {
      _isLoggedIn = await _authController.isLoggedIn();
      if (_isLoggedIn) {
        _user = await _authController.getUserInfo();
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final success = await _authController.login(email, password);
      _isLoggedIn = success;
      if (success) {
        _user = await _authController.getUserInfo();
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

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _authController.logout();
      _isLoggedIn = false;
      _user = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
