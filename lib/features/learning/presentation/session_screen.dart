import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/model/domain.dart';
import '../../../core/providers.dart';
import '../../../data/local/app_database.dart';
import '../../../l10n/app_localizations.dart';
import '../../settings/application/settings_controller.dart';
import '../domain/srs_engine.dart';
import '../domain/typing_engine.dart';

class SessionScreen extends ConsumerStatefulWidget {
  const SessionScreen({required this.mode, this.setId, super.key});
  final String mode;
  final String? setId;

  @override
  ConsumerState<SessionScreen> createState() => _SessionScreenState();
}

class _SessionScreenState extends ConsumerState<SessionScreen> {
  final typingController = TextEditingController();
  final focusNode = FocusNode();
  final typingEngine = const TypingEngine();
  final srsEngine = const SrsEngine();
  List<VocabularyItem> items = const [];
  Map<String, VocabularySet> sets = const {};
  int index = 0;
  int correct = 0;
  int almost = 0;
  int wrong = 0;
  bool loading = true;
  bool revealed = false;
  int hintLevel = 0;
  TypingEvaluation? typingResult;
  String? quizSelection;
  String? quizCorrectAnswer;
  double dragX = 0;

  @override
  void initState() {
    super.initState();
    typingController.addListener(() => setState(() {}));
    Future.microtask(_load);
  }

  Future<void> _load() async {
    final db = ref.read(databaseProvider);
    final due = await db.watchDueItems(setId: widget.setId).first;
    final allSets = await db.allSets();
    if (!mounted) return;
    setState(() {
      items = due;
      sets = {for (final set in allSets) set.id: set};
      loading = false;
    });
  }

  @override
  void dispose() {
    typingController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  VocabularyItem get current => items[index];

  String _directionFor(VocabularyItem item) =>
      item.directionOverride ??
      sets[item.setId]?.defaultDirection ??
      ref.read(settingsControllerProvider).value?.direction ??
      'foreign_to_de';

  String _prompt(VocabularyItem item) => _directionFor(item) == 'foreign_to_de'
      ? item.sourceText
      : item.targetText;

  String _answer(VocabularyItem item) => _directionFor(item) == 'foreign_to_de'
      ? item.targetText
      : item.sourceText;

  String _answerLang(VocabularyItem item) =>
      _directionFor(item) == 'foreign_to_de'
      ? item.targetLang
      : item.sourceLang;

  String _modeForCurrent() {
    if (_temporaryMode != null) return _temporaryMode!;
    if (widget.mode != 'mixed') return widget.mode;
    final share = ref.read(settingsControllerProvider).value?.typingShare ?? 50;
    if (!current.typingEnabled || share == 0) return 'cards';
    if (share == 100) return 'typing';
    return index % 100 < share ? 'typing' : 'cards';
  }

  void _resetCardState() {
    typingController.clear();
    typingResult = null;
    revealed = false;
    hintLevel = 0;
    quizSelection = null;
    quizCorrectAnswer = null;
    dragX = 0;
    _temporaryMode = null;
  }

  Future<void> _grade(TypingGrade grade) async {
    final item = current;
    final snapshot = srsEngine.grade(item, grade);
    await ref.read(databaseProvider).updateSrs(item, snapshot);
    switch (grade) {
      case TypingGrade.full:
        correct++;
        break;
      case TypingGrade.almost:
        almost++;
        break;
      case TypingGrade.fail:
        wrong++;
        break;
    }
    if (index + 1 >= items.length) {
      if (!mounted) return;
      setState(() => index++);
      return;
    }
    setState(() {
      index++;
      _resetCardState();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (items.isEmpty || index >= items.length) {
      return _SessionResult(correct: correct, almost: almost, wrong: wrong);
    }
    final mode = _modeForCurrent();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('${index + 1} / ${items.length}'),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: LinearProgressIndicator(
            value: (index + 1) / items.length,
            minHeight: 4,
          ),
        ),
      ),
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 380),
          switchInCurve: Curves.easeOutBack,
          switchOutCurve: Curves.easeInCubic,
          child: switch (mode) {
            'typing' => _typingView(),
            'quiz' => _quizView(),
            _ => _cardView(),
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _FloatingSessionToolbar(
        active: mode,
        onCards: () => setState(() => _temporaryMode = 'cards'),
        onTyping: () => setState(() => _temporaryMode = 'typing'),
      ),
    );
  }

