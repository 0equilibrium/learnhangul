import 'package:flutter/material.dart';

import 'design_system.dart';
import 'models.dart';
import 'screens.dart';

class LearnHangulHomePage extends StatelessWidget {
  const LearnHangulHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final typography = LearnHangulTheme.typographyOf(context);
    final palette = LearnHangulTheme.paletteOf(context);
    final iconColor = palette.primaryText;

    return Scaffold(
      appBar: AppBar(title: const Text('LearnHangul')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
        children: [
          const SizedBox(height: 28),
          LiquidGlassButton(
            label: '모음 마스터하기',
            leading: Icon(Icons.auto_fix_high_rounded, color: iconColor),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const VowelLearningScreen(),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          LiquidGlassButton(
            label: '자음 리듬 익히기',
            leading: Icon(Icons.graphic_eq_rounded, color: iconColor),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ConsonantLearningScreen(),
                ),
              );
            },
            variant: LiquidGlassButtonVariant.secondary,
          ),
          const SizedBox(height: 28),
LearnHangulListTile(
                  title: '학습 환경 설정',
                  subtitle: '목표 달성 리마인더와 테마',
                  leading: const Icon(Icons.tune_rounded),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SettingsScreen(),
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }
}
