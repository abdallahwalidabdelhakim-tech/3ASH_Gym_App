import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/models/exercise.dart';
import '../../core/data/exercise_data.dart';
import 'exercise_detail_screen.dart';

/// Screen for displaying exercises in a specific category
class ExerciseListScreen extends StatelessWidget {

  const ExerciseListScreen({
    super.key,
    required this.categoryName,
  });
  final String categoryName;

  @override
  Widget build(BuildContext context) {
    // Neon green color from design
    const neonGreen = Color(0xFFD0FD3E);
    // Dark background color
    const backgroundColor = Color(0xFF1C1C1E); // Slightly lighter than pure black for material feel

    final List<Exercise> exercises = _getExercisesForCategory(categoryName);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Transparent to match design if background is consistent
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.home, color: Colors.white, size: 30), // Home icon as per design
          onPressed: () => context.go('/home'), 
        ),
        title: Text(
          '$categoryName EXERCISES'.toUpperCase(),
          style: const TextStyle(
            color: neonGreen,
            fontWeight: FontWeight.bold,
            fontSize: 20,
            letterSpacing: 1.2,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white), 
            onPressed: () => context.pop(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: GridView.builder(
          itemCount: exercises.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 3 Columns
            childAspectRatio: 0.8, // Taller than wide to fit image + text
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemBuilder: (context, index) {
            return _ExerciseCard(exercise: exercises[index], neonGreen: neonGreen);
          },
        ),
      ),
    );
  }

  /// Retrieves exercises for the specified category
  List<Exercise> _getExercisesForCategory(String category) {
    return ExerciseData.getExercisesForCategory(category);
  }
}

/// Widget for displaying exercise cards in the grid
class _ExerciseCard extends StatelessWidget {

  const _ExerciseCard({
    required this.exercise,
    required this.neonGreen,
  });
  final Exercise exercise;
  final Color neonGreen;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ExerciseDetailScreen(exercise: exercise),
          ),
        );
      },
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: neonGreen, width: 3), // Neon border
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: exercise.mainImageUrl != null 
                  ? Image.asset(
                      exercise.mainImageUrl!,
                      fit: BoxFit.cover,
                      width: double.infinity, 
                      errorBuilder: (context, error, stackTrace) => Icon(
                        Icons.fitness_center,
                        color: Colors.grey[700],
                        size: 40,
                      ),
                    )
                  : Icon(
                      Icons.fitness_center,
                      color: Colors.grey[700],
                      size: 40,
                    ),
            ),
            Container(
              height: 2, // Divider line
              color: neonGreen,
            ),
            Expanded(
              flex: 2,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
                alignment: Alignment.center,
                child: Text(
                  exercise.name.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: neonGreen,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
