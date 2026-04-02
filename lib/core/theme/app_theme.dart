import 'package:flutter/material.dart';

import '../../shared/style/palette.dart';

final class AppTheme {
  const AppTheme._();

  static ThemeData get light => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Palette.kPrimary,
      primary: Palette.kPrimary,
      surface: Palette.white,
    ),
    scaffoldBackgroundColor: Palette.lightGrayBg,
    appBarTheme: const AppBarTheme(
      backgroundColor: Palette.white,
      foregroundColor: Palette.textColor,
      elevation: 0,
      centerTitle: true,
    ),
    snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating),
  );

  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Palette.kPrimary,
      primary: Palette.kPrimary,
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: Palette.darkBg,
  );
}
