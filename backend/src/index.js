/**
 * Server entry point.
 * Starts the Express server and initializes the database.
 */

const app = require('./app'); // Express application instance
const config = require('./config'); // Configuration values
const { initDb } = require('./db'); // Database initialization

// Initialize database schema
initDb();

// Start server
app.listen(config.port, () => {
    console.log(`Server running on port ${config.port} in ${config.env} mode`);
});
