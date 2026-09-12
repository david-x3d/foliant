import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
  ];

  /// No description provided for @appName.
  ///
  /// In de, this message translates to:
  /// **'Foliant'**
  String get appName;

  /// No description provided for @tagline.
  ///
  /// In de, this message translates to:
  /// **'Vokabeln von der Seite in den Kopf.'**
  String get tagline;

  /// No description provided for @navLearn.
  ///
  /// In de, this message translates to:
  /// **'Lernen'**
  String get navLearn;

  /// No description provided for @navLibrary.
  ///
  /// In de, this message translates to:
  /// **'Bibliothek'**
  String get navLibrary;

  /// No description provided for @navImport.
  ///
  /// In de, this message translates to:
  /// **'Import'**
  String get navImport;

  /// No description provided for @navMore.
  ///
  /// In de, this message translates to:
  /// **'Mehr'**
  String get navMore;

  /// No description provided for @continueLabel.
  ///
  /// In de, this message translates to:
  /// **'Weiter'**
  String get continueLabel;

  /// No description provided for @backLabel.
  ///
  /// In de, this message translates to:
  /// **'Zurück'**
  String get backLabel;

  /// No description provided for @cancelLabel.
  ///
  /// In de, this message translates to:
  /// **'Abbrechen'**
  String get cancelLabel;

  /// No description provided for @saveLabel.
  ///
  /// In de, this message translates to:
  /// **'Speichern'**
  String get saveLabel;

  /// No description provided for @deleteLabel.
  ///
  /// In de, this message translates to:
  /// **'Löschen'**
  String get deleteLabel;

  /// No description provided for @editLabel.
  ///
  /// In de, this message translates to:
  /// **'Bearbeiten'**
  String get editLabel;

  /// No description provided for @retryLabel.
  ///
  /// In de, this message translates to:
  /// **'Erneut versuchen'**
  String get retryLabel;

  /// No description provided for @languageTitle.
  ///
  /// In de, this message translates to:
  /// **'Welche Sprache lernst du?'**
  String get languageTitle;

  /// No description provided for @languageSubtitle.
  ///
  /// In de, this message translates to:
  /// **'Wähle eine Sprache oder gib sie frei ein.'**
  String get languageSubtitle;

  /// No description provided for @customLanguage.
  ///
  /// In de, this message translates to:
  /// **'Andere Sprache'**
  String get customLanguage;

  /// No description provided for @directionTitle.
  ///
  /// In de, this message translates to:
  /// **'In welche Richtung möchtest du lernen?'**
  String get directionTitle;

  /// No description provided for @directionForeignToDe.
  ///
  /// In de, this message translates to:
  /// **'Fremdsprache → Deutsch'**
  String get directionForeignToDe;

  /// No description provided for @directionDeToForeign.
  ///
  /// In de, this message translates to:
  /// **'Deutsch → Fremdsprache'**
  String get directionDeToForeign;

  /// No description provided for @directionAlwaysVisible.
  ///
  /// In de, this message translates to:
  /// **'Die Richtung lässt sich später global und pro Set ändern.'**
  String get directionAlwaysVisible;

  /// No description provided for @typingTitle.
  ///
  /// In de, this message translates to:
  /// **'Auch Schreibweise tippen?'**
  String get typingTitle;

  /// No description provided for @typingYes.
  ///
  /// In de, this message translates to:
  /// **'Ja, beim Lernen mischen'**
  String get typingYes;

  /// No description provided for @typingLater.
  ///
  /// In de, this message translates to:
  /// **'Später einstellen'**
  String get typingLater;

  /// No description provided for @aiOnboardingTitle.
  ///
  /// In de, this message translates to:
  /// **'KI optional verbinden'**
  String get aiOnboardingTitle;

  /// No description provided for @aiOnboardingBody.
  ///
  /// In de, this message translates to:
  /// **'Foliant funktioniert vollständig offline. Mit einem Anbieter kannst du Buchseiten zusätzlich strukturieren, übersetzen und ergänzen lassen.'**
  String get aiOnboardingBody;

  /// No description provided for @skipLabel.
  ///
  /// In de, this message translates to:
  /// **'Überspringen'**
  String get skipLabel;

  /// No description provided for @homeHeadline.
  ///
  /// In de, this message translates to:
  /// **'Heute landet noch was im Kopf.'**
  String get homeHeadline;

  /// No description provided for @homeDue.
  ///
  /// In de, this message translates to:
  /// **'Fällige Karten'**
  String get homeDue;

  /// No description provided for @homeStart.
  ///
  /// In de, this message translates to:
  /// **'Lernsession starten'**
  String get homeStart;

  /// No description provided for @homeEmpty.
  ///
  /// In de, this message translates to:
  /// **'Noch keine Vokabeln fällig'**
  String get homeEmpty;

  /// No description provided for @homeEmptyAction.
  ///
  /// In de, this message translates to:
  /// **'Set öffnen'**
  String get homeEmptyAction;

  /// No description provided for @modeTitle.
  ///
  /// In de, this message translates to:
  /// **'Abfrage-Modus'**
  String get modeTitle;

  /// No description provided for @modeCards.
  ///
  /// In de, this message translates to:
  /// **'Karteikarten'**
  String get modeCards;

  /// No description provided for @modeQuiz.
  ///
  /// In de, this message translates to:
  /// **'Quiz'**
  String get modeQuiz;

  /// No description provided for @modeTyping.
  ///
  /// In de, this message translates to:
  /// **'Tippen'**
  String get modeTyping;

  /// No description provided for @modeMixed.
  ///
  /// In de, this message translates to:
  /// **'Gemischt'**
  String get modeMixed;

  /// No description provided for @libraryHeadline.
  ///
  /// In de, this message translates to:
  /// **'Deine Sets'**
  String get libraryHeadline;

  /// No description provided for @libraryEmpty.
  ///
  /// In de, this message translates to:
  /// **'Noch kein eigenes Set'**
  String get libraryEmpty;

  /// No description provided for @libraryEmptyBody.
  ///
  /// In de, this message translates to:
  /// **'Das Demo-Set ist schon da. Neue Sets kannst du beim Import oder hier anlegen.'**
  String get libraryEmptyBody;

  /// No description provided for @createSet.
  ///
  /// In de, this message translates to:
  /// **'Set anlegen'**
  String get createSet;

  /// No description provided for @setName.
  ///
  /// In de, this message translates to:
  /// **'Name'**
  String get setName;

  /// No description provided for @sourceLanguage.
  ///
  /// In de, this message translates to:
  /// **'Ausgangssprache'**
  String get sourceLanguage;

  /// No description provided for @targetLanguage.
  ///
  /// In de, this message translates to:
  /// **'Zielsprache'**
  String get targetLanguage;

  /// No description provided for @defaultDirection.
  ///
  /// In de, this message translates to:
  /// **'Standard-Richtung'**
  String get defaultDirection;

  /// No description provided for @importHeadline.
  ///
  /// In de, this message translates to:
  /// **'Von der Seite ins Set'**
  String get importHeadline;

  /// No description provided for @importCamera.
  ///
  /// In de, this message translates to:
  /// **'Seite fotografieren'**
  String get importCamera;

  /// No description provided for @importGallery.
  ///
  /// In de, this message translates to:
  /// **'Aus Galerie'**
  String get importGallery;

  /// No description provided for @importText.
  ///
  /// In de, this message translates to:
  /// **'Text einfügen'**
  String get importText;

  /// No description provided for @importTextHint.
  ///
  /// In de, this message translates to:
  /// **'Zum Beispiel:\nhello - hallo\nworld - Welt'**
  String get importTextHint;

  /// No description provided for @importRunOcr.
  ///
  /// In de, this message translates to:
  /// **'Text erkennen'**
  String get importRunOcr;

  /// No description provided for @importUseAi.
  ///
  /// In de, this message translates to:
  /// **'Mit KI strukturieren'**
  String get importUseAi;

  /// No description provided for @importReview.
  ///
  /// In de, this message translates to:
  /// **'Import prüfen'**
  String get importReview;

  /// No description provided for @importReviewHint.
  ///
  /// In de, this message translates to:
  /// **'Vor dem Speichern kannst du jede Zeile korrigieren oder löschen.'**
  String get importReviewHint;

  /// No description provided for @importSet.
  ///
  /// In de, this message translates to:
  /// **'In Set speichern'**
  String get importSet;

  /// No description provided for @importNoPairs.
  ///
  /// In de, this message translates to:
  /// **'Keine sicheren Vokabelpaare erkannt.'**
  String get importNoPairs;

  /// No description provided for @importOcrFailed.
  ///
  /// In de, this message translates to:
  /// **'Die Texterkennung ist fehlgeschlagen.'**
  String get importOcrFailed;

  /// No description provided for @importAiFailed.
  ///
  /// In de, this message translates to:
  /// **'Die KI konnte den Text nicht verarbeiten.'**
  String get importAiFailed;

  /// No description provided for @importLowConfidence.
  ///
  /// In de, this message translates to:
  /// **'Unsicher'**
  String get importLowConfidence;

  /// No description provided for @sourceText.
  ///
  /// In de, this message translates to:
  /// **'Fremdsprache'**
  String get sourceText;

  /// No description provided for @targetText.
  ///
  /// In de, this message translates to:
  /// **'Deutsch'**
  String get targetText;

  /// No description provided for @notes.
  ///
  /// In de, this message translates to:
  /// **'Notizen'**
  String get notes;

  /// No description provided for @confidence.
  ///
  /// In de, this message translates to:
  /// **'Sicherheit'**
  String get confidence;

  /// No description provided for @settingsHeadline.
  ///
  /// In de, this message translates to:
  /// **'Mehr'**
  String get settingsHeadline;

  /// No description provided for @settingsGeneral.
  ///
  /// In de, this message translates to:
  /// **'Lernen & Darstellung'**
  String get settingsGeneral;

  /// No description provided for @settingsAi.
  ///
  /// In de, this message translates to:
  /// **'KI-Anbieter'**
  String get settingsAi;

  /// No description provided for @settingsLanguages.
  ///
  /// In de, this message translates to:
  /// **'Sprachen & Richtung'**
  String get settingsLanguages;

  /// No description provided for @settingsTyping.
  ///
  /// In de, this message translates to:
  /// **'Tipp-Regeln'**
  String get settingsTyping;

  /// No description provided for @settingsAppearance.
  ///
  /// In de, this message translates to:
  /// **'Erscheinungsbild'**
  String get settingsAppearance;

  /// No description provided for @settingsExport.
  ///
  /// In de, this message translates to:
  /// **'Sets exportieren / importieren'**
  String get settingsExport;

  /// No description provided for @settingsStrictCase.
  ///
  /// In de, this message translates to:
  /// **'Groß-/Kleinschreibung streng'**
  String get settingsStrictCase;

  /// No description provided for @settingsAccentsStrict.
  ///
  /// In de, this message translates to:
  /// **'Akzente müssen stimmen'**
  String get settingsAccentsStrict;

  /// No description provided for @settingsTypingShare.
  ///
  /// In de, this message translates to:
  /// **'Tipp-Anteil'**
  String get settingsTypingShare;

  /// No description provided for @settingsDynamicColor.
  ///
  /// In de, this message translates to:
  /// **'Dynamische Systemfarben'**
  String get settingsDynamicColor;

  /// No description provided for @settingsThemeMode.
  ///
  /// In de, this message translates to:
  /// **'Darstellung'**
  String get settingsThemeMode;

  /// No description provided for @themeSystem.
  ///
  /// In de, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In de, this message translates to:
  /// **'Hell'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In de, this message translates to:
  /// **'Dunkel'**
  String get themeDark;

  /// No description provided for @aiHeadline.
  ///
  /// In de, this message translates to:
  /// **'KI-Anbieter'**
  String get aiHeadline;

  /// No description provided for @aiProviderName.
  ///
  /// In de, this message translates to:
  /// **'Anzeigename'**
  String get aiProviderName;

  /// No description provided for @aiApiKey.
  ///
  /// In de, this message translates to:
  /// **'API-Key'**
  String get aiApiKey;

  /// No description provided for @aiBaseUrl.
  ///
  /// In de, this message translates to:
  /// **'Base URL'**
  String get aiBaseUrl;

  /// No description provided for @aiModel.
  ///
  /// In de, this message translates to:
  /// **'Modell'**
  String get aiModel;

  /// No description provided for @aiApiVersion.
  ///
  /// In de, this message translates to:
  /// **'API-Version'**
  String get aiApiVersion;

  /// No description provided for @aiExtraHeader.
  ///
  /// In de, this message translates to:
  /// **'Extra-Header (JSON)'**
  String get aiExtraHeader;

  /// No description provided for @aiOrg.
  ///
  /// In de, this message translates to:
  /// **'Org ID'**
  String get aiOrg;

  /// No description provided for @aiProject.
  ///
  /// In de, this message translates to:
  /// **'Project ID'**
  String get aiProject;

  /// No description provided for @aiTest.
  ///
  /// In de, this message translates to:
  /// **'Verbindung testen'**
  String get aiTest;

  /// No description provided for @aiTestSuccess.
  ///
  /// In de, this message translates to:
  /// **'Verbindung erfolgreich.'**
  String get aiTestSuccess;

  /// No description provided for @aiTestNoKey.
  ///
  /// In de, this message translates to:
  /// **'Bitte zuerst einen API-Key speichern.'**
  String get aiTestNoKey;

  /// No description provided for @aiTestRateLimit.
  ///
  /// In de, this message translates to:
  /// **'Rate Limit erreicht. Bitte später erneut testen.'**
  String get aiTestRateLimit;

  /// No description provided for @aiTestNetwork.
  ///
  /// In de, this message translates to:
  /// **'Keine Verbindung zum Anbieter.'**
  String get aiTestNetwork;

  /// No description provided for @aiTestInvalidKey.
  ///
  /// In de, this message translates to:
  /// **'Der API-Key wurde abgelehnt.'**
  String get aiTestInvalidKey;

  /// No description provided for @aiSaved.
  ///
  /// In de, this message translates to:
  /// **'KI-Einstellungen gespeichert.'**
  String get aiSaved;

  /// No description provided for @learnReveal.
  ///
  /// In de, this message translates to:
  /// **'Antwort zeigen'**
  String get learnReveal;

  /// No description provided for @learnKnown.
  ///
  /// In de, this message translates to:
  /// **'Gewusst'**
  String get learnKnown;

  /// No description provided for @learnUnsure.
  ///
  /// In de, this message translates to:
  /// **'Unsicher'**
  String get learnUnsure;

  /// No description provided for @learnUnknown.
  ///
  /// In de, this message translates to:
  /// **'Nicht gewusst'**
  String get learnUnknown;

  /// No description provided for @learnTypePrompt.
  ///
  /// In de, this message translates to:
  /// **'Tippe die Antwort'**
  String get learnTypePrompt;

  /// No description provided for @learnSubmit.
  ///
  /// In de, this message translates to:
  /// **'Prüfen'**
  String get learnSubmit;

  /// No description provided for @learnAlmost.
  ///
  /// In de, this message translates to:
  /// **'Fast richtig'**
  String get learnAlmost;

  /// No description provided for @learnCorrect.
  ///
  /// In de, this message translates to:
  /// **'Richtig'**
  String get learnCorrect;

  /// No description provided for @learnWrong.
  ///
  /// In de, this message translates to:
  /// **'Noch nicht'**
  String get learnWrong;

  /// No description provided for @learnTryAgain.
  ///
  /// In de, this message translates to:
  /// **'Nochmal tippen'**
  String get learnTryAgain;

  /// No description provided for @hintLabel.
  ///
  /// In de, this message translates to:
  /// **'Hinweis'**
  String get hintLabel;

  /// No description provided for @hintLength.
  ///
  /// In de, this message translates to:
  /// **'Wortlänge'**
  String get hintLength;

  /// No description provided for @hintFirstLetter.
  ///
  /// In de, this message translates to:
  /// **'Erster Buchstabe'**
  String get hintFirstLetter;

  /// No description provided for @hintExample.
  ///
  /// In de, this message translates to:
  /// **'Beispielsatz mit Lücke'**
  String get hintExample;

  /// No description provided for @sessionDone.
  ///
  /// In de, this message translates to:
  /// **'Session geschafft'**
  String get sessionDone;

  /// No description provided for @sessionCorrect.
  ///
  /// In de, this message translates to:
  /// **'Richtig'**
  String get sessionCorrect;

  /// No description provided for @sessionAlmost.
  ///
  /// In de, this message translates to:
  /// **'Fast'**
  String get sessionAlmost;

  /// No description provided for @sessionWrong.
  ///
  /// In de, this message translates to:
  /// **'Falsch'**
  String get sessionWrong;

  /// No description provided for @sessionFinish.
  ///
  /// In de, this message translates to:
  /// **'Fertig'**
  String get sessionFinish;

  /// No description provided for @quizChoose.
  ///
  /// In de, this message translates to:
  /// **'Wähle die richtige Antwort'**
  String get quizChoose;

  /// No description provided for @noNetwork.
  ///
  /// In de, this message translates to:
  /// **'Kein Netz. Offline-Lernen funktioniert weiter.'**
  String get noNetwork;

  /// No description provided for @genericError.
  ///
  /// In de, this message translates to:
  /// **'Etwas ist schiefgelaufen.'**
  String get genericError;

  /// No description provided for @exportJson.
  ///
  /// In de, this message translates to:
  /// **'Sets als JSON exportieren'**
  String get exportJson;

  /// No description provided for @importJson.
  ///
  /// In de, this message translates to:
  /// **'Sets aus JSON importieren'**
  String get importJson;

  /// No description provided for @exportDone.
  ///
  /// In de, this message translates to:
  /// **'Export erstellt.'**
  String get exportDone;

  /// No description provided for @importDone.
  ///
  /// In de, this message translates to:
  /// **'Import abgeschlossen.'**
  String get importDone;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
