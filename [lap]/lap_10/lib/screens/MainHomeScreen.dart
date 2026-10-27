import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lap_10/screens/MainLoginScreen.dart';
import 'package:lap_10/service/fire_base_auth_service.dart';
import 'package:lap_10/service/notification_service.dart';
import 'package:lap_10/service/session_manager.dart';

class MainHomeScreen extends StatefulWidget {
  final String? apiToken;
  final String? apiUsername;
  final User? firebaseUser;

  const MainHomeScreen({
    super.key,
    this.apiToken,
    this.apiUsername,
    this.firebaseUser,
  });

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  String? _fcmToken;
  final SessionManager _sessionManager = SessionManager();
  final FireBaseAuthService _googleAuth = FireBaseAuthService();

  @override
  void initState() {
    super.initState();
    _loadFcmToken();
  }

  Future<void> _loadFcmToken() async {
    final token = await FirebaseMessaging.instance.getToken();
    if (mounted) {
      setState(() {
        _fcmToken = token;
      });
    }
  }

  Future<void> _handleLogout() async {
    // Xóa session API
    await _sessionManager.clearSession();
    // Đăng xuất Firebase
    await _googleAuth.signOut();

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainLoginScreen()),
      );
    }
  }

  Widget _buildUserInfo() {
    if (widget.firebaseUser != null) {
      // Hiển thị thông tin người dùng Google
      return Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: widget.firebaseUser!.photoURL != null 
              ? NetworkImage(widget.firebaseUser!.photoURL!) 
              : null,
            child: widget.firebaseUser!.photoURL == null 
              ? const Icon(Icons.person, size: 50) 
              : null,
          ),
          const SizedBox(height: 16),
          Text(
            'Tên: ${widget.firebaseUser!.displayName ?? "Không rõ"}',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Email: ${widget.firebaseUser!.email ?? "Không rõ"}',
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      );
    } else {
      // Hiển thị thông tin người dùng API
      return Column(
        children: [
          const CircleAvatar(
            radius: 50,
            child: Icon(Icons.verified_user, size: 50),
          ),
          const SizedBox(height: 16),
          Text(
            'Tên đăng nhập: ${widget.apiUsername ?? "Người dùng"}',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Access Token API:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                SelectableText(
                  widget.apiToken ?? 'Không có token',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trang chủ'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Đăng xuất',
            onPressed: _handleLogout,
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 1. Thông tin người dùng
            _buildUserInfo(),
            const SizedBox(height: 40),
            const Divider(),
            const SizedBox(height: 20),

            // 2. Chức năng Thông báo (Notification)
            const Text(
              'Tính năng thông báo (FCM & Local)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                NotificationService.showLocalNotification(
                  id: DateTime.now().millisecond,
                  title: 'Thông báo cục bộ!',
                  body: 'Được gửi trực tiếp từ máy của bạn, không cần Internet.',
                );
              },
              icon: const Icon(Icons.notifications_active),
              label: const Text('Bắn Local Notification'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'FCM Token của thiết bị (dùng cho Push Notification):',
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
              child: SelectableText(
                _fcmToken ?? 'Đang tải token...',
                style: const TextStyle(fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _fcmToken == null
                  ? null
                  : () {
                      Clipboard.setData(ClipboardData(text: _fcmToken!));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Đã sao chép FCM Token!')),
                      );
                    },
              icon: const Icon(Icons.copy),
              label: const Text('Sao chép FCM Token'),
            ),
          ],
        ),
      ),
    );
  }
}
