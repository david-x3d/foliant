import 'package:shared_preferences/shared_preferences.dart';

class AppSettings {
  const AppSettings({
    this.languageCode = 'en',
    this.direction = 'foreign_to_de',
    this.lastMode = 'mixed',
    this.typingShare = 50,
    this.strictCase = false,
    this.strictAccents = false,
    this.dynamicColor = true,
    this.themeMode = 'system',
    this.onboardingDone = false,
  });

  final String languageCode;
  final String direction;
  final String lastMode;
  final int typingShare;
  final bool strictCase;
  final bool strictAccents;
  final bool dynamicColor;
  final String themeMode;
  final bool onboardingDone;

  AppSettings copyWith({
    String? languageCode,
    String? direction,
    String? lastMode,
    int? typingShare,
    bool? strictCase,
    bool? strictAccents,
    bool? dynamicColor,
    String? themeMode,
    bool? onboardingDone,
  }) => AppSettings(
    languageCode: languageCode ?? this.languageCode,
    direction: direction ?? this.direction,
    lastMode: lastMode ?? this.lastMode,
    typingShare: typingShare ?? this.typingShare,
    strictCase: strictCase ?? this.strictCase,
    strictAccents: strictAccents ?? this.strictAccents,
    dynamicColor: dynamicColor ?? this.dynamicColor,
    themeMode: themeMode ?? this.themeMode,
    onboardingDone: onboardingDone ?? this.onboardingDone,
  );
}

class SettingsRepository {
  Future<AppSettings> load() async {
    final p = await SharedPreferences.getInstance();
    return AppSettings(
      languageCode: p.getString('languageCode') ?? 'en',
      direction: p.getString('direction') ?? 'foreign_to_de',
      lastMode: p.getString('lastMode') ?? 'mixed',
      typingShare: p.getInt('typingShare') ?? 50,
      strictCase: p.getBool('strictCase') ?? false,
      strictAccents: p.getBool('strictAccents') ?? false,
      dynamicColor: p.getBool('dynamicColor') ?? true,
      themeMode: p.getString('themeMode') ?? 'system',
      onboardingDone: p.getBool('onboardingDone') ?? false,
    );
  }

  Future<void> save(AppSettings s) async {
    final p = await SharedPreferences.getInstance();
    await Future.wait([
      p.setString('languageCode', s.languageCode),
      p.setString('direction', s.direction),
      p.setString('lastMode', s.lastMode),
      p.setInt('typingShare', s.typingShare),
      p.setBool('strictCase', s.strictCase),
      p.setBool('strictAccents', s.strictAccents),
      p.setBool('dynamicColor', s.dynamicColor),
      p.setString('themeMode', s.themeMode),
      p.setBool('onboardingDone', s.onboardingDone),
    ]);
  }
}
