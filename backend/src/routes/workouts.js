/**
 * Workout Routes for managing workout plans and logs.
 * Provides endpoints for creating, retrieving, updating, and deleting workout plans and logs.
 */

const express = require('express');
const { z } = require('zod');
const crypto = require('crypto');
const { db } = require('../db');
const authenticateToken = require('../middleware/auth');

const router = express.Router();

// --- WORKOUT PLANS ---

/**
 * Get all workout plans for authenticated user.
 * @route GET /api/workouts/plans
 * @access Protected (requires JWT token)
 * @returns {Array} List of all workout plans in descending order of creation
 */
router.get('/plans', authenticateToken, (req, res) => {
    try {
        const plans = db.prepare('SELECT * FROM workout_plans WHERE user_id = ? ORDER BY created_at DESC').all(req.user.id);

        const parsedPlans = plans.map(p => ({
            ...p,
            plan_data: p.plan_data ? JSON.parse(p.plan_data) : null,
        }));

        res.json({ success: true, plans: parsedPlans });
    } catch (error) {
        console.error('Get plans error:', error);
        res.status(500).json({ success: false, message: 'Internal server error' });
    }
});

/**
 * Get current active workout plan (latest created).
 * @route GET /api/workouts/plans/current
 * @access Protected (requires JWT token)
 * @returns {Object} Current workout plan or null if no plan exists
 */
router.get('/plans/current', authenticateToken, (req, res) => {
    try {
        const plan = db.prepare('SELECT * FROM workout_plans WHERE user_id = ? ORDER BY created_at DESC LIMIT 1').get(req.user.id);
        if (!plan) {
            return res.json({ success: true, workoutPlan: null }); // Return null if no plan
        }
        plan.plan_data = plan.plan_data ? JSON.parse(plan.plan_data) : null;
        res.json({ success: true, workoutPlan: plan });
    } catch (error) {
        console.error('Get current plan error:', error);
        res.status(500).json({ success: false, message: 'Internal server error' });
    }
});

/**
 * Create a new workout plan.
 * @route POST /api/workouts/plans
 * @access Protected (requires JWT token)
 * @param {string} req.body.plan_type - Type of workout plan (e.g., 'beginner', 'advanced')
 * @param {Object} req.body.plan_data - Plan configuration data (JSON object)
 * @param {string} req.body.start_date - Start date of the plan
 * @returns {Object} Created plan ID and success message
 */
router.post('/plans', authenticateToken, (req, res) => {
    try {
        const schema = z.object({
            plan_type: z.string(),
            plan_data: z.any(), // JSON object containing plan details
            start_date: z.string(),
        });

        const parsed = schema.safeParse(req.body);
        if (!parsed.success) {
            return res.status(400).json({ success: false, message: 'Invalid request' });
        }

        const { plan_type, plan_data, start_date } = parsed.data;
        const now = Date.now();
        const id = crypto.randomUUID();

        db.prepare(`
      INSERT INTO workout_plans (id, user_id, plan_type, plan_data, start_date, created_at)
      VALUES (?, ?, ?, ?, ?, ?)
    `).run(id, req.user.id, plan_type, JSON.stringify(plan_data), start_date, now);

        res.status(201).json({ success: true, id, message: 'Plan created' });
    } catch (error) {
        console.error('Create plan error:', error);
        res.status(500).json({ success: false, message: 'Internal server error' });
    }
});

/**
 * Get specific workout plan by ID.
 * @route GET /api/workouts/plans/:id
 * @access Protected (requires JWT token)
 * @param {string} req.params.id - Plan ID
 * @returns {Object} Workout plan details
 */
router.get('/plans/:id', authenticateToken, (req, res) => {
    try {
        const plan = db.prepare('SELECT * FROM workout_plans WHERE id = ? AND user_id = ?').get(req.params.id, req.user.id);
        if (!plan) {
            return res.status(404).json({ success: false, message: 'Plan not found' });
        }
        plan.plan_data = plan.plan_data ? JSON.parse(plan.plan_data) : null;
        res.json({ success: true, workoutPlan: plan });
    } catch (error) {
        console.error('Get plan error:', error);
        res.status(500).json({ success: false, message: 'Internal server error' });
    }
});

/**
 * Update workout plan by ID.
 * @route PATCH /api/workouts/plans/:id
 * @access Protected (requires JWT token)
 * @param {string} req.params.id - Plan ID
 * @param {string} req.body.plan_type - Type of workout plan (optional)
 * @param {Object} req.body.plan_data - Plan configuration data (optional)
 * @param {string} req.body.start_date - Start date of the plan (optional)
 * @returns {Object} Updated workout plan details
 */
