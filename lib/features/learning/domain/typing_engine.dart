import 'dart:math' as math;

import '../../../core/model/domain.dart';

enum DiffKind { correct, transposed, missing, extra, wrong }

class DiffToken {
  const DiffToken(this.char, this.kind, {this.expected});

  final String char;
  final String? expected;
  final DiffKind kind;
}

class TypingEvaluation {
  const TypingEvaluation({
    required this.grade,
    required this.distance,
    required this.tokens,
    required this.accentOnly,
  });

  final TypingGrade grade;
  final int distance;
  final List<DiffToken> tokens;
  final bool accentOnly;
}

class TypingRules {
  const TypingRules({this.strictCase = false, this.strictAccents = false});

  final bool strictCase;
  final bool strictAccents;
}

class TypingEngine {
  const TypingEngine();

  TypingEvaluation evaluate(String input, String answer, TypingRules rules) {
    final normalizedInput = _normalize(input, rules, stripAccents: false);
    final normalizedAnswer = _normalize(answer, rules, stripAccents: false);
    final accentFreeInput = _normalize(input, rules, stripAccents: true);
    final accentFreeAnswer = _normalize(answer, rules, stripAccents: true);

    final accentOnly =
        normalizedInput != normalizedAnswer &&
        accentFreeInput == accentFreeAnswer;
    final comparisonInput = rules.strictAccents
        ? normalizedInput
        : accentFreeInput;
    final comparisonAnswer = rules.strictAccents
        ? normalizedAnswer
        : accentFreeAnswer;
    final distance = _damerauLevenshtein(comparisonInput, comparisonAnswer);
    final tokens = _diff(input.trim(), answer.trim(), rules);

    final grade = distance == 0
        ? TypingGrade.full
        : (distance == 1 || (!rules.strictAccents && accentOnly))
        ? TypingGrade.almost
        : TypingGrade.fail;
    return TypingEvaluation(
      grade: grade,
      distance: distance,
      tokens: tokens,
      accentOnly: accentOnly,
    );
  }

  List<DiffToken> liveDiff(String input, String answer, TypingRules rules) {
    if (input.isEmpty) return const [];
    final typed = input.characters.toList();
    final target = answer.characters.toList();
    final out = <DiffToken>[];
    for (var i = 0; i < typed.length; i++) {
      if (i >= target.length) {
        out.add(DiffToken(typed[i], DiffKind.extra));
        continue;
      }
      if (_equalChar(typed[i], target[i], rules)) {
        out.add(DiffToken(typed[i], DiffKind.correct));
        continue;
      }
      if (i + 1 < typed.length &&
          i + 1 < target.length &&
          _equalChar(typed[i], target[i + 1], rules) &&
          _equalChar(typed[i + 1], target[i], rules)) {
        out.add(DiffToken(typed[i], DiffKind.transposed, expected: target[i]));
        continue;
      }
      final appearsNext =
          i + 1 < target.length && _equalChar(typed[i], target[i + 1], rules);
      out.add(
        DiffToken(
          typed[i],
          appearsNext ? DiffKind.missing : DiffKind.wrong,
          expected: target[i],
        ),
      );
    }
    return out;
  }

