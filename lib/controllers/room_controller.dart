// lib/controllers/room_controller.dart
import 'package:get/get.dart';
import '../models/room.dart';
import '../services/room_service.dart';

class RoomController extends GetxController {
  final RoomService _roomService;
  final isLoading = false.obs;
  final error = RxString('');

  RoomController(this._roomService);

  Future<bool> createRoom(Room room) async {
    isLoading.value = true;
    error.value = '';

    try {
      await _roomService.createRoom(room);
      isLoading.value = false;
      return true;
    } catch (e) {
      error.value = e.toString();
      isLoading.value = false;
      return false;
    }
  }
}
