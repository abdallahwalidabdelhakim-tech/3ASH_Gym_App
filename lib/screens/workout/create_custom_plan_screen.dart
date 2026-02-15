import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/models/exercise.dart';
import '../../core/data/exercise_data.dart';
import '../../core/services/plan_service.dart';

/// Screen for creating a custom workout plan.
/// Allows users to select exercises from various categories and configure plan settings.
class CreateCustomPlanScreen extends StatefulWidget {
  const CreateCustomPlanScreen({super.key});

  @override
  State<CreateCustomPlanScreen> createState() => _CreateCustomPlanScreenState();
}

class _CreateCustomPlanScreenState extends State<CreateCustomPlanScreen> {
  /// Map of selected exercises (key: exercise name, value: Exercise object)
  final Map<String, Exercise> _selectedExercises = {};
  
  /// List of exercise categories to display
  final List<String> _categories = [
    'Chest',
    'Upper back',
    'Lower back',
    'Abs',
    'Legs',
    'Arms',
    'Shoulders',
    'Cardio',
  ];

  /// Map to track expansion state of category expansion tiles
  final Map<String, bool> _expandedCategories = {};

  /// Saving state indicator
  bool _isSaving = false;

  /// Plan duration in weeks
  int _durationWeeks = 4;
  /// Number of training days per week
  int _daysPerWeek = 3;

  /// Handles exercise selection/deselection
  void _onExerciseToggle(bool? selected, Exercise exercise) {
    setState(() {
      if (selected == true) {
        _selectedExercises[exercise.name] = exercise;
      } else {
        _selectedExercises.remove(exercise.name);
      }
    });
  }

  /// Saves the custom plan to storage
  Future<void> _savePlan() async {
    if (_selectedExercises.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one exercise')),
      );
      return;
    }

    // Minimum exercises check: need at least enough for 1 per day
    if (_selectedExercises.length < _daysPerWeek) {
         ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please select at least $_daysPerWeek exercises (one for each training day)')),
        );
        return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      // Logic to distribute exercises across days
      final allSelected = _selectedExercises.values.toList();
      final workouts = <Map<String, dynamic>>[];
      
      // Divide exercises into chunks with even distribution
      final int totalExercises = allSelected.length;
      final int baseChunkSize = totalExercises ~/ _daysPerWeek; // Integer division
      final int remainder = totalExercises % _daysPerWeek;

      int curIndex = 0;

      for (int i = 0; i < _daysPerWeek; i++) {
        // First 'remainder' days get +1 exercise
        final int countForThisDay = baseChunkSize + (i < remainder ? 1 : 0);
        
        final daysExercises = allSelected.sublist(curIndex, curIndex + countForThisDay);
        curIndex += countForThisDay;

        // Convert to map format expected by plan, adding default sets/reps
        final exercisesList = daysExercises.map((e) {
          return {
            'name': e.name,
            'mainImageUrl': e.mainImageUrl,
            'videoUrl': e.videoUrl,
            'sets': 3, // Default
            'reps': '12', // Default
          };
        }).toList();

        workouts.add({
          'title': 'Custom Workout Day ${i + 1}',
          'day': 'Day ${i + 1}',
          'exercises': exercisesList,
        });
      }

      // Add Rest Days
      final int restDays = 7 - _daysPerWeek;
      for (int i = 0; i < restDays; i++) {
        workouts.add({
          'title': 'Rest Day',
          'day': 'Day ${_daysPerWeek + i + 1}',
          'exercises': [],
        });
      }

      final planData = {
        'title': 'Custom Plan',
        'type': 'custom',
        'difficulty': 'Custom',
        'durationWeeks': _durationWeeks,
        'duration': '$_durationWeeks WEEKS', // For expiration logic compatibility
        'daysPerWeek': _daysPerWeek,
        'workoutDays': workouts,
      };

