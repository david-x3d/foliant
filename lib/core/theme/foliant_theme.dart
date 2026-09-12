import 'package:flutter/material.dart';

class FoliantTheme {
  static const fallbackSeed = Color(0xFF0A5A5C);
  static const warmAmber = Color(0xFFE3A72F);

  static ThemeData build(ColorScheme scheme) {
    final text = Typography.material2021().black.apply(
      bodyColor: scheme.onSurface,
      displayColor: scheme.onSurface,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      textTheme: text.copyWith(
        headlineLarge: text.headlineLarge?.copyWith(
          fontWeight: FontWeight.w800,
          letterSpacing: -1.2,
        ),
        headlineMedium: text.headlineMedium?.copyWith(
          fontWeight: FontWeight.w800,
          letterSpacing: -.8,
        ),
        titleLarge: text.titleLarge?.copyWith(fontWeight: FontWeight.w700),
      ),
      scaffoldBackgroundColor: scheme.surface,
      navigationBarTheme: NavigationBarThemeData(
        height: 72,
        backgroundColor: scheme.surfaceContainer,
        indicatorColor: scheme.secondaryContainer,
        indicatorShape: const StadiumBorder(),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => TextStyle(
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w700
                : FontWeight.w500,
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(56, 52),
          shape: const StadiumBorder(),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerHigh,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(10),
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(28),
          ),
          borderSide: BorderSide(color: scheme.primary, width: 2),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: scheme.surfaceContainerLow,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
    );
  }
}

class FoliantShapes {
  static const asymmetric = RoundedRectangleBorder(
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(34),
      topRight: Radius.circular(12),
      bottomLeft: Radius.circular(18),
      bottomRight: Radius.circular(38),
    ),
  );

  static const extraLarge = RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(32)),
  );
}

class FoliantMotion {
  static const spring = SpringDescription(mass: 1, stiffness: 390, damping: 28);
  static const gentle = SpringDescription(mass: 1, stiffness: 250, damping: 30);
}
