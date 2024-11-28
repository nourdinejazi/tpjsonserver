import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tpjsonserver/services/auth_service.dart';
import '../models/teacher.dart';

class TeacherService {
  final String baseUrl = 'http://10.0.2.2:4000/teachers';
  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${AuthService.token}',
      };
  Future<List<Teacher>> getTeachers() async {
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: _headers,
    );
    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Teacher.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load teachers');
    }
  }
}
