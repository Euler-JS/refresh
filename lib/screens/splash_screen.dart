// lib/screens/splash_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    // Espera um pouco para mostrar a tela de splash
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // Espera o provider terminar a verificação
    if (authProvider.status == AuthStatus.initial ||
        authProvider.status == AuthStatus.authenticating) {
      // Espera até que o provider termine
      authProvider.addListener(_onAuthStateChanged);
    } else {
      // Já tem o status, navega para a tela apropriada
      _navigateToNextScreen(authProvider.status);
    }
  }

  void _onAuthStateChanged() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (authProvider.status != AuthStatus.initial &&
        authProvider.status != AuthStatus.authenticating) {
      authProvider.removeListener(_onAuthStateChanged);
      _navigateToNextScreen(authProvider.status);
    }
  }

  void _navigateToNextScreen(AuthStatus status) {
    if (status == AuthStatus.authenticated) {
      Navigator.of(context).pushReplacementNamed('/home');
    } else {
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF6A4C93),
              Color(0xFF8E44AD),
              Color(0xFFA569BD),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo ou ícone do app
              const Icon(
                Icons.event,
                size: 100,
                color: Colors.white,
              ),
              const SizedBox(height: 24),
              const Text(
                'Meus Serviços',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 48),
              const CircularProgressIndicator(
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}