import 'package:flutter/material.dart';

import 'design_system.dart';
import 'home_page.dart';

void main() {
  runApp(const LearnHangulApp());
}

class LearnHangulApp extends StatelessWidget {
  const LearnHangulApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LearnHangul',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: LearnHangulTheme.light(),
      darkTheme: LearnHangulTheme.dark(),
      home: const LearnHangulHomePage(),
    );
  }
}