  String? _temporaryMode;

  Widget _cardView() {
    final l = AppLocalizations.of(context)!;
    final answer = _answer(current);
    return Padding(
      key: ValueKey('card-${current.id}'),
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 90),
      child: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onPanUpdate: (details) =>
                  setState(() => dragX += details.delta.dx),
              onPanEnd: (_) {
                if (dragX > 90) _grade(TypingGrade.full);
                if (dragX < -90) _grade(TypingGrade.fail);
                setState(() => dragX = 0);
              },
              onTap: () => setState(() => revealed = !revealed),
              child: Transform.translate(
                offset: Offset(dragX, 0),
                child: Transform.rotate(
                  angle: dragX / 1600,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutBack,
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(28),
                    decoration: ShapeDecoration(
                      color: revealed
                          ? Theme.of(context).colorScheme.secondaryContainer
                          : Theme.of(context).colorScheme.surfaceContainerLow,
                      shape: RoundedRectangleBorder(
                        borderRadius: revealed
                            ? BorderRadius.circular(54)
                            : const BorderRadius.only(
                                topLeft: Radius.circular(46),
                                topRight: Radius.circular(18),
                                bottomLeft: Radius.circular(18),
                                bottomRight: Radius.circular(46),
                              ),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          revealed ? answer : _prompt(current),
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                        const SizedBox(height: 14),
                        Text(revealed ? 'Antwort' : l.learnReveal),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (revealed)
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _grade(TypingGrade.fail),
                    child: Text(l.learnUnknown),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton.tonal(
                    onPressed: () => _grade(TypingGrade.almost),
                    child: Text(l.learnUnsure),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton(
                    onPressed: () => _grade(TypingGrade.full),
                    child: Text(l.learnKnown),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _typingView() {
    final l = AppLocalizations.of(context)!;
    final answer = _answer(current);
    final settings = ref.read(settingsControllerProvider).value;
    final rules = TypingRules(
      strictCase: settings?.strictCase ?? false,
      strictAccents: settings?.strictAccents ?? false,
    );
    final live = typingEngine.liveDiff(typingController.text, answer, rules);
    final submitted = typingResult != null;
    return ListView(
      key: ValueKey('typing-${current.id}'),
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 110),
      children: [
        Text(l.learnTypePrompt, style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 8),
        Text(
          _prompt(current),
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        const SizedBox(height: 28),
        TextField(
          controller: typingController,
          focusNode: focusNode,
          enabled: !submitted,
          enableSuggestions: false,
          autocorrect: false,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => _submitTyping(rules),
          decoration: InputDecoration(
            labelText: l.learnTypePrompt,
            suffixIcon: submitted
                ? const Icon(Icons.lock_rounded)
                : const Icon(Icons.keyboard_alt_rounded),
          ),
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 10),
        if (!submitted && live.isNotEmpty) _LiveDiff(tokens: live),
        const SizedBox(height: 12),
        _SpecialCharacters(
          lang: _answerLang(current),
          onInsert: _insertCharacter,
        ),
        const SizedBox(height: 18),
        if (!submitted)
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () =>
                      setState(() => hintLevel = math.min(3, hintLevel + 1)),
                  icon: const Icon(Icons.lightbulb_outline_rounded),
                  label: Text(l.hintLabel),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: FilledButton(
                  onPressed: typingController.text.trim().isEmpty
                      ? null
                      : () => _submitTyping(rules),
                  child: Text(l.learnSubmit),
                ),
              ),
            ],
          ),
        if (hintLevel > 0 && !submitted) ...[
          const SizedBox(height: 12),
          _hint(answer),
        ],
        if (submitted) ...[
          const SizedBox(height: 14),
          _typingResultCard(answer),
        ],
      ],
    );
  }

  void _insertCharacter(String value) {
    final selection = typingController.selection;
    final text = typingController.text;
    final start = selection.isValid ? selection.start : text.length;
    final end = selection.isValid ? selection.end : text.length;
    typingController.value = TextEditingValue(
      text: text.replaceRange(start, end, value),
      selection: TextSelection.collapsed(offset: start + value.length),
    );
    focusNode.requestFocus();
  }

  void _submitTyping(TypingRules rules) {
    if (typingController.text.trim().isEmpty) return;
    final result = typingEngine.evaluate(
      typingController.text,
      _answer(current),
      rules,
    );
    setState(() => typingResult = result);
    if (result.grade == TypingGrade.full) {
      Future.delayed(const Duration(milliseconds: 550), () {
        if (mounted && typingResult == result) _grade(TypingGrade.full);
      });
    }
  }

  Widget _typingResultCard(String answer) {
    final l = AppLocalizations.of(context)!;
    final result = typingResult!;
    final scheme = Theme.of(context).colorScheme;
    final color = switch (result.grade) {
      TypingGrade.full => scheme.primaryContainer,
      TypingGrade.almost => scheme.tertiaryContainer,
      TypingGrade.fail => scheme.errorContainer,
    };
    return AnimatedContainer(
      duration: const Duration(milliseconds: 360),
      curve: Curves.easeOutBack,
      padding: const EdgeInsets.all(20),
      decoration: ShapeDecoration(color: color, shape: const StadiumBorder()),
      child: Column(
        children: [
          Text(switch (result.grade) {
            TypingGrade.full => l.learnCorrect,
            TypingGrade.almost => l.learnAlmost,
            TypingGrade.fail => l.learnWrong,
          }, style: Theme.of(context).textTheme.titleLarge),
          if (result.grade != TypingGrade.full) ...[
            const SizedBox(height: 8),
            Text(answer, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 12),
            if (result.grade == TypingGrade.fail)
              OutlinedButton(
                onPressed: () => setState(() {
                  typingResult = null;
                  typingController.clear();
                  focusNode.requestFocus();
                }),
                child: Text(l.learnTryAgain),
              )
            else
              FilledButton.tonal(
                onPressed: () => _grade(TypingGrade.almost),
                child: Text(l.continueLabel),
              ),
          ],
        ],
      ),
    );
  }

  Widget _hint(String answer) {
    final example = _directionFor(current) == 'foreign_to_de'
        ? current.exampleSentenceTarget
        : current.exampleSentenceSource;
    final value = switch (hintLevel) {
      1 => List.filled(answer.runes.length, '_').join(' '),
      2 =>
        '${answer.characters.first} ${List.filled(math.max(0, answer.runes.length - 1), '_').join(' ')}',
      _ =>
        example == null || example.isEmpty
            ? '${answer.characters.first}…'
            : example.replaceAll(
                RegExp(RegExp.escape(answer), caseSensitive: false),
                '_____',
              ),
    };
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.lightbulb_rounded),
            const SizedBox(width: 12),
            Expanded(child: Text(value)),
          ],
        ),
      ),
    );
  }

  Widget _quizView() {
    final l = AppLocalizations.of(context)!;
    final answer = _answer(current);
    quizCorrectAnswer ??= answer;
    final candidates = <String>{answer};
    for (final item in items) {
      if (item.id != current.id) candidates.add(_answer(item));
      if (candidates.length >= 4) break;
    }
    final options = candidates.toList()
      ..shuffle(math.Random(current.id.hashCode));
    return ListView(
      key: ValueKey('quiz-${current.id}'),
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 110),
      children: [
        Text(l.quizChoose, style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 8),
        Text(
          _prompt(current),
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        const SizedBox(height: 28),
        for (final option in options) ...[
          ChoiceChip(
            label: SizedBox(width: double.infinity, child: Text(option)),
            selected: quizSelection == option,
            onSelected: quizSelection == null
                ? (_) {
                    setState(() => quizSelection = option);
                    final grade = option == answer
                        ? TypingGrade.full
                        : TypingGrade.fail;
                    Future.delayed(const Duration(milliseconds: 600), () {
                      if (mounted) _grade(grade);
                    });
                  }
                : null,
          ),
          const SizedBox(height: 10),
        ],
      ],
    );
  }
}

