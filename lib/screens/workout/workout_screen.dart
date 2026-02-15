import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/models/exercise.dart';

/// Model representing a single workout day with exercises
class WorkoutDay {

  const WorkoutDay({
    required this.day,
    required this.title,
    required this.duration,
    required this.workoutCount,
    required this.imagePath,
    this.exercises = const [],
  });
  final String day;
  final String title;
  final String duration;
  final String workoutCount;
  final String imagePath;
  final List<Exercise> exercises;
}

/// Model representing a complete workout program with multiple days
class WorkoutProgram {

  const WorkoutProgram({
    required this.title,
    required this.subtitle,
    required this.duration,
    required this.imagePath,
    required this.workoutDays,
  });
  final String title;
  final String subtitle;
  final String duration;
  final String imagePath;
  final List<WorkoutDay> workoutDays;
}

/// Screen that displays available workout programs for users to select
class WorkoutScreen extends StatelessWidget {
  const WorkoutScreen({super.key});

  // Helper function to get exercises for a workout day based on title
  static List<Exercise> _getExercisesForDay(String title) {
    List<String> getGallery(String mainImage) => [mainImage, mainImage, mainImage];
    
    final titleUpper = title.toUpperCase();
    
    // REST DAYS - no exercises
    if (titleUpper.contains('REST')) {
      return [];
    }
    
    // CARDIO exercises
    if (titleUpper.contains('CARDIO')) {
      return [
        Exercise(name: 'Treadmill Run',
          mainImageUrl: 'assets/images/exercises/treadmill.png',
          videoUrl: 'assets/videos/treadmill_run.mp4',
          instructions: [
            'Stand on the treadmill and clip the safety key to your tank top or T-shirt.',
            'Start the treadmill and gradually increase the speed from slow walking to a jog.',
            'Maintain an upright posture, direct your gaze forward, and maintain a steady breath.',
            'Keep your arms bent and move them in sync with your strides.',
          ],
          galleryImages: getGallery('assets/images/exercises/treadmill.png'),
        ),
        Exercise(name: 'Spinning',
          mainImageUrl: 'assets/images/exercises/Spinning.png',
          videoUrl: 'assets/videos/spinning.mp4',
          instructions: [
            'Adjust the seat height and get on top of the cardio machine.',
            'Select the appropriate program and grab the handles.',
            'Place your feet flat on the pedals, bring your shoulders back, and direct your gaze forward.',
            'Cycle steadily and maintain a steady breath.',
          ],
          galleryImages: getGallery('assets/images/exercises/Spinning.png'),
        ),
        Exercise(name: 'Walking on Stepmill',
          mainImageUrl: 'assets/images/exercises/Walking on Stepmill.png',
          videoUrl: 'assets/videos/walking_on_stepmill.mp4',
          instructions: [
            'Climb on top of the machine and turn it on.',
            'Select a low speed and grab the handrails for support.',
            'Climb the moving stairs while keeping your shoulders back and abs engaged.',
            'Maintain a steady breath.',
            "Increase the speed to a sustainable pace once you're familiar with the machine.",
          ],
          galleryImages: getGallery('assets/images/exercises/Walking on Stepmill.png'),
        ),
      ];
    }
    
    // LEGS - BICEPS combined
    if (titleUpper.contains('LEGS') && titleUpper.contains('BICEPS')) {
      final legExercises = [
        Exercise(name: 'Leg Press (Machine)',
          mainImageUrl: 'assets/images/exercises/Leg Press (Machine).png',
          videoUrl: 'assets/videos/leg_press_machine.mp4',
          instructions: [
            'Lift your legs and plant your feet flat on the platform. Have your feet in a comfortable position with your toes pointing slightly out.',
            'Grab the handles to your sides, bring your shoulders back, and engage your abs.',
            'Press the platform and straighten your legs while rotating the handles to remove the safety pins.',
            'Take another breath and lower the platform by bending your knees.',
            'Hold the bottom position for a moment and press the platform away as you exhale.',
            'Once finished, straighten your legs, rotate the handles to put the safety pins on, and rest.',
          ],
          galleryImages: getGallery('assets/images/exercises/Leg Press (Machine).png'),
        ),
        Exercise(name: 'Squat (Smith Machine)',
          mainImageUrl: 'assets/images/exercises/Squat (Smith Machine).png',
          videoUrl: 'assets/videos/squat_smith_machine.mp4',
          instructions: [
            'Grab the bar with an overhand grip, tuck your head underneath, and position your upper back against the bar.',
            'Walk your feet out a bit and have them hip-width apart.',
            'Extend your knees to unrack the bar.',
            'Engage your abs, breathe in, and squat by bending your knees.',
            'Descend until your thighs are parallel to the floor.',
            'Press through your heels to move back to the top and exhale.',
          ],
          galleryImages: getGallery('assets/images/exercises/Squat (Smith Machine).png'),
        ),
        Exercise(name: 'Leg Extension (Machine)',
          mainImageUrl: 'assets/images/exercises/Leg Extension (Machine).png',
          videoUrl: 'assets/videos/leg_extension_machine.mp4',
          instructions: [
            'Adjust the pad to be against your lower legs, just above your feet when seated.',
            'Sit down, grab the handles by your sides, place your lower shins against the pad, and retract your shoulders.',
            'Take a breath and straighten your legs by engaging your quadriceps.',
            'Lift the weight until your knees straighten, and breathe out.',
            'Hold for a moment and bend your knees slowly as you breathe in.',
          ],
          galleryImages: getGallery('assets/images/exercises/Leg Extension (Machine).png'),
        ),
        Exercise(name: 'Lying Leg Curl (Machine)',
          mainImageUrl: 'assets/images/exercises/Lying Leg Curl (Machine).png',
          videoUrl: 'assets/videos/lying_leg_curl_machine.mp4',
          instructions: [
            'Select the appropriate load and adjust the pad to be over your Achilles tendon (above the heel) when you lie down.',
            'Lie down, grab the handles, and place the back of your lower legs against the pad.',
            'Take a breath and engage your hamstrings to curl your legs, lifting the weight.',
            'Curl until your lower legs are almost vertical and exhale at the top.',
            'Hold for a moment and extend your knees slowly as you inhale.',
          ],
          galleryImages: getGallery('assets/images/exercises/Lying Leg Curl (Machine).png'),
        ),
      ];
      final bicepExercises = [
        Exercise(name: 'Bicep Curl (Machine)',
          mainImageUrl: 'assets/images/exercises/Bicep Curl (Machine).png',
          videoUrl: 'assets/videos/bicep_curl_machine.mp4',
          instructions: [
            'Select the correct load on the machine and adjust your seat\'s height.',
            'Sit down and grab the handles by your sides.',
            'Bring your shoulders back, engage your abs, and take a breath.',
            'Bend one arm to lift the handle. Curl until your hand is slightly higher than your elbow, and breathe out.',
            'Extend your arm slowly as you breathe in.',
            'Bend your opposite arm in the same way.',
            'Keep alternating until you finish the set.',
          ],
          galleryImages: getGallery('assets/images/exercises/Bicep Curl (Machine).png'),
        ),
        Exercise(name: 'Rope Cable Curl',
          mainImageUrl: 'assets/images/exercises/Rope Cable Curl.png',
          videoUrl: 'assets/videos/rope_cable_curl.mp4',
          instructions: [
            'Set the pulley in the lowest position and attach a rope.',
            'Select the appropriate weight on the cable machine.',
            'Bend forward and grab both ends of the rope with a neutral grip (palms facing one another).',
            'Stand tall, bring your shoulders back, and step back to lift the weight from its stack.',
            'Take a breath and curl the cable by bending your elbows.',
            'Lift until your wrists are slightly higher than your elbows, and breathe out.',
            'Extend your arms slowly and breathe in.',
          ],
          galleryImages: getGallery('assets/images/exercises/Rope Cable Curl.png'),
        ),
      ];
      return [...legExercises, ...bicepExercises];
    }
    
    // CHEST - TRICEPS combined
    if (titleUpper.contains('CHEST') && titleUpper.contains('TRICEPS')) {
      final chestExercises = [
        Exercise(name: 'Bench Press (Cable)',
          mainImageUrl: 'assets/images/exercises/Bench Press (Cable).png',
          videoUrl: 'assets/videos/bench_press_cable.mp4',
          instructions: [
            'Place a flat gym bench in the middle of a double cable machine.',
            'Adjust the load on both weight stacks, position the pulleys low, and attach handles.',
            'Grab both handles and sit on the bench while keeping your arms close to your body.',
            'Lie back carefully and bring your arms to your sides without flaring your elbows.',
            'Bring your shoulders back, engage your abs, and take a breath.',
            'Push both handles up and in, tapping your knuckles at the top as you exhale.',
            'Lower the weights carefully until your elbows are at torso level, and breathe in.',
            'Once finished, bring your arms in, get up slowly, and release both handles.',
          ],
          galleryImages: getGallery('assets/images/exercises/Bench Press (Cable).png'),
        ),
        Exercise(name: 'Cable Fly Crossovers',
          mainImageUrl: 'assets/images/exercises/Cable Fly Crossovers.png',
          videoUrl: 'assets/videos/cable_fly_crossovers.mp4',
          instructions: [
            'Adjust the load on the pair of weight stacks inside the cable crossover machine.',
            'Set the pulleys in the highest position and attach handles on both.',
            'Grab the handles one at a time and position yourself in the middle between the two pillars.',
            'Bring your arms to your sides and take a half step forward to lift the weights from their stacks.',
            'Engage your abs, bring your shoulders back, and inhale.',
            'Bring your arms in and down, meeting your knuckles in front of your hips. Exhale.',
            'Hold for a moment and bring your arms to your sides as you breathe in.',
          ],
          galleryImages: getGallery('assets/images/exercises/Cable Fly Crossovers.png'),
        ),
        Exercise(name: 'Chest Press (Machine)',
          mainImageUrl: 'assets/images/exercises/Chest Press (Machine).png',
          videoUrl: 'assets/videos/chest_press_machine.mp4',
          instructions: [
            'Select the appropriate load on the machine.',
            'Adjust the seat height. The handles should be slightly below your lower chest when you sit down.',
            'Sit down, grab the handles, bring your shoulders back, and engage your abs. Have your feet flat on the floor.',
            'Take a breath and press until your arms extend fully. Exhale.',
            'Bend your arms slowly as you breathe in.',
          ],
          galleryImages: getGallery('assets/images/exercises/Chest Press (Machine).png'),
        ),
      ];
      final tricepExercises = [
        Exercise(name: 'Triceps Pressdown',
          mainImageUrl: 'assets/images/exercises/Triceps Pressdown.png',
          videoUrl: 'assets/videos/triceps_pressdown.mp4',
          instructions: [
            'Set the appropriate weight on a cable machine.',
            'Put the pulley in the highest position and attach a straight or V-shaped bar.',
            'Grab the bar with an even overhand grip (palms facing down).',
            'Bring your elbows to your sides, take a step back, and retract your shoulder blades.',
            'Engage your abs and take a breath.',
            'Extend your arms fully and hold the bottom position for a moment as you breathe out.',
            'Slowly bend your arms until your wrists are slightly higher than your elbows, breathing in along the way.',
          ],
          galleryImages: getGallery('assets/images/exercises/Triceps Pressdown.png'),
        ),
        Exercise(name: 'Overhead Triceps Extension (Cable)',
          mainImageUrl: 'assets/images/exercises/Overhead Triceps Extension (Cable).png',
          videoUrl: 'assets/videos/overhead_triceps_extension_cable.mp4',
          instructions: [
            'Set the pulley at mid-thigh height, attach a rope, and select the correct load.',
            'Grab both ends of the rope with an overhand grip (palms facing your body).',
            'In one motion, turn away from the machine and dip slightly to raise the rope over your shoulders, positioning it behind your head. Your elbows should be bent and to the sides of your head.',
            'With your chest out, lean forward slightly, bring one foot forward for balance, and brace your abs.',
            'Breathe in and extend your elbows, spreading the rope at the top. Exhale.',
            'Slowly bend your elbows as you breathe in.',
          ],
          galleryImages: getGallery('assets/images/exercises/Overhead Triceps Extension (Cable).png'),
        ),
      ];
      return [...chestExercises, ...tricepExercises];
    }
    
    // CHEST - SHOULDERS combined
    if (titleUpper.contains('CHEST') && titleUpper.contains('SHOULDERS')) {
      final chestExercises = [
        Exercise(name: 'Bench Press (Cable)',
          mainImageUrl: 'assets/images/exercises/Bench Press (Cable).png',
          videoUrl: 'assets/videos/bench_press_cable.mp4',
          instructions: [
            'Place a flat gym bench in the middle of a double cable machine.',
            'Adjust the load on both weight stacks, position the pulleys low, and attach handles.',
            'Grab both handles and sit on the bench while keeping your arms close to your body.',
            'Lie back carefully and bring your arms to your sides without flaring your elbows.',
            'Bring your shoulders back, engage your abs, and take a breath.',
            'Push both handles up and in, tapping your knuckles at the top as you exhale.',
            'Lower the weights carefully until your elbows are at torso level, and breathe in.',
            'Once finished, bring your arms in, get up slowly, and release both handles.',
          ],
          galleryImages: getGallery('assets/images/exercises/Bench Press (Cable).png'),
        ),
        Exercise(name: 'Cable Fly Crossovers',
          mainImageUrl: 'assets/images/exercises/Cable Fly Crossovers.png',
          videoUrl: 'assets/videos/cable_fly_crossovers.mp4',
          instructions: [
            'Adjust the load on the pair of weight stacks inside the cable crossover machine.',
            'Set the pulleys in the highest position and attach handles on both.',
            'Grab the handles one at a time and position yourself in the middle between the two pillars.',
            'Bring your arms to your sides and take a half step forward to lift the weights from their stacks.',
            'Engage your abs, bring your shoulders back, and inhale.',
            'Bring your arms in and down, meeting your knuckles in front of your hips. Exhale.',
            'Hold for a moment and bring your arms to your sides as you breathe in.',
          ],
          galleryImages: getGallery('assets/images/exercises/Cable Fly Crossovers.png'),
        ),
      ];
      final shoulderExercises = [
        Exercise(name: 'Seated Shoulder Press (Machine)',
          mainImageUrl: 'assets/images/exercises/Seated Shoulder Press (Machine).png',
          videoUrl: 'assets/videos/seated_shoulder_press_machine.mp4',
          instructions: [
            'Sit down and bring your shoulder blades into the back support.',
            'Plant your feet flat on the floor.',
            'Grab the handles to your sides and keep your palms facing forward.',
            'Take a breath and engage your abs.',
            'Press the weight straight up until your arms are fully extended. Breathe out at the top.',
            'Lower the weight to the starting position and breathe in.',
          ],
          galleryImages: getGallery('assets/images/exercises/Seated Shoulder Press (Machine).png'),
        ),
        Exercise(name: 'Lateral Raise (Machine)',
          mainImageUrl: 'assets/images/exercises/Lateral Raise (Machine).png',
          videoUrl: 'assets/videos/machine_lateral_raise.mp4',
          instructions: [
            'Select the appropriate load and adjust the seat\'s height.',
            'Sit down and bring your shoulders back and into the back support.',
            'Grab the handles on your sides and position your forearms flat against the pads.',
            'Take a breath and bring your arms to your sides smoothly, going up until your elbows are at shoulder level. Breathe out.',
            'Lower your arms to your sides and breathe in.',
          ],
          galleryImages: getGallery('assets/images/exercises/Lateral Raise (Machine).png'),
        ),
      ];
      return [...chestExercises, ...shoulderExercises];
    }
    
    // BACK - BICEPS combined
    if (titleUpper.contains('BACK') && titleUpper.contains('BICEPS')) {
      final backExercises = [
        Exercise(name: 'Lat Pulldown (Cable)',
          mainImageUrl: 'assets/images/exercises/Lat Pulldown (Cable).png',
          videoUrl: 'assets/videos/lat_pulldown_cable.mp4',
          instructions: [
            'Adjust the knee pad on the machine to be right against your thighs.',
            'Select a weight you can lift for at least ten smooth reps.',
            'Grab the bar with your hands slightly wider than shoulder-width apart. Your palms should face forward.',
            'Sit down and secure your legs underneath the pad.',
            'With your arms extended, bring your shoulders back and down.',
            'Take a breath and pull the weight down through your elbows. As you pull, keep your elbows tucked and in line with your torso. Breathe out.',
            'Hold for a moment and extend your arms fully as you breathe in.',
          ],
          galleryImages: getGallery('assets/images/exercises/Lat Pulldown (Cable).png'),
        ),
        Exercise(name: 'Iso-Lateral High Row (Machine)',
          mainImageUrl: 'assets/images/exercises/Iso-Lateral High Row (Machine).png',
          videoUrl: 'assets/videos/iso-lateral_high_row_machine.mp4',
          instructions: [
            'Load the machine and set the thigh pad for your legs to fit snugly.',
            'Sit down and grab the handles.',
            'Bring your shoulders back, engage your abs, and take a breath.',
            'Pull the handles to your torso, squeezing your back muscles, and breathe out.',
            'Slowly extend your arms as you breathe in.',
          ],
          galleryImages: getGallery('assets/images/exercises/Iso-Lateral High Row (Machine).png'),
        ),
      ];
      final bicepExercises = [
        Exercise(name: 'Bicep Curl (Machine)',
          mainImageUrl: 'assets/images/exercises/Bicep Curl (Machine).png',
          videoUrl: 'assets/videos/bicep_curl_machine.mp4',
          instructions: [
            'Select the correct load on the machine and adjust your seat\'s height.',
            'Sit down and grab the handles by your sides.',
            'Bring your shoulders back, engage your abs, and take a breath.',
            'Bend one arm to lift the handle. Curl until your hand is slightly higher than your elbow, and breathe out.',
            'Extend your arm slowly as you breathe in.',
            'Bend your opposite arm in the same way.',
            'Keep alternating until you finish the set.',
          ],
          galleryImages: getGallery('assets/images/exercises/Bicep Curl (Machine).png'),
        ),
        Exercise(name: 'Rope Cable Curl',
          mainImageUrl: 'assets/images/exercises/Rope Cable Curl.png',
          videoUrl: 'assets/videos/rope_cable_curl.mp4',
          instructions: [
            'Set the pulley in the lowest position and attach a rope.',
            'Select the appropriate weight on the cable machine.',
            'Bend forward and grab both ends of the rope with a neutral grip (palms facing one another).',
            'Stand tall, bring your shoulders back, and step back to lift the weight from its stack.',
            'Take a breath and curl the cable by bending your elbows.',
            'Lift until your wrists are slightly higher than your elbows, and breathe out.',
            'Extend your arms slowly and breathe in.',
          ],
          galleryImages: getGallery('assets/images/exercises/Rope Cable Curl.png'),
        ),
      ];
      return [...backExercises, ...bicepExercises];
    }
    
    // SHOULDERS - BICEPS combined
    if (titleUpper.contains('SHOULDERS') && titleUpper.contains('BICEPS')) {
      final shoulderExercises = [
        Exercise(name: 'Seated Shoulder Press (Machine)',
          mainImageUrl: 'assets/images/exercises/Seated Shoulder Press (Machine).png',
          videoUrl: 'assets/videos/seated_shoulder_press_machine.mp4',
          instructions: [
            'Sit down and bring your shoulder blades into the back support.',
            'Plant your feet flat on the floor.',
            'Grab the handles to your sides and keep your palms facing forward.',
            'Take a breath and engage your abs.',
            'Press the weight straight up until your arms are fully extended. Breathe out at the top.',
            'Lower the weight to the starting position and breathe in.',
          ],
          galleryImages: getGallery('assets/images/exercises/Seated Shoulder Press (Machine).png'),
        ),
        Exercise(name: 'Lateral Raise (Machine)',
          mainImageUrl: 'assets/images/exercises/Lateral Raise (Machine).png',
          videoUrl: 'assets/videos/machine_lateral_raise.mp4',
          instructions: [
            'Select the appropriate load and adjust the seat\'s height.',
            'Sit down and bring your shoulders back and into the back support.',
            'Grab the handles on your sides and position your forearms flat against the pads.',
            'Take a breath and bring your arms to your sides smoothly, going up until your elbows are at shoulder level. Breathe out.',
            'Lower your arms to your sides and breathe in.',
          ],
          galleryImages: getGallery('assets/images/exercises/Lateral Raise (Machine).png'),
        ),
      ];
      final bicepExercises = [
        Exercise(name: 'Bicep Curl (Machine)',
          mainImageUrl: 'assets/images/exercises/Bicep Curl (Machine).png',
          videoUrl: 'assets/videos/bicep_curl_machine.mp4',
          instructions: [
            'Select the correct load on the machine and adjust your seat\'s height.',
            'Sit down and grab the handles by your sides.',
            'Bring your shoulders back, engage your abs, and take a breath.',
            'Bend one arm to lift the handle. Curl until your hand is slightly higher than your elbow, and breathe out.',
            'Extend your arm slowly as you breathe in.',
            'Bend your opposite arm in the same way.',
            'Keep alternating until you finish the set.',
          ],
          galleryImages: getGallery('assets/images/exercises/Bicep Curl (Machine).png'),
        ),
        Exercise(name: 'Rope Cable Curl',
          mainImageUrl: 'assets/images/exercises/Rope Cable Curl.png',
          videoUrl: 'assets/videos/rope_cable_curl.mp4',
          instructions: [
            'Set the pulley in the lowest position and attach a rope.',
            'Select the appropriate weight on the cable machine.',
            'Bend forward and grab both ends of the rope with a neutral grip (palms facing one another).',
            'Stand tall, bring your shoulders back, and step back to lift the weight from its stack.',
            'Take a breath and curl the cable by bending your elbows.',
            'Lift until your wrists are slightly higher than your elbows, and breathe out.',
            'Extend your arms slowly and breathe in.',
          ],
          galleryImages: getGallery('assets/images/exercises/Rope Cable Curl.png'),
        ),
      ];
      return [...shoulderExercises, ...bicepExercises];
    }
    
    // CHEST - BACK combined
    if (titleUpper.contains('CHEST') && titleUpper.contains('BACK')) {
      final chestExercises = [
        Exercise(name: 'Bench Press (Cable)',
          mainImageUrl: 'assets/images/exercises/Bench Press (Cable).png',
          videoUrl: 'assets/videos/bench_press_cable.mp4',
          instructions: [
            'Place a flat gym bench in the middle of a double cable machine.',
            'Adjust the load on both weight stacks, position the pulleys low, and attach handles.',
            'Grab both handles and sit on the bench while keeping your arms close to your body.',
            'Lie back carefully and bring your arms to your sides without flaring your elbows.',
            'Bring your shoulders back, engage your abs, and take a breath.',
            'Push both handles up and in, tapping your knuckles at the top as you exhale.',
            'Lower the weights carefully until your elbows are at torso level, and breathe in.',
            'Once finished, bring your arms in, get up slowly, and release both handles.',
          ],
          galleryImages: getGallery('assets/images/exercises/Bench Press (Cable).png'),
        ),
        Exercise(name: 'Cable Fly Crossovers',
          mainImageUrl: 'assets/images/exercises/Cable Fly Crossovers.png',
          videoUrl: 'assets/videos/cable_fly_crossovers.mp4',
          instructions: [
            'Adjust the load on the pair of weight stacks inside the cable crossover machine.',
            'Set the pulleys in the highest position and attach handles on both.',
            'Grab the handles one at a time and position yourself in the middle between the two pillars.',
            'Bring your arms to your sides and take a half step forward to lift the weights from their stacks.',
            'Engage your abs, bring your shoulders back, and inhale.',
            'Bring your arms in and down, meeting your knuckles in front of your hips. Exhale.',
            'Hold for a moment and bring your arms to your sides as you breathe in.',
          ],
          galleryImages: getGallery('assets/images/exercises/Cable Fly Crossovers.png'),
        ),
      ];
      final backExercises = [
        Exercise(name: 'Lat Pulldown (Cable)',
          mainImageUrl: 'assets/images/exercises/Lat Pulldown (Cable).png',
          videoUrl: 'assets/videos/lat_pulldown_cable.mp4',
          instructions: [
            'Adjust the knee pad on the machine to be right against your thighs.',
            'Select a weight you can lift for at least ten smooth reps.',
            'Grab the bar with your hands slightly wider than shoulder-width apart. Your palms should face forward.',
            'Sit down and secure your legs underneath the pad.',
            'With your arms extended, bring your shoulders back and down.',
            'Take a breath and pull the weight down through your elbows. As you pull, keep your elbows tucked and in line with your torso. Breathe out.',
            'Hold for a moment and extend your arms fully as you breathe in.',
          ],
          galleryImages: getGallery('assets/images/exercises/Lat Pulldown (Cable).png'),
        ),
        Exercise(name: 'Iso-Lateral High Row (Machine)',
          mainImageUrl: 'assets/images/exercises/Iso-Lateral High Row (Machine).png',
          videoUrl: 'assets/videos/iso-lateral_high_row_machine.mp4',
          instructions: [
            'Load the machine and set the thigh pad for your legs to fit snugly.',
            'Sit down and grab the handles.',
            'Bring your shoulders back, engage your abs, and take a breath.',
            'Pull the handles to your torso, squeezing your back muscles, and breathe out.',
            'Slowly extend your arms as you breathe in.',
          ],
          galleryImages: getGallery('assets/images/exercises/Iso-Lateral High Row (Machine).png'),
        ),
      ];
      return [...chestExercises, ...backExercises];
    }
    
    // CARDIO - ABS combined
    if (titleUpper.contains('CARDIO') && titleUpper.contains('ABS')) {
      final cardioExercises = [
        Exercise(name: 'Treadmill Run',
          mainImageUrl: 'assets/images/exercises/treadmill.png',
          videoUrl: 'assets/videos/treadmill_run.mp4',
          instructions: [
            'Stand on the treadmill and clip the safety key to your tank top or T-shirt.',
            'Start the treadmill and gradually increase the speed from slow walking to a jog.',
            'Maintain an upright posture, direct your gaze forward, and maintain a steady breath.',
            'Keep your arms bent and move them in sync with your strides.',
          ],
          galleryImages: getGallery('assets/images/exercises/treadmill.png'),
        ),
        Exercise(name: 'Spinning',
          mainImageUrl: 'assets/images/exercises/Spinning.png',
          videoUrl: 'assets/videos/spinning.mp4',
          instructions: [
            'Adjust the seat height and get on top of the cardio machine.',
            'Select the appropriate program and grab the handles.',
            'Place your feet flat on the pedals, bring your shoulders back, and direct your gaze forward.',
            'Cycle steadily and maintain a steady breath.',
          ],
          galleryImages: getGallery('assets/images/exercises/Spinning.png'),
        ),
      ];
      final absExercises = [
        Exercise(
          name: 'Cable Crunch',
          mainImageUrl: 'assets/images/exercises/Cable Crunch.png',
          videoUrl: 'assets/videos/cable_crunch.mp4',
          instructions: [
            'Grab a rope attachment with both hands and have your thumbs facing up.',
            'Kneel, lean forward, and position the rope behind your head. Keep your hands close to your neck.',
            'Once in position, engage your midsection.',
            'Initiate the crunch by taking a breath and flexing your abs. Focus on crunching your torso instead of simply moving at the hips.',
            'Hold for a moment as you exhale.',
            'Slowly raise your torso to bring yourself to the starting position as you breathe in.',
          ],
          galleryImages: getGallery('assets/images/exercises/Cable Crunch.png'),
        ),
        Exercise(
          name: 'Leg Raise Parallel Bars',
          mainImageUrl: 'assets/images/exercises/Leg Raise Parallel Bars.png',
          videoUrl: 'assets/videos/leg_raise_parallel_bars.mp4',
          instructions: [
            "Position yourself on a captain's chair. Have your forearms flat against the horizontal pads and grab the handles for support.",
            'Bring your feet together and engage your abs to position your lower back against the back support.',
            'Take a breath and raise your legs in one fluid motion, going as high as possible. Exhale at the top.',
            "Slowly lower your legs to the starting position and keep the tension on your abs. Breathe in on the way down, and don't let your lower back arch.",
          ],
          galleryImages: getGallery('assets/images/exercises/Leg Raise Parallel Bars.png'),
        ),
      ];
      return [...cardioExercises, ...absExercises];
    }
    
    // LEGS exercises
    if (titleUpper.contains('LEGS') || titleUpper.contains('LOWER BODY')) {
      return [
        Exercise(name: 'Leg Press (Machine)',
          mainImageUrl: 'assets/images/exercises/Leg Press (Machine).png',
          videoUrl: 'assets/videos/leg_press_machine.mp4',
          instructions: [
            'Lift your legs and plant your feet flat on the platform. Have your feet in a comfortable position with your toes pointing slightly out.',
            'Grab the handles to your sides, bring your shoulders back, and engage your abs.',
            'Press the platform and straighten your legs while rotating the handles to remove the safety pins.',
            'Take another breath and lower the platform by bending your knees.',
            'Hold the bottom position for a moment and press the platform away as you exhale.',
            'Once finished, straighten your legs, rotate the handles to put the safety pins on, and rest.',
          ],
          galleryImages: getGallery('assets/images/exercises/Leg Press (Machine).png'),
        ),
        Exercise(name: 'Squat (Smith Machine)',
          mainImageUrl: 'assets/images/exercises/Squat (Smith Machine).png',
          videoUrl: 'assets/videos/squat_smith_machine.mp4',
          instructions: [
            'Grab the bar with an overhand grip, tuck your head underneath, and position your upper back against the bar.',
            'Walk your feet out a bit and have them hip-width apart.',
            'Extend your knees to unrack the bar.',
            'Engage your abs, breathe in, and squat by bending your knees.',
            'Descend until your thighs are parallel to the floor.',
            'Press through your heels to move back to the top and exhale.',
          ],
          galleryImages: getGallery('assets/images/exercises/Squat (Smith Machine).png'),
        ),
        Exercise(name: 'Leg Extension (Machine)',
          mainImageUrl: 'assets/images/exercises/Leg Extension (Machine).png',
          videoUrl: 'assets/videos/leg_extension_machine.mp4',
          instructions: [
            'Adjust the pad to be against your lower legs, just above your feet when seated.',
            'Sit down, grab the handles by your sides, place your lower shins against the pad, and retract your shoulders.',
            'Take a breath and straighten your legs by engaging your quadriceps.',
            'Lift the weight until your knees straighten, and breathe out.',
            'Hold for a moment and bend your knees slowly as you breathe in.',
          ],
          galleryImages: getGallery('assets/images/exercises/Leg Extension (Machine).png'),
        ),
        Exercise(name: 'Lying Leg Curl (Machine)',
          mainImageUrl: 'assets/images/exercises/Lying Leg Curl (Machine).png',
          videoUrl: 'assets/videos/lying_leg_curl_machine.mp4',
          instructions: [
            'Select the appropriate load and adjust the pad to be over your Achilles tendon (above the heel) when you lie down.',
            'Lie down, grab the handles, and place the back of your lower legs against the pad.',
            'Take a breath and engage your hamstrings to curl your legs, lifting the weight.',
            'Curl until your lower legs are almost vertical and exhale at the top.',
            'Hold for a moment and extend your knees slowly as you inhale.',
          ],
          galleryImages: getGallery('assets/images/exercises/Lying Leg Curl (Machine).png'),
        ),
        Exercise(
          name: 'Standing Calf Raise (Machine)',
          mainImageUrl: 'assets/images/exercises/Standing Calf Raise (Machine).png',
          videoUrl: 'assets/videos/standing_calf_raise_machine.mp4',
          instructions: [
            'Select the appropriate load.',
            'Put your shoulders and upper back against the machine\'s pad.',
            'Position the balls of your feet on the platform and extend your knees.',
            'Grab the handles by the machine\'s pad for extra support.',
            'Take a breath and extend your ankles, squeezing your calves at the top, and exhale.',
            'Lower yourself slowly, feeling your calves stretch at the bottom. Breathe in on the way down.',
          ],
          galleryImages: getGallery('assets/images/exercises/Standing Calf Raise (Machine).png'),
        ),
      ];
    }
    
    // CHEST exercises
    if (titleUpper.contains('CHEST') || titleUpper.contains('PUSH')) {
      return [
        Exercise(name: 'Bench Press (Cable)',
          mainImageUrl: 'assets/images/exercises/Bench Press (Cable).png',
          videoUrl: 'assets/videos/bench_press_cable.mp4',
          instructions: [
            'Place a flat gym bench in the middle of a double cable machine.',
            'Adjust the load on both weight stacks, position the pulleys low, and attach handles.',
            'Grab both handles and sit on the bench while keeping your arms close to your body.',
            'Lie back carefully and bring your arms to your sides without flaring your elbows.',
            'Bring your shoulders back, engage your abs, and take a breath.',
            'Push both handles up and in, tapping your knuckles at the top as you exhale.',
            'Lower the weights carefully until your elbows are at torso level, and breathe in.',
            'Once finished, bring your arms in, get up slowly, and release both handles.',
          ],
          galleryImages: getGallery('assets/images/exercises/Bench Press (Cable).png'),
        ),
        Exercise(name: 'Cable Fly Crossovers',
          mainImageUrl: 'assets/images/exercises/Cable Fly Crossovers.png',
          videoUrl: 'assets/videos/cable_fly_crossovers.mp4',
          instructions: [
            'Adjust the load on the pair of weight stacks inside the cable crossover machine.',
            'Set the pulleys in the highest position and attach handles on both.',
            'Grab the handles one at a time and position yourself in the middle between the two pillars.',
            'Bring your arms to your sides and take a half step forward to lift the weights from their stacks.',
            'Engage your abs, bring your shoulders back, and inhale.',
            'Bring your arms in and down, meeting your knuckles in front of your hips. Exhale.',
            'Hold for a moment and bring your arms to your sides as you breathe in.',
          ],
          galleryImages: getGallery('assets/images/exercises/Cable Fly Crossovers.png'),
        ),
        Exercise(name: 'Chest Press (Machine)',
          mainImageUrl: 'assets/images/exercises/Chest Press (Machine).png',
          videoUrl: 'assets/videos/chest_press_machine.mp4',
          instructions: [
            'Select the appropriate load on the machine.',
            'Adjust the seat height. The handles should be slightly below your lower chest when you sit down.',
            'Sit down, grab the handles, bring your shoulders back, and engage your abs. Have your feet flat on the floor.',
            'Take a breath and press until your arms extend fully. Exhale.',
            'Bend your arms slowly as you breathe in.',
          ],
          galleryImages: getGallery('assets/images/exercises/Chest Press (Machine).png'),
        ),
        Exercise(
          name: 'Incline Chest Press (Machine)',
          mainImageUrl: 'assets/images/exercises/Incline Chest Press (Machine).png',
          videoUrl: 'assets/videos/incline_chest_press_machine.mp4',
          instructions: [
            'Add the appropriate amount of weight.',
            'Adjust the seat height so you can comfortably grab the handles and keep your elbows tucked as you sit down.',
            'Sit down, plant your feet on the floor, and grab the handles.',
            'Retract your shoulder blades, engage your abs, and take a breath.',
            'Press the handles up and overhead in one fluid motion, exhaling at the top.',
            'Slowly bend your arms as you breathe in.',
          ],
          galleryImages: getGallery('assets/images/exercises/Incline Chest Press (Machine).png'),
        ),
      ];
    }
    
    // TRICEPS exercises
    if (titleUpper.contains('TRICEPS')) {
      return [
        Exercise(name: 'Triceps Pressdown',
          mainImageUrl: 'assets/images/exercises/Triceps Pressdown.png',
          videoUrl: 'assets/videos/triceps_pressdown.mp4',
          instructions: [
            'Set the appropriate weight on a cable machine.',
            'Put the pulley in the highest position and attach a straight or V-shaped bar.',
            'Grab the bar with an even overhand grip (palms facing down).',
            'Bring your elbows to your sides, take a step back, and retract your shoulder blades.',
            'Engage your abs and take a breath.',
            'Extend your arms fully and hold the bottom position for a moment as you breathe out.',
            'Slowly bend your arms until your wrists are slightly higher than your elbows, breathing in along the way.',
          ],
          galleryImages: getGallery('assets/images/exercises/Triceps Pressdown.png'),
        ),
        Exercise(name: 'Overhead Triceps Extension (Cable)',
          mainImageUrl: 'assets/images/exercises/Overhead Triceps Extension (Cable).png',
          videoUrl: 'assets/videos/overhead_triceps_extension_cable.mp4',
          instructions: [
            'Set the pulley at mid-thigh height, attach a rope, and select the correct load.',
            'Grab both ends of the rope with an overhand grip (palms facing your body).',
            'In one motion, turn away from the machine and dip slightly to raise the rope over your shoulders, positioning it behind your head. Your elbows should be bent and to the sides of your head.',
            'With your chest out, lean forward slightly, bring one foot forward for balance, and brace your abs.',
            'Breathe in and extend your elbows, spreading the rope at the top. Exhale.',
            'Slowly bend your elbows as you breathe in.',
          ],
          galleryImages: getGallery('assets/images/exercises/Overhead Triceps Extension (Cable).png'),
        ),
        Exercise(
          name: 'Seated Dip Machine',
          mainImageUrl: 'assets/images/exercises/Seated Dip Machine.png',
          videoUrl: 'assets/videos/seated_dip_machine.mp4',
          instructions: [
            'Select the appropriate load.',
            'Sit down and grab the handles to your sides.',
            'Plant your feet on the floor, bring your shoulders back, and engage your abs.',
            'Take a breath and press the handles down, fully extending your arms and exhaling.',
            'Bend your arms as you breathe in.',
          ],
          galleryImages: getGallery('assets/images/exercises/Seated Dip Machine.png'),
        ),
      ];
    }
    
    // BICEPS exercises
    if (titleUpper.contains('BICEPS') || titleUpper.contains('PULL')) {
      return [
        Exercise(name: 'Bicep Curl (Machine)',
          mainImageUrl: 'assets/images/exercises/Bicep Curl (Machine).png',
          videoUrl: 'assets/videos/bicep_curl_machine.mp4',
          instructions: [
            'Select the correct load on the machine and adjust your seat\'s height.',
            'Sit down and grab the handles by your sides.',
            'Bring your shoulders back, engage your abs, and take a breath.',
            'Bend one arm to lift the handle. Curl until your hand is slightly higher than your elbow, and breathe out.',
            'Extend your arm slowly as you breathe in.',
            'Bend your opposite arm in the same way.',
            'Keep alternating until you finish the set.',
          ],
          galleryImages: getGallery('assets/images/exercises/Bicep Curl (Machine).png'),
        ),
        Exercise(name: 'Rope Cable Curl',
          mainImageUrl: 'assets/images/exercises/Rope Cable Curl.png',
          videoUrl: 'assets/videos/rope_cable_curl.mp4',
          instructions: [
            'Set the pulley in the lowest position and attach a rope.',
            'Select the appropriate weight on the cable machine.',
            'Bend forward and grab both ends of the rope with a neutral grip (palms facing one another).',
            'Stand tall, bring your shoulders back, and step back to lift the weight from its stack.',
            'Take a breath and curl the cable by bending your elbows.',
            'Lift until your wrists are slightly higher than your elbows, and breathe out.',
            'Extend your arms slowly and breathe in.',
          ],
          galleryImages: getGallery('assets/images/exercises/Rope Cable Curl.png'),
        ),
        Exercise(
          name: 'Single Arm Curl (Cable)',
          mainImageUrl: 'assets/images/exercises/Single Arm Curl (Cable).png',
          videoUrl: 'assets/videos/single_arm_curl_cable.mp4',
          instructions: [
            'Select the appropriate weight, set the pulley to the lowest position, and attach a handle.',
            'Grab the handle with your right hand and position the palm up.',
            'Take a step back, inhale, and squeeze your abs.',
            'Curl the weight and squeeze your bicep at the top momentarily as you exhale.',
            'Slowly extend your arm as you breathe in.',
            'Once finished, grab the handle with your left hand and repeat.',
          ],
          galleryImages: getGallery('assets/images/exercises/Single Arm Curl (Cable).png'),
        ),
      ];
    }
    
    // BACK exercises
    if (titleUpper.contains('BACK') || titleUpper.contains('UPPER BACK')) {
      return [
        Exercise(name: 'Lat Pulldown (Cable)',
          mainImageUrl: 'assets/images/exercises/Lat Pulldown (Cable).png',
          videoUrl: 'assets/videos/lat_pulldown_cable.mp4',
          instructions: [
            'Adjust the knee pad on the machine to be right against your thighs.',
            'Select a weight you can lift for at least ten smooth reps.',
            'Grab the bar with your hands slightly wider than shoulder-width apart. Your palms should face forward.',
            'Sit down and secure your legs underneath the pad.',
            'With your arms extended, bring your shoulders back and down.',
            'Take a breath and pull the weight down through your elbows. As you pull, keep your elbows tucked and in line with your torso. Breathe out.',
            'Hold for a moment and extend your arms fully as you breathe in.',
          ],
          galleryImages: getGallery('assets/images/exercises/Lat Pulldown (Cable).png'),
        ),
        Exercise(name: 'Iso-Lateral High Row (Machine)',
          mainImageUrl: 'assets/images/exercises/Iso-Lateral High Row (Machine).png',
          videoUrl: 'assets/videos/iso-lateral_high_row_machine.mp4',
          instructions: [
            'Load the machine and set the thigh pad for your legs to fit snugly.',
            'Sit down and grab the handles.',
            'Bring your shoulders back, engage your abs, and take a breath.',
            'Pull the handles to your torso, squeezing your back muscles, and breathe out.',
            'Slowly extend your arms as you breathe in.',
          ],
          galleryImages: getGallery('assets/images/exercises/Iso-Lateral High Row (Machine).png'),
        ),
        Exercise(
          name: 'Chin Up',
          mainImageUrl: 'assets/images/exercises/Chin Up.png',
          videoUrl: 'assets/videos/chin_up.mp4',
          instructions: [
            'Reach up and grab a pull-up bar with a double underhand grip (palms facing back). Your hands should be shoulder-width apart or slightly closer.',
            'Retract your shoulders, engage your abs, squeeze your glutes, and cross your lower legs, lifting your feet off the floor.',
            'Take a breath and pull yourself up in one fluid motion. Aim to have your chin over the bar at the top. Exhale.',
            'Lower yourself slowly and breathe in. Don\'t rest your feet on the floor.',
          ],
          galleryImages: getGallery('assets/images/exercises/Chin Up.png'),
        ),
        Exercise(
          name: 'Pullover (Machine)',
          mainImageUrl: 'assets/images/exercises/Pullover (Machine).png',
          videoUrl: 'assets/videos/pullover_machine.mp4',
          instructions: [
            'Add the appropriate load to the machine and adjust the seat height.',
            'Sit down and place your lower triceps and elbows on the pads, with your hands grasping the handles for additional support.',
            'Breathe in, engage your abs, and pull the weight down until your elbows are at your sides. Exhale.',
            'Raise your arms to the starting overhead position as you breathe in.',
          ],
          galleryImages: getGallery('assets/images/exercises/Pullover (Machine).png'),
        ),
      ];
    }
    
    // SHOULDERS exercises
    if (titleUpper.contains('SHOULDERS')) {
      return [
        Exercise(name: 'Seated Shoulder Press (Machine)',
          mainImageUrl: 'assets/images/exercises/Seated Shoulder Press (Machine).png',
          videoUrl: 'assets/videos/seated_shoulder_press_machine.mp4',
          instructions: [
            'Sit down and bring your shoulder blades into the back support.',
            'Plant your feet flat on the floor.',
            'Grab the handles to your sides and keep your palms facing forward.',
            'Take a breath and engage your abs.',
            'Press the weight straight up until your arms are fully extended. Breathe out at the top.',
            'Lower the weight to the starting position and breathe in.',
          ],
          galleryImages: getGallery('assets/images/exercises/Seated Shoulder Press (Machine).png'),
        ),
        Exercise(name: 'Lateral Raise (Machine)',
          mainImageUrl: 'assets/images/exercises/Lateral Raise (Machine).png',
          videoUrl: 'assets/videos/machine_lateral_raise.mp4',
          instructions: [
            'Select the appropriate load and adjust the seat\'s height.',
            'Sit down and bring your shoulders back and into the back support.',
            'Grab the handles on your sides and position your forearms flat against the pads.',
            'Take a breath and bring your arms to your sides smoothly, going up until your elbows are at shoulder level. Breathe out.',
            'Lower your arms to your sides and breathe in.',
          ],
          galleryImages: getGallery('assets/images/exercises/Lateral Raise (Machine).png'),
        ),
        Exercise(
          name: 'Front Raise (Cable)',
          mainImageUrl: 'assets/images/exercises/Front Raise (Cable).png',
          videoUrl: 'assets/videos/cable_front_raise.mp4',
          instructions: [
            'Set the pulley in the lowest position and attach a straight bar.',
            'Face away from the cable machine with the bar between your legs.',
            'Grab the straight bar with an overhand grip (palms facing back), and have the rope between your legs. Your arms should be straight.',
            'Bring your shoulders back, engage your upper body, and bend your knees slightly.',
            'Inhale and raise the bar away from your body in one fluid motion.',
            'Lift until the bar is at shoulder level and breathe out. Keep your arms straight.',
            'Lower your arms to the starting position as you breathe in.',
          ],
          galleryImages: getGallery('assets/images/exercises/Front Raise (Cable).png'),
        ),
        Exercise(
          name: 'Rear Delt Reverse Fly (Machine)',
          mainImageUrl: 'assets/images/exercises/Rear Delt Reverse Fly (Machine).png',
          videoUrl: 'assets/videos/rear_delt_reverse_fly_machine.mp4',
          instructions: [
            'Select the appropriate load.',
            'Adjust the seat height. The handles should be at shoulder level when you\'re seated.',
            'Sit down and grab the handles with your palms facing down.',
            'Bring your shoulders back and take a breath.',
            'Extend your arms to your sides and back as you breathe out.',
            'Bring your arms to the starting position as you breathe in.',
          ],
          galleryImages: getGallery('assets/images/exercises/Rear Delt Reverse Fly (Machine).png'),
        ),
      ];
    }
    
    // ABS exercises
    if (titleUpper.contains('ABS')) {
      return [
        Exercise(
          name: 'Cable Crunch',
          mainImageUrl: 'assets/images/exercises/Cable Crunch.png',
          videoUrl: 'assets/videos/cable_crunch.mp4',
          instructions: [
            'Grab a rope attachment with both hands and have your thumbs facing up.',
            'Kneel, lean forward, and position the rope behind your head. Keep your hands close to your neck.',
            'Once in position, engage your midsection.',
            'Initiate the crunch by taking a breath and flexing your abs. Focus on crunching your torso instead of simply moving at the hips.',
            'Hold for a moment as you exhale.',
            'Slowly raise your torso to bring yourself to the starting position as you breathe in.',
          ],
          galleryImages: getGallery('assets/images/exercises/Cable Crunch.png'),
        ),
        Exercise(
          name: 'Leg Raise Parallel Bars',
          mainImageUrl: 'assets/images/exercises/Leg Raise Parallel Bars.png',
          videoUrl: 'assets/videos/leg_raise_parallel_bars.mp4',
          instructions: [
            "Position yourself on a captain's chair. Have your forearms flat against the horizontal pads and grab the handles for support.",
            'Bring your feet together and engage your abs to position your lower back against the back support.',
            'Take a breath and raise your legs in one fluid motion, going as high as possible. Exhale at the top.',
            "Slowly lower your legs to the starting position and keep the tension on your abs. Breathe in on the way down, and don't let your lower back arch.",
          ],
          galleryImages: getGallery('assets/images/exercises/Leg Raise Parallel Bars.png'),
        ),
        Exercise(
          name: 'Knee Raise Parallel Bars',
          mainImageUrl: 'assets/images/exercises/Knee Raise Parallel Bars.png',
          videoUrl: 'assets/videos/knee_raise_parallel_bars.mp4',
          instructions: [
            "Position yourself inside a captain's chair with your feet on a platform or steps, back against the pad, and forearms flat on the pair of padded parallel bars.",
            'Bring your shoulders back and contract your abs.',
            'Step off the platform or steps and support yourself with your upper body musculature. Keep your shoulders in position and avoid slumping.',
            'Take a breath and engage your abs to raise your knees as high as possible in one fluid motion. Breathe out at the top.',
            'Lower your knees to the starting position, extending them on the way down, and stop before your lower back begins to arch. Breathe in on the way down.',
          ],
          galleryImages: getGallery('assets/images/exercises/Knee Raise Parallel Bars.png'),
        ),
      ];
    }
    
    // FULL BODY / UPPER BODY / ACTIVE RECOVERY - mix of exercises
    if (titleUpper.contains('FULL BODY') || titleUpper.contains('UPPER BODY') || titleUpper.contains('ACTIVE RECOVERY')) {
      return [
        Exercise(name: 'Squat (Smith Machine)',
          mainImageUrl: 'assets/images/exercises/Squat (Smith Machine).png',
          videoUrl: 'assets/videos/squat_smith_machine.mp4',
          instructions: [
            'Grab the bar with an overhand grip, tuck your head underneath, and position your upper back against the bar.',
            'Walk your feet out a bit and have them hip-width apart.',
            'Extend your knees to unrack the bar.',
            'Engage your abs, breathe in, and squat by bending your knees.',
            'Descend until your thighs are parallel to the floor.',
            'Press through your heels to move back to the top and exhale.',
          ],
          galleryImages: getGallery('assets/images/exercises/Squat (Smith Machine).png'),
        ),
        Exercise(name: 'Bench Press (Cable)',
          mainImageUrl: 'assets/images/exercises/Bench Press (Cable).png',
          videoUrl: 'assets/videos/bench_press_cable.mp4',
          instructions: [
            'Place a flat gym bench in the middle of a double cable machine.',
            'Adjust the load on both weight stacks, position the pulleys low, and attach handles.',
            'Grab both handles and sit on the bench while keeping your arms close to your body.',
            'Lie back carefully and bring your arms to your sides without flaring your elbows.',
            'Bring your shoulders back, engage your abs, and take a breath.',
            'Push both handles up and in, tapping your knuckles at the top as you exhale.',
            'Lower the weights carefully until your elbows are at torso level, and breathe in.',
            'Once finished, bring your arms in, get up slowly, and release both handles.',
          ],
          galleryImages: getGallery('assets/images/exercises/Bench Press (Cable).png'),
        ),
        Exercise(name: 'Lat Pulldown (Cable)',
          mainImageUrl: 'assets/images/exercises/Lat Pulldown (Cable).png',
          videoUrl: 'assets/videos/lat_pulldown_cable.mp4',
          instructions: [
            'Adjust the knee pad on the machine to be right against your thighs.',
            'Select a weight you can lift for at least ten smooth reps.',
            'Grab the bar with your hands slightly wider than shoulder-width apart. Your palms should face forward.',
            'Sit down and secure your legs underneath the pad.',
            'With your arms extended, bring your shoulders back and down.',
            'Take a breath and pull the weight down through your elbows. As you pull, keep your elbows tucked and in line with your torso. Breathe out.',
            'Hold for a moment and extend your arms fully as you breathe in.',
          ],
          galleryImages: getGallery('assets/images/exercises/Lat Pulldown (Cable).png'),
        ),
        Exercise(name: 'Seated Shoulder Press (Machine)',
          mainImageUrl: 'assets/images/exercises/Seated Shoulder Press (Machine).png',
          videoUrl: 'assets/videos/seated_shoulder_press_machine.mp4',
          instructions: [
            'Sit down and bring your shoulder blades into the back support.',
            'Plant your feet flat on the floor.',
            'Grab the handles to your sides and keep your palms facing forward.',
            'Take a breath and engage your abs.',
            'Press the weight straight up until your arms are fully extended. Breathe out at the top.',
            'Lower the weight to the starting position and breathe in.',
          ],
          galleryImages: getGallery('assets/images/exercises/Seated Shoulder Press (Machine).png'),
        ),
      ];
    }
    
    // Default empty list
    return [];
  }

