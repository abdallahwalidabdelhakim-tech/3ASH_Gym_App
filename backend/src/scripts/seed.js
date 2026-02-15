/**
 * Seed script for initializing the exercise database.
 * Populates the exercises table with predefined exercise data and media files.
 */

const path = require('path');
const fs = require('fs');
const crypto = require('crypto');
const { db, initDb } = require('../db');

// Exercise categories based on common gym exercise types
const CATEGORIES = [
    'chest',
    'back',
    'shoulders',
    'arms',
    'legs',
    'abs',
    'cardio'
];

// Base exercise data - predefined exercises with optional main image URLs
const BASE_EXERCISES = [
    { name: 'Bench Press', category: 'chest', mainImageUrl: 'assets/images/exercises/Bench Press (Machine).png' },
    { name: 'Incline Chest Press', category: 'chest', mainImageUrl: 'assets/images/exercises/Incline Chest Press (Machine).png' },
    { name: 'Chest Fly', category: 'chest', mainImageUrl: 'assets/images/exercises/Chest Fly (Machine).png' },
    { name: 'Butterfly', category: 'chest', mainImageUrl: 'assets/images/exercises/Butterfly (Pec Deck).png' },
    { name: 'Push-ups', category: 'chest' },
    { name: 'Lat Pulldown', category: 'back', mainImageUrl: 'assets/images/exercises/Lat Pulldown (Machine).png' },
    { name: 'Seated Row', category: 'back', mainImageUrl: 'assets/images/exercises/Iso-Lateral High Row (Machine).png' },
    { name: 'Deadlift', category: 'back', mainImageUrl: 'assets/images/exercises/Deadlift (Smith Machine).png' },
    { name: 'Bent Over Row', category: 'back' },
    { name: 'Shoulder Press', category: 'shoulders', mainImageUrl: 'assets/images/exercises/Shoulder Press (Machine Plates).png' },
    { name: 'Lateral Raise', category: 'shoulders', mainImageUrl: 'assets/images/exercises/Lateral Raise (Machine).png' },
    { name: 'Front Raise', category: 'shoulders', mainImageUrl: 'assets/images/exercises/Front Raise (Cable).png' },
    { name: 'Rear Delt Fly', category: 'shoulders', mainImageUrl: 'assets/images/exercises/Rear Delt Reverse Fly (Machine).png' },
    { name: 'Bicep Curl', category: 'arms', mainImageUrl: 'assets/images/exercises/Bicep Curl (Machine).png' },
    { name: 'Preacher Curl', category: 'arms', mainImageUrl: 'assets/images/exercises/Preacher Curl (Machine).png' },
    { name: 'Hammer Curl', category: 'arms' },
    { name: 'Cable Curl', category: 'arms', mainImageUrl: 'assets/images/exercises/Rope Cable Curl.png' },
    { name: 'Triceps Pressdown', category: 'arms', mainImageUrl: 'assets/images/exercises/Triceps Pressdown.png' },
    { name: 'Overhead Triceps Extension', category: 'arms', mainImageUrl: 'assets/images/exercises/Overhead Triceps Extension (Cable).png' },
    { name: 'Triceps Dip', category: 'arms', mainImageUrl: 'assets/images/exercises/Triceps Dip (Assisted).png' },
    { name: 'Squat', category: 'legs', mainImageUrl: 'assets/images/exercises/Squat (Smith Machine).png' },
    { name: 'Leg Press', category: 'legs', mainImageUrl: 'assets/images/exercises/Leg Press (Machine).png' },
    { name: 'Leg Extension', category: 'legs', mainImageUrl: 'assets/images/exercises/Leg Extension (Machine).png' },
    { name: 'Leg Curl', category: 'legs', mainImageUrl: 'assets/images/exercises/Lying Leg Curl (Machine).png' },
    { name: 'Calf Raise', category: 'legs', mainImageUrl: 'assets/images/exercises/Calf Raise (Machine).png' },
    { name: 'Crunches', category: 'abs', mainImageUrl: 'assets/images/exercises/Crunch (Machine).png' },
    { name: 'Plank', category: 'abs' },
    { name: 'Russian Twist', category: 'abs' },
    { name: 'Bicycle Crunch', category: 'abs' },
    { name: 'Running', category: 'cardio', mainImageUrl: 'assets/images/exercises/treadmill.png' },
    { name: 'Cycling', category: 'cardio', mainImageUrl: 'assets/images/exercises/Spinning.png' },
    { name: 'Jump Rope', category: 'cardio' },
    { name: 'Stepmill', category: 'cardio', mainImageUrl: 'assets/images/exercises/Walking on Stepmill.png' }
];

