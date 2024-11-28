import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tpjsonserver/services/auth_service.dart';
import '../models/room.dart';

class RoomService {
  final String baseUrl = 'http://10.0.2.2:4000/rooms';
  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${AuthService.token}',
      };
  Future<List> getRooms() async {
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: _headers,
    );
    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Room.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load rooms');
    }
  }

  // In room_service.dart
  Future<Room> createRoom(Room room) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: _headers,
      body: json.encode(room.toJson()),
    );

    if (response.statusCode == 201) {
      return Room.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create room');
    }
  }
}
