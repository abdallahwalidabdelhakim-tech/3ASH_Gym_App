/// Custom text field widget
///
/// A reusable Material-style text input field with custom styling and behavior.
/// Supports validation, prefix/suffix icons, read-only mode, and more.
library;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {

  /// Creates a CustomTextField instance
  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.validator,
    this.keyboardType,
    this.maxLines = 1,
    this.readOnly = false,
    this.onTap,
    this.inputFormatters,
  });
  /// Text editing controller for the text field
  final TextEditingController controller;
  
  /// Label text for the text field
  final String label;
  
  /// Hint text for the text field
  final String hint;
  
  /// Optional prefix icon for the text field
  final IconData? prefixIcon;
  
  /// Optional suffix icon for the text field
  final Widget? suffixIcon;
  
  /// Whether the text should be obscured (password field)
  final bool obscureText;
  
  /// Optional validation function for the text field
  final String? Function(String?)? validator;
  
  /// Keyboard type for the text field
  final TextInputType? keyboardType;
  
  /// Maximum number of lines for multiline text fields
  final int? maxLines;
  
  /// Whether the text field should be read-only
  final bool readOnly;
  
  /// Callback when the text field is tapped (useful for read-only fields)
  final VoidCallback? onTap;
  
  /// Optional input formatters to apply to text input
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      keyboardType: keyboardType,
      maxLines: maxLines,
      readOnly: readOnly,
      onTap: onTap,
      inputFormatters: inputFormatters,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        labelText: label,
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white54),
        labelStyle: const TextStyle(color: Colors.white70),
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: Colors.white70)
            : null,
        prefixIconConstraints: const BoxConstraints(minWidth: 48, minHeight: 48),
        suffixIcon: suffixIcon,
        suffixIconConstraints: const BoxConstraints(minWidth: 48, minHeight: 48),
        filled: true,
        fillColor: Colors.white.withAlpha(10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFD5FF5F), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        errorStyle: const TextStyle(color: Colors.red),
      ),
    );
  }
}

