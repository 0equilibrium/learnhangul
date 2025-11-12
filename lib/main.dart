import 'package:flutter/material.dart';
import 'home_page.dart';
import 'models.dart';

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
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: seedColor),
        scaffoldBackgroundColor: const Color(0xFFFFF7F2),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        tabBarTheme: const TabBarThemeData(
          labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          unselectedLabelStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      home: const LearnHangulHomePage(),
    );
  }
}
