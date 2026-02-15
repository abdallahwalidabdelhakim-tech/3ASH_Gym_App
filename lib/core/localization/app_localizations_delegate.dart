/// Localization delegate for app translations
///
/// Handles the loading and management of app translations based on the selected locale.
/// Supports English and Arabic languages.
library;
import 'package:flutter/material.dart';
import 'app_localizations.dart';

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  /// Default constructor
  const AppLocalizationsDelegate();

  /// Checks if a given locale is supported
  /// 
  /// Parameters:
  /// - locale: The locale to check for support
  /// Returns: true if the locale's language code is 'en' or 'ar'
  @override
  bool isSupported(Locale locale) {
    return ['en', 'ar'].contains(locale.languageCode);
  }

  /// Loads the appropriate localization data for the given locale
  /// 
  /// Parameters:
  /// - locale: The locale to load translations for
  // ignore: unintended_html_in_doc_comment
  /// Returns: Future<AppLocalizations> with the loaded translation data
  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  /// Determines if the delegate should reload when the old delegate instance changes
  /// 
  /// Returns: false - no reload needed
  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}

