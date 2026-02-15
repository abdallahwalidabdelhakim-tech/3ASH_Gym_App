/**
 * User Routes for managing user profiles and onboarding.
 * Provides endpoints for retrieving, updating user data and storing onboarding information.
 */

const express = require('express');
const { z } = require('zod');
const { db } = require('../db');
const authenticateToken = require('../middleware/auth');

const router = express.Router();

/**
 * Builds user response object from database row.
 * @param {Object} row - Database user record
 * @returns {Object} Formatted user response with safe fields
 */
function buildUserResponse(row) {
    return {
        id: row.id,
        username: row.username,
        email: row.email,
        country: row.country || null,
        phone_number: row.phone_number || null,
        date_of_birth: row.date_of_birth || null,
        created_at: row.created_at,
    };
}

/**
 * Get current user profile.
 * @route GET /api/users/me
 * @access Protected (requires JWT token)
 * @returns {Object} User profile data with onboarding information
 */
router.get('/me', authenticateToken, (req, res) => {
    try {
        const userRow = db.prepare('SELECT * FROM users WHERE id = ?').get(req.user.id);
        if (!userRow) {
            return res.status(404).json({ success: false, message: 'User not found' });
        }

        const onboarding = db.prepare('SELECT * FROM user_onboarding WHERE user_id = ?').get(req.user.id);

        const userData = buildUserResponse(userRow);
        if (onboarding) {
            userData.onboarding = onboarding;
        }

        res.json({ success: true, user: userData });
    } catch (error) {
        console.error('Get profile error:', error);
        res.status(500).json({ success: false, message: 'Internal server error' });
    }
});

/**
 * Update current user profile.
 * @route PUT /api/users/me
 * @access Protected (requires JWT token)
 * @param {string} req.body.username - New username (optional, must be unique)
 * @param {string} req.body.country - Country (optional)
 * @param {string} req.body.phone_number - Phone number (optional)
 * @param {string} req.body.date_of_birth - Date of birth (optional)
 * @returns {Object} Updated user profile
 */
router.put('/me', authenticateToken, (req, res) => {
    try {
        // Input validation schema
        const schema = z.object({
            username: z.string().min(1).optional(),
            country: z.string().optional(),
            phone_number: z.string().optional(),
            phoneNumber: z.string().optional(),
            date_of_birth: z.string().optional(),
            dateOfBirth: z.string().optional(),
        });

        const parsed = schema.safeParse(req.body);
        if (!parsed.success) {
            return res.status(400).json({ 
                success: false, 
                message: 'Invalid request', 
                errors: parsed.error.flatten() 
            });
        }

        const { username, country } = parsed.data;
        const phoneNumber = parsed.data.phone_number || parsed.data.phoneNumber;
        const dateOfBirth = parsed.data.date_of_birth || parsed.data.dateOfBirth;

        // Check username uniqueness if changing
        if (username) {
            const existing = db.prepare('SELECT id FROM users WHERE username = ? AND id != ?').get(username, req.user.id);
            if (existing) {
                return res.status(409).json({ success: false, message: 'Username taken' });
            }
        }

        // Build dynamic update query
        const fields = [];
        const values = [];

        if (username !== undefined) { fields.push('username = ?'); values.push(username); }
        if (country !== undefined) { fields.push('country = ?'); values.push(country); }
        if (phoneNumber !== undefined) { fields.push('phone_number = ?'); values.push(phoneNumber); }
        if (dateOfBirth !== undefined) { fields.push('date_of_birth = ?'); values.push(dateOfBirth); }

        if (fields.length > 0) {
            values.push(req.user.id);
            db.prepare(`UPDATE users SET ${fields.join(', ')} WHERE id = ?`).run(...values);
        }

        const updatedUser = db.prepare('SELECT * FROM users WHERE id = ?').get(req.user.id);
        res.json({ success: true, user: buildUserResponse(updatedUser) });
    } catch (error) {
        console.error('Update profile error:', error);
        res.status(500).json({ success: false, message: 'Internal server error' });
    }
});

/**
 * Save or update user onboarding data.
 * @route POST /api/users/onboarding
 * @access Protected (requires JWT token)
 * @param {string} req.body.goal - Fitness goal (optional)
 * @param {string} req.body.activity_level - Activity level (optional)
 * @param {string} req.body.sex - Gender (optional)
 * @param {string} req.body.date_of_birth - Date of birth (optional)
 * @param {number} req.body.age - Age (optional)
 * @param {number} req.body.height - Height in cm (optional)
 * @param {number} req.body.weight - Current weight in kg (optional)
 * @param {number} req.body.target_weight - Target weight in kg (optional)
 * @param {string} req.body.objective - Fitness objective (optional)
 * @param {number} req.body.target_calories - Daily calorie target (optional)
 * @returns {Object} Success message
 */
router.post('/onboarding', authenticateToken, (req, res) => {
    try {
        // Input validation schema - adjust based on frontend needs
        const schema = z.object({
            goal: z.string().optional(),
            activity_level: z.string().optional(),
            sex: z.string().optional(),
            date_of_birth: z.string().optional(),
            age: z.number().optional(),
            height: z.number().optional(),
            weight: z.number().optional(),
            target_weight: z.number().optional(),
            objective: z.string().optional(),
            target_calories: z.number().optional(),
        });

        const parsed = schema.safeParse(req.body);
        if (!parsed.success) {
            return res.status(400).json({ 
                success: false, 
                message: 'Invalid request', 
                errors: parsed.error.flatten() 
            });
        }

        const data = parsed.data;
        const now = Date.now();

        const existing = db.prepare('SELECT user_id FROM user_onboarding WHERE user_id = ?').get(req.user.id);

        if (existing) {
            // Update existing onboarding data
            const fields = Object.keys(data).map(k => `${k} = ?`).join(', ');
            const values = Object.values(data);
            values.push(now, req.user.id);

            db.prepare(`UPDATE user_onboarding SET ${fields}, updated_at = ? WHERE user_id = ?`).run(...values);
        } else {
            // Insert new onboarding data
            const keys = Object.keys(data);
            const placeholders = keys.map(() => '?').join(', ');
            const values = Object.values(data);
            values.push(now); // updated_at

            db.prepare(
                `INSERT INTO user_onboarding (user_id, ${keys.join(', ')}, updated_at) VALUES (?, ${placeholders}, ?)`
            ).run(req.user.id, ...values);
        }

        res.json({ success: true, message: 'Onboarding data saved' });
    } catch (error) {
        console.error('Onboarding error:', error);
        res.status(500).json({ success: false, message: 'Internal server error' });
    }
});

module.exports = router;
