/// Workout plan management service
///
/// Handles local storage and management of user's workout plans using shared preferences.
/// Provides functionality to save, retrieve, and manage program and custom workout plans.
library;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:async';

class PlanService {
  /// Key for storing workout plan data in shared preferences
  static const String _planKey = 'user_workout_plan';
  
  /// Key for storing plan type in shared preferences ('program' or 'custom')
  static const String _planTypeKey = 'user_plan_type';
  
  /// Key for storing plan start date in shared preferences
  static const String _planStartDateKey = 'user_plan_start_date';
  
  /// Key for storing last completed workout date in shared preferences
  static const String _lastCompletedWorkoutDateKey = 'last_completed_workout_date';
  
  /// Stream controller for broadcasting plan update events
  static final StreamController<void> _planUpdateController = StreamController<void>.broadcast();
  
  /// Stream of plan update events
  static Stream<void> get planUpdates => _planUpdateController.stream;


  /// Checks if user has a saved workout plan
  /// 
  /// Returns: Future with boolean indicating if a plan exists
  static Future<bool> hasPlan() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_planKey);
  }

  /// Gets the type of saved plan ('program' or 'custom')
  /// 
  /// Returns: Future with plan type string or null
  static Future<String?> getPlanType() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_planTypeKey);
  }

  /// Saves a program workout plan
  /// 
  /// Parameters:
  /// - planData: Workout plan data as Map
  static Future<void> saveProgramPlan(Map<String, dynamic> planData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_planKey, jsonEncode(planData));
    await prefs.setString(_planTypeKey, 'program');
    // Store the start date (today)
    await prefs.setString(_planStartDateKey, DateTime.now().toIso8601String());
    _planUpdateController.add(null);
  }


  /// Saves a custom workout plan
  /// 
  /// Parameters:
  /// - planData: Custom workout plan data as Map
  static Future<void> saveCustomPlan(Map<String, dynamic> planData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_planKey, jsonEncode(planData));
    await prefs.setString(_planTypeKey, 'custom');
    await prefs.setString(_planStartDateKey, DateTime.now().toIso8601String());
    _planUpdateController.add(null);
  }


  /// Gets the current saved workout plan
  /// 
  /// Returns: Future with plan data as Map or null
  static Future<Map<String, dynamic>?> getPlan() async {
    final prefs = await SharedPreferences.getInstance();
    final planJson = prefs.getString(_planKey);
    if (planJson == null) return null;
    return jsonDecode(planJson) as Map<String, dynamic>;
  }

  /// Gets the start date of the current plan
  /// 
  /// Returns: Future with DateTime or null
  static Future<DateTime?> getPlanStartDate() async {
    final prefs = await SharedPreferences.getInstance();
    final startDateStr = prefs.getString(_planStartDateKey);
    if (startDateStr == null) return null;
    return DateTime.parse(startDateStr);
  }

  /// Gets the current day index in the program (0-based)
  /// 
  /// Returns the day index based on days since program start, cycling through
  /// the program days if duration exceeds program length.
  /// 
  /// Returns: Future with integer day index or null
  static Future<int?> getCurrentDayIndex() async {
    final startDate = await getPlanStartDate();
    if (startDate == null) return null;
    
    final now = DateTime.now();
    final difference = now.difference(startDate).inDays;
    
    // Get the plan to know how many days are in the program
    final plan = await getPlan();
    if (plan == null) return null;
    
    final workoutDays = plan['workoutDays'] as List?;
    if (workoutDays == null || workoutDays.isEmpty) return null;
    
    final programLength = workoutDays.length;
    // Cycle through the program days
    return difference % programLength;
  }

  /// Clears the current workout plan
  static Future<void> clearPlan() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_planKey);
    await prefs.remove(_planTypeKey);
    await prefs.remove(_planStartDateKey);
    _planUpdateController.add(null);
  }

  /// Checks if the current plan is expired
  /// 
  /// Determines if the plan duration has been exceeded based on the start date
  /// and plan duration information.
  /// 
  /// Returns: Future with boolean indicating if plan is expired
  static Future<bool> isPlanExpired() async {
    final startDate = await getPlanStartDate();
    if (startDate == null) return false;

    final plan = await getPlan();
    if (plan == null) return false;

    final durationStr = plan['duration'] as String?;
    if (durationStr == null || durationStr.isEmpty) return false;

    final weeks = _parseDurationInWeeks(durationStr);
    if (weeks <= 0) return false; // Invalid or endless?

    // Calculate expiration date
    // 6 weeks * 7 days
    final daysDuration = weeks * 7;
    final expirationDate = startDate.add(Duration(days: daysDuration));
    
    // Check if now is after expiration
    final now = DateTime.now();
    // Use isAfter, but maybe give leeway until the END of the last day? 
    // Simply: if now > startDate + duration
    return now.isAfter(expirationDate);
  }

  /// Parses duration string to extract weeks
  /// 
  /// Handles formats like "6 WEEK", "8 WEEKS", "6 Weeks"
  /// 
  /// Parameters:
  /// - duration: Duration string to parse
  /// Returns: Number of weeks as integer
  static int _parseDurationInWeeks(String duration) {
    if (duration.isEmpty) return 0;
    
    // Expected formats: "6 WEEK", "8 WEEKS", "6 Weeks"
    final clean = duration.toUpperCase().trim();
    final parts = clean.split(' ');
    if (parts.isNotEmpty) {
      final numberPart = parts[0];
      return int.tryParse(numberPart) ?? 0;
    }
    return 0;
  }

  /// Resets the plan start date to now
  /// 
  /// Useful for restarting the workout plan.
  static Future<void> restartPlan() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_planStartDateKey, DateTime.now().toIso8601String());
    _planUpdateController.add(null);
  }

  /// Marks the workout as completed for today
  static Future<void> markWorkoutAsCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().toIso8601String().split('T')[0];
    await prefs.setString(_lastCompletedWorkoutDateKey, today);
    _planUpdateController.add(null);
  }

  /// Checks if a workout has been completed today
  /// 
  /// Returns: Future with boolean indicating if workout is completed
  static Future<bool> isWorkoutCompletedForToday() async {
    final prefs = await SharedPreferences.getInstance();
    final lastCompleted = prefs.getString(_lastCompletedWorkoutDateKey);
    if (lastCompleted == null) return false;
    
    final today = DateTime.now().toIso8601String().split('T')[0];
    return lastCompleted == today;
  }
}


