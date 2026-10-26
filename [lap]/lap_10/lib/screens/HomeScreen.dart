import 'package:flutter/material.dart';
import 'package:lap_10/service/session_manager.dart';

import 'LoginScreen.dart';

class HomeScreen extends StatefulWidget {
  final String token;
  final String username;
  const HomeScreen({super.key, required this.token, required this.username});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  SessionManager _sessionManager = SessionManager();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Token: ${widget.token}'),
            Text('Username: ${widget.username}'),
            IconButton(
              onPressed: () {
                _sessionManager.clearSession();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
      ),
    );
  }
}
