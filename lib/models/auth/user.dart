// lib/models/auth/user.dart
class User {
  final String id;
  final String username;
  final String email;
  final String status;
  final DateTime createdAt;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.status,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    if (json['id'] == null || json['username'] == null || 
        json['email'] == null || json['status'] == null || 
        json['createdAt'] == null) {
      throw FormatException('Campos obrigatórios ausentes no perfil do usuário');
    }
    
    return User(
      id: json['id'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}