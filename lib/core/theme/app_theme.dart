import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Escala tipográfica del design system (Inter).
abstract final class AppText {
  static TextStyle get displayLg => GoogleFonts.inter(
      fontSize: 40, height: 48 / 40, letterSpacing: -0.8, fontWeight: FontWeight.w700);
  static TextStyle get headlineLg => GoogleFonts.inter(
      fontSize: 30, height: 36 / 30, letterSpacing: -0.45, fontWeight: FontWeight.w700);
  static TextStyle get headlineMd => GoogleFonts.inter(
      fontSize: 24, height: 32 / 24, letterSpacing: -0.24, fontWeight: FontWeight.w600);
  static TextStyle get headlineSm => GoogleFonts.inter(
      fontSize: 20, height: 26 / 20, letterSpacing: -0.1, fontWeight: FontWeight.w600);
  static TextStyle get titleLg =>
      GoogleFonts.inter(fontSize: 18, height: 24 / 18, fontWeight: FontWeight.w600);
  static TextStyle get titleMd =>
      GoogleFonts.inter(fontSize: 16, height: 22 / 16, fontWeight: FontWeight.w600);
  static TextStyle get bodyLg =>
      GoogleFonts.inter(fontSize: 16, height: 24 / 16, fontWeight: FontWeight.w400);
  static TextStyle get bodyMd =>
      GoogleFonts.inter(fontSize: 14, height: 20 / 14, fontWeight: FontWeight.w400);
  static TextStyle get bodySm =>
      GoogleFonts.inter(fontSize: 12, height: 16 / 12, fontWeight: FontWeight.w400);
  static TextStyle get labelLg => GoogleFonts.inter(
      fontSize: 14, height: 20 / 14, letterSpacing: 0.14, fontWeight: FontWeight.w600);
  static TextStyle get labelMd => GoogleFonts.inter(
      fontSize: 12, height: 16 / 12, letterSpacing: 0.24, fontWeight: FontWeight.w500);
  static TextStyle get labelSm => GoogleFonts.inter(
      fontSize: 11, height: 14 / 11, letterSpacing: 0.22, fontWeight: FontWeight.w500);
}

abstract final class AppTheme {
  static ThemeData get light {
    const scheme = ColorScheme.light(
      primary: AppColors.primary,
      onPrimary: AppColors.onPrimary,
      primaryContainer: AppColors.primaryContainer,
      secondary: AppColors.secondary,
      secondaryContainer: AppColors.secondaryContainer,
      tertiary: AppColors.tertiaryFixedDim,
      surface: AppColors.surface,
      onSurface: AppColors.onSurface,
      onSurfaceVariant: AppColors.onSurfaceVariant,
      outline: AppColors.outline,
      outlineVariant: AppColors.outlineVariant,
      error: AppColors.error,
      errorContainer: AppColors.errorContainer,
    );

    return ThemeData(
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.surface,
      fontFamily: GoogleFonts.inter().fontFamily,
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.onSurface,
        contentTextStyle: AppText.bodyMd.copyWith(color: Colors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: AppColors.primaryContainer,
        selectionColor: AppColors.secondaryContainer,
        selectionHandleColor: AppColors.primaryContainer,
      ),
    );
  }
}