class _LiveDiff extends StatelessWidget {
  const _LiveDiff({required this.tokens});
  final List<DiffToken> tokens;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Wrap(
      spacing: 2,
      children: tokens.map((token) {
        final color = switch (token.kind) {
          DiffKind.correct => scheme.primary,
          DiffKind.transposed => scheme.tertiary,
          DiffKind.missing => scheme.tertiary,
          DiffKind.extra => scheme.error,
          DiffKind.wrong => scheme.error,
        };
        return Container(
          padding: const EdgeInsets.only(bottom: 2),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: color, width: 3)),
          ),
          child: Text(token.char),
        );
      }).toList(),
    );
  }
}

class _SpecialCharacters extends StatelessWidget {
  const _SpecialCharacters({required this.lang, required this.onInsert});
  final String lang;
  final ValueChanged<String> onInsert;

  static const chars = <String, String>{
    'de': 'äöüß',
    'fr': 'àâæçéèêëîïôœùûüÿ',
    'es': 'áéíóúüñ¿¡',
    'it': 'àèéìíîòóùú',
    'pt': 'áâãàçéêíóôõú',
    'pl': 'ąćęłńóśźż',
    'tr': 'çğıİöşü',
  };

  @override
  Widget build(BuildContext context) {
    final values = chars[lang]?.characters.toList() ?? const <String>[];
    if (values.isEmpty) return const SizedBox.shrink();
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: values
            .map(
              (c) => Padding(
                padding: const EdgeInsets.only(right: 6),
                child: ActionChip(label: Text(c), onPressed: () => onInsert(c)),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _FloatingSessionToolbar extends StatelessWidget {
  const _FloatingSessionToolbar({
    required this.active,
    required this.onCards,
    required this.onTyping,
  });
  final String active;
  final VoidCallback onCards;
  final VoidCallback onTyping;

  @override
  Widget build(BuildContext context) => Material(
    elevation: 4,
    color: Theme.of(context).colorScheme.surfaceContainerHigh,
    shape: const StadiumBorder(),
    child: Padding(
      padding: const EdgeInsets.all(5),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton.filledTonal(
            tooltip: 'Karte',
            onPressed: onCards,
            icon: const Icon(Icons.style_rounded),
          ),
          const SizedBox(width: 4),
          IconButton.filled(
            tooltip: 'Tippen',
            onPressed: onTyping,
            icon: const Icon(Icons.keyboard_alt_rounded),
          ),
        ],
      ),
    ),
  );
}

class _SessionResult extends StatelessWidget {
  const _SessionResult({
    required this.correct,
    required this.almost,
    required this.wrong,
  });
  final int correct;
  final int almost;
  final int wrong;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TweenAnimationBuilder<double>(
                tween: Tween(begin: .4, end: 1),
                duration: const Duration(milliseconds: 850),
                curve: Curves.elasticOut,
                builder: (_, value, child) =>
                    Transform.scale(scale: value, child: child),
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: ShapeDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(58),
                        topRight: Radius.circular(28),
                        bottomLeft: Radius.circular(36),
                        bottomRight: Radius.circular(58),
                      ),
                    ),
                  ),
                  child: const Icon(Icons.done_all_rounded, size: 54),
                ),
              ),
              const SizedBox(height: 26),
              Text(
                l.sessionDone,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _Score(label: l.sessionCorrect, value: correct),
                  _Score(label: l.sessionAlmost, value: almost),
                  _Score(label: l.sessionWrong, value: wrong),
                ],
              ),
              const SizedBox(height: 30),
              FilledButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.home_rounded),
                label: Text(l.sessionFinish),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Score extends StatelessWidget {
  const _Score({required this.label, required this.value});
  final String label;
  final int value;
  @override
  Widget build(BuildContext context) => Column(
    children: [
      Text(
        '$value',
        style: Theme.of(
          context,
        ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900),
      ),
      Text(label),
    ],
  );
}
