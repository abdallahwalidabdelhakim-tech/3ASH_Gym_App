/// Splash screen widget
///
/// Displays the app logo and loading indicator on app startup.
/// Automatically navigates to login screen after 3 seconds.
library;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/services/auth_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  /// Navigates based on authentication status
  Future<void> _navigateToNextScreen() async {
    // Minimum splash display time
    await Future.delayed(const Duration(seconds: 2));
    
    if (!mounted) return;

    try {
      final authService = context.read<AuthService>();
      final isAuthenticated = await authService.isAuthenticated();
      
      if (!mounted) return;
      
      if (isAuthenticated) {
        context.go('/home');
      } else {
        context.go('/login');
      }
    } catch (e) {
      // Fallback to login on error
      if (mounted) context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 247, 247, 247),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App logo image
            Image.asset(
              'assets/black 1.png',
              width: 200,
              height: 200,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.fitness_center,
                  size: 120,
                  color: Colors.white,
                );
              },
            ),
            const SizedBox(height: 20),
            // Loading indicator
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 12, 12, 12)),
            ),
            const SizedBox(height: 20),
            // Loading text
            Text(
              localizations?.loading ?? 'Loading...',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

