import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lap_10/screens/LoginScreen.dart';
import 'package:lap_10/screens/LoginWithGoogle.dart';
import 'package:lap_10/screens/RealApiLogin.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  runApp(const MaterialApp(
    home: LoginWithGoogle(),
    debugShowCheckedModeBanner: false,
  ));
}