router.patch('/plans/:id', authenticateToken, (req, res) => {
    try {
        const schema = z.object({
            plan_type: z.string().optional(),
            plan_data: z.any().optional(),
            start_date: z.string().optional(),
        });

        const parsed = schema.safeParse(req.body);
        if (!parsed.success) {
            return res.status(400).json({ success: false, message: 'Invalid request' });
        }

        const { plan_type, plan_data, start_date } = parsed.data;
        const fields = [];
        const values = [];

        // Build dynamic update query
        if (plan_type !== undefined) { fields.push('plan_type = ?'); values.push(plan_type); }
        if (plan_data !== undefined) { fields.push('plan_data = ?'); values.push(JSON.stringify(plan_data)); }
        if (start_date !== undefined) { fields.push('start_date = ?'); values.push(start_date); }

        if (fields.length > 0) {
            values.push(req.params.id, req.user.id);
            const result = db.prepare(`UPDATE workout_plans SET ${fields.join(', ')} WHERE id = ? AND user_id = ?`).run(...values);
            if (result.changes === 0) {
                return res.status(404).json({ success: false, message: 'Plan not found' });
            }
        }

        const updated = db.prepare('SELECT * FROM workout_plans WHERE id = ?').get(req.params.id);
        updated.plan_data = updated.plan_data ? JSON.parse(updated.plan_data) : null;
        res.json({ success: true, workoutPlan: updated });
    } catch (error) {
        console.error('Update plan error:', error);
        res.status(500).json({ success: false, message: 'Internal server error' });
    }
});

/**
 * Delete workout plan by ID.
 * @route DELETE /api/workouts/plans/:id
 * @access Protected (requires JWT token)
 * @param {string} req.params.id - Plan ID
 * @returns {Object} Success message
 */
router.delete('/plans/:id', authenticateToken, (req, res) => {
    try {
        const result = db.prepare('DELETE FROM workout_plans WHERE id = ? AND user_id = ?').run(req.params.id, req.user.id);
        if (result.changes === 0) {
            return res.status(404).json({ success: false, message: 'Plan not found' });
        }
        res.json({ success: true, message: 'Plan deleted' });
    } catch (error) {
        console.error('Delete plan error:', error);
        res.status(500).json({ success: false, message: 'Internal server error' });
    }
});

/**
 * Mark plan configuration or workout as complete.
 * This is a placeholder endpoint - exact logic depends on plan_data structure.
 * @route POST /api/workouts/plans/:id/mark-complete
 * @access Protected (requires JWT token)
 * @param {string} req.params.id - Plan ID
 * @returns {Object} Updated workout plan details
 */
router.post('/plans/:id/mark-complete', authenticateToken, (req, res) => {
    try {
        const plan = db.prepare('SELECT * FROM workout_plans WHERE id = ? AND user_id = ?').get(req.params.id, req.user.id);
        if (!plan) {
            return res.status(404).json({ success: false, message: 'Plan not found' });
        }
        plan.plan_data = plan.plan_data ? JSON.parse(plan.plan_data) : null;
        res.json({ success: true, workoutPlan: plan });
    } catch (error) {
        res.status(500).json({ success: false, message: 'Internal server error' });
    }
});

// --- WORKOUT LOGS ---

/**
 * Get all workout logs for authenticated user.
 * @route GET /api/workouts/logs
 * @access Protected (requires JWT token)
 * @returns {Array} List of all workout logs in descending order of date
 */
router.get('/logs', authenticateToken, (req, res) => {
    try {
        const logs = db.prepare('SELECT * FROM workout_logs WHERE user_id = ? ORDER BY date DESC').all(req.user.id);

        const parsedLogs = logs.map(l => ({
            ...l,
            exercises: l.exercises ? JSON.parse(l.exercises) : [],
        }));

        res.json({ success: true, workoutLogs: parsedLogs });
    } catch (error) {
        console.error('Get workout logs error:', error);
        res.status(500).json({ success: false, message: 'Internal server error' });
    }
});

/**
 * Create a new workout log.
 * @route POST /api/workouts/logs
 * @access Protected (requires JWT token)
 * @param {string} req.body.date - Date of the workout
 * @param {Array} req.body.exercises - Array of exercises performed
 * @param {string} req.body.notes - Additional notes (optional)
 * @returns {Object} Created log ID and success message
 */
