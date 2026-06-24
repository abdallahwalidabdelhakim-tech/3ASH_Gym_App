import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../screens/workout/workout_screen.dart';
import '../../core/services/plan_service.dart';

/// Screen that displays detailed information about a workout program.
/// Shows program overview, individual day cards, and a button to select the program.
class ProgramDetailsScreen extends StatelessWidget {

  const ProgramDetailsScreen({
    super.key,
    required this.program,
  });
  final WorkoutProgram program;

  @override
  Widget build(BuildContext context) {
    // Determine if we are in dark mode to style the app bar correctly
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF1A1A1A) : Colors.white,
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF1A1A1A) : Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.home,
            color: isDark ? Colors.white : Colors.black,
            size: 24,
          ),
          onPressed: () => context.go('/home'),
        ),
        title: const Text(
          'Program Details',
          style: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.arrow_forward_ios,
              color: isDark ? Colors.white : Colors.black,
              size: 18,
            ),
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/home');
              }
            },
          ),
        ],
      ),
  body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1A1A1A) : const Color(0xFFF5F5F5),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    ...program.workoutDays.asMap().entries.map((entry) {
                      final index = entry.key;
                      final workoutDay = entry.value;
                      return Column(
                        children: [
                          if (index > 0) const SizedBox(height: 16),
                          _buildDayCard(
                            context,
                            workoutDay: workoutDay,
                            isDark: isDark,
                          ),
                        ],
                      );
                    }),
                    const SizedBox(height: 24),
                    // Select Program Button
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 32),
                      child: ElevatedButton(
                        onPressed: () => _selectProgram(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD5FF5F),
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Select This Program',
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
            ),
          ),
        ],
      ),
    );
  }

  /// Builds a card for a workout day, with special design for rest days
  Widget _buildDayCard(
    BuildContext context, {
    required WorkoutDay workoutDay,
    required bool isDark,
  }) {
    final hasExercises = workoutDay.exercises.isNotEmpty;
    final isRestDay = workoutDay.title.toUpperCase().contains('REST');
    
    // Special design for rest days
    if (isRestDay) {
      return _buildRestDayCard(context, workoutDay, isDark);
    }
    
    return GestureDetector(
      onTap: hasExercises ? () {
        context.push('/workout/day-exercises', extra: {'workoutDay': workoutDay, 'program': program});
      } : null,
      child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color.fromARGB(0, 0, 0, 0) : Colors.white,
        border: Border.all(color: const Color(0xFFD5FF5F), width: 4),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Anatomy Image
          SizedBox(
            width: 100,  // Optimal width for 1:2 aspect ratio
            height: 130,  // Perfect height matching 1:2 aspect ratio
            child: Image.asset(
              workoutDay.imagePath,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.person, size: 80),
            ),
          ),
          const SizedBox(width: 14),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '| ${workoutDay.day}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  workoutDay.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white70 : Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                if (workoutDay.duration.isNotEmpty && workoutDay.workoutCount.isNotEmpty) ...[
                  Row(
                    children: [
                      Icon(Icons.timer_outlined, size: 18, color: isDark ? Colors.white70 : Colors.black87),
                      const SizedBox(width: 4),
                      Text(
                        workoutDay.duration,
                        style: TextStyle(
                          color: isDark ? Colors.white70 : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.fitness_center_outlined, size: 18, color: isDark ? Colors.white70 : Colors.black87),
                      const SizedBox(width: 4),
                      Text(
                        workoutDay.workoutCount,
                        style: TextStyle(
                          color: isDark ? Colors.white70 : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ] else if (workoutDay.title.toUpperCase().contains('CARDIO')) ...[
                  Text(
                    'CARDIO',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: isDark ? Colors.white70 : Colors.black87,
                    ),
                  ),
                ],
                if (hasExercises) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.arrow_forward_ios, size: 14, color: isDark ? Colors.white70 : Colors.black87),
                      const SizedBox(width: 4),
                      Text(
                        'Tap to view exercises',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.white60 : Colors.black54,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
      ),
    );
  }

  /// Builds a specialized card for rest days
  Widget _buildRestDayCard(
    BuildContext context,
    WorkoutDay workoutDay,
    bool isDark,
  ) {
    // Dark olive green color palette
    const darkOliveGreen = Color(0xFF3D4F3D);
    const neonYellowGreen = Color(0xFFD5FF5F);
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: darkOliveGreen,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          // Header with day and icon
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: darkOliveGreen,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.nightlight_round,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      workoutDay.day,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Rest & Recovery',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Rest day message card with neon yellow-green border
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: darkOliveGreen,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: neonYellowGreen,
                width: 2,
              ),
            ),
            child: Column(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.eco_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Time to Recharge',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  workoutDay.workoutCount.isNotEmpty
                      ? workoutDay.workoutCount
                      : 'Take a break!',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Recovery tips
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildRecoveryTip(
                Icons.water_drop_outlined,
                'Hydrate',
                darkOliveGreen,
                neonYellowGreen,
              ),
              _buildRecoveryTip(
                Icons.bed_outlined,
                'Sleep Well',
                darkOliveGreen,
                neonYellowGreen,
              ),
              _buildRecoveryTip(
                Icons.favorite_outline,
                'Relax',
                darkOliveGreen,
                neonYellowGreen,
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Builds a recovery tip widget with icon and label
  Widget _buildRecoveryTip(
    IconData icon,
    String label,
    Color backgroundColor,
    Color accentColor,
  ) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: backgroundColor,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 20,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: accentColor,
          ),
        ),
      ],
    );
  }

  /// Selects the program and saves it to storage
  Future<void> _selectProgram(BuildContext context) async {
    try {
      // Convert WorkoutProgram to a serializable format
      final planData = {
        'title': program.title,
        'subtitle': program.subtitle,
        'duration': program.duration,
        'imagePath': program.imagePath,
        'workoutDays': program.workoutDays.map((day) => {
          'day': day.day,
          'title': day.title,
          'duration': day.duration,
          'workoutCount': day.workoutCount,
          'imagePath': day.imagePath,
          'exercises': day.exercises.map((e) => {
            'name': e.name,
            'mainImageUrl': e.mainImageUrl,
            'videoUrl': e.videoUrl,
            'galleryImages': e.galleryImages,
            'instructions': e.instructions,
          }).toList(),
        }).toList(),
      };

      await PlanService.saveProgramPlan(planData);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Program selected! Your plan is now active.'),
            backgroundColor: Color(0xFFD5FF5F),
            duration: Duration(seconds: 2),
          ),
        );
        // Navigate back to home
        context.go('/home');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error selecting program: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
