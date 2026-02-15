/// Main entry point of the 3ASH - Gym Trainer application
///
/// This file initializes the application, sets up providers for state management,
/// and configures the root widget with theme and localization support.
library;
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/theme/app_theme.dart';
import 'core/localization/app_localizations_delegate.dart';
import 'core/providers/theme_provider.dart';
import 'core/providers/locale_provider.dart';
import 'core/router/app_router.dart';
import 'core/services/auth_service.dart';
import 'core/services/user_service.dart';

/// Main application entry point function
///
/// Initializes Flutter bindings, shared preferences, creates test user (if mock backend),
/// and runs the root application widget with all necessary providers.
void main() async {
  // Ensure Flutter framework is initialized before any async operations
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize shared preferences for persistent storage
  final prefs = await SharedPreferences.getInstance();
  
  // Run the application with MultiProvider for state management
  runApp(
    MultiProvider(
      providers: [
        // Provide theme management with shared preferences
        ChangeNotifierProvider(create: (_) => ThemeProvider(prefs)),
        // Provide locale (language) management with shared preferences
        ChangeNotifierProvider(create: (_) => LocaleProvider(prefs)),
        // Provide authentication service
        Provider(create: (_) => AuthService()),
        // Provide user service that depends on auth service
        ProxyProvider<AuthService, UserService>(
          update: (_, authService, _) => UserService(authService),
        ),
      ],
      child: const GymTrainerApp(),
    ),
  );
}

/// Root application widget
///
/// This is a stateless widget that configures the MaterialApp with theme,
/// localization, and routing support using providers.
class GymTrainerApp extends StatelessWidget {
  const GymTrainerApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Listen to changes in theme and locale from providers
    return Consumer2<ThemeProvider, LocaleProvider>(
      builder: (context, themeProvider, localeProvider, child) {
        return MaterialApp.router(
          // Application title
          title: '3ASH - Gym Trainer',
          // Hide debug banner in release mode
          debugShowCheckedModeBanner: false,
          
          // Theme configuration
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.themeMode,
          
          // Localization configuration
          locale: localeProvider.locale,
          supportedLocales: const [
            Locale('en', 'US'), // English (United States)
            Locale('ar', 'SA'), // Arabic (Saudi Arabia)
          ],
          localizationsDelegates: const [
            AppLocalizationsDelegate(), // Custom app translations
            GlobalMaterialLocalizations.delegate, // Material widget translations
            GlobalWidgetsLocalizations.delegate, // Widgets translations
            GlobalCupertinoLocalizations.delegate, // Cupertino widget translations
          ],
          
          // Router configuration for navigation
          routerConfig: AppRouter.router,
        );
      },
    );
  }
}

