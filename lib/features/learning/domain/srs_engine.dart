import '../../../core/model/domain.dart';
import '../../../data/local/app_database.dart';

class SrsEngine {
  const SrsEngine();

  SrsSnapshot grade(VocabularyItem item, TypingGrade grade, {DateTime? now}) {
    final time = now ?? DateTime.now();
    var ease = item.ease;
    var repetitions = item.repetitions;
    var lapses = item.lapses;
    var interval = item.intervalDays;

    switch (grade) {
      case TypingGrade.full:
        repetitions += 1;
        if (repetitions == 1) {
          interval = 1;
        } else if (repetitions == 2) {
          interval = 4;
        } else {
          interval = (interval * ease).round().clamp(1, 3650);
        }
        ease = (ease + .08).clamp(1.3, 3.0);
        break;
      case TypingGrade.almost:
        repetitions += 1;
        interval = repetitions <= 1
            ? 1
            : (interval * 1.35).round().clamp(1, 3650);
        ease = (ease - .05).clamp(1.3, 3.0);
        break;
      case TypingGrade.fail:
        lapses += 1;
        repetitions = 0;
        interval = 0;
        ease = (ease - .2).clamp(1.3, 3.0);
        break;
    }

    final dueAt = grade == TypingGrade.fail
        ? time.add(const Duration(minutes: 10))
        : time.add(Duration(days: interval));
    final status = interval >= 30
        ? 'mastered'
        : repetitions >= 2
        ? 'review'
        : 'learning';
    return SrsSnapshot(
      dueAt: dueAt,
      intervalDays: interval,
      ease: ease,
      repetitions: repetitions,
      lapses: lapses,
      status: status,
    );
  }
}
