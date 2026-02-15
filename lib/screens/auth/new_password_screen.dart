import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/services/auth_service.dart';
import '../../widgets/custom_text_field.dart';

/// Screen for creating a new password during password reset
/// 
/// Allows users to set a new password after verifying their email with a
/// reset code. Features password strength validation and automatic login redirection.
class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({super.key});

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _showSuccessDialog = false;
  String? _email;
  String? _code;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Get email and code from route extra
    final extra = GoRouterState.of(context).extra;
    if (_email == null && extra is Map) {
      final email = extra['email'];
      final code = extra['code'];
      if (email is String && code is String) {
        setState(() {
          _email = email;
          _code = code;
        });
      }
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  /// Handles password reset submission
  Future<void> _handleResetPassword() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_email == null || _code == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Missing email or code'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final result = await _authService.resetPassword(
        email: _email!,
        code: _code!,
        newPassword: _passwordController.text,
      );

      if (mounted) {
        if (result['success'] == true) {
          setState(() => _showSuccessDialog = true);
          // Auto navigate after 3 seconds
          Future.delayed(const Duration(seconds: 3), () {
            if (mounted) {
              context.go('/login');
            }
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message'] ?? 'Failed to reset password'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              isDark ? 'assets/Rectangle 53.png' : 'assets/Rectangle 53 (1).png',
            ),
            fit: BoxFit.cover,
            opacity: 0.3,
          ),
        ),
        child: Container(
          color: Colors.black..withValues(alpha:0.55),
          child: SafeArea(
            child: Stack(
              children: [
                SingleChildScrollView(
                  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: const EdgeInsets.all(24.0),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 520),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha:0.08),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: Colors.white.withValues(alpha:0.12)),
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const SizedBox(height: 12),
                              // Title
                              Text(
                                localizations?.translate('create_new_password') ??
                                    'Create a New Password',
                                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                              ),
                              const SizedBox(height: 24),
                              // Password Field
                              CustomTextField(
                                controller: _passwordController,
                                label: localizations?.password ?? 'Password',
                                hint: localizations?.translate('enter_password') ?? 'Enter password',
                                prefixIcon: Icons.lock_outline,
                                obscureText: _obscurePassword,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    color: Colors.white70,
                                  ),
                                  onPressed: () {
                                    setState(() => _obscurePassword = !_obscurePassword);
                                  },
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return localizations?.translate('password_required') ??
                                        'Password is required';
                                  }
                                  if (value.length < 6) {
                                    return localizations?.translate('password_too_short') ??
                                        'Password must be at least 6 characters';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              // Confirm Password Field
                              CustomTextField(
                                controller: _confirmPasswordController,
                                label: localizations?.translate('re_enter_password') ??
                                    'Re-enter password',
                                hint: localizations?.translate('re_enter_password') ??
                                    'Re-enter password',
                                prefixIcon: Icons.lock_outline,
                                obscureText: _obscureConfirmPassword,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureConfirmPassword
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    color: Colors.white70,
                                  ),
                                  onPressed: () {
                                    setState(
                                      () => _obscureConfirmPassword = !_obscureConfirmPassword,
                                    );
                                  },
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return localizations?.translate('password_required') ??
                                        'Password is required';
                                  }
                                  if (value != _passwordController.text) {
                                    return localizations?.translate('passwords_not_match') ??
                                        'Passwords do not match';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 8),
                              // Show Password Checkbox
                              Row(
                                children: [
                                  Checkbox(
                                    value: _obscurePassword == false,
                                    onChanged: (value) {
                                      setState(() {
                                        _obscurePassword = !(value ?? false);
                                        _obscureConfirmPassword = !(value ?? false);
                                      });
                                    },
                                    activeColor: Theme.of(context).colorScheme.primary,
                                    checkColor: Colors.black,
                                    side: BorderSide(color: Colors.white.withValues(alpha:0.6)),
                                  ),
                                  Text(
                                    localizations?.translate('show_password') ?? 'Show Password',
                                    style: const TextStyle(color: Colors.white70),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 18),
                              // Progress Indicator
                              Row(
                                children: [
                                  const Text(
                                    '2 of 2',
                                    style: TextStyle(color: Colors.white70),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(999),
                                      child: LinearProgressIndicator(
                                        minHeight: 6,
                                        value: 1.0,
                                        backgroundColor: Colors.white.withValues(alpha:0.2),
                                        valueColor:
                                            const AlwaysStoppedAnimation<Color>(Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 18),
                              // Verify Button
                              ElevatedButton(
                                onPressed: _isLoading ? null : _handleResetPassword,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  foregroundColor: Colors.white,
                                  minimumSize: const Size(double.infinity, 54),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: _isLoading
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(Colors.white),
                                        ),
                                      )
                                    : Text(localizations?.translate('verify') ?? 'Verify'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Success Dialog
                if (_showSuccessDialog)
                  Container(
                    color: Colors.black54,
                    child: Center(
                      child: Container(
                        margin: const EdgeInsets.all(24),
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: const BoxDecoration(
                                color: Colors.black,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.check_circle,
                                color: Colors.white,
                                size: 50,
                              ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              localizations?.translate('congratulations') ??
                                  'Congratulations!',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              localizations?.translate('password_reset_successful') ??
                                  'Password Reset successful',
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              localizations?.translate('redirect_to_login') ??
                                  "You'll be redirected to the login screen now",
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.grey),
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton(
                              onPressed: () => context.go('/login'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                foregroundColor: Colors.white,
                                minimumSize: const Size(double.infinity, 50),
                              ),
                              child: Text(localizations?.login ?? 'Login'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

