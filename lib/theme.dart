import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primaryGreen = Color(0xFF13ec6d);
  static const Color backgroundLight = Color(0xFFf6f8f7);
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceLight = Colors.white;
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color onSurfaceDark = Colors.white;

  static ThemeData get lightTheme => ThemeData(
        brightness: Brightness.light,
        primaryColor: primaryGreen,
        scaffoldBackgroundColor: backgroundLight,
        cardColor: surfaceLight,
        colorScheme: const ColorScheme.light(
          primary: primaryGreen,
          surface: surfaceLight,
        ),
        textTheme: GoogleFonts.spaceGroteskTextTheme().apply(
          bodyColor: Colors.black,
          displayColor: Colors.black,
        ),
      );

  static ThemeData get darkTheme {
    final baseTextTheme = GoogleFonts.spaceGroteskTextTheme();
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: primaryGreen,
      scaffoldBackgroundColor: backgroundDark,
      cardColor: surfaceDark,
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundDark,
        foregroundColor: Colors.white,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surfaceDark,
      ),
      colorScheme: const ColorScheme.dark(
        primary: primaryGreen,
        surface: surfaceDark,
      ),
      textTheme: baseTextTheme.copyWith(
        bodyLarge: baseTextTheme.bodyLarge?.copyWith(color: Colors.white),
        bodyMedium: baseTextTheme.bodyMedium?.copyWith(color: Colors.white),
        bodySmall: baseTextTheme.bodySmall?.copyWith(color: Colors.white),
        titleLarge: baseTextTheme.titleLarge?.copyWith(color: Colors.white),
        titleMedium: baseTextTheme.titleMedium?.copyWith(color: Colors.white),
        titleSmall: baseTextTheme.titleSmall?.copyWith(color: Colors.white),
        headlineLarge: baseTextTheme.headlineLarge?.copyWith(color: Colors.white),
        headlineMedium: baseTextTheme.headlineMedium?.copyWith(color: Colors.white),
        headlineSmall: baseTextTheme.headlineSmall?.copyWith(color: Colors.white),
        displayLarge: baseTextTheme.displayLarge?.copyWith(color: Colors.white),
        displayMedium: baseTextTheme.displayMedium?.copyWith(color: Colors.white),
        displaySmall: baseTextTheme.displaySmall?.copyWith(color: Colors.white),
        labelLarge: baseTextTheme.labelLarge?.copyWith(color: Colors.white),
        labelMedium: baseTextTheme.labelMedium?.copyWith(color: Colors.white),
        labelSmall: baseTextTheme.labelSmall?.copyWith(color: Colors.white),
      ),
    );
  }
}
