import 'package:babysitter_ham/presentation/login/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SukuSuku',
      theme: ThemeData(
        primarySwatch: Colors.blue, // AI 테마에 맞춘 블루 컬러
      ),
      home: LoginScreen(), // 로그인 화면으로 시작
    );
  }
}