      await PlanService.saveCustomPlan(planData);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Custom plan created successfully!')),
        );
        context.go('/home'); // Return to home (which will refresh)
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving plan: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const neonGreen = Color(0xFFD0FD3E);
    const backgroundColor = Color(0xFF1C1C1E);

    // Filter categories that have exercises
    final categoriesWithExercises = _categories.where((cat) {
      return ExerciseData.getExercisesForCategory(cat).isNotEmpty;
    }).toList();

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'CREATE CUSTOM PLAN',
          style: TextStyle(
            color: neonGreen,
            fontWeight: FontWeight.bold,
            fontSize: 20,
            letterSpacing: 1.2,
          ),
        ),
      ),
      body: Column(
        children: [
            // Plan Settings Section
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(25), // 0.1 * 255
                border: const Border(bottom: BorderSide(color: Colors.white10)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Duration Slider
                  _buildSettingSlider(
                    context: context, 
                    title: 'Duration', 
                    value: _durationWeeks.toDouble(), 
                    min: 2, 
                    max: 12, 
                    unit: 'Weeks',
                    activeColor: neonGreen,
                    onChanged: (val) {
                      setState(() => _durationWeeks = val.toInt());
                    }
                  ),
                  const SizedBox(height: 16),
                  // Days per Week Slider
                   _buildSettingSlider(
                    context: context, 
                    title: 'Training Frequency', 
                    value: _daysPerWeek.toDouble(), 
                    min: 1, 
                    max: 7, 
                    unit: 'Days/Week',
                    activeColor: neonGreen,
                    onChanged: (val) {
                      setState(() => _daysPerWeek = val.toInt());
                    }
                  ),
                ],
              ),
            ),


            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: backgroundColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   const Text(
                   'Select Exercises',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Text(
                    '${_selectedExercises.length} selected',
                    style: const TextStyle(color: neonGreen, fontSize: 16),
                  ),
                ],
              ),
            ),
            
            Expanded(
              child: ListView.builder(
              itemCount: categoriesWithExercises.length,
              itemBuilder: (context, index) {
                final category = categoriesWithExercises[index];
                final exercises = ExerciseData.getExercisesForCategory(category);
                final isExpanded = _expandedCategories[category] ?? false;

                return Theme(
                  data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    title: Text(
                      category,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    iconColor: neonGreen,
                    collapsedIconColor: Colors.white54,
                    backgroundColor: Colors.white.withAlpha(12),  // 0.05 * 255
                    initiallyExpanded: isExpanded,
                    onExpansionChanged: (expanded) {
                      setState(() {
                        _expandedCategories[category] = expanded;
                      });
                    },
                    children: exercises.map((exercise) {
                      final isSelected = _selectedExercises.containsKey(exercise.name);
                      return CheckboxListTile(
                        value: isSelected,
                        onChanged: (val) => _onExerciseToggle(val, exercise),
                        title: Text(
                          exercise.name,
                          style: TextStyle(
                            color: isSelected ? neonGreen : Colors.white70,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        secondary: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: exercise.mainImageUrl != null
                              ? Image.asset(
                                  exercise.mainImageUrl!,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_,_,_) => const Icon(Icons.fitness_center, color: Colors.white54),
                                )
                               : const Icon(Icons.fitness_center, color: Colors.white54),
                        ),
                        checkColor: Colors.black,
                        activeColor: neonGreen,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _isSaving ? null : _savePlan,
        backgroundColor: neonGreen,
        foregroundColor: Colors.black,
        icon: _isSaving 
          ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2)) 
          : const Icon(Icons.check),
        label: Text(_isSaving ? 'SAVING...' : 'SAVE PLAN'),
      ),
    );
  }

  /// Builds a custom slider widget with title and value display
  Widget _buildSettingSlider({
    required BuildContext context,
    required String title,
    required double value,
    required double min,
    required double max,
    required String unit,
    required Color activeColor,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(color: Colors.white70, fontSize: 14)),
            Text('${value.toInt()} $unit', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 4,
            activeTrackColor: activeColor,
            inactiveTrackColor: Colors.white24,
            thumbColor: activeColor,
            overlayColor: activeColor.withAlpha(51), // 0.2 * 255
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
          ),
          child: Slider(
            value: value,
            min: min,
            max: max,
            divisions: (max - min).toInt(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
