// lib/services/auth_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/auth/auth_response.dart';
import '../models/auth/user.dart';

class AuthService {
  // Substitua pela URL da sua API
  // static const String baseUrl = 'http://localhost:3000/api';
  static const String baseUrl = 'https://refresh-api.manna.software/api';
  static const String tokenKey = 'auth_token';
  static const String userIdKey = 'user_id';

  // Login
  Future<AuthResponse> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': email,
        'password': password,
      }),
    );

    try {
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final authResponse = AuthResponse.fromJson(jsonData);

        // Salvar token e ID do usuário
        await _saveAuthData(authResponse.token, authResponse.userId);

        return authResponse;
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Falha ao realizar login');
      }
    } on FormatException catch (e) {
      throw Exception('Erro no formato da resposta da API: ${e.message}');
    } catch (e) {
      throw Exception('Erro ao processar login: $e');
    }
  }

  // Registro
  Future<AuthResponse> register(String username, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users/register'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'username': username,
        'email': email,
        'password': password,
      }),
    );

    try {
      // Aceitar tanto 200 quanto 201 como sucesso
      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = json.decode(response.body);
        final authResponse = AuthResponse.fromJson(jsonData);

        // Salvar token e ID do usuário
        await _saveAuthData(authResponse.token, authResponse.userId);

        return authResponse;
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Falha ao registrar usuário');
      }
    } on FormatException catch (e) {
      throw Exception('Erro no formato da resposta da API: ${e.message}');
    } catch (e) {
      throw Exception('Erro ao processar registro: $e');
    }
  }

  // Obter perfil do usuário
  Future<User> getUserProfile() async {
    final authData = await _getAuthData();
    if (authData['token'] == null) {
      throw Exception('Usuário não autenticado');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/users/profile'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${authData['token']}',
      },
    );

    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      final errorData = json.decode(response.body);
      throw Exception(errorData['message'] ?? 'Falha ao buscar perfil');
    }
  }

  // Verificar se o usuário está autenticado
  Future<bool> isAuthenticated() async {
    final authData = await _getAuthData();
    return authData['token'] != null && authData['token']!.isNotEmpty;
  }

  // Logout
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(tokenKey);
    await prefs.remove(userIdKey);
  }

  // Deletar conta do usuário
  Future<void> deleteAccount() async {
    final authData = await _getAuthData();
    if (authData['token'] == null) {
      throw Exception('Usuário não autenticado');
    }

    final response = await http.delete(
      Uri.parse('$baseUrl/users/account'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${authData['token']}',
      },
    );

    if (response.statusCode == 200) {
      // Limpar dados locais após exclusão bem-sucedida
      await logout();
    } else {
      final errorData = json.decode(response.body);
      throw Exception(errorData['message'] ?? 'Falha ao deletar conta');
    }
  }

  // Métodos auxiliares para gerenciar o token e ID
  Future<void> _saveAuthData(String token, String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(tokenKey, token);
    await prefs.setString(userIdKey, userId);
  }

  Future<Map<String, String?>> _getAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'token': prefs.getString(tokenKey),
      'userId': prefs.getString(userIdKey),
    };
  }
}