  static List<WorkoutProgram> get programs => [
    WorkoutProgram(
      title: 'Program Sech 1',
      subtitle: 'Program Sech',
      duration: '6 WEEK',
      imagePath: 'assets/unsplash_sHfo3WOgGTU.png',
      workoutDays: [
        WorkoutDay(
          day: 'DAY 1',
          title: 'LEGS - BICEPS',
          duration: '60 min',
          workoutCount: '8 Workout',
          imagePath: 'assets/legs.png',
          exercises: _getExercisesForDay('LEGS - BICEPS'),
        ),
        WorkoutDay(
          day: 'DAY 2',
          title: 'CHEST - TRICEPS',
          duration: '60 min',
          workoutCount: '8 Workout',
          imagePath: 'assets/Chest.png',
          exercises: _getExercisesForDay('CHEST - TRICEPS'),
        ),
        WorkoutDay(
          day: 'DAY 3',
          title: 'CARDIO',
          duration: '45 min',
          workoutCount: '',
          imagePath: 'assets/abs.png',
          exercises: _getExercisesForDay('CARDIO'),
        ),
        WorkoutDay(
          day: 'DAY 4',
          title: 'UPPER BACK',
          duration: '55 min',
          workoutCount: '7 Workout',
          imagePath: 'assets/Chest.png',
          exercises: _getExercisesForDay('UPPER BACK'),
        ),
        WorkoutDay(
          day: 'DAY 5',
          title: 'SHOULDERS - BICEPS',
          duration: '70 min',
          workoutCount: '10 Workout',
          imagePath: 'assets/legs.png',
          exercises: _getExercisesForDay('SHOULDERS - BICEPS'),
        ),
        WorkoutDay(
          day: 'DAY 6-7',
          title: 'REST DAYS',
          duration: '',
          workoutCount: 'Take a break!',
          imagePath: 'assets/abs.png',
          exercises: _getExercisesForDay('REST DAYS'),
        ),
      ],
    ),
    WorkoutProgram(
      title: 'Program Sech 2',
      subtitle: 'Program Sech',
      duration: '6 WEEK',
      imagePath: 'assets/unsplash_BfQ0Sw7MOgM.png',
      workoutDays: [
        WorkoutDay(
          day: 'DAY 1',
          title: 'UPPER BODY',
          duration: '65 min',
          workoutCount: '9 Workout',
          imagePath: 'assets/Chest.png',
          exercises: _getExercisesForDay('UPPER BODY'),
        ),
        WorkoutDay(
          day: 'DAY 2',
          title: 'LOWER BODY',
          duration: '60 min',
          workoutCount: '8 Workout',
          imagePath: 'assets/legs.png',
          exercises: _getExercisesForDay('LOWER BODY'),
        ),
        WorkoutDay(
          day: 'DAY 3',
          title: 'CARDIO - ABS',
          duration: '45 min',
          workoutCount: '6 Workout',
          imagePath: 'assets/abs.png',
          exercises: _getExercisesForDay('CARDIO - ABS'),
        ),
        WorkoutDay(
          day: 'DAY 4',
          title: 'PUSH DAY',
          duration: '70 min',
          workoutCount: '10 Workout',
          imagePath: 'assets/Chest.png',
          exercises: _getExercisesForDay('PUSH DAY'),
        ),
        WorkoutDay(
          day: 'DAY 5',
          title: 'PULL DAY',
          duration: '70 min',
          workoutCount: '10 Workout',
          imagePath: 'assets/legs.png',
          exercises: _getExercisesForDay('PULL DAY'),
        ),
        WorkoutDay(
          day: 'DAY 6-7',
          title: 'REST DAYS',
          duration: '',
          workoutCount: 'Take a break!',
          imagePath: 'assets/abs.png',
          exercises: _getExercisesForDay('REST DAYS'),
        ),
      ],
    ),
    WorkoutProgram(
      title: 'Program Masse 1',
      subtitle: 'Program Masse',
      duration: '8 WEEK',
      imagePath: 'assets/unsplash_NXMZxygMw8o.png',
      workoutDays: [
        WorkoutDay(
          day: 'DAY 1',
          title: 'CHEST - SHOULDERS',
          duration: '75 min',
          workoutCount: '11 Workout',
          imagePath: 'assets/Chest.png',
          exercises: _getExercisesForDay('CHEST - SHOULDERS'),
        ),
        WorkoutDay(
          day: 'DAY 2',
          title: 'BACK - BICEPS',
          duration: '75 min',
          workoutCount: '11 Workout',
          imagePath: 'assets/legs.png',
          exercises: _getExercisesForDay('BACK - BICEPS'),
        ),
        WorkoutDay(
          day: 'DAY 3',
          title: 'REST DAYS',
          duration: '',
          workoutCount: 'Take a break!',
          imagePath: 'assets/abs.png',
          exercises: _getExercisesForDay('REST DAYS'),
        ),
        WorkoutDay(
          day: 'DAY 4',
          title: 'REST DAY',
          duration: '',
          workoutCount: '',
          imagePath: 'assets/abs.png',
          exercises: _getExercisesForDay('REST DAY'),
        ),
        WorkoutDay(
          day: 'DAY 5',
          title: 'CHEST - TRICEPS',
          duration: '75 min',
          workoutCount: '11 Workout',
          imagePath: 'assets/Chest.png',
          exercises: _getExercisesForDay('CHEST - TRICEPS'),
        ),
        WorkoutDay(
          day: 'DAY 6-7',
          title: 'REST DAYS',
          duration: '',
          workoutCount: 'Take a break!',
          imagePath: 'assets/abs.png',
          exercises: _getExercisesForDay('REST DAYS'),
        ),
      ],
    ),
    WorkoutProgram(
      title: 'Program Masse 2',
      subtitle: 'Program Masse',
      duration: '8 WEEK',
      imagePath: 'assets/unsplash_7JpGeYOPFqg.png',
      workoutDays: [
        WorkoutDay(
          day: 'DAY 1',
          title: 'FULL BODY STRENGTH',
          duration: '90 min',
          workoutCount: '14 Workout',
          imagePath: 'assets/Chest.png',
          exercises: _getExercisesForDay('FULL BODY STRENGTH'),
        ),
        WorkoutDay(
          day: 'DAY 2',
          title: 'UPPER BODY POWER',
          duration: '85 min',
          workoutCount: '13 Workout',
          imagePath: 'assets/Chest.png',
          exercises: _getExercisesForDay('UPPER BODY POWER'),
        ),
        WorkoutDay(
          day: 'DAY 3',
          title: 'REST DAYS',
          duration: '',
          workoutCount: 'Take a break!',
          imagePath: 'assets/abs.png',
          exercises: _getExercisesForDay('REST DAYS'),
        ),
        WorkoutDay(
          day: 'DAY 4',
          title: 'ACTIVE RECOVERY',
          duration: '40 min',
          workoutCount: '5 Workout',
          imagePath: 'assets/abs.png',
          exercises: _getExercisesForDay('ACTIVE RECOVERY'),
        ),
        WorkoutDay(
          day: 'DAY 5',
          title: 'CHEST - BACK',
          duration: '80 min',
          workoutCount: '12 Workout',
          imagePath: 'assets/Chest.png',
          exercises: _getExercisesForDay('CHEST - BACK'),
        ),
        WorkoutDay(
          day: 'DAY 6-7',
          title: 'REST DAYS',
          duration: '',
          workoutCount: 'Take a break!',
          imagePath: 'assets/abs.png',
          exercises: _getExercisesForDay('REST DAYS'),
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // Determine if we are in dark mode to style the app bar correctly
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF1A1A1A) : Colors.white,
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF1A1A1A) : Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.home, 
            color: isDark ? Colors.white : Colors.black,
            size: 28,
          ),
          onPressed: () => context.go('/home'),
        ),
        title: Text(
          'Training Programmes',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.arrow_forward_ios, 
              color: isDark ? Colors.white : Colors.black,
              size: 20,
            ),
             onPressed: () {
               // Logic to go back or forward, currently just pop
               if(context.canPop()) {
                 context.pop();
               } else {
                 context.go('/home');
               }
             }, 
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: programs.length,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          return _buildProgramCard(context, programs[index]);
        },
      ),
    );
  }

  Widget _buildProgramCard(BuildContext context, WorkoutProgram program) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image: AssetImage(program.imagePath),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withValues(alpha:0.4),
            BlendMode.darken,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Gradient Overlay
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha:0.8),
                ],
              ),
            ),
          ),
          
          // Content
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Title centered in the design, but let's stick to the structure
                // Actually design shows Title in middle-ish, but bottom aligned text mostly.
                // Let's replicate the structure in the image.
                
                const Spacer(),
                Center(
                  child: Text(
                    program.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${program.subtitle} | ${program.duration}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        context.go('/workout/details', extra: program);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD5FF5F), // Lime green
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
                      ),
                      child: const Text(
                        'Show Programme',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
}
