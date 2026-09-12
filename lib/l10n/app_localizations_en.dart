// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Foliant';

  @override
  String get tagline => 'Vocabulary from the page into your head.';

  @override
  String get navLearn => 'Lernen';

  @override
  String get navLibrary => 'Bibliothek';

  @override
  String get navImport => 'Import';

  @override
  String get navMore => 'Mehr';

  @override
  String get continueLabel => 'Weiter';

  @override
  String get backLabel => 'Zurück';

  @override
  String get cancelLabel => 'Abbrechen';

  @override
  String get saveLabel => 'Speichern';

  @override
  String get deleteLabel => 'Löschen';

  @override
  String get editLabel => 'Bearbeiten';

  @override
  String get retryLabel => 'Erneut versuchen';

  @override
  String get languageTitle => 'Welche Sprache lernst du?';

  @override
  String get languageSubtitle => 'Wähle eine Sprache oder gib sie frei ein.';

  @override
  String get customLanguage => 'Andere Sprache';

  @override
  String get directionTitle => 'In welche Richtung möchtest du lernen?';

  @override
  String get directionForeignToDe => 'Fremdsprache → Deutsch';

  @override
  String get directionDeToForeign => 'Deutsch → Fremdsprache';

  @override
  String get directionAlwaysVisible =>
      'Die Richtung lässt sich später global und pro Set ändern.';

  @override
  String get typingTitle => 'Auch Schreibweise tippen?';

  @override
  String get typingYes => 'Ja, beim Lernen mischen';

  @override
  String get typingLater => 'Später einstellen';

  @override
  String get aiOnboardingTitle => 'KI optional verbinden';

  @override
  String get aiOnboardingBody =>
      'Foliant funktioniert vollständig offline. Mit einem Anbieter kannst du Buchseiten zusätzlich strukturieren, übersetzen und ergänzen lassen.';

  @override
  String get skipLabel => 'Überspringen';

  @override
  String get homeHeadline => 'Heute landet noch was im Kopf.';

  @override
  String get homeDue => 'Fällige Karten';

  @override
  String get homeStart => 'Lernsession starten';

  @override
  String get homeEmpty => 'Noch keine Vokabeln fällig';

  @override
  String get homeEmptyAction => 'Set öffnen';

  @override
  String get modeTitle => 'Abfrage-Modus';

  @override
  String get modeCards => 'Karteikarten';

  @override
  String get modeQuiz => 'Quiz';

  @override
  String get modeTyping => 'Tippen';

  @override
  String get modeMixed => 'Gemischt';

  @override
  String get libraryHeadline => 'Deine Sets';

  @override
  String get libraryEmpty => 'Noch kein eigenes Set';

  @override
  String get libraryEmptyBody =>
      'Das Demo-Set ist schon da. Neue Sets kannst du beim Import oder hier anlegen.';

  @override
  String get createSet => 'Set anlegen';

  @override
  String get setName => 'Name';

  @override
  String get sourceLanguage => 'Ausgangssprache';

  @override
  String get targetLanguage => 'Zielsprache';

  @override
  String get defaultDirection => 'Standard-Richtung';

  @override
  String get importHeadline => 'Von der Seite ins Set';

  @override
  String get importCamera => 'Seite fotografieren';

  @override
  String get importGallery => 'Aus Galerie';

  @override
  String get importText => 'Text einfügen';

  @override
  String get importTextHint => 'Zum Beispiel:\nhello - hallo\nworld - Welt';

  @override
  String get importRunOcr => 'Text erkennen';

  @override
  String get importUseAi => 'Mit KI strukturieren';

  @override
  String get importReview => 'Import prüfen';

  @override
  String get importReviewHint =>
      'Vor dem Speichern kannst du jede Zeile korrigieren oder löschen.';

  @override
  String get importSet => 'In Set speichern';

  @override
  String get importNoPairs => 'Keine sicheren Vokabelpaare erkannt.';

  @override
  String get importOcrFailed => 'Die Texterkennung ist fehlgeschlagen.';

  @override
  String get importAiFailed => 'Die KI konnte den Text nicht verarbeiten.';

  @override
  String get importLowConfidence => 'Unsicher';

  @override
  String get sourceText => 'Fremdsprache';

  @override
  String get targetText => 'Deutsch';

  @override
  String get notes => 'Notizen';

  @override
  String get confidence => 'Sicherheit';

  @override
  String get settingsHeadline => 'Mehr';

  @override
  String get settingsGeneral => 'Lernen & Darstellung';

  @override
  String get settingsAi => 'KI-Anbieter';

  @override
  String get settingsLanguages => 'Sprachen & Richtung';

  @override
  String get settingsTyping => 'Tipp-Regeln';

  @override
  String get settingsAppearance => 'Erscheinungsbild';

  @override
  String get settingsExport => 'Sets exportieren / importieren';

  @override
  String get settingsStrictCase => 'Groß-/Kleinschreibung streng';

  @override
  String get settingsAccentsStrict => 'Akzente müssen stimmen';

  @override
  String get settingsTypingShare => 'Tipp-Anteil';

  @override
  String get settingsDynamicColor => 'Dynamische Systemfarben';

  @override
  String get settingsThemeMode => 'Darstellung';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Hell';

  @override
  String get themeDark => 'Dunkel';

  @override
  String get aiHeadline => 'KI-Anbieter';

  @override
  String get aiProviderName => 'Anzeigename';

  @override
  String get aiApiKey => 'API-Key';

  @override
  String get aiBaseUrl => 'Base URL';

  @override
  String get aiModel => 'Modell';

  @override
  String get aiApiVersion => 'API-Version';

  @override
  String get aiExtraHeader => 'Extra-Header (JSON)';

  @override
  String get aiOrg => 'Org ID';

  @override
  String get aiProject => 'Project ID';

  @override
  String get aiTest => 'Verbindung testen';

  @override
  String get aiTestSuccess => 'Verbindung erfolgreich.';

  @override
  String get aiTestNoKey => 'Bitte zuerst einen API-Key speichern.';

  @override
  String get aiTestRateLimit =>
      'Rate Limit erreicht. Bitte später erneut testen.';

  @override
  String get aiTestNetwork => 'Keine Verbindung zum Anbieter.';

  @override
  String get aiTestInvalidKey => 'Der API-Key wurde abgelehnt.';

  @override
  String get aiSaved => 'KI-Einstellungen gespeichert.';

  @override
  String get learnReveal => 'Antwort zeigen';

  @override
  String get learnKnown => 'Gewusst';

  @override
  String get learnUnsure => 'Unsicher';

  @override
  String get learnUnknown => 'Nicht gewusst';

  @override
  String get learnTypePrompt => 'Tippe die Antwort';

  @override
  String get learnSubmit => 'Prüfen';

  @override
  String get learnAlmost => 'Fast richtig';

  @override
  String get learnCorrect => 'Richtig';

  @override
  String get learnWrong => 'Noch nicht';

  @override
  String get learnTryAgain => 'Nochmal tippen';

  @override
  String get hintLabel => 'Hinweis';

  @override
  String get hintLength => 'Wortlänge';

  @override
  String get hintFirstLetter => 'Erster Buchstabe';

  @override
  String get hintExample => 'Beispielsatz mit Lücke';

  @override
  String get sessionDone => 'Session geschafft';

  @override
  String get sessionCorrect => 'Richtig';

  @override
  String get sessionAlmost => 'Fast';

  @override
  String get sessionWrong => 'Falsch';

  @override
  String get sessionFinish => 'Fertig';

  @override
  String get quizChoose => 'Wähle die richtige Antwort';

  @override
  String get noNetwork => 'Kein Netz. Offline-Lernen funktioniert weiter.';

  @override
  String get genericError => 'Etwas ist schiefgelaufen.';

  @override
  String get exportJson => 'Sets als JSON exportieren';

  @override
  String get importJson => 'Sets aus JSON importieren';

  @override
  String get exportDone => 'Export erstellt.';

  @override
  String get importDone => 'Import abgeschlossen.';
}
