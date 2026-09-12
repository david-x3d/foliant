import 'package:flutter_test/flutter_test.dart';
import 'package:foliant/core/model/domain.dart';
import 'package:foliant/features/learning/domain/typing_engine.dart';

void main() {
  const engine = TypingEngine();
  const tolerant = TypingRules();

  test('exact answer is full', () {
    expect(engine.evaluate('Apfel', 'Apfel', tolerant).grade, TypingGrade.full);
  });

  test('single typo is almost', () {
    expect(
      engine.evaluate('Apffel', 'Apfel', tolerant).grade,
      TypingGrade.almost,
    );
  });

  test('accent difference is tolerated but marked', () {
    final result = engine.evaluate('ecole', 'école', tolerant);
    expect(result.grade, TypingGrade.full);
    expect(result.accentOnly, isTrue);
  });

  test('strict accents turn accent miss into almost', () {
    final result = engine.evaluate(
      'ecole',
      'école',
      const TypingRules(strictAccents: true),
    );
    expect(result.grade, TypingGrade.almost);
  });
}
