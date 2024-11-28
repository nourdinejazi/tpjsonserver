// lib/models/user.dart
class User {
  final String id;
  final String email;
  final String name;
  final String school;
  final String role;

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.school,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'].toString(),
      email: json['email'],
      name: json['name'],
      school: json['school'],
      role: json['role'],
    );
  }
}
