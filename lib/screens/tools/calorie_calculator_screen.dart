// ignore_for_file: use_late_for_private_fields_and_variables

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Enhanced Calorie Calculator Screen inspired by workout.cool
/// Uses Mifflin-St Jeor equation with goal-based calorie adjustments,
/// macro breakdown, and beautiful gradient design
class CalorieCalculatorScreen extends StatefulWidget {
  const CalorieCalculatorScreen({super.key});

  @override
  State<CalorieCalculatorScreen> createState() =>
      _CalorieCalculatorScreenState();
}

class _CalorieCalculatorScreenState extends State<CalorieCalculatorScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  late AnimationController _resultAnimController;

  String _gender = 'male';
  String _activityLevel = 'moderate';
  String _goal = 'maintain';
  double? _bmr;
  double? _tdee;
  double? _targetCalories;
  Map<String, double>? _macros;

  final _activityLevels = [
    {'key': 'sedentary', 'label': 'Sedentary', 'desc': 'Little or no exercise', 'multiplier': 1.2},
    {'key': 'light', 'label': 'Light', 'desc': '1-3 days/week', 'multiplier': 1.375},
    {'key': 'moderate', 'label': 'Moderate', 'desc': '3-5 days/week', 'multiplier': 1.55},
    {'key': 'active', 'label': 'Active', 'desc': '6-7 days/week', 'multiplier': 1.725},
    {'key': 'very_active', 'label': 'Very Active', 'desc': 'Intense daily exercise', 'multiplier': 1.9},
  ];

  final _goals = [
    {'key': 'lose', 'label': 'Lose Weight', 'icon': Icons.trending_down_rounded, 'offset': -500},
    {'key': 'maintain', 'label': 'Maintain', 'icon': Icons.horizontal_rule_rounded, 'offset': 0},
    {'key': 'gain', 'label': 'Gain Weight', 'icon': Icons.trending_up_rounded, 'offset': 500},
  ];

  @override
  void initState() {
    super.initState();
    _resultAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
  }

  @override
  void dispose() {
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _resultAnimController.dispose();
    super.dispose();
  }

  void _calculateCalories() {
    final age = int.tryParse(_ageController.text);
    final height = double.tryParse(_heightController.text);
    final weight = double.tryParse(_weightController.text);

    if (age == null || height == null || weight == null ||
        age <= 0 || height <= 0 || weight <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please enter valid age, height, and weight'),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    // Mifflin-St Jeor Equation
    double bmr;
    if (_gender == 'male') {
      bmr = 10 * weight + 6.25 * height - 5 * age + 5;
    } else {
      bmr = 10 * weight + 6.25 * height - 5 * age - 161;
    }

    // Activity Multiplier
    final activityData = _activityLevels.firstWhere((a) => a['key'] == _activityLevel);
    final tdee = bmr * (activityData['multiplier'] as double);

    // Goal offset
    final goalData = _goals.firstWhere((g) => g['key'] == _goal);
    final targetCals = tdee + (goalData['offset'] as int);

    // Macro calculation (based on goal)
    double proteinPct, carbsPct, fatPct;
    if (_goal == 'lose') {
      proteinPct = 0.35;
      carbsPct = 0.35;
      fatPct = 0.30;
    } else if (_goal == 'gain') {
      proteinPct = 0.25;
      carbsPct = 0.50;
      fatPct = 0.25;
    } else {
      proteinPct = 0.30;
      carbsPct = 0.40;
      fatPct = 0.30;
    }

    setState(() {
      _bmr = bmr;
      _tdee = tdee;
      _targetCalories = targetCals;
      _macros = {
        'protein': (targetCals * proteinPct) / 4, // 4 cal per gram
        'carbs': (targetCals * carbsPct) / 4,     // 4 cal per gram
        'fat': (targetCals * fatPct) / 9,          // 9 cal per gram
        'proteinPct': proteinPct * 100,
        'carbsPct': carbsPct * 100,
        'fatPct': fatPct * 100,
      };
    });

    _resultAnimController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 100,
            pinned: true,
            backgroundColor: isDark ? const Color(0xFF1A1A1A) : Colors.white,
            leading: GestureDetector(
              onTap: () => context.pop(),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.08)
                      : Colors.black.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 18,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              title: ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Color(0xFFD0FD3E), Color.fromARGB(255, 0, 0, 0)],
                ).createShader(bounds),
                child: Text(
                  'Calorie Calculator',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
              centerTitle: true,
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Formula info card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFFD0FD3E).withValues(alpha: 0.08),
                          const Color(0xFFD0FD3E).withValues(alpha: 0.04),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFFD0FD3E).withValues(alpha: 0.15),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFD0FD3E), Color.fromARGB(255, 0, 0, 0)],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.science_rounded,
                              color: Colors.white, size: 22),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Mifflin-St Jeor Formula',
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Gold standard for BMR calculations (Since 1990)',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: isDark ? Colors.white54 : Colors.black45,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Gender Selection
                  _buildSectionLabel(theme, 'Gender'),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _buildGenderOption('male', 'Male', Icons.male_rounded, theme, isDark),
                      const SizedBox(width: 12),
                      _buildGenderOption('female', 'Female', Icons.female_rounded, theme, isDark),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Age Input
                  _buildInputField(
                    controller: _ageController,
                    label: 'Age',
                    suffix: 'years',
                    icon: Icons.cake_rounded,
                    gradient: const [Color(0xFFD0FD3E), Color.fromARGB(255, 0, 0, 0)],
                    theme: theme,
                    isDark: isDark,
                  ),

                  const SizedBox(height: 16),

                  // Height Input
                  _buildInputField(
                    controller: _heightController,
                    label: 'Height',
                    suffix: 'cm',
                    icon: Icons.height_rounded,
                    gradient: const [Color(0xFFD0FD3E), Color.fromARGB(255, 0, 0, 0)],
                    theme: theme,
                    isDark: isDark,
                  ),

                  const SizedBox(height: 16),

                  // Weight Input
                  _buildInputField(
                    controller: _weightController,
                    label: 'Weight',
                    suffix: 'kg',
                    icon: Icons.monitor_weight_rounded,
                    gradient: const [Color(0xFFD0FD3E), Color.fromARGB(255, 0, 0, 0)],
                    theme: theme,
                    isDark: isDark,
                  ),

                  const SizedBox(height: 24),

                  // Activity Level
                  _buildSectionLabel(theme, 'Activity Level'),
                  const SizedBox(height: 10),
                  ...(_activityLevels.map((level) =>
                      _buildActivityOption(
                        level['key'] as String,
                        level['label'] as String,
                        level['desc'] as String,
                        theme,
                        isDark,
                      ))),

                  const SizedBox(height: 24),

                  // Goal Selection
                  _buildSectionLabel(theme, 'Your Goal'),
                  const SizedBox(height: 10),
                  Row(
                    children: _goals.map((g) {
                      return Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                            right: g != _goals.last ? 8.0 : 0,
                          ),
                          child: _buildGoalOption(
                            g['key'] as String,
                            g['label'] as String,
                            g['icon'] as IconData,
                            theme,
                            isDark,
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 32),

                  // Calculate Button
                  _buildCalculateButton(theme),

                  const SizedBox(height: 32),

                  // Results
                  if (_bmr != null) _buildResults(theme, isDark),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(ThemeData theme, String label) {
    return Text(
      label,
      style: theme.textTheme.titleSmall?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: 0.3,
      ),
    );
  }

  Widget _buildGenderOption(
      String value, String label, IconData icon, ThemeData theme, bool isDark) {
    final isSelected = _gender == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _gender = value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            gradient: isSelected
                ? const LinearGradient(
                    colors: [Color(0xFFD0FD3E), Color.fromARGB(255, 0, 0, 0)],
                  )
                : null,
            color: isSelected
                ? null
                : (isDark ? const Color(0xFF2A2A2A) : const Color(0xFFF8FAFC)),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected
                  ? Colors.transparent
                  : (isDark
                      ? Colors.white.withValues(alpha: 0.08)
                      : Colors.black.withValues(alpha: 0.08)),
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: const Color(0xFFD0FD3E).withValues(alpha: 0.25),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected
                    ? Colors.white
                    : (isDark ? Colors.white54 : Colors.black45),
                size: 22,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isSelected
                      ? Colors.white
                      : (isDark ? Colors.white70 : Colors.black54),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String suffix,
    required IconData icon,
    required List<Color> gradient,
    required ThemeData theme,
    required bool isDark,
  }) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.08)
              : Colors.black.withValues(alpha: 0.08),
        ),
      ),
      child: TextField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        style: theme.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          labelText: label,
          suffixText: suffix,
          suffixStyle: theme.textTheme.bodyMedium?.copyWith(
            color: isDark ? Colors.white38 : Colors.black38,
            fontWeight: FontWeight.w600,
          ),
          prefixIcon: Container(
            margin: const EdgeInsets.all(10),
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: gradient),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        ),
      ),
    );
  }

  Widget _buildActivityOption(
    String key,
    String label,
    String desc,
    ThemeData theme,
    bool isDark,
  ) {
    final isSelected = _activityLevel == key;
    return GestureDetector(
      onTap: () => setState(() => _activityLevel = key),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFD0FD3E).withValues(alpha: 0.1)
              : (isDark ? const Color(0xFF2A2A2A) : const Color(0xFFF8FAFC)),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFD0FD3E).withValues(alpha: 0.4)
                : (isDark
                    ? Colors.white.withValues(alpha: 0.06)
                    : Colors.black.withValues(alpha: 0.06)),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? const Color(0xFFD0FD3E)
                    : (isDark
                        ? Colors.white.withValues(alpha: 0.1)
                        : Colors.black.withValues(alpha: 0.08)),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFFD0FD3E)
                      : (isDark
                          ? Colors.white.withValues(alpha: 0.2)
                          : Colors.black.withValues(alpha: 0.15)),
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check_rounded, color: Colors.white, size: 14)
                  : null,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isSelected ? const Color(0xFFD0FD3E) : null,
                    ),
                  ),
                  Text(
                    desc,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isDark ? Colors.white38 : Colors.black38,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalOption(
    String key,
    String label,
    IconData icon,
    ThemeData theme,
    bool isDark,
  ) {
    final isSelected = _goal == key;
    return GestureDetector(
      onTap: () => setState(() => _goal = key),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
                  colors: [Color(0xFFD0FD3E), Color.fromARGB(255, 0, 0, 0)],
                )
              : null,
          color: isSelected
              ? null
              : (isDark ? const Color(0xFF2A2A2A) : const Color(0xFFF8FAFC)),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? Colors.transparent
                : (isDark
                    ? Colors.white.withValues(alpha: 0.08)
                    : Colors.black.withValues(alpha: 0.08)),
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? Colors.white
                  : (isDark ? Colors.white54 : Colors.black45),
              size: 22,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: isSelected
                    ? Colors.white
                    : (isDark ? Colors.white54 : Colors.black45),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalculateButton(ThemeData theme) {
    return GestureDetector(
      onTap: _calculateCalories,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFD0FD3E), Color.fromARGB(255, 0, 0, 0)],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFD0FD3E).withValues(alpha: 0.3),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.calculate_rounded, color: Colors.white, size: 22),
            const SizedBox(width: 10),
            Text(
              'Calculate Calories',
              style: theme.textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResults(ThemeData theme, bool isDark) {
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: _resultAnimController,
        curve: Curves.easeOut,
      ),
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.1),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: _resultAnimController,
          curve: Curves.easeOutCubic,
        )),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Main result card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFFD0FD3E).withValues(alpha: 0.2),
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFD0FD3E).withValues(alpha: 0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    'Your Daily Calorie Target',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: isDark ? Colors.white54 : Colors.black45,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [Color(0xFFD0FD3E), Color.fromARGB(255, 0, 0, 0)],
                    ).createShader(bounds),
                    child: Text(
                      '${_targetCalories!.round()}',
                      style: theme.textTheme.displayLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                        fontSize: 56,
                        color: Colors.white,
                        letterSpacing: -2,
                      ),
                    ),
                  ),
                  Text(
                    'calories/day',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: isDark ? Colors.white38 : Colors.black38,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // BMR & TDEE chips
                  Row(
                    children: [
                      _buildMetricChip(
                        theme, isDark,
                        'BMR',
                        '${_bmr!.round()} cal',
                        Icons.local_fire_department_rounded,
                        const Color(0xFFF97316),
                      ),
                      const SizedBox(width: 12),
                      _buildMetricChip(
                        theme, isDark,
                        'TDEE',
                        '${_tdee!.round()} cal',
                        Icons.directions_run_rounded,
                        const Color(0xFF22C55E),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Macro Breakdown
            if (_macros != null) ...[
              Text(
                'Macro Breakdown',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildMacroCard(
                    theme, isDark,
                    'Protein',
                    '${_macros!['protein']!.round()}g',
                    '${_macros!['proteinPct']!.round()}%',
                    const Color(0xFF4F8EF7),
                  ),
                  const SizedBox(width: 8),
                  _buildMacroCard(
                    theme, isDark,
                    'Carbs',
                    '${_macros!['carbs']!.round()}g',
                    '${_macros!['carbsPct']!.round()}%',
                    const Color(0xFF22C55E),
                  ),
                  const SizedBox(width: 8),
                  _buildMacroCard(
                    theme, isDark,
                    'Fat',
                    '${_macros!['fat']!.round()}g',
                    '${_macros!['fatPct']!.round()}%',
                    const Color(0xFFF97316),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 24),

            // Calorie goals comparison
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Calorie Goals',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 14),
                  _buildGoalRow(theme, isDark, 'Weight Loss',
                      '${(_tdee! - 500).round()} cal/day', const Color(0xFF22C55E)),
                  _buildGoalRow(theme, isDark, 'Maintenance',
                      '${_tdee!.round()} cal/day', const Color(0xFF4F8EF7)),
                  _buildGoalRow(theme, isDark, 'Weight Gain',
                      '${(_tdee! + 500).round()} cal/day', const Color(0xFFF97316)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricChip(
    ThemeData theme,
    bool isDark,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withValues(alpha: 0.15),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 16, color: color),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMacroCard(
    ThemeData theme,
    bool isDark,
    String name,
    String grams,
    String percentage,
    Color color,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: color.withValues(alpha: 0.2),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  percentage,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w800,
                    fontSize: 10,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              grams,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              name,
              style: theme.textTheme.labelSmall?.copyWith(
                color: isDark ? Colors.white38 : Colors.black38,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalRow(
    ThemeData theme,
    bool isDark,
    String label,
    String value,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isDark ? Colors.white70 : Colors.black54,
                ),
              ),
            ],
          ),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
