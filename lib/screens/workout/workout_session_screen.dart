import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';
import '../../core/services/plan_service.dart';
import '../../services/data_service.dart';
import '../../core/models/workout_log.dart';

/// Screen that manages an active workout session with exercise navigation and timing
class WorkoutSessionScreen extends StatefulWidget {

  const WorkoutSessionScreen({
    super.key,
    required this.exercises,
    required this.dayTitle,
  });
  final List<Map<String, dynamic>> exercises;
  final String dayTitle;

  @override
  State<WorkoutSessionScreen> createState() => _WorkoutSessionScreenState();
}

class _WorkoutSessionScreenState extends State<WorkoutSessionScreen> {
  int _currentExerciseIndex = 0;
  late Stopwatch _stopwatch;
  late final Stream<String> _timerStream;
  late VideoPlayerController _videoController;

  @override
  void initState() {
    super.initState();
    _stopwatch = Stopwatch()..start();
    _timerStream = Stream.periodic(const Duration(seconds: 1), (_) {
      final duration = _stopwatch.elapsed;
      final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
      final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
      return '$minutes:$seconds';
    });
    
    // Initialize video controller
    _initializeVideoController();
  }

  @override
  void dispose() {
    _stopwatch.stop();
    _videoController.dispose();
    super.dispose();
  }

  /// Initializes the video controller for the current exercise
  void _initializeVideoController() {
    final currentExercise = widget.exercises[_currentExerciseIndex];
    final videoUrl = currentExercise['videoUrl'] as String? ?? 'assets/videos/bench_press_cable.mp4';
    
    _videoController = VideoPlayerController.asset(videoUrl)
      ..initialize().then((_) {
        setState(() {});
        _videoController.setLooping(true);
        _videoController.play();
      });
  }

  /// Updates the video controller when exercise changes
  void _updateVideoController() {
    _videoController.dispose();
    _initializeVideoController();
  }

  /// Navigates to the previous exercise if there is one
  void _goToPreviousExercise() {
    if (_currentExerciseIndex > 0) {
      setState(() {
        _currentExerciseIndex--;
        _updateVideoController();
      });
    }
  }

  /// Navigates to the next exercise if there is one
  void _goToNextExercise() {
    if (_currentExerciseIndex < widget.exercises.length - 1) {
      setState(() {
        _currentExerciseIndex++;
        _updateVideoController();
      });
    }
  }

