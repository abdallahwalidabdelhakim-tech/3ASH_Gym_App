/// Login screen widget
///
/// Displays the login interface with username/password fields,
/// social login options, and animated transitions.
library;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/services/auth_service.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/social_login_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  /// Form key for validation
  final _formKey = GlobalKey<FormState>();
  
  /// Username text field controller
  final _usernameController = TextEditingController();
  
  /// Password text field controller
  final _passwordController = TextEditingController();
  
  /// Remember me checkbox state
  bool _rememberMe = true;
  
  /// Loading state indicator
  bool _isLoading = false;
  
  /// Password visibility toggle
  bool _obscurePassword = true;
  
  /// Animation controller for login screen animations
  late AnimationController _animationController;
  
  /// Logo position animation (moves from center to top)
  late Animation<double> _logoPositionAnimation;
  
  /// Logo opacity animation (fades in)
  late Animation<double> _logoOpacityAnimation;
  
  /// Content opacity animation (fades in after logo starts moving)
  late Animation<double> _contentOpacityAnimation;

  @override
  void initState() {
    super.initState();
    
    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    // Logo position animation: starts from center, moves to top
    _logoPositionAnimation = Tween<double>(
      begin: 0.0, // Center position
      end: 1.0,   // Top position
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    // Logo opacity: fades in quickly
    _logoOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.3, curve: Curves.easeIn),
    ));

    // Content opacity: fades in after logo starts moving
    _contentOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.4, 1.0, curve: Curves.easeIn),
    ));

    // Start animation when page opens
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Handles login process
  /// 
  /// Validates form, calls authentication service, and handles success/failure.
  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final authService = context.read<AuthService>();
      final result = await authService.login(
        username: _usernameController.text.trim(),
        password: _passwordController.text,
        rememberMe: _rememberMe,
      );
  
      if (mounted) {
        if (result['success'] == true) {
          // await _saveUserData(result['user'], result['token']);
          final token = result['token'];
          if (token is String && token.isNotEmpty) {
            await authService.saveToken(token, persist: _rememberMe);
          }
          
          if (mounted) context.go('/home');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message'] ?? 'Login failed'),
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
              isDark ? 'assets/gg.png' : 'assets/gg.png',
            ),
            fit: BoxFit.cover,
            opacity: 0.3,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Animated content
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _contentOpacityAnimation.value,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.only(
                        left: 24.0,
                        right: 24.0,
                        bottom: 24.0,
                        top: 180.0, // Space for logo at top
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Title
                            Text(
                              localizations?.login ?? 'Login',
                              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              localizations?.hiWelcomeBack ?? 'Hi, Welcome back!',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: Colors.white70,
                                  ),
                            ),
                            const SizedBox(height: 32),
                  // Username Field
                  CustomTextField(
                    controller: _usernameController,
                    label: localizations?.username ?? 'Username',
                    hint: localizations?.username ?? 'Username',
                    prefixIcon: Icons.person_outline,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return localizations?.translate('username_required') ?? 'Username is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  // Password Field
                  CustomTextField(
                    controller: _passwordController,
                    label: localizations?.password ?? 'Password',
                    hint: localizations?.password ?? 'Password',
                    prefixIcon: Icons.lock_outline,
                    obscureText: _obscurePassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                      ),
                      onPressed: () {
                        setState(() => _obscurePassword = !_obscurePassword);
                      },
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return localizations?.translate('password_required') ?? 'Password is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  // Remember Me & Forgot Password
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: _rememberMe,
                            onChanged: (value) {
                              setState(() => _rememberMe = value ?? true);
                            },
                            activeColor: Theme.of(context).colorScheme.primary,
                          ),
                          Text(
                            localizations?.rememberMe ?? 'Remember me',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    TextButton(
                      onPressed: () => context.push('/forgot-password'),
                      child: Text(
                        localizations?.forgotPassword ?? 'Forgot password',
                        style: const TextStyle(
                          color: Colors.red,
                          decoration: TextDecoration.underline, // <-- adds underline
                           decorationColor: Colors.red,    
                        ),
                      ),
                    ),

                    ],
                  ),
                  const SizedBox(height: 24),
                  // Login Button
                  Container(
                    height: 56,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color.fromARGB(255, 255, 255, 255).withValues(alpha:0.15),
                          const Color.fromARGB(255, 255, 255, 255).withValues(alpha:0.15),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha:0.20),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: _isLoading ? null : _handleLogin,
                        borderRadius: BorderRadius.circular(30),
                        child: Container(
                          alignment: Alignment.center,
                          child: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : Text(
                                  localizations?.login ?? 'Login',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Divider
                  const Row(
                    children: [
                      Expanded(child: Divider(color: Colors.white54)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'or',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
                      Expanded(child: Divider(color: Colors.white54)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Social Login Buttons
                  SocialLoginButton(
                    icon: Icons.facebook,
                    label: localizations?.translate('continue_with_facebook') ?? 'Continue with Facebook',
                    backgroundColor: const Color(0xFF1877F2),
                    textColor: Colors.white,
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Facebook login coming soon!')),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  SocialLoginButton(
                    icon: Icons.g_mobiledata,
                    label: localizations?.translate('continue_with_google') ?? 'Continue with Google',
                    backgroundColor: Colors.white,
                    textColor: Colors.black,
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Google login coming soon!')),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  SocialLoginButton(
                    icon: Icons.apple,
                    label: localizations?.translate('continue_with_apple') ?? 'Continue with Apple',
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Apple login coming soon!')),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  // Sign Up Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        localizations?.dontHaveAccount ?? "Don't have an account?",
                        style: const TextStyle(color: Colors.white70),
                      ),
                      TextButton(
                        onPressed: () => context.push('/signup'),
                        child: Text(
                          localizations?.signUp ?? 'Sign up',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
                );
                },
              ),
              // Animated Logo
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  final screenHeight = MediaQuery.of(context).size.height;
                  final safeAreaTop = MediaQuery.of(context).padding.top;
                  final centerY = (screenHeight - safeAreaTop) / 2;
                  final topY = 50.0; // Final top position
                  
                  // Calculate current Y position
                  final currentY = centerY + (topY - centerY) * _logoPositionAnimation.value;
                  
                  return Positioned(
                    top: currentY - 125, // Center the logo (half of 250 height)
                    left: 0,
                    right: 0,
                    child: Opacity(
                      opacity: _logoOpacityAnimation.value,
                      child: Center(
                        child: Image.asset(
                          'assets/س-removebg-preview 3.png',
                          width: 250,
                          height: 250,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.fitness_center,
                              size: 80,
                              color: Colors.white,
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

