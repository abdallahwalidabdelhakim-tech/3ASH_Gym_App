/// Application configuration management
/// This file defines the AppConfig class, which provides static properties for configuring
/// This class contains static configuration properties for the 3ASH - Gym Trainer app,
/// including backend API configuration and environment-specific settings.  
library;
import 'dart:io';
import 'package:flutter/foundation.dart';

/// App configuration for switching between mock and real backend
class AppConfig {
  /// Flag indicating whether to use mock services instead of real backend API
  /// 
  /// You can set this via environment variable: USE_MOCK_BACKEND=true
  /// Defaults to false (real backend) if not specified
  static const bool useMockBackend = bool.fromEnvironment(
    'USE_MOCK_BACKEND',
    defaultValue: true, // Default to real backend API
  );

  /// Base URL for the real backend API
  /// 
  /// Returns the API base URL based on the current platform and environment configuration.
  /// Prioritizes environment variable API_BASE_URL if specified.
  static String get baseUrl {
    // Check for environment variable configuration
    const envUrl = String.fromEnvironment('API_BASE_URL');
    if (envUrl.isNotEmpty) {
      return envUrl;
    }
    
    // Web platform configuration
    if (kIsWeb) {
      return 'http://localhost:3000/api';
    }
    
    // Android platform configuration (uses local network IP for emulator)
    if (Platform.isAndroid) {
      return 'http://192.168.100.7:3000/api';
    }
    
    // iOS and other platforms default configuration
    return 'http://localhost:3001/api';
  }
}

