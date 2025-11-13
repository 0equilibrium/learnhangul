import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

import 'design_system.dart';
import 'models.dart';
import 'widgets.dart';

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
      appBar: LearnHangulAppBar('모음학습'),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  for (final section in vowelSections)
                    HangulSectionCard(
                      section: section,
                      onCharacterTap: (character) =>
                          showCharacterDetails(context, character),
                      correctCounts: _correctCounts ?? {},
                    ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
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
      appBar: LearnHangulAppBar('자음 학습'),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 32),
              children: [
                for (final section in consonantSections)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
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
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
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

  @override
  void initState() {
    super.initState();
    _flutterTts.setLanguage('ko-KR');
    _loadCounts();
  }

  Future<void> _loadCounts() async {
    final prefs = await SharedPreferences.getInstance();
    // Load counts for all characters
    final allCharacters = widget.sections
        .expand((section) => section.characters)
        .toList();
    final counts = <String, int>{};
    for (var c in allCharacters) {
      counts[c.symbol] = prefs.getInt('correct_${c.symbol}') ?? 0;
    }

    // Determine active sections
    final activeSections = <HangulSection>[];
    for (var section in widget.sections) {
      activeSections.add(section);
      // Check if all characters in this section have at least 10 correct answers
      final minCorrect = section.characters
          .map((c) => counts[c.symbol]!)
          .reduce((a, b) => a < b ? a : b);
      if (minCorrect < 10) {
        break; // Stop at the first section that doesn't meet the criteria
      }
    }

    // Set active characters
    _characters = activeSections
        .expand((section) => section.characters)
        .toList();

    setState(() {
      _correctCounts = counts;
      _globalWrongCount = prefs.getInt('global_wrong_count') ?? 0;
    });
    _startNewQuestion();
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

    // Choose randomly from candidates
    final choice = candidates[_rand.nextInt(candidates.length)];
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
    if (idx != -1) return _characters[idx].name;
    // If not found (e.g. synthesized sequence), return the symbol itself
    return symbol;
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
      final s = _synthesizeSequence(parts);
      seqs[s.symbol] = s;
    }

    // Then generate random combos of length 2..4
    final attempts = 100;
    for (var i = 0; i < attempts && seqs.length < 40; i++) {
      final len = 2 + rand.nextInt(3); // 2..4
      final parts = List.generate(
        len,
        (_) => vowels[rand.nextInt(vowels.length)],
      );
      final s = _synthesizeSequence(parts);
      seqs[s.symbol] = s;
    }

    // Return only synthesized sequences of length >=2 to avoid duplicating
    // the original single-character list in candidates.
    return seqs.values.where((c) => c.name.length >= 2).toList();
  }

  List<String> _generateOptions() {
    final correct = _getCorrectOption();
    List<HangulCharacter> pool;
    // If current question is a vowel-sequence, generate distractor sequences
    if (_isVowelTraining &&
        _currentQuestion!.type == HangulCharacterType.vowel &&
        _currentQuestion!.name.length >= 2) {
      pool = _buildVowelSequencePool();
    } else {
      pool = _characters;
    }

    final others = pool.where((c) {
      if (_getOptionValue(c) == correct) return false;
      // For vowel sequences, only include options with the same length
      if (_isVowelTraining &&
          _currentQuestion!.name.length >= 2 &&
          c.name.length != _currentQuestion!.name.length)
        return false;
      return true;
    }).toList();
    others.shuffle();
    final selectedOthers = others
        .take(5)
        .map((c) => _getOptionValue(c))
        .toList();
    selectedOthers.add(correct);
    selectedOthers.shuffle();
    return selectedOthers;
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

  void _checkAnswer() {
    final correct = _getCorrectOption();
    final isCorrect = _selectedOption == correct;
    setState(() {
      _showResult = true;
      _isCorrect = isCorrect;
      if (isCorrect) {
        _totalCorrect++;
        final sym = _currentQuestion!.symbol;
        _correctCounts[sym] = (_correctCounts[sym] ?? 0) + 1;
        // Mark this (vowel, mode) pair as completed for this session so it
        // won't be presented again until the training screen is recreated.
        final key =
            '${_currentQuestion!.symbol}|${_currentMode!.given.index}-${_currentMode!.choose.index}';
        _sessionCorrectPairs.add(key);
        _saveCounts();
      } else {
        _globalWrongCount++;
        if (_globalWrongCount >= 5) {
          _showAdDialog();
          _globalWrongCount = 0;
        }
        _saveCounts();
      }
    });
    if (_totalCorrect >= 10) {
      _showCompletionDialog();
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

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back),
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
                      ? '${_getCorrectOption()} 발음을 정확히 기억하고 있어요.'
                      : '정답은 ${_getCorrectOption()} 입니다. 다음 문제에서 만회해보세요.',
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
