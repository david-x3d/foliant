import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/app_router.dart';
import 'core/theme/foliant_theme.dart';
import 'features/settings/application/settings_controller.dart';
import 'l10n/app_localizations.dart';

class FoliantApp extends ConsumerWidget {
  const FoliantApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsControllerProvider).value;
    final mode = switch (settings?.themeMode) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
    return DynamicColorBuilder(
      builder: (lightDynamic, darkDynamic) {
        final useDynamic = settings?.dynamicColor ?? true;
        final light = useDynamic && lightDynamic != null
            ? lightDynamic.harmonized()
            : ColorScheme.fromSeed(
                seedColor: FoliantTheme.fallbackSeed,
                brightness: Brightness.light,
                secondary: FoliantTheme.warmAmber,
              );
        final dark = useDynamic && darkDynamic != null
            ? darkDynamic.harmonized()
            : ColorScheme.fromSeed(
                seedColor: FoliantTheme.fallbackSeed,
                brightness: Brightness.dark,
                secondary: FoliantTheme.warmAmber,
              );
        return MaterialApp.router(
          title: 'Foliant',
          debugShowCheckedModeBanner: false,
          theme: FoliantTheme.build(light),
          darkTheme: FoliantTheme.build(dark),
          themeMode: mode,
          routerConfig: appRouter,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('de'),
        );
      },
    );
  }
}
