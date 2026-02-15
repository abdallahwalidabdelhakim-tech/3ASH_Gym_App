const express = require('express');
const { z } = require('zod');
const AuthService = require('../services/auth.service');
const authenticateToken = require('../middleware/auth');

const router = express.Router();

// Helper for error handling
const handleAuthError = (res, error) => {
    console.error('Auth error:', error);
    if (error.message === 'User already exists') return res.status(409).json({ success: false, message: error.message });
    if (error.message === 'Invalid credentials') return res.status(401).json({ success: false, message: error.message });
    if (error.message === 'User not found') return res.status(404).json({ success: false, message: error.message });
    if (error.message === 'Invalid current password') return res.status(400).json({ success: false, message: error.message });
    if (error.message === 'User with this email not found') return res.status(404).json({ success: false, message: error.message });
    if (error.message === 'No reset code found') return res.status(400).json({ success: false, message: error.message });
    if (error.message === 'Code expired') return res.status(400).json({ success: false, message: error.message });
    if (error.message === 'Invalid code') return res.status(400).json({ success: false, message: error.message });

    // Default to 500
    res.status(500).json({ success: false, message: 'Internal server error' });
};

/**
 * User registration endpoint.
 */
router.post('/signup', async (req, res) => {
    try {
        const schema = z.object({
            username: z.string().min(1),
            email: z.string().email(),
            password: z.string().min(6),
            country: z.string().min(1).optional(),
            phone_number: z.string().min(1).optional(),
            phoneNumber: z.string().min(1).optional(),
        });

        const parsed = schema.safeParse(req.body);
        if (!parsed.success) {
            return res.status(400).json({
                success: false,
                message: 'Invalid request',
                errors: parsed.error.flatten()
            });
        }

        const { username, email, password, country } = parsed.data;
        const phoneNumber = parsed.data.phone_number || parsed.data.phoneNumber;

        const result = await AuthService.signup({ username, email, password, country, phoneNumber });
        res.status(201).json({ success: true, ...result });
    } catch (error) {
        handleAuthError(res, error);
    }
});

/**
 * User login endpoint.
 */
router.post('/login', async (req, res) => {
    try {
        const schema = z.object({
            username: z.string().min(1),
            password: z.string().min(1),
        });

        const parsed = schema.safeParse(req.body);
        if (!parsed.success) {
            return res.status(400).json({
                success: false,
                message: 'Invalid request',
                errors: parsed.error.flatten()
            });
        }

        const { username, password } = parsed.data;
        const result = await AuthService.login(username, password);

        res.status(200).json({ success: true, ...result });
    } catch (error) {
        handleAuthError(res, error);
    }
});

/**
 * Change user password endpoint.
 */
router.post('/change-password', authenticateToken, async (req, res) => {
    try {
        const schema = z.object({
            old_password: z.string().min(1).optional(),
            oldPassword: z.string().min(1).optional(),
            new_password: z.string().min(6).optional(),
            newPassword: z.string().min(6).optional(),
        });

        const parsed = schema.safeParse(req.body);
        if (!parsed.success) {
            return res.status(400).json({ success: false, message: 'Invalid request' });
        }

        const oldPassword = parsed.data.old_password || parsed.data.oldPassword;
        const newPassword = parsed.data.new_password || parsed.data.newPassword;

        if (!oldPassword || !newPassword) {
            return res.status(400).json({ success: false, message: 'Missing password fields' });
        }

        await AuthService.changePassword(req.user.id, oldPassword, newPassword);
        res.status(200).json({ success: true, message: 'Password changed successfully' });
    } catch (error) {
        handleAuthError(res, error);
    }
});

/**
 * Send password reset code to email.
 */
router.post('/send-reset-code', async (req, res) => {
    try {
        const { email } = req.body;
        if (!email) return res.status(400).json({ success: false, message: 'Email is required' });

        await AuthService.sendResetCode(email);
        res.json({ success: true, message: 'Reset code sent to your email' });
    } catch (error) {
        handleAuthError(res, error);
    }
});

/**
 * Verify password reset code.
 */
router.post('/verify-reset-code', async (req, res) => {
    try {
        const { email, code } = req.body;
        if (!email || !code) return res.status(400).json({ success: false, message: 'Email and code are required' });

        await AuthService.verifyResetCode(email, code);
        res.json({ success: true, message: 'Code verified' });
    } catch (error) {
        handleAuthError(res, error);
    }
});

/**
 * Reset user password using reset code.
 */
router.post('/reset-password', async (req, res) => {
    try {
        const { email, code, newPassword } = req.body;
        if (!email || !code || !newPassword) {
            return res.status(400).json({
                success: false,
                message: 'Email, code, and new password are required'
            });
        }

        await AuthService.resetPassword(email, code, newPassword);
        res.json({ success: true, message: 'Password reset successful' });
    } catch (error) {
        handleAuthError(res, error);
    }
});

module.exports = router;
