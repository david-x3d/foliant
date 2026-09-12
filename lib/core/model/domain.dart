enum LearningDirection { foreignToDe, deToForeign }

enum LearningMode { cards, quiz, typing, mixed }

enum VocabularyStatus { newItem, learning, review, mastered }

enum SourceOrigin { manual, cameraOcr, bookImport, aiExtract }

enum TypingGrade { full, almost, fail }

extension LearningDirectionX on LearningDirection {
  String get dbValue =>
      this == LearningDirection.foreignToDe ? 'foreign_to_de' : 'de_to_foreign';

  static LearningDirection parse(String value) => value == 'de_to_foreign'
      ? LearningDirection.deToForeign
      : LearningDirection.foreignToDe;
}
