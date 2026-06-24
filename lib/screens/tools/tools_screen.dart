import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Fitness tool data model
class _FitnessTool {

  const _FitnessTool({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.gradientFrom,
    required this.gradientTo,
    required this.route,
    this.comingSoon = false,
  });
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color gradientFrom;
  final Color gradientTo;
  final String route;
  final bool comingSoon;
}

/// Tools screen widget inspired by workout.cool's tool section
/// Features gradient cards, smooth animations, and a premium design feel
class ToolsScreen extends StatefulWidget {
  const ToolsScreen({super.key});

  @override
  State<ToolsScreen> createState() => _ToolsScreenState();
}

class _ToolsScreenState extends State<ToolsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  static const List<_FitnessTool> _tools = [
    _FitnessTool(
      id: 'calorie-calculator',
      title: 'Calorie Calculator',
      description:
          'Calculate your daily caloric needs (TDEE) based on your activity level and goals',
      icon: Icons.local_fire_department_rounded,
      gradientFrom: Color(0xFFD0FD3E),
      gradientTo: Color.fromARGB(255, 0, 0, 0),
      route: '/tools/calorie-calculator',
    ),
    _FitnessTool(
      id: 'bmi-calculator',
      title: 'BMI Calculator',
      description:
          'Calculate your Body Mass Index and understand your weight category',
      icon: Icons.monitor_weight_rounded,
      gradientFrom: Color(0xFFD0FD3E),
      gradientTo: Color.fromARGB(255, 0, 0, 0),
      route: '/tools/bmi-calculator',
    ),
    _FitnessTool(
      id: 'macro-calculator',
      title: 'Macro Calculator',
      description:
          'Find your optimal protein, carbs and fat distribution for your fitness goals',
      icon: Icons.pie_chart_rounded,
      gradientFrom: Color(0xFFD0FD3E),
      gradientTo: Color.fromARGB(255, 0, 0, 0),
      route: '/tools/macro-calculator',
      comingSoon: true,
    ),
    _FitnessTool(
      id: 'heart-rate-zones',
      title: 'Heart Rate Zones',
      description:
          'Discover your optimal training zones for fat burning and performance',
      icon: Icons.monitor_heart_rounded,
      gradientFrom: Color(0xFFD0FD3E),
      gradientTo: Color.fromARGB(255, 0, 0, 0),
      route: '/tools/heart-rate-zones',
    ),
    _FitnessTool(
      id: 'one-rep-max',
      title: '1RM Calculator',
      description:
          'Estimate your one rep max and plan your strength training percentages',
      icon: Icons.fitness_center_rounded,
      gradientFrom: Color(0xFFD0FD3E),
      gradientTo: Color.fromARGB(255, 0, 0, 0),
      route: '/tools/one-rep-max',
      comingSoon: true,
    ),
    _FitnessTool(
      id: 'nutrition-guide',
      title: 'Nutrition Guide',
      description:
          'Complete guide to meal plans, macros, supplements and timing tips',
      icon: Icons.restaurant_menu_rounded,
      gradientFrom: Color(0xFFD0FD3E),
      gradientTo: Color.fromARGB(255, 0, 0, 0),
      route: '/tools/nutrition-guide',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Hero Header
          SliverToBoxAdapter(
            child: _buildHeader(theme, isDark),
          ),
          // Tools Grid
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                mainAxisSpacing: 16,
                childAspectRatio: 2.2,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final tool = _tools[index];
                  return _AnimatedToolCard(
                    tool: tool,
                    index: index,
                    animationController: _animationController,
                    isDark: isDark,
                    theme: theme,
                  );
                },
                childCount: _tools.length,
              ),
            ),
          ),
          // Bottom "More Coming Soon" badge
          SliverToBoxAdapter(
            child: _buildMoreComingSoon(theme, isDark),
          ),
          // Bottom spacing
          const SliverToBoxAdapter(
            child: SizedBox(height: 40),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, bool isDark) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16,
        left: 24,
        right: 24,
        bottom: 24,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  const Color(0xFF1A1A1A),
                  const Color(0xFF1A1A2E),
                ]
              : [
                  Colors.white,
                  const Color(0xFFF8FAFC),
                ],
        ),
      ),
      child: Column(
        children: [
          // Top bar with back button
          Row(
            children: [
              GestureDetector(
                onTap: () => context.pop(),
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.08)
                        : Colors.black.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 18,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 24),
          // Title with gradient
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [Color(0xFFD0FD3E), Color(0xFFD0FD3E)],
            ).createShader(bounds),
            child: Text(
              'Fitness Tools',
              style: theme.textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: -0.5,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Essential calculators to optimize your training and nutrition',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: isDark ? Colors.white54 : Colors.black45,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildMoreComingSoon(ThemeData theme, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withValues(alpha: 0.06)
                : Colors.black.withValues(alpha: 0.04),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.08)
                  : Colors.black.withValues(alpha: 0.06),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.auto_awesome_rounded,
                size: 18,
                color: Color(0xFFD5FF5F),
              ),
              const SizedBox(width: 8),
              Text(
                'More tools coming soon',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isDark ? Colors.white54 : Colors.black45,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Animated tool card widget with staggered entrance animation
class _AnimatedToolCard extends StatelessWidget {

  const _AnimatedToolCard({
    required this.tool,
    required this.index,
    required this.animationController,
    required this.isDark,
    required this.theme,
  });
  final _FitnessTool tool;
  final int index;
  final AnimationController animationController;
  final bool isDark;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    // Stagger the animation for each card
    final begin = (index * 0.1).clamp(0.0, 1.0);
    final end = (begin + 0.6).clamp(0.0, 1.0);

    final slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: Interval(begin, end, curve: Curves.easeOutCubic),
    ));

    final fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: Interval(begin, end, curve: Curves.easeOut),
    ));

    return SlideTransition(
      position: slideAnimation,
      child: FadeTransition(
        opacity: fadeAnimation,
        child: _ToolCard(
          tool: tool,
          isDark: isDark,
          theme: theme,
        ),
      ),
    );
  }
}

