import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:lap_10/screens/MainLoginScreen.dart';
import 'package:lap_10/service/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  await NotificationService.initialize();

  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MainLoginScreen(),
  ));
}

