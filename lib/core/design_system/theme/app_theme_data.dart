import "package:flutter/material.dart";

import "../tokens/app_theme_tokens.dart";

ThemeData buildMaterialTheme(AppThemeTokens tokens) {
  final textTheme = const TextTheme().apply(
    bodyColor: tokens.semantic.text.primary,
    displayColor: tokens.semantic.text.primary,
  );

  final colorScheme = ColorScheme.dark(
    surface: tokens.semantic.surface.card,
    primary: tokens.foundation.accentPrimary,
    onPrimary: tokens.semantic.action.primaryFg,
    secondary: tokens.foundation.info,
    error: tokens.foundation.error,
    onSurface: tokens.semantic.text.primary,
  );

  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: tokens.semantic.surface.screen,
    colorScheme: colorScheme,
    textTheme: textTheme,
    cardTheme: CardThemeData(
      color: tokens.semantic.surface.card,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: tokens.foundation.borderSubtle),
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: tokens.semantic.surface.screen,
      foregroundColor: tokens.semantic.text.primary,
      elevation: 0,
    ),
    dividerColor: tokens.foundation.borderSubtle,
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: tokens.foundation.bgElev2,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: tokens.foundation.borderSubtle),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: tokens.foundation.borderSubtle),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: tokens.semantic.action.focusRing, width: 1.5),
      ),
      labelStyle: TextStyle(color: tokens.semantic.text.muted),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: tokens.semantic.action.primaryBg,
        foregroundColor: tokens.semantic.action.primaryFg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: tokens.semantic.action.secondaryFg,
        side: BorderSide(color: tokens.foundation.borderStrong),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    ),
  );
}
