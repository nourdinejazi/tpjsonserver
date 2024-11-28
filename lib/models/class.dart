class Class {
  final String classId;
  final String subjectId;
  final String className;
  final List<String> students;
  final String id;

  Class({
    required this.classId,
    required this.subjectId,
    required this.className,
    required this.students,
    required this.id,
  });

  factory Class.fromJson(Map<String, dynamic> json) {
    return Class(
      classId: json['class_id'],
      subjectId: json['subject_id'],
      className: json['class_name'],
      students: List<String>.from(json['students']),
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'class_id': classId,
      'subject_id': subjectId,
      'class_name': className,
      'students': students,
      'id': id,
    };
  }

  @override
  String toString() {
    return '$className (${students.length} students)';
  }
}
