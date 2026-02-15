/// Locale (language) state management provider
///
/// Handles language/locale management with persistent storage.
/// Supports English (en_US) and Arabic (ar_SA) languages.
library;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider extends ChangeNotifier {

  /// Creates a LocaleProvider instance with shared preferences
  LocaleProvider(this._prefs) {
    _loadLocale();
  }
  /// Shared preferences instance for persistent storage
  final SharedPreferences _prefs;
  
  /// Key used to store locale in shared preferences
  static const String _localeKey = 'locale';
  
  /// Current locale
  Locale _locale = const Locale('en', 'US');

  /// Gets the current locale
  Locale get locale => _locale;

  /// Loads saved locale from shared preferences
  void _loadLocale() {
    final localeString = _prefs.getString(_localeKey);
    if (localeString != null) {
      final parts = localeString.split('_');
      if (parts.length == 2) {
        _locale = Locale(parts[0], parts[1]);
        notifyListeners();
      }
    }
  }

  /// Sets a new locale and saves it to persistent storage
  /// 
  /// Parameters:
  /// - locale: The new locale to set
  Future<void> setLocale(Locale locale) async {
    _locale = locale;
    await _prefs.setString(_localeKey, '${locale.languageCode}_${locale.countryCode}');
    notifyListeners();
  }

  /// Toggles between English and Arabic languages
  void toggleLanguage() {
    final newLocale = _locale.languageCode == 'en'
        ? const Locale('ar', 'SA')
        : const Locale('en', 'US');
    setLocale(newLocale);
  }
}

