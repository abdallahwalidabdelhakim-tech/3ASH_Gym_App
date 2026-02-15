/// Exercise data service
///
/// Handles loading and caching exercise data from JSON assets.
/// Provides asynchronous access to exercise information.
library;
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/exercise.dart';

class ExerciseService {
  /// Cache for loaded exercises
  static List<Exercise>? cachedExercises;
  
  /// Load exercises from JSON file
  static Future<List<Exercise>> _loadExercisesFromJson() async {
    try {
      final jsonString = await rootBundle.loadString('assets/data/exercises.json');
      final jsonData = json.decode(jsonString);
      
      final categories = jsonData['categories'] as List;
      final exercises = <Exercise>[];
      
      for (final category in categories) {
        final categoryExercises = category['exercises'] as List;
        for (final exerciseJson in categoryExercises) {
          exercises.add(Exercise.fromJson(exerciseJson));
        }
      }
      
      return exercises;
    } catch (e) {
      return [];
    }
  }

  /// Returns all exercises from all categories
  /// 
  /// Caches the results for subsequent calls for better performance.
  /// 
  /// Returns: List of all Exercise objects available in the application
  static Future<List<Exercise>> getAllExercises() async {
    if (cachedExercises != null) {
      return cachedExercises!;
    }
    
    cachedExercises = await _loadExercisesFromJson();
    return cachedExercises!;
  }

  /// Searches for exercises by name
  /// 
  /// Performs a case-insensitive search on exercise names.
  /// 
  /// Parameters:
  /// - query: The search term to look for in exercise names
  /// Returns: List of Exercise objects matching the search query
  static Future<List<Exercise>> searchExercises(String query) async {
    final allExercises = await getAllExercises();
    final lowerCaseQuery = query.toLowerCase();
    
    return allExercises.where((exercise) {
      return exercise.name.toLowerCase().contains(lowerCaseQuery);
    }).toList();
  }

  /// Returns exercises for a specific category
  /// 
  /// Retrieves all exercises belonging to a specific body part category.
  /// 
  /// Parameters:
  /// - category: The body part category to retrieve exercises for
  /// Returns: List of Exercise objects in the specified category
  static Future<List<Exercise>> getExercisesForCategory(String category) async {
    final jsonString = await rootBundle.loadString('assets/data/exercises.json');
    final jsonData = json.decode(jsonString);
    
    final categories = jsonData['categories'] as List;
    final categoryData = categories.firstWhere(
      (c) => c['name'] == category,
      orElse: () => {'exercises': []},
    );
    
    final categoryExercises = categoryData['exercises'] as List;
    return categoryExercises.map((e) => Exercise.fromJson(e)).toList();
  }
}
