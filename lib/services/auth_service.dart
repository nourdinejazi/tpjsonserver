// lib/services/auth_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tpjsonserver/models/user.dart';

class AuthService {
  static final _logger = Logger('AuthService');
// auth_service.dart
  static const String baseUrl = 'http://10.0.2.2:4000';
  static String? _token;
  static const String _tokenKey = 'Bearer ';
  static User? _currentUser;
  static User? get currentUser => _currentUser;
  static String? get token => _token;

  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString(_tokenKey);
  }

  static Future<bool> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );
      print('status code: ${response.statusCode}');
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _token = data['token'];
        print('user data: ${data['user']}');
        _currentUser = User.fromJson(data['user']);
        try {
          _currentUser = User.fromJson(data['user']);
          print('User parsed successfully: $_currentUser');
        } catch (e) {
          print('Error parsing user data: $e');
          return false;
        }

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_tokenKey, _token!);
        print('trueeeee');
        return true;
      }
      print('falseeeeess');

      return false;
    } catch (e) {
      _logger.severe('Login error: $e');

      return false;
    }
  }

// lib/services/auth_service.dart - Add this method
  static Future<bool> register(
      String email, String password, String name, String school) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
          'name': name,
          'school': school,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _token = data['token'];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_tokenKey, _token!);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future<void> logout() async {
    _token = null;
    _currentUser = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  static bool isLoggedIn() => _token != null;

  static bool isAdmin() {
    return _currentUser?.role == 'ADMIN';
  }

  static bool canManageSessions() {
    return isAdmin();
  }
}
