/// Data service layer
///
/// Provides high-level data access methods with support for both real backend
/// API and mock backend (for testing without network connection).
library;
import 'package:boda_new/core/models/body_log.dart';
import 'package:boda_new/core/models/workout_log.dart';
import 'package:boda_new/core/services/body_log_service.dart';
import 'package:boda_new/core/services/workout_log_service.dart';
import 'package:boda_new/core/services/auth_service.dart';
import 'package:boda_new/core/config/app_config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class DataService {

  /// Factory constructor to return singleton instance
  factory DataService() {
    return _instance;
  }

  /// Private constructor for singleton pattern
  DataService._internal();
  /// Singleton instance
  static final DataService _instance = DataService._internal();

  /// Body log service instance
  final BodyLogService _bodyLogService = BodyLogService();
  
  /// Workout log service instance
  final WorkoutLogService _workoutLogService = WorkoutLogService();
  
  /// Authentication service instance
  final AuthService _authService = AuthService();

  /// Shared preferences key for mock body logs
  static const String _mockBodyLogsKey = 'mock_body_logs';
  
  /// Shared preferences key for mock workout logs
  static const String _mockWorkoutLogsKey = 'mock_workout_logs';

  /// Gets authentication token from auth service
  Future<String?> _getAuthToken() async {
    return _authService.getToken();
  }

  // --- Body Logs ---

  /// Gets all body logs
  /// 
  /// Returns body logs sorted by date in descending order (newest first)
  Future<List<BodyLog>> getBodyLogs() async {
    if (AppConfig.useMockBackend) {
      final prefs = await SharedPreferences.getInstance();
      final logsJson = prefs.getStringList(_mockBodyLogsKey) ?? [];
      final logs = logsJson.map((s) => BodyLog.fromJson(jsonDecode(s))).toList();
      return logs..sort((a, b) => b.date.compareTo(a.date));
    }

    final token = await _getAuthToken();
    if (token == null) {
      return [];
    }
    final logs = await _bodyLogService.getBodyLogs(token);
    return logs..sort((a, b) => b.date.compareTo(a.date)); // Newest first
  }

  /// Saves a body log
  /// 
  /// Handles both create and update operations. If a log for the same date exists,
  /// it will be updated; otherwise, a new log will be created.
  /// 
  /// Parameters:
  /// - log: BodyLog to save
  Future<void> saveBodyLog(BodyLog log) async {
    if (AppConfig.useMockBackend) {
      final prefs = await SharedPreferences.getInstance();
      final logs = await getBodyLogs();
      final index = logs.indexWhere((element) => 
        element.date.year == log.date.year && 
        element.date.month == log.date.month && 
        element.date.day == log.date.day);

      if (index != -1) {
        logs[index] = log;
      } else {
        logs.add(log);
      }
      
      final logsJson = logs.map((l) => jsonEncode(l.toJson())).toList();
      await prefs.setStringList(_mockBodyLogsKey, logsJson);
      return;
    }

    final token = await _getAuthToken();
    if (token == null) {
      return;
    }
    // Check if log for this date already exists, update it if so
    final existingLogs = await getBodyLogs();
    final index = existingLogs.indexWhere((element) => 
      element.date.year == log.date.year && 
      element.date.month == log.date.month && 
      element.date.day == log.date.day);

    if (index != -1) {
      // Update existing log
      await _bodyLogService.updateBodyLog(existingLogs[index].id, log, token);
    } else {
      // Create new log
      await _bodyLogService.createBodyLog(log, token);
    }
  }
  
  // --- Workout Logs ---

  /// Gets all workout logs
  /// 
  /// Returns workout logs sorted by date in descending order (newest first)
  Future<List<WorkoutLog>> getWorkoutLogs() async {
    if (AppConfig.useMockBackend) {
      final prefs = await SharedPreferences.getInstance();
      final logsJson = prefs.getStringList(_mockWorkoutLogsKey) ?? [];
      final logs = logsJson.map((s) => WorkoutLog.fromJson(jsonDecode(s))).toList();
      return logs..sort((a, b) => b.date.compareTo(a.date));
    }

    final token = await _getAuthToken();
    if (token == null) {
      return [];
    }
    final logs = await _workoutLogService.getWorkoutLogs(token);
    return logs..sort((a, b) => b.date.compareTo(a.date));
  }

  /// Saves a workout log
  /// 
  /// Handles both create and update operations. If a log with the same ID exists,
  /// it will be updated; otherwise, a new log will be created.
  /// 
  /// Parameters:
  /// - log: WorkoutLog to save
  Future<void> saveWorkoutLog(WorkoutLog log) async {
    if (AppConfig.useMockBackend) {
      final prefs = await SharedPreferences.getInstance();
      final logs = await getWorkoutLogs();
      final index = logs.indexWhere((element) => element.id == log.id);

      if (index != -1) {
        logs[index] = log;
      } else {
        logs.add(log);
      }
      
      final logsJson = logs.map((l) => jsonEncode(l.toJson())).toList();
      await prefs.setStringList(_mockWorkoutLogsKey, logsJson);
      return;
    }

    final token = await _getAuthToken();
    if (token == null) {
      return;
    }
    // Replace if ID exists (edit), otherwise add
    final existingLogs = await getWorkoutLogs();
    final index = existingLogs.indexWhere((element) => element.id == log.id);

    if (index != -1) {
      await _workoutLogService.updateWorkoutLog(existingLogs[index].id, log, token);
    } else {
      await _workoutLogService.createWorkoutLog(log, token);
    }
  }

  // --- Special Queries ---

  /// Gets personal records for all exercises
  /// 
  /// Returns the best (maximum weight) set for each exercise type.
  /// 
  /// Returns: List of ExerciseSetLog representing personal records
  Future<List<ExerciseSetLog>> getPersonalRecords() async {
    final workouts = await getWorkoutLogs();
    final Map<String, ExerciseSetLog> bestSets = {};

    for (var workout in workouts) {
      for (var set in workout.exercises) {
        if (!bestSets.containsKey(set.exerciseName)) {
           bestSets[set.exerciseName] = set;
        } else {
          if (set.weight > bestSets[set.exerciseName]!.weight) {
             bestSets[set.exerciseName] = set;
          }
        }
      }
    }
    
    return bestSets.values.toList();
  }
  
  /// Gets exercise history for charting purposes
  /// 
  /// Calculates daily statistics for a specific exercise including:
  /// - Max weight (1RM using Epley formula)
  /// - Raw max weight (actual maximum lifted)
  /// - Total volume (weight * reps)
  /// 
  /// Parameters:
  /// - exerciseName: Name of the exercise to get history for
  /// Returns: List of daily statistics for the exercise
  Future<List<Map<String, dynamic>>> getExerciseHistory(String exerciseName) async {
    final workouts = await getWorkoutLogs();
    
    // Aggregate by Date (YYYY-MM-DD)
    final Map<String, Map<String, dynamic>> dailyMap = {};

    for (var workout in workouts) {
      // Create a key for the date to group by day
      final dateKey = '${workout.date.year}-${workout.date.month}-${workout.date.day}';

      // Find stats for this specific workout session
      double sessionMax1RM = 0;
      int sessionVolume = 0;
      double sessionRawMax = 0;
      bool foundInSession = false;

      for (var set in workout.exercises) {
        if (set.exerciseName == exerciseName) {
          foundInSession = true;
          // Epley Formula: 1RM = Weight * (1 + Reps/30)
          final double epley1RM = set.weight * (1 + set.reps / 30.0);
          if (epley1RM > sessionMax1RM) sessionMax1RM = epley1RM;
          
          if (set.weight > sessionRawMax) sessionRawMax = set.weight;
          sessionVolume += (set.weight * set.reps).toInt();
        }
      }

      if (foundInSession) {
        if (!dailyMap.containsKey(dateKey)) {
          // Initialize daily entry
          dailyMap[dateKey] = {
            'date': DateTime(workout.date.year, workout.date.month, workout.date.day),
            'maxWeight': sessionMax1RM,
            'rawMaxWeight': sessionRawMax,
            'totalVolume': sessionVolume,
          };
        } else {
          // Update existing daily entry
          final existing = dailyMap[dateKey]!;
          
          // Max Weight should be the best of the day
          if (sessionMax1RM > (existing['maxWeight'] as double)) {
            existing['maxWeight'] = sessionMax1RM;
          }
           // Raw Max should be the best of the day
          if (sessionRawMax > (existing['rawMaxWeight'] as double)) {
            existing['rawMaxWeight'] = sessionRawMax;
          }

          // Volume should be the SUM of the day
          existing['totalVolume'] = (existing['totalVolume'] as int) + sessionVolume;
        }
      }
    }
    
    final List<Map<String, dynamic>> history = dailyMap.values.toList();

    // Sort by date ascending for charts
    history.sort((a, b) => (a['date'] as DateTime).compareTo(b['date'] as DateTime));
    return history;
  }
  
}

