// lib/providers/auth_provider.dart
import 'package:flutter/material.dart';
import '../models/auth/user.dart';
import '../services/auth_service.dart';

enum AuthStatus {
  initial,
  authenticating,
  authenticated,
  unauthenticated,
  error
}

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();

  AuthStatus _status = AuthStatus.initial;
  User? _user;
  String _errorMessage = '';

  AuthStatus get status => _status;
  User? get user => _user;
  String get errorMessage => _errorMessage;
  bool get isAuthenticated => _status == AuthStatus.authenticated;

  AuthProvider() {
    // Verificar o estado de autenticação quando o provider é criado
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    _status = AuthStatus.authenticating;
    notifyListeners();

    try {
      final isAuth = await _authService.isAuthenticated();

      if (isAuth) {
        _user = await _authService.getUserProfile();
        _status = AuthStatus.authenticated;
      } else {
        _status = AuthStatus.unauthenticated;
      }
    } catch (e) {
      _status = AuthStatus.unauthenticated;
      _errorMessage = e.toString();
    }

    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _status = AuthStatus.authenticating;
    _errorMessage = '';
    notifyListeners();

    try {
      await _authService.login(email, password);
      
      // Tentar buscar o perfil, mas não falhar se não conseguir
      try {
        _user = await _authService.getUserProfile();
      } catch (profileError) {
        print('⚠️ Não foi possível buscar perfil: $profileError');
        // Continuar mesmo sem o perfil completo
      }
      
      _status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } catch (e) {
      _status = AuthStatus.error;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(String username, String email, String password) async {
    _status = AuthStatus.authenticating;
    _errorMessage = '';
    notifyListeners();

    try {
      await _authService.register(username, email, password);
      
      // Tentar buscar o perfil, mas não falhar se não conseguir
      try {
        _user = await _authService.getUserProfile();
      } catch (profileError) {
        print('⚠️ Não foi possível buscar perfil: $profileError');
        // Continuar mesmo sem o perfil completo
      }
      
      _status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } catch (e) {
      _status = AuthStatus.error;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    _user = null;
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }
}