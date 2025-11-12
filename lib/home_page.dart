import 'package:flutter/material.dart';
import 'screens.dart';

class LearnHangulHomePage extends StatelessWidget {
  const LearnHangulHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('LearnHangul')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const VowelLearningScreen(),
                  ),
                );
              },
              child: const Text('모음'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ConsonantLearningScreen(),
                  ),
                );
              },
              child: const Text('자음'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsScreen(),
                  ),
                );
              },
              child: const Text('설정'),
            ),
          ],
        ),
      ),
    );
  }
}
