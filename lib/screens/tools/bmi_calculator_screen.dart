// ignore_for_file: use_late_for_private_fields_and_variables

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Enhanced BMI Calculator Screen inspired by workout.cool
/// Features detailed BMI categories (WHO classification), BMI Prime,
/// ideal weight range, health risk assessment, and recommendations
class BmiCalculatorScreen extends StatefulWidget {
  const BmiCalculatorScreen({super.key});

  @override
  State<BmiCalculatorScreen> createState() => _BmiCalculatorScreenState();
}

class _BmiCalculatorScreenState extends State<BmiCalculatorScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  late AnimationController _resultAnimController;
  
  double? _bmi;
  double? _bmiPrime;
  String? _bmiCategory;
  String? _healthRisk;
  Color? _bmiColor;
  double? _idealWeightMin;
  double? _idealWeightMax;
  List<String>? _recommendations;

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
    _heightController.dispose();
    _weightController.dispose();
    _resultAnimController.dispose();
    super.dispose();
  }

  void _calculateBMI() {
    final height = double.tryParse(_heightController.text);
    final weight = double.tryParse(_weightController.text);

    if (height == null || weight == null || height <= 0 || weight <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please enter valid height and weight'),
          backgroundColor: const Color(0xFFD0FD3E),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    final heightInMeters = height / 100;
    final bmi = weight / (heightInMeters * heightInMeters);
    final bmiPrime = bmi / 25;

    // Ideal weight range (BMI 18.5-24.9)
    final idealMin = 18.5 * heightInMeters * heightInMeters;
    final idealMax = 24.9 * heightInMeters * heightInMeters;

    setState(() {
      _bmi = bmi;
      _bmiPrime = bmiPrime;
      _bmiCategory = _getDetailedCategory(bmi);
      _healthRisk = _getHealthRisk(bmi);
      _bmiColor = _getBMIColor(bmi);
      _idealWeightMin = idealMin;
      _idealWeightMax = idealMax;
      _recommendations = _getRecommendations(bmi);
    });
    
    _resultAnimController.forward(from: 0);
  }

  String _getDetailedCategory(double bmi) {
    if (bmi < 16) return 'Severe Thinness';
    if (bmi < 17) return 'Moderate Thinness';
    if (bmi < 18.5) return 'Mild Thinness';
    if (bmi < 25) return 'Normal';
    if (bmi < 30) return 'Overweight';
    if (bmi < 35) return 'Obese Class I';
    if (bmi < 40) return 'Obese Class II';
    return 'Obese Class III';
  }

  String _getHealthRisk(double bmi) {
    if (bmi < 16) return 'Very High';
    if (bmi < 17) return 'High';
    if (bmi < 18.5) return 'Increased';
    if (bmi < 25) return 'Normal';
    if (bmi < 30) return 'Increased';
    if (bmi < 35) return 'High';
    if (bmi < 40) return 'Very High';
    return 'Extremely High';
  }

  Color _getBMIColor(double bmi) {
    if (bmi < 16) return const Color(0xFFEF4444);
    if (bmi < 17) return const Color(0xFFF97316);
    if (bmi < 18.5) return const Color(0xFFFBBF24);
    if (bmi < 25) return const Color(0xFF22C55E);
    if (bmi < 30) return const Color(0xFFFBBF24);
    if (bmi < 35) return const Color(0xFFF97316);
    if (bmi < 40) return const Color(0xFFEF4444);
    return const Color(0xFFDC2626);
  }

  List<String> _getRecommendations(double bmi) {
    if (bmi < 18.5) {
      return [
        'Consider consulting a healthcare provider',
        'Focus on nutrient-dense foods',
        'Include strength training exercises',
        'Monitor health markers regularly',
        'Aim for gradual, healthy weight gain',
      ];
    } else if (bmi < 25) {
      return [
        'Maintain your healthy weight',
        'Stay active with regular exercise',
        'Continue a balanced diet',
        'Schedule regular health checkups',
        'Focus on overall wellness',
      ];
    } else if (bmi < 30) {
      return [
        'Aim for gradual weight loss (0.5-1 kg/week)',
        'Increase physical activity levels',
        'Practice portion control',
        'Consult a healthcare provider',
        'Set realistic lifestyle goals',
      ];
    } else {
      return [
        'Seek medical consultation',
        'Work with a registered dietitian',
        'Start a structured exercise program',
        'Monitor for health complications',
        'Consider a multidisciplinary approach',
      ];
    }
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
                  'BMI Calculator',
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
                  // Info card
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
                          child: const Icon(Icons.info_outline_rounded,
                              color: Colors.white, size: 22),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            'BMI uses WHO classification with 8 detailed categories for accurate health assessment.',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: isDark ? Colors.white60 : Colors.black54,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Input Fields
                  _buildInputField(
                    controller: _heightController,
                    label: 'Height',
                    suffix: 'cm',
                    icon: Icons.height_rounded,
                    theme: theme,
                    isDark: isDark,
                  ),

                  const SizedBox(height: 16),

                  _buildInputField(
                    controller: _weightController,
                    label: 'Weight',
                    suffix: 'kg',
                    icon: Icons.monitor_weight_rounded,
                    theme: theme,
                    isDark: isDark,
                  ),

                  const SizedBox(height: 28),

                  // Calculate Button
                  _buildCalculateButton(theme),

                  const SizedBox(height: 32),

                  // Results
                  if (_bmi != null) _buildResults(theme, isDark),

                  const SizedBox(height: 40),

                  // BMI Categories Reference Table
                  _buildBmiTable(theme, isDark),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String suffix,
    required IconData icon,
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
              gradient: const LinearGradient(
                colors: [Color(0xFFD0FD3E), Color.fromARGB(255, 0, 0, 0)],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        ),
        onChanged: (value) {
          if (value.isEmpty) {
            setState(() {
              _bmi = null;
              _bmiCategory = null;
              _bmiColor = null;
              _bmiPrime = null;
              _healthRisk = null;
              _recommendations = null;
            });
          }
        },
      ),
    );
  }

  Widget _buildCalculateButton(ThemeData theme) {
    return GestureDetector(
      onTap: _calculateBMI,
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
              'Calculate BMI',
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
            // Main BMI Result Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _bmiColor!.withValues(alpha: 0.3),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: _bmiColor!.withValues(alpha: 0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // BMI Value
                  Text(
                    'Your BMI',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: isDark ? Colors.white54 : Colors.black45,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _bmi!.toStringAsFixed(1),
                    style: theme.textTheme.displayLarge?.copyWith(
                      color: _bmiColor,
                      fontWeight: FontWeight.w900,
                      fontSize: 56,
                      letterSpacing: -2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: _bmiColor!.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _bmiCategory!,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: _bmiColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Stats Row
                  Row(
                    children: [
                      _buildStatChip(
                        theme,
                        isDark,
                        'BMI Prime',
                        _bmiPrime!.toStringAsFixed(2),
                        Icons.speed_rounded,
                      ),
                      const SizedBox(width: 12),
                      _buildStatChip(
                        theme,
                        isDark,
                        'Health Risk',
                        _healthRisk!,
                        Icons.shield_rounded,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Ideal Weight Range
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
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD5FF5F).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.straighten_rounded,
                        color: Color(0xFFD5FF5F), size: 22),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ideal Weight Range',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: isDark ? Colors.white54 : Colors.black45,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${_idealWeightMin!.toStringAsFixed(1)} - ${_idealWeightMax!.toStringAsFixed(1)} kg',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFFD5FF5F),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Recommendations
            if (_recommendations != null) ...[
              Text(
                'Recommendations',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              ...List.generate(_recommendations!.length, (i) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color:
                        isDark ? const Color(0xFF2A2A2A) : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.06)
                          : Colors.black.withValues(alpha: 0.06),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: _bmiColor!.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            '${i + 1}',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: _bmiColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _recommendations![i],
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: isDark ? Colors.white70 : Colors.black54,
                            height: 1.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatChip(
    ThemeData theme,
    bool isDark,
    String label,
    String value,
    IconData icon,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withValues(alpha: 0.04)
              : Colors.black.withValues(alpha: 0.03),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 16, color: isDark ? Colors.white38 : Colors.black38),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: isDark ? Colors.white38 : Colors.black38,
                    fontWeight: FontWeight.w500,
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

  Widget _buildBmiTable(ThemeData theme, bool isDark) {
    final categories = [
      {'category': 'Severe Thinness', 'range': '< 16', 'risk': 'Very High', 'color': const Color(0xFFEF4444)},
      {'category': 'Moderate Thinness', 'range': '16 - 16.9', 'risk': 'High', 'color': const Color(0xFFF97316)},
      {'category': 'Mild Thinness', 'range': '17 - 18.4', 'risk': 'Increased', 'color': const Color(0xFFFBBF24)},
      {'category': 'Normal', 'range': '18.5 - 24.9', 'risk': 'Normal', 'color': const Color(0xFF22C55E)},
      {'category': 'Overweight', 'range': '25 - 29.9', 'risk': 'Increased', 'color': const Color(0xFFFBBF24)},
      {'category': 'Obese Class I', 'range': '30 - 34.9', 'risk': 'High', 'color': const Color(0xFFF97316)},
      {'category': 'Obese Class II', 'range': '35 - 39.9', 'risk': 'Very High', 'color': const Color(0xFFEF4444)},
      {'category': 'Obese Class III', 'range': '≥ 40', 'risk': 'Extremely High', 'color': const Color(0xFFDC2626)},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'BMI Classification',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'World Health Organization (WHO) Standards',
          style: theme.textTheme.bodySmall?.copyWith(
            color: isDark ? Colors.white38 : Colors.black38,
          ),
        ),
        const SizedBox(height: 16),
        DecoratedBox(
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
            children: [
              // Header
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.04)
                      : Colors.black.withValues(alpha: 0.03),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text('Category',
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: isDark ? Colors.white54 : Colors.black54,
                          )),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text('BMI Range',
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: isDark ? Colors.white54 : Colors.black54,
                          )),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text('Risk',
                          textAlign: TextAlign.right,
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: isDark ? Colors.white54 : Colors.black54,
                          )),
                    ),
                  ],
                ),
              ),
              // Rows
              ...categories.map((cat) {
                final isHighlighted = _bmiCategory == cat['category'];
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isHighlighted
                        ? (cat['color'] as Color).withValues(alpha: 0.1)
                        : null,
                    border: Border(
                      bottom: BorderSide(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.04)
                            : Colors.black.withValues(alpha: 0.04),
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: cat['color'] as Color,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                cat['category'] as String,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  fontWeight:
                                      isHighlighted ? FontWeight.w700 : FontWeight.w500,
                                  color: isHighlighted
                                      ? (cat['color'] as Color)
                                      : null,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          cat['range'] as String,
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: isDark ? Colors.white54 : Colors.black45,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          cat['risk'] as String,
                          textAlign: TextAlign.right,
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: cat['color'] as Color,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }
}
