// ignore_for_file: use_late_for_private_fields_and_variables

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Enhanced Heart Rate Zones Screen inspired by workout.cool
/// Features Karvonen formula, visual zone bars, training tips,
/// and a beautiful purple gradient design
class HeartRateZonesScreen extends StatefulWidget {
  const HeartRateZonesScreen({super.key});

  @override
  State<HeartRateZonesScreen> createState() => _HeartRateZonesScreenState();
}

class _HeartRateZonesScreenState extends State<HeartRateZonesScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _restingHrController = TextEditingController();
  late AnimationController _resultAnimController;

  double? _maxHr;
  double? _hrr;
  List<Map<String, dynamic>>? _heartRateZones;

  @override
  void initState() {
    super.initState();
    _resultAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
  }

  @override
  void dispose() {
    _ageController.dispose();
    _restingHrController.dispose();
    _resultAnimController.dispose();
    super.dispose();
  }

  void _calculateHeartRateZones() {
    final age = int.tryParse(_ageController.text);
    final restingHr = int.tryParse(_restingHrController.text);

    if (age == null || restingHr == null || age <= 0 || restingHr <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please enter valid age and resting heart rate'),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    final maxHr = 220.0 - age;
    final hrr = maxHr - restingHr;

    final zones = [
      {
        'zone': 1,
        'name': 'Warm Up',
        'percentage': '50-60%',
        'minPct': 0.50,
        'maxPct': 0.60,
        'minHr': (restingHr + 0.5 * hrr).round(),
        'maxHr': (restingHr + 0.6 * hrr).round(),
        'description': 'Recovery & warm-up. Very easy effort.',
        'benefit': 'Improves overall health and recovery',
        'duration': '20-40 min',
        'color': const Color(0xFF3B82F6),
        'icon': Icons.directions_walk_rounded,
      },
      {
        'zone': 2,
        'name': 'Fat Burn',
        'percentage': '60-70%',
        'minPct': 0.60,
        'maxPct': 0.70,
        'minHr': (restingHr + 0.6 * hrr).round(),
        'maxHr': (restingHr + 0.7 * hrr).round(),
        'description': 'Best zone for fat burning. Comfortable pace.',
        'benefit': 'Optimizes fat metabolism and endurance',
        'duration': '30-60 min',
        'color': const Color(0xFF22C55E),
        'icon': Icons.local_fire_department_rounded,
      },
      {
        'zone': 3,
        'name': 'Aerobic',
        'percentage': '70-80%',
        'minPct': 0.70,
        'maxPct': 0.80,
        'minHr': (restingHr + 0.7 * hrr).round(),
        'maxHr': (restingHr + 0.8 * hrr).round(),
        'description': 'Moderate intensity. Improves cardiovascular fitness.',
        'benefit': 'Builds cardiovascular endurance',
        'duration': '20-40 min',
        'color': const Color(0xFFFBBF24),
        'icon': Icons.directions_run_rounded,
      },
      {
        'zone': 4,
        'name': 'Anaerobic',
        'percentage': '80-90%',
        'minPct': 0.80,
        'maxPct': 0.90,
        'minHr': (restingHr + 0.8 * hrr).round(),
        'maxHr': (restingHr + 0.9 * hrr).round(),
        'description': 'High intensity. Hard to sustain for long.',
        'benefit': 'Increases speed and power output',
        'duration': '10-20 min',
        'color': const Color(0xFFF97316),
        'icon': Icons.speed_rounded,
      },
      {
        'zone': 5,
        'name': 'VO2 Max',
        'percentage': '90-100%',
        'minPct': 0.90,
        'maxPct': 1.00,
        'minHr': (restingHr + 0.9 * hrr).round(),
        'maxHr': maxHr.round(),
        'description': 'Maximum effort. All-out sprints only.',
        'benefit': 'Maximizes performance and VO2 max',
        'duration': '1-5 min intervals',
        'color': const Color(0xFFEF4444),
        'icon': Icons.bolt_rounded,
      },
    ];

    setState(() {
      _maxHr = maxHr;
      _hrr = hrr;
      _heartRateZones = zones;
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
                  'Heart Rate Zones',
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
                        color:
                            const Color(0xFFD0FD3E).withValues(alpha: 0.15),
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
                          child: const Icon(Icons.favorite_rounded,
                              color: Colors.white, size: 22),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Karvonen Formula',
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Uses resting HR for accurate personalized zones',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color:
                                      isDark ? Colors.white54 : Colors.black45,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Age Input
                  _buildInputField(
                    controller: _ageController,
                    label: 'Age',
                    suffix: 'years',
                    icon: Icons.cake_rounded,
                    theme: theme,
                    isDark: isDark,
                  ),

                  const SizedBox(height: 16),

                  // Resting HR Input
                  _buildInputField(
                    controller: _restingHrController,
                    label: 'Resting Heart Rate',
                    suffix: 'bpm',
                    icon: Icons.monitor_heart_rounded,
                    theme: theme,
                    isDark: isDark,
                  ),

                  const SizedBox(height: 12),

                  // Resting HR tip
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.04)
                          : Colors.black.withValues(alpha: 0.03),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.lightbulb_rounded,
                          size: 16,
                          color: Color(0xFFFBBF24),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Measure your resting heart rate first thing in the morning for best accuracy.',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: isDark ? Colors.white38 : Colors.black38,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Calculate Button
                  _buildCalculateButton(theme),

                  const SizedBox(height: 32),

                  // Results
                  if (_maxHr != null && _heartRateZones != null)
                    _buildResults(theme, isDark),

                  const SizedBox(height: 40),

                  // Training tips (always visible)
                  _buildTrainingTips(theme, isDark),

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
        keyboardType: TextInputType.number,
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
      ),
    );
  }

  Widget _buildCalculateButton(ThemeData theme) {
    return GestureDetector(
      onTap: _calculateHeartRateZones,
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
            const Icon(Icons.monitor_heart_rounded,
                color: Colors.white, size: 22),
            const SizedBox(width: 10),
            Text(
              'Calculate Zones',
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
            // Key Metrics
            Row(
              children: [
                _buildMetricCard(
                  theme,
                  isDark,
                  'Max HR',
                  '${_maxHr!.round()} bpm',
                  Icons.favorite_rounded,
                  const Color(0xFFEF4444),
                ),
                const SizedBox(width: 12),
                _buildMetricCard(
                  theme,
                  isDark,
                  'HR Reserve',
                  '${_hrr!.round()} bpm',
                  Icons.bar_chart_rounded,
                  const Color(0xFFD0FD3E),
                ),
              ],
            ),

            const SizedBox(height: 24),

            Text(
              'Your Training Zones',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Based on Karvonen method',
              style: theme.textTheme.bodySmall?.copyWith(
                color: isDark ? Colors.white38 : Colors.black38,
              ),
            ),

            const SizedBox(height: 16),

            // Zone Cards
            ...List.generate(_heartRateZones!.length, (i) {
              final zone = _heartRateZones![i];
              // Stagger the animation
              final begin = (i * 0.1).clamp(0.0, 0.7);
              final end = (begin + 0.5).clamp(0.0, 1.0);

              return FadeTransition(
                opacity: CurvedAnimation(
                  parent: _resultAnimController,
                  curve: Interval(begin, end, curve: Curves.easeOut),
                ),
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.15, 0),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: _resultAnimController,
                    curve:
                        Interval(begin, end, curve: Curves.easeOutCubic),
                  )),
                  child: _buildZoneCard(theme, isDark, zone),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(
    ThemeData theme,
    bool isDark,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withValues(alpha: 0.15),
          ),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, size: 18, color: color),
                ),
                const SizedBox(width: 10),
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isDark ? Colors.white54 : Colors.black45,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildZoneCard(
      ThemeData theme, bool isDark, Map<String, dynamic> zone) {
    final color = zone['color'] as Color;
    final zoneNum = zone['zone'] as int;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withValues(alpha: 0.15),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          // Zone header with gradient strip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  color.withValues(alpha: 0.12),
                  color.withValues(alpha: 0.04),
                ],
              ),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(15)),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [color, color.withValues(alpha: 0.8)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: color.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Icon(zone['icon'] as IconData,
                      color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Zone $zoneNum - ${zone['name']}',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: color,
                        ),
                      ),
                      Text(
                        zone['percentage'] as String,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: isDark ? Colors.white38 : Colors.black38,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                // Heart rate badge
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${zone['minHr']}-${zone['maxHr']} bpm',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: color,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Zone body
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  zone['description'] as String,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: isDark ? Colors.white70 : Colors.black54,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildZoneChip(
                      theme,
                      isDark,
                      Icons.star_rounded,
                      zone['benefit'] as String,
                      color,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildZoneChip(
                      theme,
                      isDark,
                      Icons.timer_rounded,
                      zone['duration'] as String,
                      color,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildZoneChip(
    ThemeData theme,
    bool isDark,
    IconData icon,
    String text,
    Color color,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withValues(alpha: 0.04)
              : Colors.black.withValues(alpha: 0.03),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                text,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isDark ? Colors.white54 : Colors.black45,
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrainingTips(ThemeData theme, bool isDark) {
    final tips = [
      {
        'title': 'Progressive Warm-up',
        'desc': 'Always start in Zone 1 before increasing intensity.',
        'icon': Icons.trending_up_rounded,
      },
      {
        'title': '80/20 Rule',
        'desc': '80% of training in Zones 1-2, 20% in Zones 3-5.',
        'icon': Icons.pie_chart_rounded,
      },
      {
        'title': 'Active Recovery',
        'desc': 'Use Zone 1 for recovery days between hard sessions.',
        'icon': Icons.self_improvement_rounded,
      },
      {
        'title': 'Gradual Progression',
        'desc': 'Increase intensity by no more than 10% per week.',
        'icon': Icons.show_chart_rounded,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.lightbulb_rounded,
                size: 20, color: Color(0xFFFBBF24)),
            const SizedBox(width: 8),
            Text(
              'Training Tips',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        ...tips.map((tip) => Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF2A2A2A)
                    : const Color(0xFFF8FAFC),
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
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color:
                          const Color(0xFFD0FD3E).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      tip['icon'] as IconData,
                      size: 18,
                      color: const Color(0xFFD0FD3E),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tip['title'] as String,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          tip['desc'] as String,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color:
                                isDark ? Colors.white38 : Colors.black38,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }
}
