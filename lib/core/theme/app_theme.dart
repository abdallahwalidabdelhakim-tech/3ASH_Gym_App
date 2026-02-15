/// Application theme configuration
///
/// Defines light and dark theme styles for the 3ASH - Gym Trainer app.
/// Includes color schemes, typography, and component styles.
library;
import 'package:flutter/material.dart';

class AppTheme {
  /// Primary Colors
  static const Color primaryLight = Color(0xFFD6DFE2); // Light gray
  static const Color primaryGreen = Color(0xFFD5FF5F); // Neon green (brand color)
  static const Color primaryBlack = Color(0xFF010101); // Black
  static const Color primaryWhite = Color(0xFFFFFFFF); // White
  
  /// Secondary Colors
  static const Color secondaryGray = Color(0xFF9F9F9F); // Medium gray
  static const Color secondaryDarkGray = Color(0xFF595959); // Dark gray
  static const Color secondaryLightBlue = Color(0xFF9AC0D6); // Light blue
  static const Color secondaryBlueGray = Color(0xFF4E6075); // Blue-gray
  
  /// Additional Colors
  static const Color backgroundColor = Color(0xFF1A1A1A); // Dark background
  static const Color cardBackground = Color(0xFF2A2A2A); // Card background
  static const Color errorColor = Color(0xFFE53935); // Error/negative state
  static const Color successColor = Color(0xFF4CAF50); // Success/positive state

  /// Light theme configuration
  /// 
  /// Uses bright colors with white background and green accents.
  /// Optimized for readability in well-lit environments.
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primaryGreen,
      scaffoldBackgroundColor: primaryWhite,
      colorScheme: const ColorScheme.light(
        primary: primaryGreen,
        secondary: secondaryLightBlue,
        surface: primaryWhite,
        error: errorColor,
        onPrimary: primaryBlack,
        onSecondary: primaryWhite,
        onSurface: primaryBlack,
        onError: primaryWhite,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryWhite,
        foregroundColor: primaryBlack,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: primaryWhite,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: primaryLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryGreen, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: errorColor, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: errorColor, width: 2),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlack,
          foregroundColor: primaryWhite,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryGreen,
        ),
      ),
      fontFamily: 'Roboto',
    );
  }

  /// Dark theme configuration
  /// 
  /// Uses dark colors with deep gray backgrounds and green accents.
  /// Optimized for low-light environments and reduced eye strain.
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: primaryGreen,
      scaffoldBackgroundColor: backgroundColor,
      colorScheme: const ColorScheme.dark(
        primary: primaryGreen,
        secondary: secondaryLightBlue,
        surface: cardBackground,
        error: errorColor,
        onPrimary: primaryBlack,
        onSecondary: primaryWhite,
        onSurface: primaryWhite,
        onError: primaryWhite,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundColor,
        foregroundColor: primaryWhite,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: cardBackground,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cardBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryGreen, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: errorColor, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: errorColor, width: 2),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlack,
          foregroundColor: primaryWhite,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryGreen,
        ),
      ),
      fontFamily: 'Roboto',
    );
  }
}

