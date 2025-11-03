// lib/models/auth/auth_response.dart
class AuthResponse {
  final String message;
  final String token;
  final String userId;

  AuthResponse({
    required this.message,
    required this.token,
    required this.userId,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    if (json['message'] == null || json['token'] == null || json['userId'] == null) {
      throw FormatException('Campos obrigatórios ausentes na resposta da API');
    }
    
    return AuthResponse(
      message: json['message'] as String,
      token: json['token'] as String,
      userId: json['userId'] as String,
    );
  }
}