// To parse this JSON data, do
//
//     final attendanceHistoryModel = attendanceHistoryModelFromJson(jsonString);

import 'dart:convert';

List<AttendanceHistoryModel> attendanceHistoryModelFromJson(String str) =>
    List<AttendanceHistoryModel>.from(
        json.decode(str).map((x) => AttendanceHistoryModel.fromJson(x)));

String attendanceHistoryModelToJson(List<AttendanceHistoryModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AttendanceHistoryModel {
  final int id;
  final int schedule;
  final ScheduleDetail scheduleDetail;
  final DateTime timestamp;
  final String timestampVn;
  final bool isPresent;
  final bool isLate;
  final int minutesLate;
  final double latitude;
  final double longitude;
  final String deviceInfo;
  final String attendanceStatus;
  final String location;

  AttendanceHistoryModel({
    required this.id,
    required this.schedule,
    required this.scheduleDetail,
    required this.timestamp,
    required this.timestampVn,
    required this.isPresent,
    required this.isLate,
    required this.minutesLate,
    required this.latitude,
    required this.longitude,
    required this.deviceInfo,
    required this.attendanceStatus,
    required this.location,
  });

  factory AttendanceHistoryModel.fromJson(Map<String, dynamic> json) =>
      AttendanceHistoryModel(
        id: json["id"],
        schedule: json["schedule"],
        scheduleDetail: ScheduleDetail.fromJson(json["schedule_detail"]),
        timestamp: DateTime.parse(json["timestamp"]),
        timestampVn: json["timestamp_vn"],
        isPresent: json["is_present"],
        isLate: json["is_late"],
        minutesLate: json["minutes_late"],
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
        deviceInfo: json["device_info"],
        attendanceStatus: json["attendance_status"],
        location: json["location"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "schedule": schedule,
        "schedule_detail": scheduleDetail.toJson(),
        "timestamp": timestamp.toIso8601String(),
        "timestamp_vn": timestampVn,
        "is_present": isPresent,
        "is_late": isLate,
        "minutes_late": minutesLate,
        "latitude": latitude,
        "longitude": longitude,
        "device_info": deviceInfo,
        "attendance_status": attendanceStatus,
        "location": location,
      };
}

class ScheduleDetail {
  final int id;
  final String courseName;
  final String teacherName;
  final String room;
  final String className;
  final DateTime startTime;
  final DateTime endTime;

  ScheduleDetail({
    required this.id,
    required this.courseName,
    required this.teacherName,
    required this.room,
    required this.className,
    required this.startTime,
    required this.endTime,
  });

  factory ScheduleDetail.fromJson(Map<String, dynamic> json) => ScheduleDetail(
        id: json["id"],
        courseName: json["course_name"],
        teacherName: json["teacher_name"],
        room: json["room"],
        className: json["class_name"],
        startTime: DateTime.parse(json["start_time"]),
        endTime: DateTime.parse(json["end_time"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "course_name": courseName,
        "teacher_name": teacherName,
        "room": room,
        "class_name": className,
        "start_time": startTime.toIso8601String(),
        "end_time": endTime.toIso8601String(),
      };
}
