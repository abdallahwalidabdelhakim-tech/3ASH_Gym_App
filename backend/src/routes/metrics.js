/**
 * Metrics Routes for tracking body measurements and health metrics.
 * Provides endpoints for logging, retrieving, updating, and deleting body measurement data.
 */

const express = require('express');
const { z } = require('zod');
const crypto = require('crypto');
const { db } = require('../db');
const authenticateToken = require('../middleware/auth');

const router = express.Router();

/**
 * Get all body measurement history for authenticated user.
 * @route GET /api/metrics/history
 * @access Protected (requires JWT token)
 * @returns {Array} List of all body measurement logs in descending date order
 */
router.get('/history', authenticateToken, (req, res) => {
    try {
        const logs = db.prepare('SELECT * FROM body_logs WHERE user_id = ? ORDER BY date DESC').all(req.user.id);
        res.json({ success: true, bodyLogs: logs });
    } catch (error) {
        console.error('Get metrics history error:', error);
        res.status(500).json({ success: false, message: 'Internal server error' });
    }
});

/**
 * Get body measurement log by specific date.
 * @route GET /api/metrics/history/date/:date
 * @access Protected (requires JWT token)
 * @param {string} req.params.date - ISO date string
 * @returns {Object} Body measurement log for specified date
 */
router.get('/history/date/:date', authenticateToken, (req, res) => {
    try {
        const log = db.prepare('SELECT * FROM body_logs WHERE date = ? AND user_id = ?').get(req.params.date, req.user.id);
        if (!log) {
            return res.status(404).json({ success: false, message: 'Log not found' });
        }
        res.json({ success: true, bodyLog: log });
    } catch (error) {
        console.error('Get body log by date error:', error);
        res.status(500).json({ success: false, message: 'Internal server error' });
    }
});

/**
 * Get body measurement log by ID.
 * @route GET /api/metrics/history/:id
 * @access Protected (requires JWT token)
 * @param {string} req.params.id - Log ID
 * @returns {Object} Body measurement log with specified ID
 */
router.get('/history/:id', authenticateToken, (req, res) => {
    try {
        const log = db.prepare('SELECT * FROM body_logs WHERE id = ? AND user_id = ?').get(req.params.id, req.user.id);
        if (!log) {
            return res.status(404).json({ success: false, message: 'Log not found' });
        }
        res.json({ success: true, bodyLog: log });
    } catch (error) {
        console.error('Get body log error:', error);
        res.status(500).json({ success: false, message: 'Internal server error' });
    }
});

/**
 * Update body measurement log by ID.
 * @route PATCH /api/metrics/history/:id
 * @access Protected (requires JWT token)
 * @param {string} req.params.id - Log ID
 * @param {string} req.body.date - ISO date string (optional)
 * @param {number} req.body.weight - Weight in kg (optional)
 * @param {number} req.body.chest - Chest circumference in cm (optional)
 * @param {number} req.body.waist - Waist circumference in cm (optional)
 * @param {number} req.body.hips - Hips circumference in cm (optional)
 * @param {number} req.body.arms - Arm circumference in cm (optional)
 * @param {number} req.body.thighs - Thigh circumference in cm (optional)
 * @returns {Object} Updated body measurement log
 */
router.patch('/history/:id', authenticateToken, (req, res) => {
    try {
        // Input validation schema
        const schema = z.object({
            date: z.string().optional(),
            weight: z.number().optional(),
            chest: z.number().optional(),
            waist: z.number().optional(),
            hips: z.number().optional(),
            arms: z.number().optional(),
            thighs: z.number().optional(),
        });

        const parsed = schema.safeParse(req.body);
        if (!parsed.success) {
            return res.status(400).json({ success: false, message: 'Invalid request' });
        }

        const { date, weight, chest, waist, hips, arms, thighs } = parsed.data;
        const fields = [];
        const values = [];

        // Build dynamic update query
        if (date !== undefined) { fields.push('date = ?'); values.push(date); }
        if (weight !== undefined) { fields.push('weight = ?'); values.push(weight); }
        if (chest !== undefined) { fields.push('chest = ?'); values.push(chest); }
        if (waist !== undefined) { fields.push('waist = ?'); values.push(waist); }
        if (hips !== undefined) { fields.push('hips = ?'); values.push(hips); }
        if (arms !== undefined) { fields.push('arms = ?'); values.push(arms); }
        if (thighs !== undefined) { fields.push('thighs = ?'); values.push(thighs); }

        if (fields.length > 0) {
            values.push(req.params.id, req.user.id);
            const result = db.prepare(`UPDATE body_logs SET ${fields.join(', ')} WHERE id = ? AND user_id = ?`).run(...values);
            if (result.changes === 0) {
                return res.status(404).json({ success: false, message: 'Log not found' });
            }
        }

        // Update current weight in user_onboarding if weight is updated
        if (weight !== undefined) {
            const now = Date.now();
            const existingOnboarding = db.prepare('SELECT user_id FROM user_onboarding WHERE user_id = ?').get(req.user.id);
            if (existingOnboarding) {
                db.prepare('UPDATE user_onboarding SET weight = ?, updated_at = ? WHERE user_id = ?').run(weight, now, req.user.id);
            }
        }

        const updated = db.prepare('SELECT * FROM body_logs WHERE id = ?').get(req.params.id);
        res.json({ success: true, bodyLog: updated });
    } catch (error) {
        console.error('Update body log error:', error);
        res.status(500).json({ success: false, message: 'Internal server error' });
    }
});

