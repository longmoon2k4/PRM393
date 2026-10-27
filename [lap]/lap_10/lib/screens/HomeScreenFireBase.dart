import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lap_10/screens/LoginWithGoogle.dart';
import 'package:lap_10/service/fire_base_auth_service.dart';

class HomeScreenFireBase extends StatelessWidget {
  final User user;
  const HomeScreenFireBase({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final FireBaseAuthService _auth = FireBaseAuthService();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông tin người dùng'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (user.photoURL != null)
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(user.photoURL!),
              )
            else
              const CircleAvatar(
                radius: 50,
                child: Icon(Icons.person, size: 50),
              ),
            const SizedBox(height: 16),
            Text(
              'Tên: ${user.displayName ?? "Không có"}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Email: ${user.email ?? "Không có"}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () async {
                await _auth.signOut();
                if (context.mounted) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginWithGoogle(),
                    ),
                  );
                }
              },
              child: const Text('Đăng xuất'),
            ),
          ],
        ),
      ),
    );
  }
}
