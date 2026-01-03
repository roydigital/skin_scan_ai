import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primaryGreen = Color(0xFF13ec6d);
  static const Color backgroundLight = Color(0xFFf6f8f7);
  static const Color backgroundDark = Color(0xFF102218);
  static const Color surfaceLight = Colors.white;
  static const Color surfaceDark = Color(0xFF1a3324);

  static ThemeData get lightTheme => ThemeData(
        brightness: Brightness.light,
        primaryColor: primaryGreen,
        scaffoldBackgroundColor: backgroundLight,
        colorScheme: const ColorScheme.light(
          primary: primaryGreen,
          surface: surfaceLight,
        ),
        textTheme: GoogleFonts.spaceGroteskTextTheme().apply(
          bodyColor: Colors.black,
          displayColor: Colors.black,
        ),
      );

  static ThemeData get darkTheme => ThemeData(
        brightness: Brightness.dark,
        primaryColor: primaryGreen,
        scaffoldBackgroundColor: backgroundDark,
        colorScheme: const ColorScheme.dark(
          primary: primaryGreen,
          surface: surfaceDark,
        ),
        textTheme: GoogleFonts.spaceGroteskTextTheme().apply(
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ),
      );
}