/**
 * Delete body measurement log by ID.
 * @route DELETE /api/metrics/history/:id
 * @access Protected (requires JWT token)
 * @param {string} req.params.id - Log ID
 * @returns {Object} Success message
 */
router.delete('/history/:id', authenticateToken, (req, res) => {
    try {
        const result = db.prepare('DELETE FROM body_logs WHERE id = ? AND user_id = ?').run(req.params.id, req.user.id);
        if (result.changes === 0) {
            return res.status(404).json({ success: false, message: 'Log not found' });
        }
        res.json({ success: true, message: 'Log deleted' });
    } catch (error) {
        console.error('Delete body log error:', error);
        res.status(500).json({ success: false, message: 'Internal server error' });
    }
});

/**
 * Log new body measurements or update existing log.
 * @route POST /api/metrics/weight
 * @access Protected (requires JWT token)
 * @param {string} req.body.date - ISO date string (required)
 * @param {number} req.body.weight - Weight in kg (optional)
 * @param {number} req.body.chest - Chest circumference in cm (optional)
 * @param {number} req.body.waist - Waist circumference in cm (optional)
 * @param {number} req.body.hips - Hips circumference in cm (optional)
 * @param {number} req.body.arms - Arm circumference in cm (optional)
 * @param {number} req.body.thighs - Thigh circumference in cm (optional)
 * @returns {Object} Saved body measurement log
 */
router.post('/weight', authenticateToken, (req, res) => {
    try {
        const schema = z.object({
            date: z.string(), // ISO date string
            weight: z.number().optional(),
            chest: z.number().optional(),
            waist: z.number().optional(),
            hips: z.number().optional(),
            arms: z.number().optional(),
            thighs: z.number().optional(),
        });

        const parsed = schema.safeParse(req.body);
        if (!parsed.success) {
            return res.status(400).json({ 
                success: false, 
                message: 'Invalid request', 
                errors: parsed.error.flatten() 
            });
        }

        const { date, weight, chest, waist, hips, arms, thighs } = parsed.data;
        const now = Date.now();

        // Check if log already exists for this date
        const existing = db.prepare('SELECT id FROM body_logs WHERE user_id = ? AND date = ?').get(req.user.id, date);

        if (existing) {
            // Update existing log
            const fields = [];
            const values = [];

            if (weight !== undefined) { fields.push('weight = ?'); values.push(weight); }
            if (chest !== undefined) { fields.push('chest = ?'); values.push(chest); }
            if (waist !== undefined) { fields.push('waist = ?'); values.push(waist); }
            if (hips !== undefined) { fields.push('hips = ?'); values.push(hips); }
            if (arms !== undefined) { fields.push('arms = ?'); values.push(arms); }
            if (thighs !== undefined) { fields.push('thighs = ?'); values.push(thighs); }

            if (fields.length > 0) {
                values.push(existing.id);
                db.prepare(`UPDATE body_logs SET ${fields.join(', ')} WHERE id = ?`).run(...values);
            }
        } else {
            // Insert new log
            const id = crypto.randomUUID();
            db.prepare(`
        INSERT INTO body_logs (id, user_id, date, weight, chest, waist, hips, arms, thighs, created_at)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
      `).run(
                id,
                req.user.id,
                date,
                weight || null,
                chest || null,
                waist || null,
                hips || null,
                arms || null,
                thighs || null,
                now
            );
        }

        // Update current weight in user_onboarding if provided
        if (weight !== undefined) {
            const existingOnboarding = db.prepare('SELECT user_id FROM user_onboarding WHERE user_id = ?').get(req.user.id);
            if (existingOnboarding) {
                db.prepare('UPDATE user_onboarding SET weight = ?, updated_at = ? WHERE user_id = ?').run(weight, now, req.user.id);
            }
        }

        const updatedLog = db.prepare('SELECT * FROM body_logs WHERE date = ? AND user_id = ?').get(date, req.user.id);
        res.json({ success: true, message: 'Measurements logged', bodyLog: updatedLog });
    } catch (error) {
        console.error('Log metrics error:', error);
        res.status(500).json({ success: false, message: 'Internal server error' });
    }
});

module.exports = router;
