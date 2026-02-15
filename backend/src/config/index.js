/**
 * Configuration module for the application.
 * Loads environment variables from .env file and provides default values.
 */

// Load environment variables from .env file
require('dotenv').config();

const path = require('path');

/**
 * Exports configuration object with application settings.
 */
const jwtSecret = process.env.JWT_SECRET;
if (!jwtSecret) {
    throw new Error('FATAL ERROR: JWT_SECRET is not defined in .env file');
}

module.exports = {
    /** Server port to listen on - defaults to 3000 */
    port: process.env.PORT || 3000,
    
    /** Secret key for JWT token signing */
    jwtSecret: jwtSecret,
    
    /** Path to SQLite database file - defaults to data.db in root directory */
    dbPath: process.env.DB_PATH || path.join(__dirname, '../../data.db'),
    
    /** Current environment - defaults to 'development' */
    env: process.env.NODE_ENV || 'development',
};
