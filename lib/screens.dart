import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'design_system.dart';
import 'liquid_glass_buttons.dart';
import 'models.dart';
import 'widgets.dart';

const _learnedWordsPrefsKey = 'learned_words_v1';

enum ConsonantQuestionCategory { single, openSyllable, batchimWord }

class LearnedWordEntry {
  const LearnedWordEntry({
    required this.term,
    required this.romanization,
    this.meaning,
    required this.seenAt,
    required this.timesSeen,
  });

  final String term;
  final String romanization;
  final String? meaning;
  final DateTime seenAt;
  final int timesSeen;

  factory LearnedWordEntry.fromJson(Map<String, dynamic> json) {
    return LearnedWordEntry(
      term: json['term'] as String,
      romanization: json['romanization'] as String,
      meaning: json['meaning'] as String?,
      seenAt: DateTime.parse(json['seenAt'] as String),
      timesSeen: json['timesSeen'] as int? ?? 1,
    );
  }

  Map<String, dynamic> toJson() => {
    'term': term,
    'romanization': romanization,
    'meaning': meaning,
    'seenAt': seenAt.toIso8601String(),
    'timesSeen': timesSeen,
  };

  LearnedWordEntry copyWith({DateTime? seenAt, int? timesSeen}) {
    return LearnedWordEntry(
      term: term,
      romanization: romanization,
      meaning: meaning,
      seenAt: seenAt ?? this.seenAt,
      timesSeen: timesSeen ?? this.timesSeen,
    );
  }
}

const Map<String, String> _consonantSoundOverrides = {
  'ㄱ': '그',
  'ㄲ': '끄',
  'ㅋ': '크',
  'ㄴ': '느',
  'ㄷ': '드',
  'ㄸ': '뜨',
  'ㅌ': '트',
  'ㄹ': '르',
  'ㅁ': '므',
  'ㅂ': '브',
  'ㅃ': '쁘',
  'ㅍ': '프',
  'ㅅ': '스',
  'ㅆ': '쓰',
  'ㅎ': '흐',
  'ㅇ': '으',
  'ㅈ': '즈',
  'ㅉ': '쯔',
  'ㅊ': '츠',
};

class VowelLearningScreen extends StatefulWidget {
  const VowelLearningScreen({super.key});

  @override
  State<VowelLearningScreen> createState() => _VowelLearningScreenState();
}

class _VowelLearningScreenState extends State<VowelLearningScreen> {
  Map<String, int>? _correctCounts;

  @override
  void initState() {
    super.initState();
    _loadCounts();
  }

