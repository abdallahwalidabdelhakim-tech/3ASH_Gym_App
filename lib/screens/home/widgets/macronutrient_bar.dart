import 'package:flutter/material.dart';

/// Widget to display macronutrient progress bar
class MacronutrientBar extends StatelessWidget {

  const MacronutrientBar({
    super.key,
    required this.label,
    required this.current,
    required this.target,
    this.isDark = false,
  });
  final String label;
  final int current;
  final int target;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    // Avoid division by zero
    final progress = target > 0 ? current / target : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isDark ? Colors.white : Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            // Progress bar
            Expanded(
              child: Container(
                height: 8,
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[800] : Colors.grey[700],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Stack(
                  children: [
                    if (progress > 0)
                      FractionallySizedBox(
                        widthFactor: progress.clamp(0.0, 1.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFD5FF5F),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Value text
            Text(
              '$current /${target}g',
              style: TextStyle(
                fontSize: 12,
                color: isDark ? Colors.white70 : Colors.white70,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
