/**
 * Authentication middleware for Express.
 * Verifies JWT tokens from Authorization header and attaches user data to request.
 */

const jwt = require('jsonwebtoken');
const config = require('../config');

/**
 * Middleware function to authenticate requests using JWT token.
 * @param {Object} req - Express request object
 * @param {Object} res - Express response object
 * @param {Function} next - Next middleware function
 */
function authenticateToken(req, res, next) {
    // Extract token from Authorization header (format: Bearer <token>)
    const authHeader = req.headers['authorization'];
    const token = authHeader && authHeader.split(' ')[1];

    // If no token provided, return 401 Unauthorized
    if (!token) {
        return res.status(401).json({ error: 'Access token required' });
    }

    // Verify token using secret key
    jwt.verify(token, config.jwtSecret, (err, user) => {
        // If token is invalid or expired, return 403 Forbidden
        if (err) {
            return res.status(403).json({ error: 'Invalid or expired token' });
        }
        
        // Attach user data to request object
        req.user = user;
        next(); // Continue to next middleware or route handler
    });
}

module.exports = authenticateToken;
