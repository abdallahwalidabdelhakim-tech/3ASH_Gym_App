/// Theme state management provider
///
/// Handles theme mode management (light/dark/system) with persistent storage.
/// Uses SharedPreferences to store user's theme preferences between sessions.
library;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {

  /// Creates a ThemeProvider instance with shared preferences
  ThemeProvider(this._prefs) {
    _loadTheme();
  }
  /// Shared preferences instance for persistent storage
  final SharedPreferences _prefs;
  
  /// Key used to store theme mode in shared preferences
  static const String _themeKey = 'theme_mode';
  
  /// Current theme mode
  ThemeMode _themeMode = ThemeMode.dark;

  /// Gets the current theme mode
  ThemeMode get themeMode => _themeMode;

  /// Loads saved theme mode from shared preferences
  void _loadTheme() {
    final themeString = _prefs.getString(_themeKey);
    if (themeString != null) {
      _themeMode = ThemeMode.values.firstWhere(
        (mode) => mode.toString() == themeString,
        orElse: () => ThemeMode.dark,
      );
      notifyListeners();
    }
  }

  /// Sets a new theme mode and saves it to persistent storage
  /// 
  /// Parameters:
  /// - mode: The new theme mode to set
  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    await _prefs.setString(_themeKey, mode.toString());
    notifyListeners();
  }

  /// Toggles between light and dark theme modes
  void toggleTheme() {
    final newMode = _themeMode == ThemeMode.light 
        ? ThemeMode.dark 
        : ThemeMode.light;
    setThemeMode(newMode);
  }
}

