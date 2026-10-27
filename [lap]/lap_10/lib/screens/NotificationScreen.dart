import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../service/notification_service.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  String? _fcmToken;

  @override
  void initState() {
    super.initState();
    _loadFcmToken();
  }

  Future<void> _loadFcmToken() async {
    final token = await FirebaseMessaging.instance.getToken();
    setState(() {
      _fcmToken = token;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab 10.5 - Notification'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 1. NÚT TEST LOCAL NOTIFICATION (NỘI BỘ KHÔNG CẦN INTERNET)
            ElevatedButton.icon(
              onPressed: () {
                NotificationService.showLocalNotification(
                  id: DateTime.now().millisecond,
                  title: 'Thông báo cục bộ!',
                  body: 'Đây là nội dung được gửi trực tiếp từ điện thoại của bạn.',
                );
              },
              icon: const Icon(Icons.notifications_active),
              label: const Text('Bắn Local Notification'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
              ),
            ),
            const SizedBox(height: 30),

            // 2. KHU VỰC HIỂN THỊ FCM TOKEN ĐỂ TEST TRÊN MÂY
            const Text(
              'FCM Token của thiết bị (dùng để test Push Notification):',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
              child: SelectableText(
                _fcmToken ?? 'Đang tải token...',
                style: const TextStyle(fontSize: 12),
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _fcmToken == null
                  ? null
                  : () {
                Clipboard.setData(ClipboardData(text: _fcmToken!));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Đã sao chép FCM Token vào bộ nhớ tạm!')),
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