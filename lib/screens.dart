import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
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
      appBar: AppBar(title: const Text('모음 학습')),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 32),
              children: [
                for (final section in vowelSections)
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
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        TrainingScreen(sections: vowelSections),
                  ),
                );
              },
              child: const Text('훈련하기'),
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
      appBar: AppBar(title: const Text('자음 학습')),
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
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        TrainingScreen(sections: consonantSections),
                  ),
                );
              },
              child: const Text('훈련하기'),
            ),
          ),
        ],
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('설정')),
      body: const Center(child: Text('hello world')),
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
      description: '',
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

    final others = pool.where((c) => _getOptionValue(c) != correct).toList();
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

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('훈련 완료!'),
        content: Text('총 맞힌 수: $_totalCorrect, 틀린 수: $_globalWrongCount'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(); // Go back to previous screen
            },
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  void _showAdDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('전면 광고'),
        content: const Text('광고 표시 중...'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_currentMode == null || _currentQuestion == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('훈련')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Progress bars
            LinearProgressIndicator(
              value: _totalCorrect / 10.0,
              backgroundColor: Colors.grey[300],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: _globalWrongCount / 5.0,
              backgroundColor: Colors.grey[300],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.red),
            ),
            const SizedBox(height: 16),
            // Given
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Text(
                    _getGivenDisplay(),
                    style: const TextStyle(fontSize: 36),
                  ),
                  if (_currentMode!.given == GivenType.sound)
                    IconButton(
                      icon: const Icon(Icons.volume_up),
                      onPressed: () => _playSound(_currentQuestion!.symbol),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // Choose
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                childAspectRatio: 1.0,
                children: _options.map((option) {
                  Color? cardColor;
                  if (_showResult) {
                    if (option == _getCorrectOption()) {
                      cardColor = Colors.green.shade100;
                    } else if (_selectedOption == option && !_isCorrect) {
                      cardColor = Colors.red.shade100;
                    }
                  } else {
                    cardColor = _selectedOption == option
                        ? Colors.blue.shade100
                        : null;
                  }
                  return Card(
                    color: cardColor,
                    child: InkWell(
                      onTap: _showResult
                          ? null
                          : () => _onOptionSelected(option),
                      child: Center(
                        child: _currentMode!.choose == ChooseType.sound
                            ? (_showResult
                                  ? Text(
                                      option,
                                      style: const TextStyle(fontSize: 36),
                                    )
                                  : Icon(
                                      Icons.volume_up,
                                      size: 40,
                                      color: Colors.grey[800],
                                    ))
                            : Text(
                                option,
                                style: const TextStyle(fontSize: 24),
                              ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            // Result
            if (_showResult)
              Text(
                _isCorrect
                    ? 'Correct!'
                    : 'Wrong! Correct: ${_getCorrectOption()}',
                style: TextStyle(
                  fontSize: 24,
                  color: _isCorrect ? Colors.green : Colors.red,
                ),
              ),
            const SizedBox(height: 16),
            // Button
            ElevatedButton(
              onPressed: _selectedOption == null
                  ? null
                  : _showResult
                  ? (_totalCorrect >= 10 ? null : _nextQuestion)
                  : _checkAnswer,
              child: Text(
                _showResult ? (_totalCorrect >= 10 ? '완료' : '다음 문제') : '정답확인',
              ),
            ),
            // Counts
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text('맞힌 수: $_totalCorrect, 틀린 수: $_globalWrongCount'),
            ),
          ],
        ),
      ),
    );
  }
}
