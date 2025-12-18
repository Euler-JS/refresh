import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SubscriptionService {
  static const String _apiBaseUrl = 'http://localhost:3000/api';
  
  static SubscriptionService? _instance;
  static SubscriptionService get instance {
    _instance ??= SubscriptionService._();
    return _instance!;
  }
  
  SubscriptionService._();

  // Verificar se o usuário tem subscrição ativa
  Future<bool> hasActiveSubscription() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) {
        return false;
      }

      final response = await http.get(
        Uri.parse('$_apiBaseUrl/subscriptions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // Verificar se a subscrição é válida e está ativa
        final isValid = data['isValid'] ?? false;
        final status = data['subscription']?['status'] ?? '';
        
        return isValid && status == 'active';
      }

      return false;
    } catch (e) {
      print('Erro ao verificar subscrição: $e');
      return false;
    }
  }

  // Obter detalhes da subscrição
  Future<Map<String, dynamic>?> getSubscriptionDetails() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) {
        return null;
      }

      final response = await http.get(
        Uri.parse('$_apiBaseUrl/subscriptions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      }

      return null;
    } catch (e) {
      print('Erro ao obter detalhes da subscrição: $e');
      return null;
    }
  }
}
