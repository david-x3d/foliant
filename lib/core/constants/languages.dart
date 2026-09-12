class LearningLanguage {
  const LearningLanguage(this.code, this.label, {this.rtl = false});

  final String code;
  final String label;
  final bool rtl;
}

const supportedLearningLanguages = <LearningLanguage>[
  LearningLanguage('en', 'Englisch'),
  LearningLanguage('fr', 'Französisch'),
  LearningLanguage('es', 'Spanisch'),
  LearningLanguage('it', 'Italienisch'),
  LearningLanguage('nl', 'Niederländisch'),
  LearningLanguage('pt', 'Portugiesisch'),
  LearningLanguage('pl', 'Polnisch'),
  LearningLanguage('tr', 'Türkisch'),
  LearningLanguage('ar', 'Arabisch', rtl: true),
  LearningLanguage('ja', 'Japanisch'),
  LearningLanguage('zh', 'Chinesisch'),
  LearningLanguage('ko', 'Koreanisch'),
  LearningLanguage('ru', 'Russisch'),
  LearningLanguage('la', 'Latein'),
  LearningLanguage('gr', 'Griechisch'),
];

String languageLabel(String code) =>
    supportedLearningLanguages
        .where((language) => language.code == code)
        .map((language) => language.label)
        .firstOrNull ??
    code.toUpperCase();

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
