class Teacher {
  final String teacherId;
  final String firstName;
  final String lastName;
  final String email;
  final String department;
  final String phone;
  final String id;

  Teacher({
    required this.teacherId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.department,
    required this.phone,
    required this.id,
  });

  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
      teacherId: json['teacher_id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      department: json['department'],
      phone: json['phone'],
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'teacher_id': teacherId,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'department': department,
      'phone': phone,
      'id': id,
    };
  }

  @override
  String toString() {
    return '$firstName $lastName ($teacherId)';
  }
}
