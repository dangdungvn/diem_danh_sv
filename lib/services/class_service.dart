import 'dart:convert' show json, utf8;
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/class_model.dart';

class ClassService {
  final String baseUrl = 'http://34.143.254.122';
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  Future<List<ClassModel>> getMyClasses() async {
    try {
      String? token = await storage.read(key: 'access_token');

      if (token == null) {
        throw Exception('Token không tồn tại');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/api/school/students/my_classes/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        // Sử dụng Utf8Decoder để đảm bảo tiếng Việt hiển thị đúng
        List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        return data.map((json) => ClassModel.fromJson(json)).toList();
      } else {
        throw Exception('Lỗi khi tải dữ liệu: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Lỗi kết nối: $e');
    }
  }
}
