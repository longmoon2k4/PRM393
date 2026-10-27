import 'package:flutter/material.dart';
import 'package:lap_10/service/fire_base_auth_service.dart';

import 'HomeScreenFireBase.dart';

class LoginWithGoogle extends StatefulWidget {
  const LoginWithGoogle({super.key});

  @override
  State<LoginWithGoogle> createState() => _LoginWithGoogleState();
}

class _LoginWithGoogleState extends State<LoginWithGoogle> {
  final FireBaseAuthService _authService = FireBaseAuthService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _handleLogin() async {
    setState(() {
      _isLoading = true;
    });
    final user = await _authService.signInWithGoogle();
    if (!mounted) return;
    setState(() {
      _isLoading = false;
    });
    if (user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreenFireBase(user: user)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : ElevatedButton(
                onPressed: _handleLogin,
                child: const Text('Login with Google'),
              ),
      ),
    );
  }
}
