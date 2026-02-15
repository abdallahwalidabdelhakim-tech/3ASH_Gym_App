/**
 * Express application setup and configuration.
 * Main entry point for the backend server.
 */

const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const authRoutes = require('./routes/auth');
const userRoutes = require('./routes/users');
const exerciseRoutes = require('./routes/exercises');
const workoutRoutes = require('./routes/workouts');
const metricRoutes = require('./routes/metrics');

// Initialize Express app
const app = express();

// Security middleware
app.use(helmet()); // Protect against common vulnerabilities

// CORS Configuration
const allowedOrigins = [
    'http://localhost:3000', // Backend itself
    'http://localhost:8080', // Common frontend dev port
    // Add client origins here
];

app.use(cors({
    origin: function (origin, callback) {
        // Allow requests with no origin (like mobile apps or curl requests)
        if (!origin) return callback(null, true);

        if (allowedOrigins.indexOf(origin) === -1 && process.env.NODE_ENV === 'production') {
            var msg = 'The CORS policy for this site does not allow access from the specified Origin.';
            return callback(new Error(msg), false);
        }
        return callback(null, true);
    }
})); // Enable safe CORS

// Request parsing middleware
app.use(express.json()); // Parse JSON request bodies

// API Routes
app.use('/api/auth', authRoutes); // Authentication routes (login, signup, password management)
app.use('/api/users', userRoutes); // User profile and onboarding routes
app.use('/api/exercises', exerciseRoutes); // Exercise library routes
app.use('/api/workouts', workoutRoutes); // Workout plans and logs routes
app.use('/api/metrics', metricRoutes); // Body measurements and weight tracking routes
app.use('/api/ai', require('./routes/ai')); // AI image analysis routes

/**
 * Health check endpoint.
 * @route GET /health
 * @access Public
 * @returns {Object} Status and timestamp
 */
app.get('/health', (req, res) => {
    res.json({ status: 'ok', timestamp: new Date().toISOString() });
});

module.exports = app;