  Future<void> _loadCounts() async {
    final prefs = await SharedPreferences.getInstance();
    final allVowels = vowelSections
        .expand((section) => section.characters)
        .toList();
    setState(() {
      _correctCounts = {
        for (var v in allVowels)
          v.symbol: prefs.getInt('correct_${v.symbol}') ?? 0,
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LearnHangulAppBar('모음'),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.zero,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  for (final section in vowelSections)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: HangulSectionCard(
                        section: section,
                        onCharacterTap: (character) =>
                            showCharacterDetails(context, character),
                        correctCounts: _correctCounts ?? {},
                      ),
                    ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: LiquidGlassButton(
              label: '훈련하기',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        TrainingScreen(sections: vowelSections),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ConsonantLearningScreen extends StatefulWidget {
  const ConsonantLearningScreen({super.key});

  @override
  State<ConsonantLearningScreen> createState() =>
      _ConsonantLearningScreenState();
}

class _ConsonantLearningScreenState extends State<ConsonantLearningScreen> {
  Map<String, int>? _correctCounts;

  @override
  void initState() {
    super.initState();
    _loadCounts();
  }

  Future<void> _loadCounts() async {
    final prefs = await SharedPreferences.getInstance();
    final allConsonants = consonantSections
        .expand((section) => section.characters)
        .toList();
    setState(() {
      _correctCounts = {
        for (var c in allConsonants)
          c.symbol: prefs.getInt('correct_${c.symbol}') ?? 0,
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LearnHangulAppBar(
        '자음 학습',
        trailing: IconButton(
          icon: const Icon(Icons.menu_book_rounded),
          tooltip: '내가 학습한 단어',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const LearnedWordsScreen(),
              ),
            );
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.zero,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  for (final section in consonantSections)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: HangulSectionCard(
                        section: section,
                        onCharacterTap: (character) =>
                            showCharacterDetails(context, character),
                        correctCounts: _correctCounts ?? {},
                      ),
                    ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: LiquidGlassButton(
              label: '훈련하기',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        TrainingScreen(sections: consonantSections),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _reminderEnabled = true;
  bool _ttsHintsEnabled = true;

  void _toggleReminder(bool value) {
    setState(() => _reminderEnabled = value);
    LearnHangulSnackbar.show(
      context,
      message: value ? '매일 저녁 알림을 켰어요.' : '알림을 잠시 쉬고 있어요.',
      tone: value ? LearnHangulSnackTone.success : LearnHangulSnackTone.warning,
    );
  }

  void _toggleTts(bool value) {
    setState(() => _ttsHintsEnabled = value);
  }

  void _confirmReset() {
    showDialog(
      context: context,
      builder: (_) => LearnHangulDialog(
        title: '학습 데이터 초기화',
        message: '맞힌 기록과 음절 진행도가 모두 삭제됩니다. 계속할까요?',
        variant: LearnHangulDialogVariant.danger,
        actions: [
          LearnHangulDialogAction(label: '취소'),
          LearnHangulDialogAction(
            label: '초기화',
            isPrimary: true,
            onTap: () {
              LearnHangulSnackbar.show(
                context,
                message: '데이터를 초기화했어요.',
                tone: LearnHangulSnackTone.danger,
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final typography = LearnHangulTheme.typographyOf(context);

    return Scaffold(
      appBar: LearnHangulAppBar('설정'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
        children: [
          const LearnHangulNotice(
            title: '진행 상황',
            message: '연습 목표와 알림을 조정해 스스로에게 가장 잘 맞는 리듬을 만들어 보세요.',
          ),
          const SizedBox(height: 24),
          LearnHangulSurface(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('학습 흐름', style: typography.subtitle),
                const SizedBox(height: 16),
                LearnHangulListTile(
                  title: '저녁 리마인더',
                  subtitle: '매일 19시에 학습 알림 받기',
                  leading: const Icon(Icons.alarm_rounded),
                  trailing: Switch.adaptive(
                    value: _reminderEnabled,
                    onChanged: _toggleReminder,
                  ),
                  onTap: () => _toggleReminder(!_reminderEnabled),
                ),
                const SizedBox(height: 12),
                LearnHangulListTile(
                  title: 'TTS 힌트',
                  subtitle: '문제를 풀 때 자동으로 음성 힌트 듣기',
                  leading: const Icon(Icons.hearing_rounded),
                  trailing: Switch.adaptive(
                    value: _ttsHintsEnabled,
                    onChanged: _toggleTts,
                  ),
                  onTap: () => _toggleTts(!_ttsHintsEnabled),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          LearnHangulSurface(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('계정 및 도움', style: typography.subtitle),
                const SizedBox(height: 12),
                LearnHangulListTile(
                  title: '진행 데이터 초기화',
                  subtitle: '맞힌 수와 섹션 잠금 해제를 모두 삭제합니다',
                  leading: const Icon(Icons.delete_sweep_rounded),
                  onTap: _confirmReset,
                  variant: LearnHangulListTileVariant.danger,
                ),
                const SizedBox(height: 12),
                LearnHangulListTile(
                  title: '피드백 보내기',
                  subtitle: '디자인 개선 의견 공유하기',
                  leading: const Icon(Icons.email_outlined),
                  trailing: const Icon(Icons.open_in_new_rounded),
                  onTap: () {
                    LearnHangulSnackbar.show(
                      context,
                      message: 'feedback@learnhangul.app 로 메일을 보내주세요.',
                      tone: LearnHangulSnackTone.neutral,
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LearnedWordsScreen extends StatefulWidget {
  const LearnedWordsScreen({super.key});

  @override
  State<LearnedWordsScreen> createState() => _LearnedWordsScreenState();
}

class _LearnedWordsScreenState extends State<LearnedWordsScreen> {
  List<LearnedWordEntry> _words = const [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadWords();
  }

  Future<void> _loadWords() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_learnedWordsPrefsKey);
      final entries = raw == null
          ? <LearnedWordEntry>[]
          : (jsonDecode(raw) as List<dynamic>)
                .map(
                  (item) => LearnedWordEntry.fromJson(
                    Map<String, dynamic>.from(item as Map),
                  ),
                )
                .toList();
      entries.sort((a, b) => b.seenAt.compareTo(a.seenAt));
      if (!mounted) return;
      setState(() {
        _words = entries;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _words = const [];
        _isLoading = false;
      });
    }
  }

  String _formatRelative(DateTime seenAt) {
    final now = DateTime.now();
    final diff = now.difference(seenAt);
    if (diff.inDays >= 1) {
      final local = seenAt.toLocal();
      final month = local.month.toString().padLeft(2, '0');
      final day = local.day.toString().padLeft(2, '0');
      final hour = local.hour.toString().padLeft(2, '0');
      final minute = local.minute.toString().padLeft(2, '0');
      return '$month/$day $hour:$minute';
    }
    if (diff.inHours >= 1) {
      return '${diff.inHours}시간 전';
    }
    if (diff.inMinutes >= 1) {
      return '${diff.inMinutes}분 전';
    }
    return '방금 전';
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        appBar: LearnHangulAppBar('내가 학습한 단어'),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final typography = LearnHangulTheme.typographyOf(context);
    final palette = LearnHangulTheme.paletteOf(context);

    Widget body;
    if (_words.isEmpty) {
      body = Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.menu_book_outlined,
                size: 48,
                color: palette.secondaryText,
              ),
              const SizedBox(height: 12),
              Text('아직 정리된 단어가 없어요.', style: typography.heading),
              const SizedBox(height: 8),
              Text(
                '훈련하기에서 새로운 단어를 만나면 여기에 차곡차곡 쌓여요.',
                textAlign: TextAlign.center,
                style: typography.body.copyWith(color: palette.secondaryText),
              ),
            ],
          ),
        ),
      );
    } else {
      body = RefreshIndicator(
        onRefresh: _loadWords,
        child: ListView.separated(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
          physics: const AlwaysScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final word = _words[index];
            return LearnHangulSurface(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    word.term,
                    style: typography.hero.copyWith(fontSize: 36),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(word.romanization, style: typography.caption),
                      if (word.meaning != null) ...[
                        const SizedBox(width: 12),
                        Text('·', style: typography.caption),
                        const SizedBox(width: 12),
                        Text(word.meaning!, style: typography.caption),
                      ],
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        Icons.timer_outlined,
                        size: 18,
                        color: palette.secondaryText,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _formatRelative(word.seenAt),
                        style: typography.body.copyWith(
                          color: palette.secondaryText,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '학습 ${word.timesSeen}회',
                        style: typography.body.copyWith(
                          color: palette.secondaryText,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemCount: _words.length,
        ),
      );
    }

    return Scaffold(appBar: const LearnHangulAppBar('내가 학습한 단어'), body: body);
  }
}

enum GivenType { hangul, sound, romanization }

enum ChooseType { romanization, sound, hangul }

class TrainingMode {
  final GivenType given;
  final ChooseType choose;
  const TrainingMode(this.given, this.choose);
}

class TrainingScreen extends StatefulWidget {
  const TrainingScreen({super.key, required this.sections});

  final List<HangulSection> sections;

  @override
  State<TrainingScreen> createState() => _TrainingScreenState();
}

class _TrainingScreenState extends State<TrainingScreen> {
  final FlutterTts _flutterTts = FlutterTts();
  late List<HangulCharacter> _characters;
  late Map<String, int> _correctCounts;
  late Map<String, int> _sessionCorrectCounts;
  int _totalCorrect = 0;
  int _globalWrongCount = 0;
  TrainingMode? _currentMode;
  HangulCharacter? _currentQuestion;
  List<String> _options = [];
  String? _selectedOption;
  bool _showResult = false;
  bool _isCorrect = false;
  // Session state: keep track of (character, mode) pairs answered correctly
  final Set<String> _sessionCorrectPairs = <String>{};
  // Avoid consecutive same mode or same character
  TrainingMode? _lastMode;
  String? _lastCharacterSymbol;
  final Random _rand = Random();

  bool get _isVowelTraining =>
      identical(widget.sections, vowelSections) ||
      (widget.sections.isNotEmpty && widget.sections.first.title == '기본 모음');

  bool get _isConsonantTraining =>
      identical(widget.sections, consonantSections) ||
      (widget.sections.isNotEmpty &&
          widget.sections.first.characters.isNotEmpty &&
          widget.sections.first.characters.first.type ==
              HangulCharacterType.consonant);

  // When generating vowel-sequence questions we synthesize a HangulCharacter
  // where `symbol` is the displayed Hangul (e.g. '아오') and `romanization`
  // is the joined romanizations (e.g. 'a-o' or 'ai'). This lets the
  // rest of the logic treat sequences like ordinary characters.
  HangulCharacter _synthesizeSequence(List<HangulCharacter> parts) {
    final display = parts.map((p) => p.name).join();
    // Join romanizations with '/' so multi-part sequences are unambiguous
    // (e.g. 'o/eo/u/i'). For single-part sequences this will just be the
    // single romanization.
    final roman = parts.map((p) => p.romanization).join('/');
    return HangulCharacter(
      symbol: display,
      name: display,
      romanization: roman,
      example: '',
      type: HangulCharacterType.vowel,
    );
  }

  bool _hasVariedParts(List<HangulCharacter> parts) {
    if (parts.length < 2) return false;
    final first = parts.first.name;
    return parts.any((p) => p.name != first);
  }

  @override
  void initState() {
    super.initState();
    _flutterTts.setLanguage('ko-KR');
    _loadCounts();
  }

  Future<void> _loadCounts() async {
    final prefs = await SharedPreferences.getInstance();
    // Load counts for all characters
    final baseCharacters = widget.sections
        .expand((section) => section.characters)
        .toList();
    final extraCharacters = _isConsonantTraining
        ? consonantTrainingWordPool
        : const <HangulCharacter>[];
    final allCharacters = [...baseCharacters, ...extraCharacters];
    final counts = <String, int>{};
    for (var c in allCharacters) {
      counts[c.symbol] = prefs.getInt('correct_${c.symbol}') ?? 0;
    }

    // Determine active sections
    final activeSections = <HangulSection>[];
    for (var section in widget.sections) {
      activeSections.add(section);
      // Determine threshold: for vowel training permit advancing a section
      // once the minimum correct count in the row reaches 3; otherwise
      // use the existing threshold of 10.
      final threshold = _isVowelTraining ? 3 : 10;
      // Check if all characters in this section have at least `threshold`
      // correct answers.
      final minCorrect = section.characters
          .map((c) => counts[c.symbol]!)
          .reduce((a, b) => a < b ? a : b);
      if (minCorrect < threshold) {
        break; // Stop at the first section that doesn't meet the criteria
      }
    }

    // Set active characters
    _characters = activeSections
        .expand((section) => section.characters)
        .toList();

    if (_isConsonantTraining) {
      _characters = [..._characters, ...consonantTrainingWordPool];
    }

    setState(() {
      _correctCounts = counts;
      _sessionCorrectCounts = {};
      _globalWrongCount = prefs.getInt('global_wrong_count') ?? 0;
    });
    _startNewQuestion();
  }

  Future<void> _updateCountsAndSave() async {
    for (var entry in _sessionCorrectCounts.entries) {
      _correctCounts[entry.key] =
          (_correctCounts[entry.key] ?? 0) + entry.value;
    }
    await _saveCounts();
  }

  Future<void> _saveCounts() async {
    final prefs = await SharedPreferences.getInstance();
    for (var entry in _correctCounts.entries) {
      await prefs.setInt('correct_${entry.key}', entry.value);
    }
    await prefs.setInt('global_wrong_count', _globalWrongCount);
  }

  void _startNewQuestion() {
    // Build available modes
    final modes = [
      TrainingMode(GivenType.hangul, ChooseType.romanization),
      TrainingMode(GivenType.hangul, ChooseType.sound),
      TrainingMode(GivenType.sound, ChooseType.hangul),
      TrainingMode(GivenType.romanization, ChooseType.hangul),
    ];

    // Build list of candidate (character, mode) pairs and apply constraints:
    // - not the same character as last
    // - not the same mode as last
    // - not already answered-correct in this session
    final candidates = <MapEntry<HangulCharacter, TrainingMode>>[];

    // If this is vowel training, include synthesized sequences (2-4 parts)
    // made from vowel names (which already include leading ㅇ like '아').
    List<HangulCharacter> poolCharacters = _characters;
    if (_isVowelTraining) {
      final sequences = _buildVowelSequencePool();
      poolCharacters = [..._characters, ...sequences];
    }

    for (final c in poolCharacters) {
      for (final m in modes) {
        final key = '${c.symbol}|${m.given.index}-${m.choose.index}';
        if (_sessionCorrectPairs.contains(key)) continue;
        if (_lastCharacterSymbol != null && c.symbol == _lastCharacterSymbol)
          continue;
        if (_lastMode != null &&
            m.given == _lastMode!.given &&
            m.choose == _lastMode!.choose)
          continue;
        candidates.add(MapEntry(c, m));
      }
    }

    // If no candidates remain under constraints, relax only the "not same mode"
    // or the "not same character" rule in stages to avoid deadlocking too early.
    if (candidates.isEmpty) {
      for (final c in _characters) {
        for (final m in modes) {
          final key = '${c.symbol}|${m.given.index}-${m.choose.index}';
          if (_sessionCorrectPairs.contains(key)) continue;
          if (_lastCharacterSymbol != null && c.symbol == _lastCharacterSymbol)
            continue;
          candidates.add(MapEntry(c, m));
        }
      }
    }
    if (candidates.isEmpty) {
      for (final c in _characters) {
        for (final m in modes) {
          final key = '${c.symbol}|${m.given.index}-${m.choose.index}';
          if (_sessionCorrectPairs.contains(key)) continue;
          candidates.add(MapEntry(c, m));
        }
      }
    }

    if (candidates.isEmpty) {
      // No remaining unseen/correct-excluded problems: finish session
      _showCompletionDialog();
      return;
    }

    // Choose randomly from candidates with consonant bias if needed
    final choicePool = _isConsonantTraining
        ? _prioritizeConsonantCandidates(candidates)
        : candidates;
    final choice = choicePool[_rand.nextInt(choicePool.length)];
    _currentQuestion = choice.key;
    _currentMode = choice.value;

    // Save last chosen for consecutive-avoidance
    _lastMode = _currentMode;
    _lastCharacterSymbol = _currentQuestion!.symbol;

    // Generate options
    _options = _generateOptions();

    _selectedOption = null;
    _showResult = false;
  }

  String _getNameFromSymbol(String symbol) {
    final idx = _characters.indexWhere((c) => c.symbol == symbol);
    if (idx != -1) {
      return _pronunciationFor(_characters[idx]);
    }
    // If not found (e.g. synthesized sequence), return the symbol itself
    return symbol;
  }

  String _pronunciationFor(HangulCharacter char) {
    if (char.type == HangulCharacterType.consonant &&
        _isHangulJamo(char.symbol)) {
      final override = _consonantSoundOverrides[char.symbol];
      if (override != null) return override;
    }
    return char.name;
  }

  List<HangulCharacter> _buildVowelSequencePool() {
    // Build a pool of synthesized vowel sequences (length 2..4). We try to
    // prefer plausible/word-like small sequences and also include random
    // combinations so the user sees a variety. Names already include the
    // leading ㅇ (e.g. '아').
    final vowels = _characters
        .where((c) => c.type == HangulCharacterType.vowel)
        .toList();
    final byName = {for (var v in vowels) v.name: v};

    final preferred = <List<HangulCharacter>>[];
    // common interjections / sequences to bias towards (if parts exist)
    final commonNames = [
      ['우', '와'],
      ['이', '야'],
      ['아', '이'],
      ['오', '우'],
      ['이', '에'],
      ['우', '아'],
    ];
    for (final combo in commonNames) {
      final parts = combo
          .map((n) => byName[n])
          .whereType<HangulCharacter>()
          .toList();
      if (parts.length == combo.length) preferred.add(parts);
    }

    // Randomly generate additional combinations to reach a modest pool size.
    final seqs = <String, HangulCharacter>{};
    final rand = _rand;
    // Include single vowels as well (but they already exist in _characters)
    for (var v in vowels) {
      seqs[v.name] = v;
    }

    // Add preferred combos first
    for (var parts in preferred) {
      if (_hasVariedParts(parts)) {
        final s = _synthesizeSequence(parts);
        seqs[s.symbol] = s;
      }
    }

    // Then generate random combos of length 2..4
    final attempts = 100;
    for (var i = 0; i < attempts && seqs.length < 40; i++) {
      final len = 2 + rand.nextInt(3); // 2..4
      final parts = List.generate(
        len,
        (_) => vowels[rand.nextInt(vowels.length)],
      );
      if (!_hasVariedParts(parts)) continue;
      final s = _synthesizeSequence(parts);
      seqs[s.symbol] = s;
    }

    // Return only synthesized sequences of length >=2 to avoid duplicating
    // the original single-character list in candidates.
    return seqs.values.where((c) => c.name.length >= 2).toList();
  }

  List<MapEntry<HangulCharacter, TrainingMode>> _prioritizeConsonantCandidates(
    List<MapEntry<HangulCharacter, TrainingMode>> candidates,
  ) {
    if (candidates.isEmpty) return candidates;
    final priorities = _buildConsonantPreferenceOrder();
    for (final category in priorities) {
      final bucket = candidates
          .where((entry) => _categoryOf(entry.key) == category)
          .toList();
      if (bucket.isNotEmpty) return bucket;
    }
    return candidates;
  }

  List<ConsonantQuestionCategory> _buildConsonantPreferenceOrder() {
    final picked = _rollConsonantCategory();
    final order = [
      picked,
      ConsonantQuestionCategory.batchimWord,
      ConsonantQuestionCategory.openSyllable,
      ConsonantQuestionCategory.single,
    ];
    final result = <ConsonantQuestionCategory>[];
    final visited = <ConsonantQuestionCategory>{};
    for (final item in order) {
      if (visited.add(item)) {
        result.add(item);
      }
    }
    return result;
  }

  ConsonantQuestionCategory _rollConsonantCategory() {
    final value = _rand.nextDouble();
    if (value < 0.15) return ConsonantQuestionCategory.single;
    if (value < 0.55) return ConsonantQuestionCategory.openSyllable;
    return ConsonantQuestionCategory.batchimWord;
  }

  List<String> _generateOptions() {
    final correct = _getCorrectOption();
    final question = _currentQuestion!;
    List<HangulCharacter> pool;
    bool enforceSequenceLength = false;
    int? targetConsonantLength;
    ConsonantQuestionCategory? questionCategory;

    if (_isVowelTraining &&
        question.type == HangulCharacterType.vowel &&
        question.name.length >= 2) {
      pool = _buildVowelSequencePool();
      enforceSequenceLength = true;
    } else if (_isConsonantTraining) {
      questionCategory = _categoryOf(question);
      final length = _syllableLength(question.symbol);
      targetConsonantLength = length;
      final categoryPool = _characters
          .where((c) => _categoryOf(c) == questionCategory)
          .toList();
      final sameLengthPool = categoryPool
          .where((c) => _syllableLength(c.symbol) == length)
          .toList();

      pool = sameLengthPool.length >= 6 ? sameLengthPool : categoryPool;
    } else {
      pool = _characters;
    }

    List<HangulCharacter> optionsPool = pool.where((c) {
      if (_getOptionValue(c) == correct) return false;
      if (enforceSequenceLength &&
          question.name.length >= 2 &&
          c.name.length != question.name.length) {
        return false;
      }
      if (targetConsonantLength != null &&
          _syllableLength(c.symbol) != targetConsonantLength) {
        return false;
      }
      return true;
    }).toList();

    if (optionsPool.length < 5) {
      optionsPool = _buildFallbackOptions(
        correctOption: correct,
        question: question,
        enforceSequenceLength: enforceSequenceLength,
        targetConsonantLength: targetConsonantLength,
        categoryOverride: questionCategory,
      );
    }

    optionsPool.shuffle();
    final selectedOthers = optionsPool
        .take(5)
        .map((c) => _getOptionValue(c))
        .toList();
    selectedOthers.add(correct);
    selectedOthers.shuffle();
    return selectedOthers;
  }

  List<HangulCharacter> _buildFallbackOptions({
    required String correctOption,
    required HangulCharacter question,
    required bool enforceSequenceLength,
    required int? targetConsonantLength,
    ConsonantQuestionCategory? categoryOverride,
  }) {
    List<HangulCharacter> pool;
    if (_isConsonantTraining) {
      final category = categoryOverride ?? _categoryOf(question);
      final desiredLength =
          targetConsonantLength ?? _syllableLength(question.symbol);
      pool = _characters.where((c) {
        if (_getOptionValue(c) == correctOption) return false;
        if (_categoryOf(c) != category) return false;
        if (_syllableLength(c.symbol) != desiredLength) return false;
        return true;
      }).toList();

      if (pool.length >= 5) {
        return pool;
      }

      return _characters.where((c) {
        if (_getOptionValue(c) == correctOption) return false;
        return _categoryOf(c) == category;
      }).toList();
    }

    if (enforceSequenceLength) {
      pool = _buildVowelSequencePool().where((c) {
        if (_getOptionValue(c) == correctOption) return false;
        return c.name.length == question.name.length;
      }).toList();
      if (pool.length >= 5) {
        return pool;
      }
    }

    return _characters
        .where((c) => _getOptionValue(c) != correctOption)
        .toList();
  }

  String _getCorrectOption() {
    return _getOptionValue(_currentQuestion!);
  }

  String _getOptionValue(HangulCharacter char) {
    switch (_currentMode!.choose) {
      case ChooseType.romanization:
        return char.romanization;
      case ChooseType.sound:
        return char.symbol; // For sound, we use symbol but will play TTS
      case ChooseType.hangul:
        // For vowel training prefer the 'name' (which includes leading ㅇ)
        if (char.type == HangulCharacterType.vowel) return char.name;
        return char.symbol;
    }
  }

  ConsonantQuestionCategory _categoryOf(HangulCharacter char) {
    final symbol = char.symbol;
    if (consonantBatchimWordSymbols.contains(symbol)) {
      return ConsonantQuestionCategory.batchimWord;
    }
    if (consonantOpenWordSymbols.contains(symbol)) {
      return ConsonantQuestionCategory.openSyllable;
    }
    if (_isHangulJamo(symbol)) {
      return ConsonantQuestionCategory.single;
    }
    if (_hasBatchim(symbol)) {
      return ConsonantQuestionCategory.batchimWord;
    }
    return ConsonantQuestionCategory.openSyllable;
  }

  int _syllableLength(String text) => text.runes.length;

  bool _isHangulJamo(String text) {
    if (text.runes.length != 1) return false;
    final code = text.runes.first;
    const jamoStart = 0x3131;
    const jamoEnd = 0x318E;
    const choseongStart = 0x1100;
    const choseongEnd = 0x11FF;
    return (code >= jamoStart && code <= jamoEnd) ||
        (code >= choseongStart && code <= choseongEnd);
  }

  bool _hasBatchim(String text) {
    for (final rune in text.runes) {
      const base = 0xAC00;
      const last = 0xD7A3;
      if (rune < base || rune > last) continue;
      final relative = rune - base;
      final jong = relative % 28;
      if (jong > 0) return true;
    }
    return false;
  }

  String _getGivenDisplay() {
    switch (_currentMode!.given) {
      case GivenType.hangul:
        // For vowel training prefer the readable name (e.g. '아') so the
        // displayed syllable includes an initial ㅇ. For synthesized
        // sequences the name is already the joined display.
        return _currentQuestion!.type == HangulCharacterType.vowel
            ? _currentQuestion!.name
            : _currentQuestion!.symbol;
      case GivenType.sound:
        // Will play TTS
        return '🔊'; // Placeholder
      case GivenType.romanization:
        return _currentQuestion!.romanization;
    }
  }

  String _meaningLine() {
    final meaning = _currentQuestion?.meaning;
    if (meaning == null || meaning.isEmpty) return '';
    return '\n뜻: $meaning';
  }

  void _playSound(String symbol) async {
    final text = _getNameFromSymbol(symbol);
    await _flutterTts.speak(text);
  }

  void _onOptionSelected(String option) {
    // When selecting an option, for TTS-type choices we want to play the
    // audio immediately and treat the tap as both "play" and "select".
    // We play audio on tap and mark selection, but do NOT auto-check the
    // answer here — the user must press '정답확인' to reveal correctness.
    final wasSoundChoice = _currentMode?.choose == ChooseType.sound;
    if (wasSoundChoice) {
      _playSound(option);
    }

    setState(() {
      _selectedOption = option;
    });
  }

  void _checkAnswer() async {
    final correct = _getCorrectOption();
    final isCorrect = _selectedOption == correct;
    setState(() {
      _showResult = true;
      _isCorrect = isCorrect;
      if (isCorrect) {
        _totalCorrect++;
        final sym = _currentQuestion!.symbol;
        _sessionCorrectCounts[sym] = (_sessionCorrectCounts[sym] ?? 0) + 1;
        // Mark this (vowel, mode) pair as completed for this session so it
        // won't be presented again until the training screen is recreated.
        final key =
            '${_currentQuestion!.symbol}|${_currentMode!.given.index}-${_currentMode!.choose.index}';
        _sessionCorrectPairs.add(key);
      } else {
        _globalWrongCount++;
        if (_globalWrongCount >= 5) {
          _showAdDialog();
          _globalWrongCount = 0;
        }
        _saveCounts();
      }
    });
    _rememberCurrentWord();
    if (_totalCorrect == 10) {
      await _updateCountsAndSave();
      _showCompletionDialog();
    } else if (_totalCorrect == 9) {
      _showPreCompletionDialog();
    }
  }

  void _rememberCurrentWord() {
    if (!_isConsonantTraining) return;
    final current = _currentQuestion;
    if (current == null) return;
    if (_categoryOf(current) == ConsonantQuestionCategory.single) return;
    unawaited(_recordLearnedWord(current));
  }

  Future<void> _recordLearnedWord(HangulCharacter char) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_learnedWordsPrefsKey);
      final entries = raw == null
          ? <LearnedWordEntry>[]
          : (jsonDecode(raw) as List<dynamic>)
                .map(
                  (item) => LearnedWordEntry.fromJson(
                    Map<String, dynamic>.from(item as Map),
                  ),
                )
                .toList();
      final idx = entries.indexWhere((e) => e.term == char.symbol);
      final now = DateTime.now();
      if (idx == -1) {
        entries.add(
          LearnedWordEntry(
            term: char.symbol,
            romanization: char.romanization,
            meaning: char.meaning,
            seenAt: now,
            timesSeen: 1,
          ),
        );
      } else {
        final existing = entries[idx];
        entries[idx] = existing.copyWith(
          seenAt: now,
          timesSeen: existing.timesSeen + 1,
        );
      }
      entries.sort((a, b) => b.seenAt.compareTo(a.seenAt));
      await prefs.setString(
        _learnedWordsPrefsKey,
        jsonEncode(entries.map((e) => e.toJson()).toList()),
      );
    } catch (_) {
      // Ignore persistence failures to avoid interrupting 학습 흐름.
    }
  }

  void _nextQuestion() {
    setState(() {
      _startNewQuestion();
    });
  }

  void _restartSession() {
    setState(() {
      _totalCorrect = 0;
      _sessionCorrectPairs.clear();
      _sessionCorrectCounts.clear();
      _startNewQuestion();
    });
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (_) => LearnHangulDialog(
        title: '훈련 완료!',
        message: '총 맞힌 수: $_totalCorrect, 틀린 수: $_globalWrongCount',
        variant: LearnHangulDialogVariant.success,
        actions: [
          LearnHangulDialogAction(label: '한 번 더 풀기', onTap: _restartSession),
          LearnHangulDialogAction(
            label: '홈으로 가기',
            isPrimary: true,
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
    // Show interstitial ad here
  }

  void _showPreCompletionDialog() {
    showDialog(
      context: context,
      builder: (_) => LearnHangulDialog(
        title: '훈련 종료 안내',
        message: '세션이 끝나면 지금까지 맞힌 문제들의 정답 카운트가 올라갑니다. 계속하시겠습니까?',
        variant: LearnHangulDialogVariant.info,
        actions: [
          LearnHangulDialogAction(
            label: '계속하기',
            onTap: () {
              // Just close dialog, continue to next question
            },
          ),
        ],
      ),
    );
  }

  void _showAdDialog() {
    showDialog(
      context: context,
      builder: (_) => const LearnHangulDialog(
        title: '잠깐 숨 돌려요',
        message: '집중력이 흔들릴 땐 짧은 광고나 스트레칭으로 리셋해주세요.',
        variant: LearnHangulDialogVariant.warning,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_currentMode == null || _currentQuestion == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final palette = LearnHangulTheme.paletteOf(context);
    final typography = LearnHangulTheme.typographyOf(context);

    final bool canCheck = !_showResult && _selectedOption != null;
    final bool canAdvance = _showResult && _totalCorrect < 10;
    final String buttonLabel = !_showResult
        ? '정답 확인'
        : (_totalCorrect >= 10 ? '완료' : '다음 문제');
    final VoidCallback? primaryAction = !_showResult
        ? (canCheck ? _checkAnswer : null)
        : (canAdvance ? _nextQuestion : null);
    final meaningLine = _meaningLine();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
          child: Column(
            children: [
              Row(
                children: [
                  LiquidGlassButtons.circularIconButton(
                    context,
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icons.arrow_back,
                  ),
                  const SizedBox(width: 16),
                  _buildProgressMeter(
                    context: context,
                    label: '맞힌 문제',
                    value: _totalCorrect,
                    goal: 10,
                    color: palette.success,
                  ),
                  const SizedBox(width: 16),
                  _buildProgressMeter(
                    context: context,
                    label: '실수 카운트',
                    value: _globalWrongCount,
                    goal: 5,
                    color: palette.danger,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              LearnHangulSurface(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 32,
                ),
                child: Column(
                  children: [
                    Text(
                      _getGivenDisplay(),
                      style: typography.hero.copyWith(fontSize: 40),
                    ),
                    if (_currentMode!.given == GivenType.sound)
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: LiquidGlassButton(
                          label: '발음 다시 듣기',
                          leading: Icon(
                            Icons.volume_up_rounded,
                            color: palette.primaryText,
                          ),
                          variant: LiquidGlassButtonVariant.secondary,
                          expand: false,
                          onPressed: () => _playSound(_currentQuestion!.symbol),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: GridView.builder(
                  padding: EdgeInsets.zero,
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 18,
                    crossAxisSpacing: 18,
                    childAspectRatio: 1.1,
                  ),
                  itemCount: _options.length,
                  itemBuilder: (context, index) {
                    final option = _options[index];
                    return _buildOptionCard(
                      context: context,
                      option: option,
                      isCorrectAnswer: option == _getCorrectOption(),
                      isSelected: option == _selectedOption,
                      showIcon:
                          _currentMode!.choose == ChooseType.sound &&
                          !_showResult,
                      onTap: _showResult
                          ? null
                          : () => _onOptionSelected(option),
                    );
                  },
                ),
              ),
              if (_showResult) ...[
                const SizedBox(height: 12),
                LearnHangulNotice(
                  title: _isCorrect ? '정답이에요' : '다시 시도해요',
                  message: _isCorrect
                      ? '${_getCorrectOption()} 발음을 정확히 기억하고 있어요.$meaningLine'
                      : '정답은 ${_getCorrectOption()} 입니다. 다음 문제에서 만회해보세요.$meaningLine',
                  type: _isCorrect
                      ? LearnHangulNoticeType.success
                      : LearnHangulNoticeType.warning,
                ),
              ],
              const SizedBox(height: 12),
              LiquidGlassButton(
                label: buttonLabel,
                onPressed: primaryAction,
                variant: LiquidGlassButtonVariant.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionCard({
    required BuildContext context,
    required String option,
    required bool isCorrectAnswer,
    required bool isSelected,
    required bool showIcon,
    required VoidCallback? onTap,
  }) {
    final palette = LearnHangulTheme.paletteOf(context);
    final typography = LearnHangulTheme.typographyOf(context);

    Color background = palette.surface;
    Color border = palette.outline;
    Color foreground = palette.primaryText;

    if (_showResult) {
      if (isCorrectAnswer) {
        background = palette.success.withOpacity(0.15);
        border = palette.success;
        foreground = palette.success;
      } else if (isSelected && !_isCorrect) {
        background = palette.danger.withOpacity(0.15);
        border = palette.danger;
        foreground = palette.danger;
      }
    } else if (isSelected) {
      background = palette.info.withOpacity(0.12);
      border = palette.info.withOpacity(0.5);
      foreground = palette.info;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 240),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: border),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: BorderRadius.circular(28),
          onTap: onTap,
          child: Center(
            child: showIcon
                ? Icon(Icons.volume_up_rounded, color: foreground, size: 34)
                : Text(
                    option,
                    textAlign: TextAlign.center,
                    style: typography.heading.copyWith(color: foreground),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressMeter({
    required BuildContext context,
    required String label,
    required int value,
    required int goal,
    required Color color,
  }) {
    final typography = LearnHangulTheme.typographyOf(context);
    final palette = LearnHangulTheme.paletteOf(context);
    final progress = (value / goal).clamp(0.0, 1.0);

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: typography.caption),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: palette.surface,
              color: color,
            ),
          ),
          const SizedBox(height: 6),
          Text('$value / $goal', style: typography.caption),
        ],
      ),
    );
  }
}
