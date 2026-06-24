import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'dart:async';

import '../../core/localization/app_localizations.dart';
import '../../core/models/user_model.dart';
import '../../core/services/user_service.dart';
import '../../core/services/plan_service.dart';
import '../analysis/analysis_screen.dart';
import '../tools/tools_screen.dart';
import '../profile/profile_screen.dart';
import 'widgets/action_card.dart';
import 'widgets/plan_exercise_card.dart';

/// Main home screen widget with bottom navigation
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _HomeContent(
            onSeeStatsPressed: () {
              setState(() {
                _currentIndex = 1; // Analysis screen index
              });
            },
          ),
          const AnalysisScreen(),
          const ToolsScreen(),
          const ProfileScreen(),
        ],
      ),
      bottomNavigationBar: _buildCustomBottomNav(context, theme),
    );
  }

  /// Builds custom bottom navigation bar with Google Navigation Bar
  Widget _buildCustomBottomNav(BuildContext context, ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: GNav(
          backgroundColor: isDark ? const Color(0xFF1A1A1A) : Colors.white,
          color: isDark ? Colors.white70 : Colors.black54,
          activeColor: const Color(0xFFD5FF5F),
          tabBackgroundColor: const Color(0xFFD5FF5F).withValues(alpha: 0.1),
          gap: 8,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          selectedIndex: _currentIndex,
          onTabChange: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          tabs: const [
            GButton(icon: IconlyLight.home, text: 'Home'),
            GButton(icon: IconlyLight.chart, text: 'Analysis'),
            GButton(icon: Icons.calculate, text: 'Tools'),
            GButton(icon: IconlyLight.profile, text: 'Profile'),
          ],
        ),
      ),
    );
  }
}

// Separate widget for home content to avoid state issues
class _HomeContent extends StatefulWidget {
  const _HomeContent({required this.onSeeStatsPressed});
  final VoidCallback onSeeStatsPressed;

