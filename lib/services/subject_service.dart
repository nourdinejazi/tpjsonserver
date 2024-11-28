import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tpjsonserver/services/auth_service.dart';
import '../models/subject.dart';

class SubjectService {
  final String baseUrl = 'http://10.0.2.2:4000/subjects';
  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${AuthService.token}',
      };

  Future<List<Subject>> getSubjects() async {
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: _headers,
    );
    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Subject.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load subjects');
    }
  }
}