/**
 * Generates standard exercise instructions based on exercise name.
 * @param {string} exerciseName - Name of the exercise
 * @returns {Array} Array of exercise instructions
 */
function generateInstructions(exerciseName) {
    return [
        'Warm up properly before starting',
        `Maintain proper form throughout the ${exerciseName}`,
        'Breathe in during the eccentric phase',
        'Breathe out during the concentric phase',
        'Control the movement - don\'t use momentum',
        'Keep your core engaged',
        'Adjust weight if needed to maintain proper form',
        'Stop if you feel pain beyond normal muscle fatigue',
        'Cool down and stretch after completing'
    ];
}

/**
 * Retrieves available image and video files from assets directory.
 * @returns {Object} Object containing arrays of image and video file paths
 */
function getAvailableFiles() {
    // Go up 3 levels from src/scripts to backend root, then up to project root, then to assets
    const projectRoot = path.join(__dirname, '../../../');
    const imagesDir = path.join(projectRoot, 'assets', 'images', 'exercises');
    const videosDir = path.join(projectRoot, 'assets', 'videos');

    const imageFiles = [];
    const videoFiles = [];

    if (fs.existsSync(imagesDir)) {
        const files = fs.readdirSync(imagesDir);
        imageFiles.push(...files.filter(file => file.toLowerCase().endsWith('.png') || file.toLowerCase().endsWith('.jpg')));
    }

    if (fs.existsSync(videosDir)) {
        const files = fs.readdirSync(videosDir);
        videoFiles.push(...files.filter(file => file.toLowerCase().endsWith('.mp4')));
    }

    return { imageFiles, videoFiles };
}

/**
 * Finds matching video file for an exercise.
 * @param {string} exerciseName - Exercise name to match
 * @param {Array} videoFiles - Available video files
 * @returns {string|null} Path to matching video file or null if not found
 */
function findMatchingVideo(exerciseName, videoFiles) {
    const normalizedName = exerciseName.toLowerCase().replace(/[^\w\s]/g, '').replace(/\s+/g, '_');
    const videoFile = videoFiles.find(file =>
        file.toLowerCase().includes(normalizedName) ||
        normalizedName.includes(file.toLowerCase().replace('.mp4', ''))
    );

    return videoFile ? `assets/videos/${videoFile}` : null;
}

/**
 * Seeds the exercises table with predefined exercise data.
 * Skips seeding if exercises already exist in the database.
 */
function seedExercises() {
    const { imageFiles, videoFiles } = getAvailableFiles();
    const now = Date.now();

    // Check if exercises table already has data
    const existing = db.prepare('SELECT COUNT(*) as count FROM exercises').get().count;
    if (existing > 0) {
        console.log(`Found ${existing} existing exercises - skipping seeding`);
        return;
    }

    console.log('Seeding exercises...');

    const insert = db.prepare(`
    INSERT INTO exercises (
      id, name, main_image_url, video_url, gallery_images, instructions, category, created_at
    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?)
  `);

    // Use transaction for atomic operation
    const update = db.transaction((exercises) => {
        for (const baseExercise of exercises) {
            const id = crypto.randomUUID();

            let videoUrl = null;
            if (baseExercise.category !== 'cardio') {
                videoUrl = findMatchingVideo(baseExercise.name, videoFiles);
            }

            const instructions = generateInstructions(baseExercise.name);

            // Find matching gallery images for exercise
            const galleryImages = [];
            const normalizedName = baseExercise.name.toLowerCase().replace(/\s+/g, '');
            for (const imageFile of imageFiles) {
                const fileName = path.basename(imageFile).toLowerCase().replace(/\s+/g, '');
                if (fileName.includes(normalizedName)) {
                    galleryImages.push(`assets/images/exercises/${imageFile}`);
                }
            }

            // Remove main image from gallery if it exists
            if (baseExercise.mainImageUrl && galleryImages.includes(baseExercise.mainImageUrl)) {
                galleryImages.splice(galleryImages.indexOf(baseExercise.mainImageUrl), 1);
            }

            // Insert exercise into database
            insert.run(
                id,
                baseExercise.name,
                baseExercise.mainImageUrl || null,
                videoUrl,
                JSON.stringify(galleryImages),
                JSON.stringify(instructions),
                baseExercise.category,
                now
            );
        }
    });

    update(BASE_EXERCISES);
    console.log(`Successfully seeded ${BASE_EXERCISES.length} exercises`);
}

// Run if called directly from CLI
if (require.main === module) {
    initDb();
    seedExercises();
}

// Export for use in other modules
module.exports = { seedExercises };
