import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/models/exercise.dart';
import '../../core/data/exercise_data.dart';
import '../../core/services/plan_service.dart';

/// Model for an exercise entry in a custom plan day
class _PlanExerciseEntry {
  _PlanExerciseEntry({
    required this.exercise,
  })  : sets = 3,
        reps = '12';

  final Exercise exercise;
  int sets;
  String reps;
}

/// Screen for creating a custom workout plan in a table format.
/// Users can add exercises to specific days and configure sets/reps inline.
class CreateCustomPlanScreen extends StatefulWidget {
  const CreateCustomPlanScreen({super.key});

  @override
  State<CreateCustomPlanScreen> createState() => _CreateCustomPlanScreenState();
}

class _CreateCustomPlanScreenState extends State<CreateCustomPlanScreen>
    with SingleTickerProviderStateMixin {
  static const neonGreen = Color(0xFFD0FD3E);
  static const backgroundColor = Color(0xFF1C1C1E);
  static const cardColor = Color(0xFF2C2C2E);
  static const surfaceColor = Color(0xFF3A3A3C);

  /// Plan settings
  int _durationWeeks = 4;
  int _daysPerWeek = 3;

  /// Exercises per day: day index => list of exercise entries
  late List<List<_PlanExerciseEntry>> _dayExercises;

  /// Custom day titles
  late List<String> _dayTitles;

  /// Tab controller for day tabs
  late TabController _tabController;

  /// Saving state
  bool _isSaving = false;

  /// Available exercise categories
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

  @override
  void initState() {
    super.initState();
    _initializeDays();
  }

  void _initializeDays() {
    _dayExercises = List.generate(_daysPerWeek, (_) => <_PlanExerciseEntry>[]);
    _dayTitles = List.generate(_daysPerWeek, (i) => 'Day ${i + 1}');
    _tabController = TabController(length: _daysPerWeek, vsync: this);
  }

  void _updateDaysPerWeek(int newDays) {
    if (newDays == _daysPerWeek) return;

    setState(() {
      final oldDays = _daysPerWeek;
      _daysPerWeek = newDays;

      // Preserve existing days data
      final oldExercises = List<List<_PlanExerciseEntry>>.from(_dayExercises);
      final oldTitles = List<String>.from(_dayTitles);

      _dayExercises = List.generate(newDays, (i) {
        if (i < oldDays) return oldExercises[i];
        return <_PlanExerciseEntry>[];
      });
      _dayTitles = List.generate(newDays, (i) {
        if (i < oldDays) return oldTitles[i];
        return 'Day ${i + 1}';
      });

      _tabController.dispose();
      _tabController = TabController(
        length: _daysPerWeek,
        vsync: this,
        initialIndex: _tabController.index.clamp(0, newDays - 1),
      );
    });
  }

  /// Shows dialog to add exercises to the current day
  void _showAddExerciseDialog(int dayIndex) {
    // Track which exercises are already added to this day
    final existingNames =
        _dayExercises[dayIndex].map((e) => e.exercise.name).toSet();
    final selectedToAdd = <Exercise>{};

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.75,
              decoration: const BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  // Handle bar
                  Container(
                    margin: const EdgeInsets.only(top: 12),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  // Header
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Add to ${_dayTitles[dayIndex]}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton.icon(
                          onPressed: selectedToAdd.isEmpty
                              ? null
                              : () {
                                  setState(() {
                                    for (final ex in selectedToAdd) {
                                      _dayExercises[dayIndex].add(
                                        _PlanExerciseEntry(exercise: ex),
                                      );
                                    }
                                  });
                                  Navigator.pop(context);
                                },
                          icon: Icon(
                            Icons.add_circle,
                            color: selectedToAdd.isEmpty
                                ? Colors.white24
                                : neonGreen,
                          ),
                          label: Text(
                            'Add (${selectedToAdd.length})',
                            style: TextStyle(
                              color: selectedToAdd.isEmpty
                                  ? Colors.white24
                                  : neonGreen,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(color: Colors.white10, height: 1),
                  // Exercise categories and exercises
                  Expanded(
                    child: ListView.builder(
                      itemCount: _categories.length,
                      itemBuilder: (context, catIndex) {
                        final category = _categories[catIndex];
                        final exercises =
                            ExerciseData.getExercisesForCategory(category);
                        if (exercises.isEmpty) {
                          return const SizedBox.shrink();
                        }

                        return Theme(
                          data: Theme.of(context)
                              .copyWith(dividerColor: Colors.transparent),
                          child: ExpansionTile(
                            title: Row(
                              children: [
                                _getCategoryIcon(category),
                                const SizedBox(width: 12),
                                Text(
                                  category,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const Spacer(),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withAlpha(15),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    '${exercises.length}',
                                    style: const TextStyle(
                                      color: Colors.white54,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            iconColor: neonGreen,
                            collapsedIconColor: Colors.white54,
                            backgroundColor: Colors.white.withAlpha(8),
                            children: exercises.map((exercise) {
                              final isAlreadyAdded =
                                  existingNames.contains(exercise.name);
                              final isSelected =
                                  selectedToAdd.contains(exercise);

                              return ListTile(
                                onTap: isAlreadyAdded
                                    ? null
                                    : () {
                                        setSheetState(() {
                                          if (isSelected) {
                                            selectedToAdd.remove(exercise);
                                          } else {
                                            selectedToAdd.add(exercise);
                                          }
                                        });
                                      },
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: exercise.mainImageUrl != null
                                      ? Image.asset(
                                          exercise.mainImageUrl!,
                                          width: 44,
                                          height: 44,
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, _, _) =>
                                              Container(
                                            width: 44,
                                            height: 44,
                                            color: surfaceColor,
                                            child: const Icon(
                                                Icons.fitness_center,
                                                color: Colors.white38,
                                                size: 20),
                                          ),
                                        )
                                      : Container(
                                          width: 44,
                                          height: 44,
                                          color: surfaceColor,
                                          child: const Icon(
                                              Icons.fitness_center,
                                              color: Colors.white38,
                                              size: 20),
                                        ),
                                ),
                                title: Text(
                                  exercise.name,
                                  style: TextStyle(
                                    color: isAlreadyAdded
                                        ? Colors.white30
                                        : isSelected
                                            ? neonGreen
                                            : Colors.white70,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    fontSize: 14,
                                  ),
                                ),
                                trailing: isAlreadyAdded
                                    ? const Icon(Icons.check_circle,
                                        color: Colors.white24, size: 22)
                                    : isSelected
                                        ? const Icon(Icons.check_circle,
                                            color: neonGreen, size: 22)
                                        : const Icon(
                                            Icons.add_circle_outline,
                                            color: Colors.white38,
                                            size: 22,
                                          ),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 2),
                              );
                            }).toList(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  /// Shows dialog to edit sets/reps
  void _showEditSetsRepsDialog(int dayIndex, int exerciseIndex) {
    final entry = _dayExercises[dayIndex][exerciseIndex];
    final setsController =
        TextEditingController(text: entry.sets.toString());
    final repsController = TextEditingController(text: entry.reps);

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: cardColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            entry.exercise.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDialogTextField(
                controller: setsController,
                label: 'Sets',
                hint: 'e.g. 3',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              _buildDialogTextField(
                controller: repsController,
                label: 'Reps',
                hint: 'e.g. 12 or 12-10-8',
                keyboardType: TextInputType.text,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child:
                  const Text('Cancel', style: TextStyle(color: Colors.white54)),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  entry.sets =
                      int.tryParse(setsController.text) ?? entry.sets;
                  entry.reps = repsController.text.isNotEmpty
                      ? repsController.text
                      : entry.reps;
                });
                Navigator.pop(ctx);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: neonGreen,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDialogTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white, fontSize: 16),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white54),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white24),
        filled: true,
        fillColor: surfaceColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: neonGreen, width: 1.5),
        ),
      ),
    );
  }

  /// Shows dialog to rename a day
  void _showRenameDayDialog(int dayIndex) {
    final controller = TextEditingController(text: _dayTitles[dayIndex]);
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: cardColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Rename Day',
              style: TextStyle(color: Colors.white, fontSize: 18)),
          content: TextField(
            controller: controller,
            autofocus: true,
            style: const TextStyle(color: Colors.white, fontSize: 16),
            decoration: InputDecoration(
              hintText: 'e.g. Push Day, Leg Day',
              hintStyle: const TextStyle(color: Colors.white24),
              filled: true,
              fillColor: surfaceColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: neonGreen, width: 1.5),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child:
                  const Text('Cancel', style: TextStyle(color: Colors.white54)),
            ),
            ElevatedButton(
              onPressed: () {
                if (controller.text.trim().isNotEmpty) {
                  setState(() {
                    _dayTitles[dayIndex] = controller.text.trim();
                  });
                }
                Navigator.pop(ctx);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: neonGreen,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Icon _getCategoryIcon(String category) {
    switch (category) {
      case 'Chest':
        return const Icon(Icons.fitness_center, color: neonGreen, size: 20);
      case 'Upper back':
        return const Icon(Icons.airline_seat_flat, color: neonGreen, size: 20);
      case 'Lower back':
        return const Icon(Icons.accessibility_new, color: neonGreen, size: 20);
      case 'Abs':
        return const Icon(Icons.grid_on, color: neonGreen, size: 20);
      case 'Legs':
        return const Icon(Icons.directions_walk, color: neonGreen, size: 20);
      case 'Arms':
        return const Icon(Icons.sports_martial_arts, color: neonGreen, size: 20);
      case 'Shoulders':
        return const Icon(Icons.man, color: neonGreen, size: 20);
      case 'Cardio':
        return const Icon(Icons.directions_run, color: neonGreen, size: 20);
      default:
        return const Icon(Icons.fitness_center, color: neonGreen, size: 20);
    }
  }

  /// Saves the custom plan
  Future<void> _savePlan() async {
    // Validate: at least one day must have exercises
    final hasExercises =
        _dayExercises.any((dayList) => dayList.isNotEmpty);
    if (!hasExercises) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please add at least one exercise to a day')),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final workouts = <Map<String, dynamic>>[];

      for (int i = 0; i < _daysPerWeek; i++) {
        final dayEntries = _dayExercises[i];

        if (dayEntries.isEmpty) {
          // Empty training day becomes rest day
          workouts.add({
            'title': 'Rest Day',
            'day': _dayTitles[i],
            'exercises': [],
          });
        } else {
          final exercisesList = dayEntries.map((entry) {
            return {
              'name': entry.exercise.name,
              'mainImageUrl': entry.exercise.mainImageUrl,
              'videoUrl': entry.exercise.videoUrl,
              'sets': entry.sets,
              'reps': entry.reps,
            };
          }).toList();

          workouts.add({
            'title': _dayTitles[i],
            'day': _dayTitles[i],
            'exercises': exercisesList,
          });
        }
      }

      // Add remaining rest days to fill 7 days
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
        'duration': '$_durationWeeks WEEKS',
        'daysPerWeek': _daysPerWeek,
        'workoutDays': workouts,
      };

      await PlanService.saveCustomPlan(planData);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Custom plan created successfully!')),
        );
        context.go('/home');
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
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            fontSize: 18,
            letterSpacing: 1.2,
          ),
        ),
      ),
      body: Column(
        children: [
          // ── Plan Settings ──
          _buildPlanSettings(),

          // ── Day Tabs ──
          _buildDayTabs(),

          // ── Exercise Table for selected day ──
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: List.generate(_daysPerWeek, (dayIndex) {
                return _buildDayTable(dayIndex);
              }),
            ),
          ),
        ],
      ),
      // Save button
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  /// Plan settings (duration + days per week)
  Widget _buildPlanSettings() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(15),
        border: const Border(bottom: BorderSide(color: Colors.white10)),
      ),
      child: Row(
        children: [
          // Duration
          Expanded(
            child: _buildCompactSetting(
              icon: Icons.calendar_month,
              label: 'Duration',
              value: '$_durationWeeks Weeks',
              onTap: () => _showDurationPicker(),
            ),
          ),
          Container(
            width: 1,
            height: 40,
            color: Colors.white12,
            margin: const EdgeInsets.symmetric(horizontal: 12),
          ),
          // Training Days
          Expanded(
            child: _buildCompactSetting(
              icon: Icons.today,
              label: 'Training Days',
              value: '$_daysPerWeek days/week',
              onTap: () => _showDaysPicker(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactSetting({
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: surfaceColor.withAlpha(120),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: neonGreen, size: 20),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style:
                        const TextStyle(color: Colors.white38, fontSize: 11)),
                const SizedBox(height: 2),
                Text(value,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold)),
              ],
            ),
            const Spacer(),
            const Icon(Icons.chevron_right, color: Colors.white24, size: 18),
          ],
        ),
      ),
    );
  }

  void _showDurationPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Plan Duration',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [2, 4, 6, 8, 10, 12].map((weeks) {
                  final isSelected = _durationWeeks == weeks;
                  return ChoiceChip(
                    label: Text('$weeks Weeks'),
                    selected: isSelected,
                    selectedColor: neonGreen,
                    backgroundColor: surfaceColor,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.black : Colors.white70,
                      fontWeight: FontWeight.bold,
                    ),
                    onSelected: (_) {
                      setState(() => _durationWeeks = weeks);
                      Navigator.pop(ctx);
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  void _showDaysPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Training Days per Week',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [1, 2, 3, 4, 5, 6, 7].map((days) {
                  final isSelected = _daysPerWeek == days;
                  return ChoiceChip(
                    label: Text('$days ${days == 1 ? 'Day' : 'Days'}'),
                    selected: isSelected,
                    selectedColor: neonGreen,
                    backgroundColor: surfaceColor,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.black : Colors.white70,
                      fontWeight: FontWeight.bold,
                    ),
                    onSelected: (_) {
                      _updateDaysPerWeek(days);
                      Navigator.pop(ctx);
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  /// Day tabs
  Widget _buildDayTabs() {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: backgroundColor,
        border: Border(bottom: BorderSide(color: Colors.white10)),
      ),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        indicatorColor: neonGreen,
        indicatorWeight: 3,
        labelColor: neonGreen,
        unselectedLabelColor: Colors.white54,
        labelStyle:
            const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        tabAlignment: TabAlignment.start,
        tabs: List.generate(_daysPerWeek, (i) {
          final exerciseCount = _dayExercises[i].length;
          return Tab(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(_dayTitles[i]),
                if (exerciseCount > 0) ...[
                  const SizedBox(width: 6),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                    decoration: BoxDecoration(
                      color: neonGreen.withAlpha(40),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '$exerciseCount',
                      style: const TextStyle(
                          color: neonGreen,
                          fontSize: 11,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ],
            ),
          );
        }),
      ),
    );
  }

  /// Exercise table for a specific day
  Widget _buildDayTable(int dayIndex) {
    final exercises = _dayExercises[dayIndex];

    return Column(
      children: [
        // Day header with rename + add button
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => _showRenameDayDialog(dayIndex),
                child: Row(
                  children: [
                    const Icon(Icons.edit, color: Colors.white38, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      _dayTitles[dayIndex],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Text(
                '${exercises.length} exercise${exercises.length == 1 ? '' : 's'}',
                style: const TextStyle(color: Colors.white38, fontSize: 13),
              ),
              const SizedBox(width: 12),
              _buildAddButton(dayIndex),
            ],
          ),
        ),

        // Table header
        if (exercises.isNotEmpty) _buildTableHeader(),

        // Exercise rows
        Expanded(
          child: exercises.isEmpty
              ? _buildEmptyDayPlaceholder(dayIndex)
              : ReorderableListView.builder(
                  itemCount: exercises.length,
                  onReorder: (oldIndex, newIndex) {
                    setState(() {
                      if (newIndex > oldIndex) newIndex--;
                      final item = exercises.removeAt(oldIndex);
                      exercises.insert(newIndex, item);
                    });
                  },
                  proxyDecorator: (child, index, animation) {
                    return Material(
                      color: Colors.transparent,
                      elevation: 4,
                      shadowColor: neonGreen.withAlpha(60),
                      child: child,
                    );
                  },
                  itemBuilder: (context, exIndex) {
                    return _buildExerciseRow(
                      dayIndex,
                      exIndex,
                      key: ValueKey(
                          '${exercises[exIndex].exercise.name}_$exIndex'),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildAddButton(int dayIndex) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => _showAddExerciseDialog(dayIndex),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            color: neonGreen.withAlpha(25),
            border: Border.all(color: neonGreen.withAlpha(80)),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add, color: neonGreen, size: 18),
              SizedBox(width: 4),
              Text(
                'Add',
                style: TextStyle(
                    color: neonGreen,
                    fontWeight: FontWeight.bold,
                    fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Table header row
  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      margin: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: surfaceColor.withAlpha(80),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: const Row(
        children: [
          SizedBox(width: 36), // drag handle space
          SizedBox(width: 8),
          // Exercise column header
          Expanded(
            flex: 4,
            child: Text(
              'EXERCISE',
              style: TextStyle(
                color: Colors.white38,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
              ),
            ),
          ),
          // Sets column header
          SizedBox(
            width: 50,
            child: Center(
              child: Text(
                'SETS',
                style: TextStyle(
                  color: Colors.white38,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
          SizedBox(width: 8),
          // Reps column header
          SizedBox(
            width: 65,
            child: Center(
              child: Text(
                'REPS',
                style: TextStyle(
                  color: Colors.white38,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
          SizedBox(width: 36), // delete button space
        ],
      ),
    );
  }

  /// A single exercise row in the table
  Widget _buildExerciseRow(int dayIndex, int exIndex, {required Key key}) {
    final entry = _dayExercises[dayIndex][exIndex];
    final isEven = exIndex % 2 == 0;

    return Container(
      key: key,
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isEven
            ? Colors.white.withAlpha(8)
            : Colors.white.withAlpha(15),
        border: Border(
          bottom: BorderSide(color: Colors.white.withAlpha(8)),
        ),
      ),
      child: Row(
        children: [
          // Drag handle
          const Icon(Icons.drag_indicator, color: Colors.white24, size: 20),
          const SizedBox(width: 8),

          // Exercise image + name
          Expanded(
            flex: 4,
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: entry.exercise.mainImageUrl != null
                      ? Image.asset(
                          entry.exercise.mainImageUrl!,
                          width: 36,
                          height: 36,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => Container(
                            width: 36,
                            height: 36,
                            color: surfaceColor,
                            child: const Icon(Icons.fitness_center,
                                color: Colors.white38, size: 16),
                          ),
                        )
                      : Container(
                          width: 36,
                          height: 36,
                          color: surfaceColor,
                          child: const Icon(Icons.fitness_center,
                              color: Colors.white38, size: 16),
                        ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    entry.exercise.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          // Sets (tappable)
          GestureDetector(
            onTap: () => _showEditSetsRepsDialog(dayIndex, exIndex),
            child: Container(
              width: 50,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                color: surfaceColor.withAlpha(120),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                '${entry.sets}',
                style: const TextStyle(
                  color: neonGreen,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Reps (tappable)
          GestureDetector(
            onTap: () => _showEditSetsRepsDialog(dayIndex, exIndex),
            child: Container(
              width: 65,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                color: surfaceColor.withAlpha(120),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                entry.reps,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

          // Delete button
          IconButton(
            icon: const Icon(Icons.close, color: Colors.redAccent, size: 18),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(
              minWidth: 36,
              minHeight: 36,
            ),
            onPressed: () {
              setState(() {
                _dayExercises[dayIndex].removeAt(exIndex);
              });
            },
          ),
        ],
      ),
    );
  }

  /// Empty state for a day with no exercises
  Widget _buildEmptyDayPlaceholder(int dayIndex) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.table_chart_outlined,
            size: 64,
            color: Colors.white.withAlpha(30),
          ),
          const SizedBox(height: 16),
          Text(
            'No exercises added to ${_dayTitles[dayIndex]}',
            style: const TextStyle(color: Colors.white38, fontSize: 15),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tap the + Add button to build your workout table',
            style: TextStyle(color: Colors.white24, fontSize: 13),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _showAddExerciseDialog(dayIndex),
            icon: const Icon(Icons.add, size: 20),
            label: const Text('Add Exercises'),
            style: ElevatedButton.styleFrom(
              backgroundColor: neonGreen.withAlpha(30),
              foregroundColor: neonGreen,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: neonGreen.withAlpha(80)),
              ),
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  /// Bottom bar with summary + save button
  Widget _buildBottomBar() {
    final totalExercises =
        _dayExercises.fold<int>(0, (sum, day) => sum + day.length);
    final daysWithExercises =
        _dayExercises.where((day) => day.isNotEmpty).length;

    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 12,
        bottom: MediaQuery.of(context).padding.bottom + 12,
      ),
      decoration: BoxDecoration(
        color: cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(80),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Summary
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$totalExercises exercises',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '$daysWithExercises of $_daysPerWeek days configured',
                style: const TextStyle(color: Colors.white38, fontSize: 12),
              ),
            ],
          ),
          const Spacer(),
          // Save button
          ElevatedButton(
            onPressed: _isSaving ? null : _savePlan,
            style: ElevatedButton.styleFrom(
              backgroundColor: neonGreen,
              foregroundColor: Colors.black,
              disabledBackgroundColor: neonGreen.withAlpha(80),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
              padding:
                  const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
              elevation: 0,
            ),
            child: _isSaving
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.black),
                  )
                : const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'SAVE PLAN',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
