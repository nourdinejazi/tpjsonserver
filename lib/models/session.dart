class Session {
  final String sessionId;
  final String subjectId;
  final String teacherId;
  final String roomId;
  final String classId;
  final DateTime sessionDate;
  final String startTime;
  final String endTime;
  final String id;

  Session({
    required this.sessionId,
    required this.subjectId,
    required this.teacherId,
    required this.roomId,
    required this.classId,
    required this.sessionDate,
    required this.startTime,
    required this.endTime,
    required this.id,
  });

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      sessionId: json['session_id'],
      subjectId: json['subject_id'],
      teacherId: json['teacher_id'],
      roomId: json['room_id'],
      classId: json['class_id'],
      sessionDate: DateTime.parse(json['session_date']),
      startTime: json['start_time'],
      endTime: json['end_time'],
      id: json['id'],
    );
  }
}
