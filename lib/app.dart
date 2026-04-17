import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

class TriageSyncApp extends StatelessWidget {
  const TriageSyncApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TriageSync',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF005EB8)),
      ),
      home: const LoginScreen(),
    );
  }
}