router.post('/logs', authenticateToken, (req, res) => {
    try {
        const schema = z.object({
            date: z.string(),
            exercises: z.array(z.any()), // Array of exercise data with sets/reps
            notes: z.string().optional(),
        });

        const parsed = schema.safeParse(req.body);
        if (!parsed.success) {
            return res.status(400).json({ success: false, message: 'Invalid request' });
        }

        const { date, exercises, notes } = parsed.data;
        const now = Date.now();
        const id = crypto.randomUUID();

        db.prepare(`
      INSERT INTO workout_logs (id, user_id, date, exercises, notes, created_at)
      VALUES (?, ?, ?, ?, ?, ?)
    `).run(id, req.user.id, date, JSON.stringify(exercises), notes || null, now);

        res.status(201).json({ success: true, id, message: 'Workout logged' });
    } catch (error) {
        console.error('Log workout error:', error);
        res.status(500).json({ success: false, message: 'Internal server error' });
    }
});

/**
 * Get specific workout log by ID.
 * @route GET /api/workouts/logs/:id
 * @access Protected (requires JWT token)
 * @param {string} req.params.id - Log ID
 * @returns {Object} Workout log details
 */
router.get('/logs/:id', authenticateToken, (req, res) => {
    try {
        const log = db.prepare('SELECT * FROM workout_logs WHERE id = ? AND user_id = ?').get(req.params.id, req.user.id);
        if (!log) {
            return res.status(404).json({ success: false, message: 'Log not found' });
        }
        log.exercises = log.exercises ? JSON.parse(log.exercises) : [];
        res.json({ success: true, workoutLog: log });
    } catch (error) {
        console.error('Get log error:', error);
        res.status(500).json({ success: false, message: 'Internal server error' });
    }
});

/**
 * Get workout log by specific date.
 * @route GET /api/workouts/logs/date/:date
 * @access Protected (requires JWT token)
 * @param {string} req.params.date - Date string
 * @returns {Object} Workout log for specified date
 */
router.get('/logs/date/:date', authenticateToken, (req, res) => {
    try {
        const log = db.prepare('SELECT * FROM workout_logs WHERE date = ? AND user_id = ?').get(req.params.date, req.user.id);
        if (!log) {
            return res.status(404).json({ success: false, message: 'Log not found' });
        }
        log.exercises = log.exercises ? JSON.parse(log.exercises) : [];
        res.json({ success: true, workoutLog: log });
    } catch (error) {
        console.error('Get log by date error:', error);
        res.status(500).json({ success: false, message: 'Internal server error' });
    }
});

/**
 * Update workout log by ID.
 * @route PATCH /api/workouts/logs/:id
 * @access Protected (requires JWT token)
 * @param {string} req.params.id - Log ID
 * @param {string} req.body.date - Date of the workout (optional)
 * @param {Array} req.body.exercises - Array of exercises performed (optional)
 * @param {string} req.body.notes - Additional notes (optional)
 * @returns {Object} Updated workout log details
 */
router.patch('/logs/:id', authenticateToken, (req, res) => {
    try {
        const schema = z.object({
            date: z.string().optional(),
            exercises: z.array(z.any()).optional(),
            notes: z.string().optional(),
        });

        const parsed = schema.safeParse(req.body);
        if (!parsed.success) {
            return res.status(400).json({ success: false, message: 'Invalid request' });
        }

        const { date, exercises, notes } = parsed.data;
        const fields = [];
        const values = [];

        // Build dynamic update query
        if (date !== undefined) { fields.push('date = ?'); values.push(date); }
        if (exercises !== undefined) { fields.push('exercises = ?'); values.push(JSON.stringify(exercises)); }
        if (notes !== undefined) { fields.push('notes = ?'); values.push(notes); }

        if (fields.length > 0) {
            values.push(req.params.id, req.user.id);
            const result = db.prepare(`UPDATE workout_logs SET ${fields.join(', ')} WHERE id = ? AND user_id = ?`).run(...values);
            if (result.changes === 0) {
                return res.status(404).json({ success: false, message: 'Log not found' });
            }
        }

        const updated = db.prepare('SELECT * FROM workout_logs WHERE id = ?').get(req.params.id);
        updated.exercises = updated.exercises ? JSON.parse(updated.exercises) : [];
        res.json({ success: true, workoutLog: updated });
    } catch (error) {
        console.error('Update log error:', error);
        res.status(500).json({ success: false, message: 'Internal server error' });
    }
});

/**
 * Delete workout log by ID.
 * @route DELETE /api/workouts/logs/:id
 * @access Protected (requires JWT token)
 * @param {string} req.params.id - Log ID
 * @returns {Object} Success message
 */
router.delete('/logs/:id', authenticateToken, (req, res) => {
    try {
        const result = db.prepare('DELETE FROM workout_logs WHERE id = ? AND user_id = ?').run(req.params.id, req.user.id);
        if (result.changes === 0) {
            return res.status(404).json({ success: false, message: 'Log not found' });
        }
        res.json({ success: true, message: 'Log deleted' });
    } catch (error) {
        console.error('Delete log error:', error);
        res.status(500).json({ success: false, message: 'Internal server error' });
    }
});

module.exports = router;
