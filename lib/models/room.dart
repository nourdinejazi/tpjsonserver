class Room {
  final String roomId;
  final String roomName;
  final int capacity;
  final String building;
  final int floor;
  final String id;

  Room({
    required this.roomId,
    required this.roomName,
    required this.capacity,
    required this.building,
    required this.floor,
    required this.id,
  });

  Map<String, dynamic> toJson() => {
        'room_id': roomId,
        'room_name': roomName,
        'capacity': capacity,
        'building': building,
        'floor': floor,
        'id': id,
      };

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      roomId: json['room_id'] as String,
      roomName: json['room_name'] as String,
      capacity: json['capacity'] as int,
      building: json['building'] as String,
      floor: json['floor'] as int,
      id: json['id'] as String,
    );
  }
}
