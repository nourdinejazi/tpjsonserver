class Subject {
  final String subjectId;
  final String subjectName;
  final String subjectCode;
  final String department;
  final String description;
  final String id;

  Subject({
    required this.subjectId,
    required this.subjectName,
    required this.subjectCode,
    required this.department,
    required this.description,
    required this.id,
  });

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      subjectId: json['subject_id'],
      subjectName: json['subject_name'],
      subjectCode: json['subject_code'],
      department: json['department'],
      description: json['description'],
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subject_id': subjectId,
      'subject_name': subjectName,
      'subject_code': subjectCode,
      'department': department,
      'description': description,
      'id': id,
    };
  }

  @override
  String toString() {
    return '$subjectName ($subjectCode)';
  }
}
