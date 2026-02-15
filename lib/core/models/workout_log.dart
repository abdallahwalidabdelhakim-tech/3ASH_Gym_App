/// Workout log data model
///
/// Represents a complete workout session log with detailed exercise information.
class WorkoutLog {

  /// Creates a WorkoutLog instance
  WorkoutLog({
    required this.id,
    required this.date,
    required this.workoutName,
    this.durationSeconds = 0,
    this.caloriesBurned = 0,
    this.exercises = const [],
  });

  /// Creates a WorkoutLog instance from JSON map
  factory WorkoutLog.fromJson(Map<String, dynamic> json) {
    return WorkoutLog(
      id: json['id'] ?? '',
      date: DateTime.parse(json['date']),
      workoutName: json['workoutName'] ?? 'Unknown Workout',
      durationSeconds: json['durationSeconds'] ?? 0,
      caloriesBurned: json['caloriesBurned'] ?? 0,
      exercises: (json['exercises'] as List?)
              ?.map((e) => ExerciseSetLog.fromJson(e))
              .toList() ??
          [],
    );
  }
  /// Unique identifier for the workout log
  final String id;
  
  /// Date and time when the workout was performed
  final DateTime date;
  
  /// Name of the workout
  final String workoutName;
  
  /// Duration of the workout in seconds
  final int durationSeconds;
  
  /// Number of calories burned during the workout
  final int caloriesBurned;
  
  /// List of exercise sets performed in this workout
  final List<ExerciseSetLog> exercises;

  /// Converts the model to JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'workoutName': workoutName,
      'durationSeconds': durationSeconds,
      'caloriesBurned': caloriesBurned,
      'exercises': exercises.map((e) => e.toJson()).toList(),
    };
  }
}

/// Exercise set log data model
///
/// Represents a single set of an exercise performed in a workout.
class ExerciseSetLog {

  /// Creates an ExerciseSetLog instance
  ExerciseSetLog({
    required this.exerciseName,
    required this.setNumber,
    required this.weight,
    required this.reps,
    this.isPr = false,
  });

  /// Creates an ExerciseSetLog instance from JSON map
  factory ExerciseSetLog.fromJson(Map<String, dynamic> json) {
    return ExerciseSetLog(
      exerciseName: json['exerciseName'] ?? '',
      setNumber: json['setNumber'] ?? 1,
      weight: json['weight']?.toDouble() ?? 0.0,
      reps: json['reps'] ?? 0,
      isPr: json['isPr'] ?? false,
    );
  }
  /// Name of the exercise
  final String exerciseName;
  
  /// Set number (1-based)
  final int setNumber;
  
  /// Weight lifted in kilograms
  final double weight;
  
  /// Number of repetitions performed
  final int reps;
  
  /// Flag indicating if this set is a personal record
  final bool isPr;

  /// Converts the model to JSON map
  Map<String, dynamic> toJson() {
    return {
      'exerciseName': exerciseName,
      'setNumber': setNumber,
      'weight': weight,
      'reps': reps,
      'isPr': isPr,
    };
  }
}
