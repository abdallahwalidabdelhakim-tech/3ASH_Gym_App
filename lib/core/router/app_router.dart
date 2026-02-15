/// Application navigation router configuration
///
/// Defines all app routes and their navigation behavior using GoRouter.
/// Handles route definitions, parameters, and nested routes for workout features.
library;
import 'package:go_router/go_router.dart';
import '../../screens/splash/splash_screen.dart';
import '../../screens/auth/login_screen.dart';
import '../../screens/auth/signup_screen.dart';
import '../../screens/auth/forgot_password_screen.dart';
import '../../screens/auth/verify_code_screen.dart';
import '../../screens/auth/new_password_screen.dart';
import '../../screens/auth/change_password_screen.dart';
import '../../screens/home/home_screen.dart';
import '../../screens/settings/settings_screen.dart';
import '../../screens/onboarding/step1.dart';
import '../../core/models/onboarding_model.dart';
import '../../screens/workout/workout_screen.dart';
import '../../screens/workout/program_details_screen.dart';
import '../../screens/workout/day_exercises_screen.dart';
import '../../screens/workout/workout_session_screen.dart';
import '../../screens/exercise/exercise_library_screen.dart';
import '../../screens/exercise/exercise_list_screen.dart';
import '../../screens/settings/privacy_screen.dart';
import '../../screens/workout/create_custom_plan_screen.dart';
import '../../screens/analysis/analysis_screen.dart';
import '../../screens/food_ai_screen.dart';


class AppRouter {
  /// The main GoRouter instance configured with all app routes
  static final GoRouter router = GoRouter(
    /// Initial route when app starts
    initialLocation: '/splash',
    routes: [
      /// Splash screen (app initialization)
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      
      /// Authentication routes
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        name: 'signup',
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        name: 'forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/verify-code',
        name: 'verify-code',
        builder: (context, state) => const VerifyCodeScreen(),
      ),
      GoRoute(
        path: '/new-password',
        name: 'new-password',
        builder: (context, state) => const NewPasswordScreen(),
      ),
      GoRoute(
        path: '/change-password',
        name: 'change-password',
        builder: (context, state) => const ChangePasswordScreen(),
      ),
      
      /// Main app routes
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      
      GoRoute(
        path: '/settings/privacy',
        name: 'privacy',
        builder: (context, state) => const PrivacyScreen(),
      ),
      
      /// Workout management routes with nested children
      GoRoute(
        path: '/workout',
        name: 'workout',
        builder: (context, state) => const WorkoutScreen(),
        routes: [
           /// Workout program details route
           GoRoute(
            path: 'details',
            name: 'program-details',
            builder: (context, state) {
              final program = state.extra as WorkoutProgram;
              return ProgramDetailsScreen(program: program);
            },
          ),
          
          /// Day exercises route
          GoRoute(
            path: 'day-exercises',
            name: 'day-exercises',
            builder: (context, state) {
              final data = state.extra as Map<String, dynamic>;
              final workoutDay = data['workoutDay'] as WorkoutDay;
              final program = data['program'] as WorkoutProgram;
              return DayExercisesScreen(workoutDay: workoutDay, program: program);
            },
          ),
          
          /// Workout session route
          GoRoute(
            path: 'session',
            name: 'workout-session',
            builder: (context, state) {
              final data = state.extra as Map<String, dynamic>;
              final exercises = data['exercises'] as List<Map<String, dynamic>>;
              final dayTitle = data['dayTitle'] as String? ?? 'Workout';
              return WorkoutSessionScreen(exercises: exercises, dayTitle: dayTitle);
            },
          ),
        ],
      ),
      
      /// Exercise library routes
      GoRoute(
        path: '/exercises',
        name: 'exercises',
        builder: (context, state) => const ExerciseLibraryScreen(),
      ),
      
      GoRoute(
        path: '/exercises/:category',
        name: 'exercise-list',
        builder: (context, state) {
          final category = state.pathParameters['category'] ?? 'Exercises';
          return ExerciseListScreen(categoryName: category);
        },
      ),
      
      /// Custom plan creation route
      GoRoute(
        path: '/create-custom-plan',
        name: 'create-custom-plan',
        builder: (context, state) => const CreateCustomPlanScreen(),
      ),
      
      /// Progress analysis route
      GoRoute(
        path: '/analysis',
        name: 'analysis',
        builder: (context, state) => const AnalysisScreen(),
      ),
      
      /// AI camera feature route
      GoRoute(
        path: '/camera-ai',
        name: 'camera-ai',
        builder: (context, state) => const FoodAiScreen(),
      ),
      
      /// Onboarding routes
      GoRoute(
        path: '/onboarding/step1',
        name: 'step1',
        builder: (context, state) {
          final data = state.extra as OnboardingData?;
          return OnboardingStep3AboutScreen(initialData: data);
        },
      ),
    ],
  );
}

