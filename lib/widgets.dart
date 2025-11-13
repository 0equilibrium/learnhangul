import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

import 'design_system.dart';
import 'models.dart';

Future<void> showCharacterDetails(
  BuildContext context,
  HangulCharacter character,
) {
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
    ),
    builder: (_) => CharacterDetailSheet(character: character),
  );
}

class HangulTabContent extends StatelessWidget {
  const HangulTabContent({
    super.key,
    required this.heroTitle,
    required this.heroSubtitle,
    required this.practiceIdeas,
    required this.sections,
    this.correctCounts = const {},
  });

  final String heroTitle;
  final String heroSubtitle;
  final List<String> practiceIdeas;
  final List<HangulSection> sections;
  final Map<String, int> correctCounts;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      children: [
        _LearningHeroCard(
          title: heroTitle,
          subtitle: heroSubtitle,
          practiceIdeas: practiceIdeas,
        ),
        const SizedBox(height: 24),
        for (final section in sections)
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: HangulSectionCard(
              section: section,
              onCharacterTap: (character) =>
                  showCharacterDetails(context, character),
              correctCounts: correctCounts,
            ),
          ),
      ],
    );
  }
}

class _LearningHeroCard extends StatelessWidget {
  const _LearningHeroCard({
    required this.title,
    required this.subtitle,
    required this.practiceIdeas,
  });

  final String title;
  final String subtitle;
  final List<String> practiceIdeas;

  @override
  Widget build(BuildContext context) {
    final palette = LearnHangulTheme.paletteOf(context);
    final typography = LearnHangulTheme.typographyOf(context);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(36),
        gradient: LinearGradient(
          colors: [seedColor.withOpacity(0.95), accentColor.withOpacity(0.75)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: palette.danger.withOpacity(0.3),
            blurRadius: 36,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: typography.hero.copyWith(color: Colors.white)),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: typography.body.copyWith(
              color: Colors.white.withOpacity(0.85),
            ),
          ),
          const SizedBox(height: 16),
          ...practiceIdeas.map(
            (idea) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    margin: const EdgeInsets.only(right: 10),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      idea,
                      style: typography.body.copyWith(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HangulSectionCard extends StatelessWidget {
  const HangulSectionCard({
    super.key,
    required this.section,
    required this.onCharacterTap,
    this.correctCounts = const {},
  });

  final HangulSection section;
  final ValueChanged<HangulCharacter> onCharacterTap;
  final Map<String, int> correctCounts;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                for (final character in section.characters)
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: _HangulCharacterTile(
                      character: character,
                      onTap: onCharacterTap,
                      correctCount: correctCounts[character.symbol] ?? 0,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HangulCharacterTile extends StatelessWidget {
  const _HangulCharacterTile({
    required this.character,
    required this.onTap,
    required this.correctCount,
  });

  final HangulCharacter character;
  final ValueChanged<HangulCharacter> onTap;
  final int correctCount;

  @override
  Widget build(BuildContext context) {
    final palette = LearnHangulTheme.paletteOf(context);
    final typography = LearnHangulTheme.typographyOf(context);

    return InkWell(
      onTap: () => onTap(character),
      borderRadius: BorderRadius.circular(20),
      child: Ink(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: palette.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: palette.outline),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              character.symbol,
              style: typography.heading.copyWith(fontSize: 30),
            ),
            const SizedBox(height: 6),
            Text(
              character.romanization,
              textAlign: TextAlign.center,
              style: typography.caption,
            ),
            const SizedBox(height: 4),
            Text(
              '$correctCount',
              textAlign: TextAlign.center,
              style: typography.caption.copyWith(color: palette.success),
            ),
          ],
        ),
      ),
    );
  }
}

class CharacterDetailSheet extends StatefulWidget {
  const CharacterDetailSheet({required this.character});

  final HangulCharacter character;

  @override
  State<CharacterDetailSheet> createState() => _CharacterDetailSheetState();
}

class _CharacterDetailSheetState extends State<CharacterDetailSheet> {
  late FlutterTts _flutterTts;

  @override
  void initState() {
    super.initState();
    _flutterTts = FlutterTts();
    _flutterTts.setLanguage('ko-KR');
  }

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }

  Future<void> _speakCharacter() async {
    await _flutterTts.speak(widget.character.name);
  }

  @override
  Widget build(BuildContext context) {
    final palette = LearnHangulTheme.paletteOf(context);
    final typography = LearnHangulTheme.typographyOf(context);

    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: 24 + MediaQuery.of(context).viewPadding.bottom,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              child: Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  color: palette.surface,
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(color: palette.outline),
                ),
                child: Center(
                  child: Text(widget.character.symbol, style: typography.hero),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(widget.character.name, style: typography.heading),
            const SizedBox(height: 4),
            Row(
              children: [
                Text(
                  'Romanization • ${widget.character.romanization}',
                  style: typography.body.copyWith(color: palette.info),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.volume_up_rounded, color: palette.info),
                  onPressed: _speakCharacter,
                  tooltip: '발음 듣기',
                ),
              ],
            ),
            const SizedBox(height: 16),
            _InfoRow(
              icon: Icons.volume_up_outlined,
              label: '예시 단어',
              value: widget.character.example,
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final palette = LearnHangulTheme.paletteOf(context);
    final typography = LearnHangulTheme.typographyOf(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: palette.info),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: typography.caption.copyWith(color: palette.mutedText),
              ),
              const SizedBox(height: 4),
              Text(value, style: typography.body),
            ],
          ),
        ),
      ],
    );
  }
}
