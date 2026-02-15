import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../screens/workout/workout_screen.dart';
import '../../screens/exercise/exercise_detail_screen.dart';
import '../../core/models/exercise.dart';

/// Screen that displays exercises for a specific workout day.
/// Shows exercise cards in a grid layout and provides a button to start the workout.
class DayExercisesScreen extends StatelessWidget {

  const DayExercisesScreen({
    super.key,
    required this.workoutDay,
    required this.program,
  });
  final WorkoutDay workoutDay;
  final WorkoutProgram program;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const neonGreen = Color(0xFFD0FD3E);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF1C1C1E) : Colors.white,
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF1C1C1E) : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? Colors.white : Colors.black,
          ),
          onPressed: () {
            context.go('/workout/details', extra: program);
          },
        ),
        title: Text(
          '${workoutDay.day} - ${workoutDay.title}',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: workoutDay.exercises.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.fitness_center,
                    size: 64,
                    color: isDark ? Colors.white54 : Colors.black54,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No exercises for this day',
                    style: TextStyle(
                      color: isDark ? Colors.white54 : Colors.black54,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Day info card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF2C2C2C) : Colors.grey[100],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        if (workoutDay.duration.isNotEmpty) ...[
                          Icon(Icons.timer_outlined,
                              size: 18, color: isDark ? Colors.white70 : Colors.black87),
                          const SizedBox(width: 8),
                          Text(
                            workoutDay.duration,
                            style: TextStyle(
                              color: isDark ? Colors.white70 : Colors.black87,
                            ),
                          ),
                          const SizedBox(width: 16),
                        ],
                        if (workoutDay.workoutCount.isNotEmpty) ...[
                          Icon(Icons.fitness_center_outlined,
                              size: 18, color: isDark ? Colors.white70 : Colors.black87),
                          const SizedBox(width: 8),
                          Text(
                            workoutDay.workoutCount,
                            style: TextStyle(
                              color: isDark ? Colors.white70 : Colors.black87,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Exercises (${workoutDay.exercises.length})',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: GridView.builder(
                      itemCount: workoutDay.exercises.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.8,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemBuilder: (context, index) {
                        final exercise = workoutDay.exercises[index];
                        return _ExerciseCard(
                          exercise: exercise,
                          neonGreen: neonGreen,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Start Workout Button
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: () {
                        // Convert Exercise objects to Map format expected by WorkoutSessionScreen
                        final sessionExercises = workoutDay.exercises.map((e) => {
                          'name': e.name,
                          'mainImageUrl': e.mainImageUrl,
                          'reps': '12-10-8', // Default reps as it's not in Exercise model yet
                        }).toList();

                        context.push('/workout/session', extra: {
                          'exercises': sessionExercises,
                          'dayTitle': workoutDay.title,
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: neonGreen,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'START WORKOUT',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

/// Widget for displaying an exercise card with image and title.
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
          border: Border.all(color: neonGreen, width: 3),
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
              height: 2,
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

