import 'package:flutter/material.dart';
import 'app_colors.dart';

abstract class AppTheme {
  static ThemeData get light => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      // o que e' meu, fixo
      primary: AppColors.primary,
      error: AppColors.error,
      onSurface: AppColors.text,
      outline: AppColors.border,
      // superficies neutras: o M3 as tingiria de verde
      surface: AppColors.background,
      surfaceTint: Colors.transparent,
      surfaceBright: AppColors.background,
      surfaceContainerLowest: AppColors.background,
      surfaceContainerLow: AppColors.background,
      surfaceContainer: AppColors.background,
      surfaceContainerHigh: AppColors.background,
      surfaceContainerHighest: AppColors.background,
    ),
    scaffoldBackgroundColor: AppColors.background,
    appBarTheme: const AppBarTheme(color: AppColors.appbar),
    fontFamily: 'Archivo',
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 57,
        fontWeight: FontWeight.w800,
        color: AppColors.text,
        height: 1.1,
      ),
      displayMedium: TextStyle(
        fontSize: 45,
        fontWeight: FontWeight.w800,
        color: AppColors.text,
        height: 1.1,
      ),
      displaySmall: TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.w800,
        color: AppColors.text,
        height: 1.1,
      ),
      headlineLarge: TextStyle(
        fontSize: 38,
        fontWeight: FontWeight.w800,
        color: AppColors.text,
        height: 1.1,
      ),
      headlineMedium: TextStyle(
        fontSize: 33,
        fontWeight: FontWeight.w800,
        color: AppColors.text,
        height: 1.1,
      ),
      headlineSmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: AppColors.text,
        height: 1.2,
      ),
      titleLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: AppColors.text,
        height: 1.2,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: AppColors.text,
        height: 1.25,
      ),
      titleSmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.text,
        height: 1.25,
      ),
      bodyLarge: TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w500,
        color: AppColors.text,
        height: 1.35,
      ),
      bodyMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: AppColors.text,
        height: 1.35,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.text,
        height: 1.4,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.text,
        height: 1.2,
      ),
      labelMedium: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: AppColors.text,
        height: 1.2,
      ),
      labelSmall: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: AppColors.text,
        height: 1.2,
      ),
    ),
  );
}
