import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class ScheduleModel {
  final int id;
  final int teacher;
  final String courseName;
  final int room;
  final String className;
  final int lessonStart;
  final int lessonCount;
  final DateTime startTime;
  final DateTime endTime;
  final List<int> weekdays;
  final DateTime startDate;
  final DateTime endDate;
  final bool isActive;
  final String teacherName;
  final String roomName;

  ScheduleModel({
    required this.id,
    required this.teacher,
    required this.courseName,
    required this.room,
    required this.className,
    required this.lessonStart,
    required this.lessonCount,
    required this.startTime,
    required this.endTime,
    required this.weekdays,
    required this.startDate,
    required this.endDate,
    required this.isActive,
    required this.teacherName,
    required this.roomName,
  });

  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    return ScheduleModel(
      id: json['id'] ?? 0,
      teacher: json['teacher'] ?? 0,
      courseName: json['course_name'] ?? 'Unknown Course',
      room: json['room'] ?? 0,
      className: json['class_name'] ?? 'Unknown Class',
      lessonStart: json['lesson_start'] ?? 0,
      lessonCount: json['lesson_count'] ?? 0,
      startTime: DateTime.parse(json['start_time'] ?? '').toLocal(),
      endTime: DateTime.parse(json['end_time'] ?? '').toLocal(),
      weekdays: List<int>.from(json['weekdays'] ?? []),
      startDate: DateTime.tryParse(json['start_date'] ?? '') ?? DateTime.now(),
      endDate: DateTime.tryParse(json['end_date'] ?? '') ?? DateTime.now(),
      isActive: json['is_active'] ?? false,
      teacherName: json['teacher_name'] ?? 'Unknown Teacher',
      roomName: json['room_name'] ?? 'Unknown Room',
    );
  }

  // Helper method to get formatted time
  String getFormattedTime() {
    final formatter = DateFormat('HH:mm');
    return '${formatter.format(startTime)} - ${formatter.format(endTime)}';
  }

  // Helper method to get lesson information text
  String getLessonInfo() {
    return 'Tiết $lessonStart-${lessonStart + lessonCount - 1}';
  }

  // Method to check if schedule is on a specific weekday (1-7, where 1 is Monday)
  bool isOnWeekday(int weekday) {
    return weekdays.contains(weekday);
  }

  // Helper to check if this schedule occurs on a specific date
  bool isOnDate(DateTime date) {
    // Check if date is within the schedule range and is on a valid weekday
    if (date.isBefore(startDate) || date.isAfter(endDate)) {
      return false;
    }

    // Weekdays in API are 1-7 (Monday to Sunday)
    // DateTime.weekday is also 1-7 (Monday to Sunday)
    return weekdays.contains(date.weekday);
  }

  // Returns lesson type based on some logic (can be customized)
  String getLessonType() {
    // Just an example - you may want to customize this based on your needs
    if (courseName.toLowerCase().contains('thực hành')) {
      return 'Thực hành';
    } else {
      return 'Lý thuyết';
    }
  }

  // Get a color based on the course name (for consistency in UI)
  Color getSubjectColor() {
    // List of pleasant colors
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.cyan,
      Colors.deepOrange,
      Colors.indigo,
      Colors.teal,
    ];

    // Consistent color based on courseName hash
    return colors[courseName.hashCode.abs() % colors.length];
  }
}

class WeekScheduleResponse {
  final String weekInfo;
  final List<ScheduleModel> schedules;

  WeekScheduleResponse({
    required this.weekInfo,
    required this.schedules,
  });

  factory WeekScheduleResponse.fromJson(Map<String, dynamic> json) {
    final schedulesJson = json['schedules'] as List<dynamic>? ?? [];
    return WeekScheduleResponse(
      weekInfo: json['week_info'] ?? 'Unknown Week',
      schedules: schedulesJson
          .map((scheduleJson) => ScheduleModel.fromJson(scheduleJson))
          .toList(),
    );
  }
}