  @override
  State<_HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<_HomeContent> {
  late final Future<UserModel?> _userFuture;
  Future<bool>? _hasPlanFuture;
  StreamSubscription? _planSubscription;

  @override
  void initState() {
    super.initState();
    _userFuture = _loadUser();
    _refreshPlanStatus();

    // Subscribe to plan updates
    _planSubscription = PlanService.planUpdates.listen((_) {
      if (mounted) {
        _refreshPlanStatus();
      }
    });
  }

  @override
  void dispose() {
    _planSubscription?.cancel();
    super.dispose();
  }

  /// Refreshes the plan status by checking if user has a current plan
  void _refreshPlanStatus() {
    setState(() {
      _hasPlanFuture = PlanService.hasPlan();
    });
  }

  /// Loads user data from UserService
  Future<UserModel?> _loadUser() async {
    try {
      final userService = context.read<UserService>();
      final result = await userService.getCurrentUser();

      if (result['success'] == true) {
        final userJson = result['user'] as Map<String, dynamic>?;
        return userJson != null ? UserModel.fromJson(userJson) : null;
      }
      return null;
    } catch (e) {
      debugPrint('Error loading user: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          // Greeting
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  FutureBuilder<UserModel?>(
                    future: _userFuture,
                    builder: (context, snapshot) {
                      final username = snapshot.data?.username;
                      final displayName =
                          snapshot.connectionState == ConnectionState.waiting
                          ? '...'
                          : (username != null && username.isNotEmpty)
                          ? username
                          : '';
                      return Text(
                        'HI $displayName 🔥',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 255, 255, 255),
                        ),
                      );
                    },
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () => context.push('/settings'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Action Cards Slider
          SizedBox(
            height: 250,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              padding: const EdgeInsets.symmetric(horizontal: 4),
              itemBuilder: (context, index) {
                final cards = [
                  {
                    'image': 'assets/ST W.png',
                    'title': localizations?.workoutplans ?? 'Workout Plans',
                    'onTap': () {
                      context.push('/workout');
                    },
                  },
                  {
                    'image': 'assets/EXL.png',
                    'title':
                        localizations?.exerciseLibrary ?? 'Exercise Library',
                    'onTap': () {
                      context.push('/exercises');
                    },
                  },
                  {
                    'image': 'assets/AI CAM.png',
                    'title': localizations?.cameraAi ?? 'Camera Ai',
                    'onTap': () {
                      context.push('/camera-ai');
                    },
                  },
                ];

                // Calculate width: screen width - padding (40) - margins (32) divided by 2
                final screenWidth = MediaQuery.of(context).size.width;
                final cardWidth = (screenWidth - 40 - 32) / 2;

                return Container(
                  width: cardWidth,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  child: ActionCard(
                    imagePath: cards[index]['image'] as String,
                    title: cards[index]['title'] as String,
                    buttonColor: theme.colorScheme.primary,
                    onTap: cards[index]['onTap'] as VoidCallback,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 32),
          // Today Plan Section - Conditional rendering based on plan existence and expiration
          FutureBuilder<bool>(
            future: _hasPlanFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final hasPlan = snapshot.data ?? false;

              if (!hasPlan) {
                // Show "no plan" message with two options
                return _buildNoPlanSection(
                  context,
                  theme,
                  isDark,
                  localizations,
                );
              }

              // Check for expiration
              return FutureBuilder<bool>(
                future: PlanService.isPlanExpired(),
                builder: (context, expiredSnapshot) {
                  if (expiredSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final isExpired = expiredSnapshot.data ?? false;
                  if (isExpired) {
                    return _buildExpiredPlanSection(
                      context,
                      theme,
                      isDark,
                      localizations,
                    );
                  }

                  // Show existing plan
                  return _buildTodayPlanSection(context, theme, localizations);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildExpiredPlanSection(
    BuildContext context,
    ThemeData theme,
    bool isDark,
    AppLocalizations? localizations,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations?.todayPlan ?? 'Today Plan',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF2C2C2E) : Colors.grey[100],
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFFD5FF5F), // Highlight border
              width: 2,
            ),
          ),
          child: Column(
            children: [
              const Icon(
                Icons.emoji_events,
                size: 64,
                color: Color(0xFFD5FF5F),
              ),
              const SizedBox(height: 16),
              Text(
                'Plan Completed!',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'You have finished your workout plan.',
                style: TextStyle(
                  color: isDark ? Colors.white70 : Colors.black54,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              // Option 1: Pickup a new plan
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    // Clear old plan first? Or just overwriting is fine.
                    // PlanService.saveProgramPlan overwrites.
                    await context.push('/workout');
                    // Refresh plan status when returning
                    if (mounted) {
                      _refreshPlanStatus();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD5FF5F),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Pickup a New Plan',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // Option 2: Create custom plan
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () async {
                    await context.push('/create-custom-plan');
                    // Refresh plan status when returning
                    if (mounted) {
                      _refreshPlanStatus();
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFD5FF5F),
                    side: const BorderSide(color: Color(0xFFD5FF5F), width: 2),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Create Custom Plan',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Builds message when no exercises are scheduled for today
  Widget _buildNoExercisesMessage(BuildContext context, ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: isDark ? const Color(0xFF2C2C2E) : Colors.grey[100],
      ),
      child: Column(
        children: [
          Icon(
            Icons.fitness_center_outlined,
            size: 48,
            color: isDark ? Colors.white70 : Colors.grey[600],
          ),
          const SizedBox(height: 16),
          Text(
            'No exercises scheduled for today',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  /// Builds section when user has no current workout plan
  Widget _buildNoPlanSection(
    BuildContext context,
    ThemeData theme,
    bool isDark,
    AppLocalizations? localizations,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations?.todayPlan ?? 'Today Plan',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF2C2C2E) : Colors.grey[100],
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFFD5FF5F).withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              Icon(
                Icons.fitness_center_outlined,
                size: 64,
                color: isDark ? Colors.white70 : Colors.grey[600],
              ),
              const SizedBox(height: 16),
              Text(
                'You do not have a plan yet',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              // Option 1: Pick program plan
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    await context.push('/workout');
                    // Refresh plan status when returning
                    if (mounted) {
                      _refreshPlanStatus();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD5FF5F),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Pick a Workout Plan',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // Option 2: Create custom plan
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () async {
                    await context.push('/create-custom-plan');
                    // Refresh plan status when returning
                    if (mounted) {
                      _refreshPlanStatus();
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFD5FF5F),
                    side: const BorderSide(color: Color(0xFFD5FF5F), width: 2),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Create Custom Plan',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Builds rest day message
  Widget _buildRestDayMessage(
    BuildContext context,
    ThemeData theme,
    Map<String, dynamic> workoutDay,
  ) {
    const darkOliveGreen = Color(0xFF3D4F3D);
    const neonYellowGreen = Color(0xFFD5FF5F);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: darkOliveGreen,
        border: Border.all(color: neonYellowGreen, width: 2),
      ),
      child: Column(
        children: [
          const Icon(Icons.nightlight_round, color: Colors.white, size: 48),
          const SizedBox(height: 16),
          const Text(
            'Rest Day',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            workoutDay['workoutCount'] as String? ?? 'Take a break!',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  /// Builds message when workout is completed for today
  Widget _buildWorkoutCompletedTodayMessage(
    BuildContext context,
    ThemeData theme,
  ) {
    const neonYellowGreen = Color(0xFFD5FF5F);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2C2C2E) : Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: neonYellowGreen, width: 2),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.check_circle_outline,
            color: neonYellowGreen,
            size: 64,
          ),
          const SizedBox(height: 16),
          const Text(
            'Great job you finished\nyour workout today!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: widget.onSeeStatsPressed,
              style: OutlinedButton.styleFrom(
                foregroundColor: neonYellowGreen,
                side: const BorderSide(color: neonYellowGreen),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('SEE STATS'),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds today's plan section with conditional rendering based on plan status
  Widget _buildTodayPlanSection(
    BuildContext context,
    ThemeData theme,
    AppLocalizations? localizations,
  ) {
    return FutureBuilder<bool>(
      future: PlanService.isWorkoutCompletedForToday(),
      builder: (context, completedSnapshot) {
        final isCompleted = completedSnapshot.data ?? false;

        if (isCompleted) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                localizations?.todayPlan ?? 'Today Plan',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildWorkoutCompletedTodayMessage(context, theme),
            ],
          );
        }

        return FutureBuilder<Map<String, dynamic>?>(
          future: PlanService.getPlan(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    localizations?.todayPlan ?? 'Today Plan',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Center(child: CircularProgressIndicator()),
                ],
              );
            }

            final plan = snapshot.data;
            if (plan == null) {
              return _buildNoPlanSection(
                context,
                theme,
                theme.brightness == Brightness.dark,
                localizations,
              );
            }

            return FutureBuilder<int?>(
              future: PlanService.getCurrentDayIndex(),
              builder: (context, daySnapshot) {
                if (daySnapshot.connectionState == ConnectionState.waiting) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        localizations?.todayPlan ?? 'Today Plan',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Center(child: CircularProgressIndicator()),
                    ],
                  );
                }

                final dayIndex = daySnapshot.data ?? 0;
                final workoutDays = plan['workoutDays'] as List?;

                if (workoutDays == null ||
                    workoutDays.isEmpty ||
                    dayIndex >= workoutDays.length) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        localizations?.todayPlan ?? 'Today Plan',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text('No plan data available'),
                    ],
                  );
                }

                final todayWorkoutDay = Map<String, dynamic>.from(
                  workoutDays[dayIndex] as Map,
                );
                final title = todayWorkoutDay['title'] as String? ?? '';
                final isRestDay = title.toUpperCase().contains('REST');
                final exercises = todayWorkoutDay['exercises'] as List? ?? [];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          localizations?.todayPlan ?? 'Today Plan',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFFD5FF5F,
                            ).withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            todayWorkoutDay['day'] as String? ?? '',
                            style: const TextStyle(
                              color: Color(0xFFD5FF5F),
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (isRestDay)
                      _buildRestDayMessage(context, theme, todayWorkoutDay)
                    else if (exercises.isEmpty)
                      _buildNoExercisesMessage(context, theme)
                    else
                      Column(
                        children: [
                          // Exercise cards list - scrollable, showing only 3 initially
                          SizedBox(
                            height: 384,
                            child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: exercises.length,
                              itemBuilder: (context, index) {
                                final exerciseData = Map<String, dynamic>.from(
                                  exercises[index] as Map,
                                );
                                // Get sets and reps from exercise data, or use default
                                final sets = exerciseData['sets'] as int? ?? 3;
                                final reps =
                                    exerciseData['reps'] as String? ??
                                    '12-10-8';
                                final setsRepsText = '$sets Sets $reps Reps';

                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: PlanExerciseCard(
                                    imagePath:
                                        exerciseData['mainImageUrl']
                                            as String? ??
                                        'assets/Rectangle 53.png',
                                    exerciseName:
                                        exerciseData['name'] as String? ??
                                        'Exercise',
                                    setsReps: setsRepsText,
                                    isDark: theme.brightness == Brightness.dark,
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 24),
                          // Start Workout button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                // Navigate to workout session with today's exercises
                                // Convert List<dynamic> to List<Map<String, dynamic>>
                                final exercisesList = exercises
                                    .map((e) => e as Map<String, dynamic>)
                                    .toList();
                                context.push(
                                  '/workout/session',
                                  extra: {
                                    'exercises': exercisesList,
                                    'dayTitle': title,
                                  },
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFD5FF5F),
                                foregroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 18,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                              child: Text(
                                localizations?.startWorkoutButton ??
                                    'Start Workout',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }
}
