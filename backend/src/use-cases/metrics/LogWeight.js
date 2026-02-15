/**
 * Use case for logging weight and body measurements.
 * Handles both creation of new logs and updates to existing logs.
 */

const crypto = require('crypto');

class LogWeightUseCase {
    /**
     * Creates a new LogWeightUseCase instance.
     * @param {Object} db - Database instance (better-sqlite3)
     */
    constructor(db) {
        this.db = db;
    }

    /**
     * Executes the use case to log weight and body measurements.
     * @param {Object} params - Parameters
     * @param {string} params.userId - User ID
     * @param {string} params.date - Date of measurement (ISO string)
     * @param {number} params.weight - Weight in kg
     * @param {Object} params.measurements - Additional measurements (chest, waist, hips, arms, thighs)
     * @returns {Object} Updated body log
     */
    execute({ userId, date, weight, measurements = {} }) {
        const { chest, waist, hips, arms, thighs } = measurements;
        const now = Date.now();

        // Step 1: Check if log already exists for this date
        const existing = this.db.prepare('SELECT id FROM body_logs WHERE user_id = ? AND date = ?').get(userId, date);

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
                this.db.prepare(`UPDATE body_logs SET ${fields.join(', ')} WHERE id = ?`).run(...values);
            }
        } else {
            // Insert new log
            const id = crypto.randomUUID();
            this.db.prepare(`
                INSERT INTO body_logs (id, user_id, date, weight, chest, waist, hips, arms, thighs, created_at)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
            `).run(
                id,
                userId,
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

        // Step 2: Update current weight in user_onboarding if provided
        if (weight !== undefined) {
            const existingOnboarding = this.db.prepare('SELECT user_id FROM user_onboarding WHERE user_id = ?').get(userId);
            if (existingOnboarding) {
                this.db.prepare('UPDATE user_onboarding SET weight = ?, updated_at = ? WHERE user_id = ?').run(weight, now, userId);
            }
        }

        // Step 3: Return the updated log
        return this.db.prepare('SELECT * FROM body_logs WHERE date = ? AND user_id = ?').get(date, userId);
    }
}

module.exports = LogWeightUseCase;
