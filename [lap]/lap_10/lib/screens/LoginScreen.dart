import 'package:flutter/material.dart';
import 'package:lap_10/screens/HomeScreen.dart';
import 'package:lap_10/screens/RealApiLogin.dart';
import 'package:lap_10/service/session_manager.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final SessionManager _sessionManager = SessionManager();

  Future<void> _checkLoginStatus() async {
    await Future.delayed(const Duration(seconds: 1));
    final token = await _sessionManager.getToken();
    final username = await _sessionManager.getUserName();

    if (!mounted) return;
    if (token == null || token.isEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const RealApiLoginScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(
            token: token,
            username: username ?? 'Người dùng',
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
