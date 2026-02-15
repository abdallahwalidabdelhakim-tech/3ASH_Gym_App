/// Social login button widget
///
/// A reusable button widget for social media login providers (Google, Facebook, Apple).
/// Features customizable icon, label, and colors.
library;
import 'package:flutter/material.dart';

class SocialLoginButton extends StatelessWidget {

  /// Creates a SocialLoginButton instance
  const SocialLoginButton({
    super.key,
    required this.icon,
    required this.label,
    required this.backgroundColor,
    required this.textColor,
    required this.onPressed,
  });
  /// Icon to display on the button
  final IconData icon;
  
  /// Label text for the button
  final String label;
  
  /// Background color of the button
  final Color backgroundColor;
  
  /// Text color of the button
  final Color textColor;
  
  /// Callback when the button is pressed
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 24),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

