import 'package:flutter/material.dart';
import 'models.dart';
import 'utils.dart';

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
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          colors: [seedColor, seedColor.withValues(alpha: 0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33EF476F),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: theme.textTheme.bodyLarge?.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: 16),
          ...practiceIdeas.map(
            (idea) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.only(right: 10),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      idea,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                      ),
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

  List<Widget> _buildRowTiles(
    List<HangulCharacter> characters,
    ValueChanged<HangulCharacter> onTap,
  ) {
    List<Widget> tiles = characters
        .map(
          (character) => _HangulCharacterTile(
            character: character,
            onTap: onTap,
            correctCount: correctCounts[character.symbol] ?? 0,
          ),
        )
        .toList();
    List<Widget> result = [];
    for (int i = 0; i < tiles.length; i++) {
      result.add(tiles[i]);
      if (i < tiles.length - 1) result.add(const SizedBox(width: 12));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (int i = 0; i < section.characters.length; i += 6)
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: i + 6 < section.characters.length ? 12 : 0,
                    ),
                    child: Row(
                      children: _buildRowTiles(
                        section.characters.sublist(
                          i,
                          i + 6 > section.characters.length
                              ? section.characters.length
                              : i + 6,
                        ),
                        onCharacterTap,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
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
    final theme = Theme.of(context);
    return InkWell(
      onTap: () => onTap(character),
      borderRadius: BorderRadius.circular(18),
      child: Ink(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: accentColor.withValues(alpha: 0.18),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              character.symbol,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              character.romanization,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.grey[800],
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '$correctCount',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.green[700],
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CharacterDetailSheet extends StatelessWidget {
  const CharacterDetailSheet({required this.character});

  final HangulCharacter character;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: 24 + MediaQuery.of(context).viewPadding.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            child: Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: seedColor.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(26),
              ),
              child: Center(
                child: Text(
                  character.symbol,
                  style: theme.textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            character.name,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Romanization • ${character.romanization}',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: seedColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Text(character.description, style: theme.textTheme.bodyMedium),
          const SizedBox(height: 16),
          _InfoRow(
            icon: Icons.volume_up_outlined,
            label: '예시 단어',
            value: character.example,
          ),
          const SizedBox(height: 16),
          Text(
            '연습 팁',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(buildPracticeTip(character), style: theme.textTheme.bodyMedium),
        ],
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
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: seedColor),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(value, style: theme.textTheme.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }
}
