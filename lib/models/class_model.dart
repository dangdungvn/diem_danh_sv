import 'package:flutter/foundation.dart';

class StudentInfo {
  final int id;
  final String studentCode;
  final String name;
  final String email;

  StudentInfo({
    required this.id,
    required this.studentCode,
    required this.name,
    required this.email,
  });

  factory StudentInfo.fromJson(Map<String, dynamic> json) {
    return StudentInfo(
      id: json['id'],
      studentCode: json['student_code'],
      name: json['name'],
      email: json['email'],
    );
  }
}

class TeacherInfo {
  final int id;
  final String teacherCode;
  final String name;
  final String email;

  TeacherInfo({
    required this.id,
    required this.teacherCode,
    required this.name,
    required this.email,
  });

  factory TeacherInfo.fromJson(Map<String, dynamic> json) {
    return TeacherInfo(
      id: json['id'],
      teacherCode: json['teacher_code'],
      name: json['name'],
      email: json['email'],
    );
  }
}

class ClassModel {
  final int id;
  final String classCode;
  final String className;
  final List<StudentInfo> students;
  final List<TeacherInfo> teachers;

  ClassModel({
    required this.id,
    required this.classCode,
    required this.className,
    required this.students,
    required this.teachers,
  });

  factory ClassModel.fromJson(Map<String, dynamic> json) {
    return ClassModel(
      id: json['id'],
      classCode: json['class_code'],
      className: json['class_name'],
      students: (json['students'] as List)
          .map((student) => StudentInfo.fromJson(student))
          .toList(),
      teachers: (json['teachers'] as List)
          .map((teacher) => TeacherInfo.fromJson(teacher))
          .toList(),
    );
  }

  @override
  String toString() {
    return 'ClassModel{id: $id, classCode: $classCode, className: $className}';
  }
}
