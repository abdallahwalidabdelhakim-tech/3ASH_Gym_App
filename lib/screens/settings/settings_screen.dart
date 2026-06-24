import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/providers/theme_provider.dart';
import '../../core/providers/locale_provider.dart';
import '../../core/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Screen for managing application settings.
/// Allows users to customize language, theme, notifications, and access privacy and about information.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  /// Flag indicating if notifications are enabled
  bool _notificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  /// Loads settings from SharedPreferences
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool('notifications_enabled') ?? true;
    });
  }

  /// Saves notification setting to SharedPreferences
  Future<void> _saveNotificationSetting(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_enabled', value);
    setState(() {
      _notificationsEnabled = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final localeProvider = Provider.of<LocaleProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations?.settings ?? 'Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Preferences Section
          _buildSectionHeader(
            context,
            localizations?.translate('preferences') ?? 'Preferences',
          ),
          
          // Language Setting
          _buildListTile(
            context,
            icon: Icons.language,
            title: localizations?.language ?? 'Language',
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  localeProvider.locale.languageCode == 'ar'
                      ? localizations?.translate('arabic') ?? 'Arabic'
                      : localizations?.translate('english') ?? 'English',
                  style: TextStyle(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Switch(
                  value: localeProvider.locale.languageCode == 'ar',
                  onChanged: (value) {
                    localeProvider.toggleLanguage();
                  },
                  activeThumbColor: theme.colorScheme.primary,
                ),
              ],
            ),
          ),
          
          // Theme Setting
          _buildListTile(
            context,
            icon: themeProvider.themeMode == ThemeMode.dark
                ? Icons.dark_mode
                : Icons.light_mode,
            title: localizations?.theme ?? 'Theme',
            trailing: DropdownButton<ThemeMode>(
              value: themeProvider.themeMode,
              underline: const SizedBox(),
              items: [
                DropdownMenuItem(
                  value: ThemeMode.light,
                  child: Text(localizations?.translate('light_theme') ?? 'Light'),
                ),
                DropdownMenuItem(
                  value: ThemeMode.dark,
                  child: Text(localizations?.translate('dark_theme') ?? 'Dark'),
                ),
                DropdownMenuItem(
                  value: ThemeMode.system,
                  child: Text(localizations?.translate('system_theme') ?? 'System'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  themeProvider.setThemeMode(value);
                }
              },
            ),
          ),
          const Divider(),
          
          // Notifications Section
          _buildSectionHeader(
            context,
            localizations?.translate('notifications') ?? 'Notifications',
          ),
          _buildListTile(
            context,
            icon: Icons.notifications_outlined,
            title: localizations?.translate('notifications') ?? 'Notifications',
            trailing: Switch(
              value: _notificationsEnabled, 
              onChanged: (value) {
                _saveNotificationSetting(value);
              },
              activeThumbColor: theme.colorScheme.primary,
            ),
          ),
          const Divider(),
          
          // Privacy Section
          _buildSectionHeader(
            context,
            localizations?.translate('privacy') ?? 'Privacy',
          ),
          _buildListTile(
            context,
            icon: Icons.privacy_tip_outlined,
            title: localizations?.translate('privacy') ?? 'Privacy',
            onTap: () {
              context.push('/settings/privacy');
            },
          ),
          const Divider(),
          
          // About Section
          _buildSectionHeader(
            context,
            localizations?.translate('about') ?? 'About',
          ),
          _buildListTile(
            context,
            icon: Icons.info_outline,
            title: localizations?.translate('about') ?? 'About',
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: localizations?.translate('app_name') ?? '3ASH App',
                applicationVersion: '1.0.0',
                applicationIcon: const Icon(Icons.fitness_center),
                children: [
                   Text(localizations?.translate('about_description') ?? 'A fitness application to track your progress and health.'),
                ],
              );
            },
          ),
          const SizedBox(height: 32),
          
          // Logout Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton(
              onPressed: () {
                _showLogoutDialog(context, localizations);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.logout),
                  const SizedBox(width: 8),
                  Text(
                    localizations?.logout ?? 'Logout',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds a section header widget
  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 8, left: 16),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  /// Builds a list tile widget with optional trailing widget and onTap callback
  Widget _buildListTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: trailing,
      onTap: onTap,
    );
  }

  /// Shows a logout confirmation dialog
  void _showLogoutDialog(
    BuildContext context,
    AppLocalizations? localizations,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(localizations?.logout ?? 'Logout'),
        content: Text(
          localizations?.translate('logout_confirmation') ?? 
              'Are you sure you want to logout?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(localizations?.translate('cancel') ?? 'Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final prefs = await SharedPreferences.getInstance();
              
              // Clear plan data first
              await prefs.remove('plan');
              
              // Use AuthService to clear authentication data
              if (context.mounted) {
                await context.read<AuthService>().clearToken();
              }
              
              // Clear other stored user data if necessary
              if (context.mounted) {
                context.go('/login');
              }
            },
            child: Text(
              localizations?.logout ?? 'Logout',
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}

