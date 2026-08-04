import 'package:flutter/material.dart';

abstract final class AppColors {
  static const background = Color(0xff090d0f);
  static const panel = Color(0xff12181b);
  static const panelRaised = Color(0xff182024);
  static const line = Color(0xff3d484d);
  static const text = Color(0xfff1f3f3);
  static const mutedText = Color(0xff89959a);
  static const mfRed = Color(0xffb8272f);
  static const mfRedDark = Color(0xff721921);
  static const grainTank = Color(0xffe5e0d2);
  static const accent = Color(0xffcda83c);
  static const normal = Color(0xff55c98a);
  static const warning = Color(0xffe4b84e);
  static const alarm = Color(0xffec5d62);
  static const noSignal = Color(0xff667278);
}

abstract final class AppTheme {
  static ThemeData get dark => darkWithFont('Roboto');

  static ThemeData darkWithFont([String? fontFamily]) {
    final scheme = ColorScheme.fromSeed(seedColor: AppColors.accent, brightness: Brightness.dark, surface: AppColors.panel);
    return ThemeData(
      useMaterial3: true,
      fontFamily: fontFamily,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: scheme,
      dividerColor: AppColors.line,
      appBarTheme: const AppBarTheme(backgroundColor: AppColors.background, foregroundColor: AppColors.text, elevation: 0),
      cardTheme: CardThemeData(color: AppColors.panel, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
      textTheme: const TextTheme(bodyMedium: TextStyle(color: AppColors.text), bodySmall: TextStyle(color: AppColors.mutedText)),
      inputDecorationTheme: InputDecorationTheme(filled: true, fillColor: AppColors.panelRaised, border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none)),
    );
  }
}
