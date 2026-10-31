import 'package:flutter/material.dart';

/// Paleta tomada del design system de Stitch (Asistly).
abstract final class AppColors {
  static const primary = Color(0xFF00266F);
  static const primaryContainer = Color(0xFF1A3D8F);
  static const primaryFixed = Color(0xFFDBE1FF);
  static const onPrimary = Color(0xFFFFFFFF);

  static const secondary = Color(0xFF4A5D91);
  static const secondaryContainer = Color(0xFFAFC2FE);
  static const secondaryFixed = Color(0xFFDBE1FF);
  static const onSecondaryFixedVariant = Color(0xFF324578);

  static const tertiaryContainer = Color(0xFF553F00);
  static const tertiaryFixed = Color(0xFFFFDF9B);
  static const tertiaryFixedDim = Color(0xFFF6BE21);
  static const onTertiaryFixed = Color(0xFF251A00);

  static const surface = Color(0xFFF7F9FE);
  static const surfaceContainerLowest = Color(0xFFFFFFFF);
  static const surfaceContainerLow = Color(0xFFF1F4F9);
  static const surfaceContainer = Color(0xFFEBEEF3);
  static const surfaceContainerHigh = Color(0xFFE5E8ED);
  static const surfaceContainerHighest = Color(0xFFDFE3E8);
  static const onSurface = Color(0xFF181C20);
  static const onSurfaceVariant = Color(0xFF444651);

  static const outline = Color(0xFF747683);
  static const outlineVariant = Color(0xFFC4C6D3);

  static const error = Color(0xFFBA1A1A);
  static const errorContainer = Color(0xFFFFDAD6);
  static const onErrorContainer = Color(0xFF93000A);
}
