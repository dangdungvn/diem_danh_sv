import 'package:flutter/material.dart';
import '../controllers/schedule_controller.dart';
import '../models/schedule_model.dart';

class ScheduleProvider extends ChangeNotifier {
  final ScheduleController _scheduleController = ScheduleController();

  List<ScheduleModel> _schedules = [];
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;
  String? _error;

  // Getters
  List<ScheduleModel> get schedules => _schedules;
  DateTime get selectedDate => _selectedDate;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Set selected date
  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  // Get student schedule
  Future<void> fetchStudentSchedule() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _schedules = await _scheduleController.getStudentSchedule();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get schedule for a specific date range
  Future<void> fetchScheduleByDateRange(
      DateTime startDate, DateTime endDate) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _schedules =
          await _scheduleController.getScheduleByDateRange(startDate, endDate);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get schedules for a specific day (1-7, where 1 is Monday)
  List<ScheduleModel> getSchedulesForDay(int weekday) {
    return _schedules
        .where((schedule) => schedule.isOnWeekday(weekday))
        .toList();
  }

  // Get schedules for a specific date
  List<ScheduleModel> getSchedulesForDate(DateTime date) {
    return _schedules.where((schedule) => schedule.isOnDate(date)).toList();
  }

  // Get schedules for current selected date
  List<ScheduleModel> getSchedulesForSelectedDate() {
    return getSchedulesForDate(_selectedDate);
  }

  // Clear error message
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
