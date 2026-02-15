import 'package:flutter/material.dart';

/// Action card widget with image background and button
class ActionCard extends StatelessWidget {

  const ActionCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.buttonColor,
    required this.onTap,
  });
  final String imagePath;
  final String title;
  final Color buttonColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        children: [
          // Background image fills the entire card
          Positioned.fill(
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[300],
                  child: const Center(child: Icon(Icons.image, size: 50)),
                );
              },
            ),
          ),
          // Dark overlay for readability
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.25),
              ),
            ),
          ),
          // Button anchored to the bottom with padding
          Positioned(
            left: 12,
            right: 12,
            bottom: 12,
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(title),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
