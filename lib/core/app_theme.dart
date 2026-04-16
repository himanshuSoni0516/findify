import 'package:flutter/material.dart';

class AppTheme {
  // ── Brand colors ──────────────────────────────────────────
  static const primary    = Colors.blueAccent;
  static const lostColor  = Colors.red;
  static const foundColor = Colors.lightGreen;

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
      backgroundColor: Colors.white,
      indicatorColor: primary.withOpacity(0.1),
      labelTextStyle: WidgetStateProperty.all(
        const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(
            fontWeight: FontWeight.w600, fontSize: 15),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primary, width: 1.5),
      ),
      contentPadding:
      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
      backgroundColor: const Color(0xFF1A1A1A),
      indicatorColor: primary.withOpacity(0.2),
      labelTextStyle: WidgetStateProperty.all(
        const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(
            fontWeight: FontWeight.w600, fontSize: 15),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF2A2A2A),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.white12),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.white12),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primary, width: 1.5),
      ),
      hintStyle: const TextStyle(color: Colors.white38),
      contentPadding:
      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
  );
}