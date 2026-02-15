/// Nutrition management service
///
/// Handles local storage of daily nutrition logs.
library;

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/nutrition_model.dart';
import 'dart:async';

class NutritionService {
  static const String _storageKeyPrefix = 'nutrition_log_';
  
  // Stream controller to broadcast updates to listeners (like Home Screen)
  static final StreamController<NutritionModel> _updateController = 
      StreamController<NutritionModel>.broadcast();

  static Stream<NutritionModel> get updates => _updateController.stream;


  /// Gets the nutrition log for a specific date (YYYY-MM-DD)
  static Future<NutritionModel> getDailyLog(String date) async {
    final prefs = await SharedPreferences.getInstance();
    
    // Get stored log
    final key = '$_storageKeyPrefix$date';
    final jsonStr = prefs.getString(key);

    if (jsonStr != null) {
      return NutritionModel.fromJson(jsonDecode(jsonStr));
    }

    // Return default empty model if no data exists
    return NutritionModel(date: date);
  }

  /// Saves the nutrition log
  static Future<void> saveDailyLog(NutritionModel log) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$_storageKeyPrefix${log.date}';
    await prefs.setString(key, jsonEncode(log.toJson()));
    
    // Broadcast update
    _updateController.add(log);
  }

  /// Adds food macros to today's log
  static Future<void> addMacros({
    required int calories,
    required double protein,
    required double carbs,
    required double lipid,
  }) async {
    final now = DateTime.now();
    final date = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
    
    final currentLog = await getDailyLog(date);
    
    final updatedLog = currentLog.copyWith(
      calories: currentLog.calories + calories,
      protein: currentLog.protein + protein,
      carbs: currentLog.carbs + carbs,
      lipid: currentLog.lipid + lipid,
    );

    await saveDailyLog(updatedLog);
  }

}
