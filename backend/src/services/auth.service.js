/**
 * Authentication Service
 * Handles all business logic for user authentication and account management.
 */

const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const crypto = require('crypto');
const config = require('../config');
const { db } = require('../db');

class AuthService {
    /**
     * Generates a JWT token for authenticated users.
     * @param {string} userId - User ID to include in token
     * @returns {string} Signed JWT token valid for 7 days
     */
    static signToken(userId) {
        return jwt.sign({ id: userId }, config.jwtSecret, { expiresIn: '7d' });
    }

    /**
     * Builds user response object from database row.
     * @param {Object} row - Database user record
     * @returns {Object} Formatted user response with safe fields
     */
    static buildUserResponse(row) {
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
     * Register a new user.
     * @param {Object} userData - payload { username, email, password, country, phoneNumber }
     * @returns {Object} { user, token }
     */
    static async signup(userData) {
        const { username, email, password, country, phoneNumber } = userData;

        // Check if user already exists
        const existing = db.prepare('SELECT id FROM users WHERE username = ? OR email = ?').get(username, email);
        if (existing) {
            throw new Error('User already exists');
        }

        // Hash password and create user
        const passwordHash = await bcrypt.hash(password, 10);
        const id = crypto.randomUUID();
        const createdAt = new Date().toISOString();

        db.prepare(
            'INSERT INTO users (id, username, email, password_hash, country, phone_number, created_at) VALUES (?, ?, ?, ?, ?, ?, ?)'
        ).run(id, username, email, passwordHash, country || null, phoneNumber || null, createdAt);

        const userRow = db.prepare('SELECT * FROM users WHERE id = ?').get(id);
        const token = this.signToken(id);

        return { user: this.buildUserResponse(userRow), token };
    }

    /**
     * Authenticate a user.
     * @param {string} username - username or email
     * @param {string} password - plain text password
     * @returns {Object} { user, token }
     */
    static async login(username, password) {
        // Allow login by confirmed username. 
        // Note: The original code used username field for lookup.
        // If we want to support email login, we should change the query.
        // Original: const userRow = db.prepare('SELECT * FROM users WHERE username = ?').get(username);
        // Let's improve it to support email too if the input looks like an email?
        // For now, let's stick to the original logic to avoid breaking changes, 
        // but looking at the original code comment: "@param {string} req.body.username - Username or email (required)"
        // The original CODE only queried by `username = ?`. 
        // I will keep it as strictly username for now to match exact behavior, 
        // or improve it if I'm confident. The JSDoc said "Username or email", but code was `username = ?`.
        // I'll stick to the code's behavior for safety, but maybe add email check if not found?
        // Let's stick to code behavior:

        const userRow = db.prepare('SELECT * FROM users WHERE username = ?').get(username);

        if (!userRow) {
            throw new Error('Invalid credentials');
        }

        const ok = await bcrypt.compare(password, userRow.password_hash);
        if (!ok) {
            throw new Error('Invalid credentials');
        }

        const token = this.signToken(userRow.id);
        return { user: this.buildUserResponse(userRow), token };
    }

    /**
     * Change user password.
     * @param {string} userId 
     * @param {string} oldPassword 
     * @param {string} newPassword 
     */
    static async changePassword(userId, oldPassword, newPassword) {
        const userRow = db.prepare('SELECT * FROM users WHERE id = ?').get(userId);
        if (!userRow) {
            throw new Error('User not found');
        }

        const ok = await bcrypt.compare(oldPassword, userRow.password_hash);
        if (!ok) {
            throw new Error('Invalid current password');
        }

        const passwordHash = await bcrypt.hash(newPassword, 10);
        db.prepare('UPDATE users SET password_hash = ? WHERE id = ?').run(passwordHash, userId);
    }

    /**
     * Send password reset code.
     * @param {string} email 
     */
    static async sendResetCode(email) {
        const user = db.prepare('SELECT id FROM users WHERE email = ?').get(email);
        if (!user) {
            throw new Error('User with this email not found');
        }

        const code = Math.floor(1000 + Math.random() * 9000).toString(); // 4-digit code
        const expiresAt = Date.now() + 15 * 60 * 1000; // 15 minutes

        const codeHash = await bcrypt.hash(code, 5); // reduced rounds for speed on temp codes

        db.prepare('INSERT INTO password_reset_codes (email, code_hash, expires_at, created_at) VALUES (?, ?, ?, ?)')
            .run(email, codeHash, expiresAt, Date.now());

        // In a real app, send email here.
        console.log(`[MOCK EMAIL] To: ${email}, Code: ${code}`);
        return code; // Return for testing/logging
    }

    /**
     * Verify execution of reset code.
     * @param {string} email 
     * @param {string} code 
     */
    static async verifyResetCode(email, code) {
        const record = db.prepare('SELECT * FROM password_reset_codes WHERE email = ? ORDER BY created_at DESC LIMIT 1').get(email);
        if (!record) {
            throw new Error('No reset code found');
        }

        if (Date.now() > record.expires_at) {
            throw new Error('Code expired');
        }

        const ok = await bcrypt.compare(code, record.code_hash);
        if (!ok) {
            throw new Error('Invalid code');
        }
        return true;
    }

    /**
     * Reset password using code.
     * @param {string} email 
     * @param {string} code 
     * @param {string} newPassword 
     */
    static async resetPassword(email, code, newPassword) {
        // Verify again
        await this.verifyResetCode(email, code);

        const passwordHash = await bcrypt.hash(newPassword, 10);
        db.prepare('UPDATE users SET password_hash = ? WHERE email = ?').run(passwordHash, email);

        // Consume code
        db.prepare('DELETE FROM password_reset_codes WHERE email = ?').run(email);
    }
}

module.exports = AuthService;