  List<DiffToken> _diff(String input, String answer, TypingRules rules) {
    final typed = input.characters.toList();
    final target = answer.characters.toList();
    final rows = typed.length + 1;
    final cols = target.length + 1;
    final dp = List.generate(rows, (_) => List<int>.filled(cols, 0));
    for (var i = 0; i < rows; i++) {
      dp[i][0] = i;
    }
    for (var j = 0; j < cols; j++) {
      dp[0][j] = j;
    }

    for (var i = 1; i < rows; i++) {
      for (var j = 1; j < cols; j++) {
        final cost = _equalChar(typed[i - 1], target[j - 1], rules) ? 0 : 1;
        dp[i][j] = math.min(
          math.min(dp[i - 1][j] + 1, dp[i][j - 1] + 1),
          dp[i - 1][j - 1] + cost,
        );
        if (i > 1 &&
            j > 1 &&
            _equalChar(typed[i - 1], target[j - 2], rules) &&
            _equalChar(typed[i - 2], target[j - 1], rules)) {
          dp[i][j] = math.min(dp[i][j], dp[i - 2][j - 2] + 1);
        }
      }
    }

    var i = typed.length;
    var j = target.length;
    final reverse = <DiffToken>[];
    while (i > 0 || j > 0) {
      if (i > 1 &&
          j > 1 &&
          _equalChar(typed[i - 1], target[j - 2], rules) &&
          _equalChar(typed[i - 2], target[j - 1], rules) &&
          dp[i][j] == dp[i - 2][j - 2] + 1) {
        reverse.add(
          DiffToken(typed[i - 1], DiffKind.transposed, expected: target[j - 1]),
        );
        reverse.add(
          DiffToken(typed[i - 2], DiffKind.transposed, expected: target[j - 2]),
        );
        i -= 2;
        j -= 2;
      } else if (i > 0 && j > 0 && dp[i][j] == dp[i - 1][j - 1]) {
        reverse.add(DiffToken(typed[i - 1], DiffKind.correct));
        i--;
        j--;
      } else if (i > 0 && j > 0 && dp[i][j] == dp[i - 1][j - 1] + 1) {
        reverse.add(
          DiffToken(typed[i - 1], DiffKind.wrong, expected: target[j - 1]),
        );
        i--;
        j--;
      } else if (i > 0 && dp[i][j] == dp[i - 1][j] + 1) {
        reverse.add(DiffToken(typed[i - 1], DiffKind.extra));
        i--;
      } else {
        reverse.add(
          DiffToken(target[j - 1], DiffKind.missing, expected: target[j - 1]),
        );
        j--;
      }
    }
    return reverse.reversed.toList();
  }

  int _damerauLevenshtein(String a, String b) {
    final aa = a.characters.toList();
    final bb = b.characters.toList();
    final d = List.generate(
      aa.length + 1,
      (_) => List<int>.filled(bb.length + 1, 0),
    );
    for (var i = 0; i <= aa.length; i++) {
      d[i][0] = i;
    }
    for (var j = 0; j <= bb.length; j++) {
      d[0][j] = j;
    }
    for (var i = 1; i <= aa.length; i++) {
      for (var j = 1; j <= bb.length; j++) {
        final cost = aa[i - 1] == bb[j - 1] ? 0 : 1;
        d[i][j] = math.min(
          math.min(d[i - 1][j] + 1, d[i][j - 1] + 1),
          d[i - 1][j - 1] + cost,
        );
        if (i > 1 &&
            j > 1 &&
            aa[i - 1] == bb[j - 2] &&
            aa[i - 2] == bb[j - 1]) {
          d[i][j] = math.min(d[i][j], d[i - 2][j - 2] + 1);
        }
      }
    }
    return d[aa.length][bb.length];
  }

  String _normalize(
    String value,
    TypingRules rules, {
    required bool stripAccents,
  }) {
    var out = value.trim().replaceAll(RegExp(r'\s+'), ' ');
    if (!rules.strictCase) out = out.toLowerCase();
    if (stripAccents) out = _withoutCommonDiacritics(out);
    return out;
  }

  bool _equalChar(String a, String b, TypingRules rules) {
    var aa = a;
    var bb = b;
    if (!rules.strictCase) {
      aa = aa.toLowerCase();
      bb = bb.toLowerCase();
    }
    if (!rules.strictAccents) {
      aa = _withoutCommonDiacritics(aa);
      bb = _withoutCommonDiacritics(bb);
    }
    return aa == bb;
  }

  String _withoutCommonDiacritics(String input) {
    const from =
        'áàâäãåāăąçćčďđéèêëēėęěíìîïīįłñńňóòôöõøōőŕřśšşťúùûüūůűýÿžźżÁÀÂÄÃÅĀĂĄÇĆČĎĐÉÈÊËĒĖĘĚÍÌÎÏĪĮŁÑŃŇÓÒÔÖÕØŌŐŔŘŚŠŞŤÚÙÛÜŪŮŰÝŸŽŹŻ';
    const to =
        'aaaaaaaaacccddeeeeeeeeiiiiiilnnnoooooooorrssstuuuuuuuyyzzzAAAAAAAAACCC DDEEEEEEEEIIIIIILNNNOOOOOOOORRSSSTUUUUUUUYYZZZ';
    final normalizedTo = to.replaceAll(' ', '');
    final map = <String, String>{};
    for (var i = 0; i < math.min(from.length, normalizedTo.length); i++) {
      map[from[i]] = normalizedTo[i];
    }
    return input.split('').map((c) => map[c] ?? c).join();
  }
}

extension on String {
  Iterable<String> get characters sync* {
    final runesList = runes.toList();
    for (final rune in runesList) {
      yield String.fromCharCode(rune);
    }
  }
}
