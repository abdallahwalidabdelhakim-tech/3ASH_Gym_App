import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

import '../../core/models/user_model.dart';
import '../../core/services/auth_service.dart';
import '../../core/services/user_service.dart';

/// Screen for displaying and managing user profile information.
/// Allows users to view, edit, and update their personal details, profile picture,
/// and log out of the application.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  /// Current user data
  UserModel? _user;
  /// Loading state for API calls
  bool _isLoading = true;
  /// Error message to display to the user
  String? _errorMessage;
  /// Path to user's profile image
  String? _profileImagePath;

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
    _loadProfile();
  }

  /// Loads profile image path from SharedPreferences
  Future<void> _loadProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    final path = prefs.getString('profile_image_path');
    if (!mounted) return;
    setState(() {
      _profileImagePath = path;
    });
  }

  /// Picks a profile image from gallery and saves it to local storage
  Future<void> _pickAndSaveProfileImage() async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1024,
      );

      if (picked == null) return;

      final docsDir = await getApplicationDocumentsDirectory();
      final ext = p.extension(picked.path);
      final safeExt = ext.isEmpty ? '.jpg' : ext;
      final savedPath = p.join(docsDir.path, 'profile_image$safeExt');

      await File(picked.path).copy(savedPath);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('profile_image_path', savedPath);

      if (!mounted) return;
      setState(() {
        _profileImagePath = savedPath;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  /// Loads user profile data from backend
  Future<void> _loadProfile() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final userService = context.read<UserService>();
      final result = await userService.getCurrentUser();
      
      if (!mounted) return;

      if (result['success'] == true) {
        final userJson = result['user'] as Map<String, dynamic>?;
        setState(() {
          _user = userJson != null ? UserModel.fromJson(userJson) : null;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = result['message'] ?? 'Failed to load profile';
        });
        if (result['message'] == 'Not authenticated') {
          context.go('/login');
        }
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  /// Updates user profile information
  Future<bool> _updateProfile({
    String? username,
    String? country,
    String? phoneNumber,
  }) async {
    try {
      final userService = context.read<UserService>();
      final result = await userService.updateProfile(
        username: username,
        country: country,
        phoneNumber: phoneNumber,
      );

      if (!mounted) return false;

      if (result['success'] == true) {
        final userJson = result['user'] as Map<String, dynamic>?;
        setState(() {
          _user = userJson != null ? UserModel.fromJson(userJson) : _user;
        });
        return true;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? 'Failed to update profile'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    } catch (e) {
      if (!mounted) return false;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final userName = _user?.username ?? '';
    final userEmail = _user?.email ?? '';
    final country = _user?.country ?? '';
    final phoneNumber = _user?.phoneNumber ?? '';

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF1A1A1A) : Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header with gradient background
            Container(
              height: 200,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFFD5FF5F),
                    const Color(0xFFD5FF5F).withValues(alpha:0.7),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Stack(
                children: [
                  // Edit profile image button
                  Positioned(
                    top: 16,
                    right: 16,
                    child: IconButton(
                      icon: const Icon(Icons.edit_outlined, color: Colors.black),
                      onPressed: () {
                        _pickAndSaveProfileImage();
                      },
                    ),
                  ),
                  // User information section
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Column(
                      children: [
                        // Profile picture
                        Builder(
                          builder: (context) {
                            final localPath = _profileImagePath;
                            final file = (localPath == null) ? null : File(localPath);
                            final hasFile = file != null && file.existsSync();

                            return Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
                                  width: 4,
                                ),
                                image: DecorationImage(
                                  image: hasFile ? FileImage(file) : const AssetImage('assets/black 1.png'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: hasFile
                                  ? null
                                  : DecoratedBox(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.grey[300],
                                      ),
                                      child: const Icon(
                                        Icons.person,
                                        size: 50,
                                        color: Colors.grey,
                                      ),
                                    ),
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _isLoading ? '' : userName,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _isLoading ? '' : userEmail,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFFD5FF5F),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Profile details section
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : (_errorMessage != null)
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  _errorMessage ?? '',
                                  style: TextStyle(
                                    color: isDark ? Colors.white70 : Colors.black54,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 12),
                                ElevatedButton(
                                  onPressed: _loadProfile,
                                  child: const Text('Retry'),
                                ),
                              ],
                            ),
                          ),
                        )
                      : ListView(
                          padding: const EdgeInsets.all(20),
                          children: [
                  _buildProfileField(
                    context,
                    'Name',
                    userName,
                    'Change name',
                    Icons.arrow_forward_ios,
                    () {
                      _showEditDialog(context, 'Name', userName, (value) async {
                        final ok = await _updateProfile(username: value);
                        if (!ok) return;
                      });
                    },
                  ),
                  const Divider(color: Color(0xFFD5FF5F), height: 32),
                  _buildProfileField(
                    context,
                    'Country',
                    country,
                    'Change country',
                    Icons.arrow_forward_ios,
                    () {
                      _showEditDialog(context, 'Country', country, (value) async {
                        final ok = await _updateProfile(country: value);
                        if (!ok) return;
                      });
                    },
                  ),
                  const Divider(color: Color(0xFFD5FF5F), height: 32),
                  _buildProfileField(
                    context,
                    'Phone Number',
                    phoneNumber,
                    'Change phone number',
                    Icons.arrow_forward_ios,
                    () {
                      _showEditDialog(context, 'Phone Number', phoneNumber, (value) async {
                        final ok = await _updateProfile(phoneNumber: value);
                        if (!ok) return;
                      });
                    },
                  ),
                  const Divider(color: Color(0xFFD5FF5F), height: 32),
                  _buildProfileField(
                    context,
                    'Password',
                    '************',
                    'change password',
                    Icons.arrow_forward_ios,
                    () {
                      context.push('/change-password');
                    },
                  ),
                          ],
                        ),
            ),

            // Footer with Logout button
            Container(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    _showLogoutDialog(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Log out',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds a profile field widget with editable functionality
  Widget _buildProfileField(
    BuildContext context,
    String label,
    String value,
    String hint,
    IconData icon,
    VoidCallback onTap,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFFD5FF5F),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  hint,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.white70 : Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            icon,
            size: 16,
            color: const Color(0xFFD5FF5F),
          ),
        ],
      ),
    );
  }

  /// Shows a dialog for editing profile fields
  void _showEditDialog(
    BuildContext context,
    String title,
    String currentValue,
    Future<void> Function(String) onSave,
  ) {
    final controller = TextEditingController(text: currentValue);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF2A2A2A) : Colors.white,
        title: Text(
          title,
          style: TextStyle(color: isDark ? Colors.white : Colors.black),
        ),
        content: TextField(
          controller: controller,
          style: TextStyle(color: isDark ? Colors.white : Colors.black),
          decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: isDark ? Colors.white70 : Colors.black54,
              ),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFD5FF5F)),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                onSave(controller.text).then((_) {
                  if (!context.mounted) return;
                  if (Navigator.of(context).canPop()) {
                    Navigator.pop(context);
                  }
                });
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD5FF5F),
              foregroundColor: Colors.black,
            ),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  /// Shows a dialog to confirm logout action
  void _showLogoutDialog(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF2A2A2A) : Colors.white,
        title: Text(
          'Log Out',
          style: TextStyle(color: isDark ? Colors.white : Colors.black),
        ),
        content: Text(
          'Are you sure you want to log out?',
          style: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              await context.read<AuthService>().clearToken();
              if (!context.mounted) return;
              context.go('/login');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }
}

