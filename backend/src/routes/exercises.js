/**
 * Exercise Routes for accessing exercise library.
 * Provides endpoints for retrieving exercises by various criteria.
 */

const express = require('express');
const { db } = require('../db');

const router = express.Router();

/**
 * Get all exercises from library.
 * @route GET /api/exercises
 * @access Public
 * @returns {Array} List of all exercises with parsed JSON fields
 */
router.get('/', (req, res) => {
    try {
        const exercises = db.prepare('SELECT * FROM exercises').all();

        // Parse JSON fields (gallery_images and instructions are stored as JSON strings)
        const parsedExercises = exercises.map(ex => ({
            ...ex,
            gallery_images: ex.gallery_images ? JSON.parse(ex.gallery_images) : [],
            instructions: ex.instructions ? JSON.parse(ex.instructions) : [],
        }));

        res.json({ success: true, exercises: parsedExercises });
    } catch (error) {
        console.error('Get exercises error:', error);
        res.status(500).json({ success: false, message: 'Internal server error' });
    }
});

/**
 * Get specific exercise by ID.
 * @route GET /api/exercises/:id
 * @access Public
 * @param {string} req.params.id - Exercise ID
 * @returns {Object} Exercise data with parsed JSON fields
 */
router.get('/:id', (req, res) => {
    try {
        const exercise = db.prepare('SELECT * FROM exercises WHERE id = ?').get(req.params.id);
        if (!exercise) {
            return res.status(404).json({ success: false, message: 'Exercise not found' });
        }

        exercise.gallery_images = exercise.gallery_images ? JSON.parse(exercise.gallery_images) : [];
        exercise.instructions = exercise.instructions ? JSON.parse(exercise.instructions) : [];

        res.json({ success: true, exercise });
    } catch (error) {
        console.error('Get exercise error:', error);
        res.status(500).json({ success: false, message: 'Internal server error' });
    }
});

/**
 * Get exercises by category.
 * @route GET /api/exercises/category/:category
 * @access Public
 * @param {string} req.params.category - Exercise category (chest, back, shoulders, arms, legs, abs, cardio)
 * @returns {Array} List of exercises in specified category
 */
router.get('/category/:category', (req, res) => {
    try {
        const exercises = db.prepare('SELECT * FROM exercises WHERE category = ?').all(req.params.category);
        const parsedExercises = exercises.map(ex => ({
            ...ex,
            gallery_images: ex.gallery_images ? JSON.parse(ex.gallery_images) : [],
            instructions: ex.instructions ? JSON.parse(ex.instructions) : [],
        }));
        res.json({ success: true, exercises: parsedExercises });
    } catch (error) {
        console.error('Get exercises by category error:', error);
        res.status(500).json({ success: false, message: 'Internal server error' });
    }
});

/**
 * Search exercises by name or category.
 * @route GET /api/exercises/search/:query
 * @access Public
 * @param {string} req.params.query - Search query
 * @returns {Array} List of exercises matching search criteria
 */
router.get('/search/:query', (req, res) => {
    try {
        const query = `%${req.params.query}%`; // Wildcard search pattern
        const exercises = db.prepare('SELECT * FROM exercises WHERE name LIKE ? OR category LIKE ?').all(query, query);
        const parsedExercises = exercises.map(ex => ({
            ...ex,
            gallery_images: ex.gallery_images ? JSON.parse(ex.gallery_images) : [],
            instructions: ex.instructions ? JSON.parse(ex.instructions) : [],
        }));
        res.json({ success: true, exercises: parsedExercises });
    } catch (error) {
        console.error('Search exercises error:', error);
        res.status(500).json({ success: false, message: 'Internal server error' });
    }
});

module.exports = router;
