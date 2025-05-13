import 'package:flutter/material.dart';
import '../models/class_model.dart';
import '../services/class_service.dart';

enum ClassLoadingStatus { initial, loading, loaded, error }

class ClassProvider extends ChangeNotifier {
  final ClassService _classService = ClassService();
  List<ClassModel> _classes = [];
  ClassLoadingStatus _status = ClassLoadingStatus.initial;
  String _errorMessage = '';

  List<ClassModel> get classes => _classes;
  ClassLoadingStatus get status => _status;
  String get errorMessage => _errorMessage;

  Future<void> fetchMyClasses() async {
    try {
      _status = ClassLoadingStatus.loading;
      notifyListeners();

      _classes = await _classService.getMyClasses();
      _status = ClassLoadingStatus.loaded;
    } catch (e) {
      _status = ClassLoadingStatus.error;
      _errorMessage = e.toString();
    } finally {
      notifyListeners();
    }
  }
}