  /// Shows the rest timer screen before moving to the next exercise
  void _showRestTimer() {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      pageBuilder: (context, animation, secondaryAnimation) {
        return _RestTimerScreen(
          onFinished: () => _goToNextExercise(),
        );
      },
    );
  }

  /// Shows the workout completion dialog with session summary
  void _showCompletionDialog() {
    final duration = _stopwatch.elapsed;
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds.remainder(60);
    const primary = Color(0xFFD0FD3E);

    // Save Workout Log
    _saveWorkoutLog();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1C1C1E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Workout Completed!',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.emoji_events, color: primary, size: 80),
            const SizedBox(height: 16),
            Text(
              'Great job! You finished your workout in',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white.withValues(alpha:0.7)),
            ),
            const SizedBox(height: 8),
            Text(
              '$minutes min $seconds sec',
              style: const TextStyle(
                color: primary,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                context.go('/home');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('BACK TO HOME'),
            ),
          ),
        ],
      ),
    );
  }

  /// Saves the workout log to storage
  Future<void> _saveWorkoutLog() async {
    debugPrint('Starting to save workout log');
    final dataService = DataService();
    
    debugPrint('Number of exercises: ${widget.exercises.length}');
    debugPrint('Exercises data: $widget.exercises');
    
    // Create exercise logs
    final List<ExerciseSetLog> exerciseLogs = [];
    for (var i = 0; i < widget.exercises.length; i++) {
       final ex = widget.exercises[i];
       final name = ex['name'] as String? ?? 'Exercise';
       
       // Try to parse number of sets
       final sets = ex['sets'] as int? ?? 3;
       // Try to parse reps/weight if available, otherwise use defaults
       // In a real app we'd get these from user input in the session
       for (var s = 1; s <= sets; s++) {
         exerciseLogs.add(ExerciseSetLog(
           exerciseName: name,
           setNumber: s,
           weight: 40.0 + (i * 5), // Mock some weight progression
           reps: 10,
         ));
       }
    }

    final workoutLog = WorkoutLog(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      date: DateTime.now(),
      workoutName: widget.dayTitle,
      durationSeconds: _stopwatch.elapsed.inSeconds,
      caloriesBurned: (_stopwatch.elapsed.inMinutes * 8).toInt(), // Mock calories
      exercises: exerciseLogs,
    );

    debugPrint('Workout log created: ${workoutLog.toJson()}');
    
    await dataService.saveWorkoutLog(workoutLog);
    debugPrint('Workout log saved successfully');
  }


  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFF1C1C1E);
    const primary = Color(0xFFD0FD3E); // Consistent neon green

    if (widget.exercises.isEmpty) {
      return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color.fromARGB(255, 0, 0, 0)),
            onPressed: () => context.pop(),
          ),
        ),
        body: const Center(
          child: Text(
            'No exercises for today',
            style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 18),
          ),
        ),
      );
    }

    final currentExercise = widget.exercises[_currentExerciseIndex];
    final exerciseName = currentExercise['name'] as String? ?? 'Exercise';
    final reps = currentExercise['reps'] as String? ?? '12-10-8';
    final repsText = '$reps Repeats';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color.fromARGB(255, 0, 0, 0)),
          onPressed: () => context.pop(),
        ),
        title: Column(
          children: [
            Text(
              exerciseName.toUpperCase(),
              style: const TextStyle(
                color: Color.fromARGB(255, 0, 0, 0),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            StreamBuilder<String>(
              stream: _timerStream,
              initialData: '00:00',
              builder: (context, snapshot) {
                return Text(
                  snapshot.data ?? '00:00',
                  style: const TextStyle(
                    color: Color.fromARGB(180, 0, 0, 0),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                );
              },
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
           // Exercise video
          Expanded(
            child: Container(
              width: double.infinity,
              color: Colors.white,
              child: Center(
                child: _videoController.value.isInitialized
                    ? AspectRatio(
                        aspectRatio: _videoController.value.aspectRatio,
                        child: VideoPlayer(_videoController),
                      )
                    : Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: Colors.grey[200],
                        child: const Icon(
                          Icons.fitness_center,
                          size: 100,
                          color: Colors.grey,
                        ),
                      ),
              ),
            ),
          ),
          // Reps info
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            color: Colors.white,
            child: Text(
              repsText,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color.fromARGB(255, 0, 0, 0),
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          // Navigation buttons
          Container(
            padding: const EdgeInsets.all(24),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Previous button
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _currentExerciseIndex > 0 ? _goToPreviousExercise : null,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: 80,
                      height: 60,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: _currentExerciseIndex > 0 ? primary : Colors.grey[300]!,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        color: const Color.fromARGB(255, 0, 0, 0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 4,
                            height: 20,
                            decoration: BoxDecoration(
                              color: _currentExerciseIndex > 0 ? primary : Colors.grey[300],
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 2),
                          Container(
                            width: 4,
                            height: 20,
                            decoration: BoxDecoration(
                              color: _currentExerciseIndex > 0 ? primary : Colors.grey[300],
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.arrow_back_ios,
                            color: _currentExerciseIndex > 0 ? primary : const Color.fromARGB(255, 0, 0, 0),
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 24),
                // Next / Complete button
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      if (_currentExerciseIndex < widget.exercises.length - 1) {
                        _showRestTimer();
                      } else {
                        // Complete Workout
                        _stopwatch.stop();
                        PlanService.markWorkoutAsCompleted();
                        _showCompletionDialog();
                      }
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: 140, // Wider for text
                      height: 60,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: primary,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        color: const Color.fromARGB(255, 0, 0, 0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (_currentExerciseIndex < widget.exercises.length - 1) ...[
                            const Icon(
                              Icons.arrow_forward_ios,
                              color: primary,
                              size: 20,
                            ),
                            const SizedBox(width: 4),
                            Container(
                              width: 4,
                              height: 20,
                              decoration: BoxDecoration(
                                color: primary,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            const SizedBox(width: 2),
                            Container(
                              width: 4,
                              height: 20,
                              decoration: BoxDecoration(
                                color: primary,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ] else ...[
                            const Text(
                              'FINISH',
                              style: TextStyle(
                                color: primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.check_circle,
                              color: primary,
                              size: 20,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Screen that shows a rest timer before the next exercise
class _RestTimerScreen extends StatefulWidget {

  const _RestTimerScreen({required this.onFinished});
  final VoidCallback onFinished;

  @override
  State<_RestTimerScreen> createState() => _RestTimerScreenState();
}

class _RestTimerScreenState extends State<_RestTimerScreen> {
  int _secondsRemaining = 30;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  /// Starts the countdown timer
  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        _timer?.cancel();
        Navigator.of(context).pop();
        widget.onFinished();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(225, 212, 255, 95), 
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Rest Time',
                style: TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 32,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 60),
              Text(
                '$_secondsRemaining',
                style: const TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 120,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 80),
              SizedBox(
                width: 200,
                height: 56,
                child: OutlinedButton(
                  onPressed: () {
                    _timer?.cancel();
                    Navigator.of(context).pop();
                    widget.onFinished();
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color.fromARGB(255, 0, 0, 0), width: 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: Colors.white.withValues(alpha:0.1),
                  ),
                  child: const Text(
                    'Skip Rest',
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

