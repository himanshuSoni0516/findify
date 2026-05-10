import 'package:flutter/material.dart';

class AppTheme {
  // ── Brand colors ──────────────────────────────────────────
  static const primary = Colors.blueAccent;
  static const lostColor = Colors.red;
  static const foundColor = Colors.lightGreen;

  // ── Gradient backgrounds ──────────────────────────────────

  // Light
  static const lightGradient = RadialGradient(
    center: Alignment(-0.6, -0.7),
    radius: 1.4,
    colors: [Color(0xFFF0FDF4), Color(0xFFE5F7EC), Color(0xFFDCF0E3)],
    stops: [0.0, 0.5, 1.0],
  );

  // Dark
  static const darkGradient = RadialGradient(
    center: Alignment(-0.6, -0.7),
    radius: 1.4,
    colors: [Color(0xFF0C1F14), Color(0xFF091510), Color(0xFF05100A)],
    stops: [0.0, 0.5, 1.0],
  );

  static RadialGradient background(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? darkGradient : lightGradient;
  }

  // ── Shared border radius ──────────────────────────────────
  static const _borderRadius = 8.0;
  static const _borderWidth = 1.0;

  // ── Light theme ───────────────────────────────────────────
  static final light = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primary,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: const Color(0xFFF5F5F5),
    fontFamily: 'Fredoka',
    cardColor: Colors.white,
    dividerColor: Colors.grey.shade200,

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 18,
        fontWeight: FontWeight.w700,
        fontFamily: 'Fredoka',
      ),
    ),

    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.transparent,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
        borderSide: BorderSide(
          color: Colors.grey.withValues(alpha: 0.25),
          width: _borderWidth,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
        borderSide: BorderSide(
          color: Colors.grey.withValues(alpha: 0.25),
          width: _borderWidth,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
        borderSide: BorderSide(
          color: Colors.grey.withValues(alpha: 0.5),
          width: _borderWidth,
        ),
      ),
      hintStyle: TextStyle(
        color: Colors.grey.shade400,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    ),
  );

  // ── Dark theme ────────────────────────────────────────────
  static final dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primary,
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: const Color(0xFF0F0F0F),
    fontFamily: 'Fredoka',
    cardColor: const Color(0xFF1E1E1E),
    dividerColor: Colors.white12,

    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1A1A1A),
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.w700,
        fontFamily: 'Fredoka',
      ),
    ),

    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.transparent,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF2A2A2A),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
        borderSide: BorderSide(
          color: Colors.grey.withValues(alpha: 0.25),
          width: _borderWidth,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
        borderSide: BorderSide(
          color: Colors.grey.withValues(alpha: 0.25),
          width: _borderWidth,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
        borderSide: BorderSide(
          color: Colors.grey.withValues(alpha: 0.5),
          width: _borderWidth,
        ),
      ),
      hintStyle: const TextStyle(
        color: Colors.white38,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    ),
  );
}
