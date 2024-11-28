import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tpjsonserver/services/auth_service.dart';
import '../models/session.dart';

class SessionService {
  final String baseUrl = 'http://10.0.2.2:4000/sessions';
  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${AuthService.token}',
      };
  Future<List<Session>> getSessions() async {
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: _headers,
    );
    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Session.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load sessions');
    }
  }

  Future<Session> createSession(Session session) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: _headers,
        body: json.encode({
          'session_id': session.sessionId,
          'subject_id': session.subjectId,
          'teacher_id': session.teacherId,
          'room_id': session.roomId,
          'class_id': session.classId,
          'session_date': session.sessionDate.toIso8601String(),
          'start_time': session.startTime,
          'end_time': session.endTime,
        }),
      );

      if (response.statusCode == 201) {
        return Session.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to create session');
      }
    } catch (e) {
      print('Error creating session: $e');
      rethrow;
    }
  }

  Future<void> updateSession(Session session) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/${session.id}'),
        headers: _headers,
        body: json.encode({
          'session_id': session.sessionId,
          'subject_id': session.subjectId,
          'teacher_id': session.teacherId,
          'room_id': session.roomId,
          'class_id': session.classId,
          'session_date': session.sessionDate.toIso8601String(),
          'start_time': session.startTime,
          'end_time': session.endTime,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update session');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<void> deleteSession(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/$id'),
        headers: _headers,
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to delete session');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