/// Individual tool card with gradient overlay, icon, and description
class _ToolCard extends StatefulWidget {

  const _ToolCard({
    required this.tool,
    required this.isDark,
    required this.theme,
  });
  final _FitnessTool tool;
  final bool isDark;
  final ThemeData theme;

  @override
  State<_ToolCard> createState() => _ToolCardState();
}

class _ToolCardState extends State<_ToolCard>
    with SingleTickerProviderStateMixin {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.tool.comingSoon
          ? null
          : (_) => setState(() => _isPressed = true),
      onTapUp: widget.tool.comingSoon
          ? null
          : (_) => setState(() => _isPressed = false),
      onTapCancel: widget.tool.comingSoon
          ? null
          : () => setState(() => _isPressed = false),
      onTap: widget.tool.comingSoon
          ? null
          : () => context.push(widget.tool.route),
      child: AnimatedScale(
        scale: _isPressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: widget.isDark
                ? const Color(0xFF2A2A2A)
                : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: widget.tool.comingSoon
                  ? (widget.isDark
                      ? Colors.white.withValues(alpha: 0.05)
                      : Colors.black.withValues(alpha: 0.06))
                  : (widget.isDark
                      ? Colors.white.withValues(alpha: 0.08)
                      : Colors.black.withValues(alpha: 0.08)),
              width: 1,
            ),
            boxShadow: [
              if (!widget.tool.comingSoon)
                BoxShadow(
                  color: widget.tool.gradientFrom.withValues(alpha: 0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                // Gradient overlay
                Positioned.fill(
                  child: AnimatedOpacity(
                    opacity: widget.tool.comingSoon ? 0.03 : 0.06,
                    duration: const Duration(milliseconds: 300),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            widget.tool.gradientFrom,
                            widget.tool.gradientTo,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                // Content
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Opacity(
                    opacity: widget.tool.comingSoon ? 0.5 : 1.0,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Icon container with gradient
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                widget.tool.gradientFrom,
                                widget.tool.gradientTo,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: widget.tool.gradientFrom
                                    .withValues(alpha: 0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Icon(
                            widget.tool.icon,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Text content
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                widget.tool.title,
                                style: widget.theme.textTheme.titleMedium
                                    ?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: -0.3,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                widget.tool.description,
                                style: widget.theme.textTheme.bodySmall
                                    ?.copyWith(
                                  color: widget.isDark
                                      ? Colors.white54
                                      : Colors.black45,
                                  height: 1.3,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Action indicator
                        if (widget.tool.comingSoon)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: widget.isDark
                                  ? Colors.white.withValues(alpha: 0.08)
                                  : Colors.black.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Soon',
                              style:
                                  widget.theme.textTheme.labelSmall?.copyWith(
                                color: widget.isDark
                                    ? Colors.white38
                                    : Colors.black38,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          )
                        else
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: widget.isDark
                                  ? Colors.white.withValues(alpha: 0.06)
                                  : Colors.black.withValues(alpha: 0.04),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 14,
                              color: widget.tool.gradientFrom,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}