import 'package:flutter/material.dart';
import 'package:boda_new/core/models/workout_log.dart';

/// Widget to display list of personal records (PRs) for exercises
/// 
/// Shows PRs in a scrollable list with exercise name and PR details.
class PrList extends StatelessWidget {

  const PrList({super.key, required this.prs});
  final List<ExerciseSetLog> prs;

  @override
  Widget build(BuildContext context) {
    // Show empty state if no PRs available
    if (prs.isEmpty) {
       return const Center(child: Text('No PRs yet. Go lift heavy!'));
    }
    
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListView.builder(
      itemCount: prs.length,
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        final pr = prs[index];
        return Card(
          color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Color(0xFFD5FF5F),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.emoji_events, color: Colors.black),
            ),
            title: Text(
              pr.exerciseName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            subtitle: Text(
              '${pr.weight} kg x ${pr.reps} reps',
              style: TextStyle(
                 color: isDark ? Colors.white70 : Colors.black87,
                 fontSize: 16,
              ),
            ),
          ),
        );
      },
    );
  }
}
