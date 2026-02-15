/**
 * Database module for SQLite connection and initialization.
 * Handles database setup, table creation, and provides database instance.
 */

const Database = require('better-sqlite3');
const path = require('path');
const fs = require('fs');
const config = require('../config');

// Ensure database directory exists
const dir = path.dirname(config.dbPath);
if (!fs.existsSync(dir)) {
    fs.mkdirSync(dir, { recursive: true });
}

// Create database connection with verbose logging in development
const db = new Database(config.dbPath, { verbose: config.env === 'development' ? console.log : null });
db.pragma('journal_mode = WAL'); // Enable Write-Ahead Logging for better performance

/**
 * Initializes the database by creating all required tables if they don't exist.
 * This function ensures the database schema is set up correctly.
 */
function initDb() {
    console.log('Initializing Database...');

    // Execute SQL to create all required tables and indexes
    db.exec(`
    -- User account table
    CREATE TABLE IF NOT EXISTS users (
      id TEXT PRIMARY KEY,
      username TEXT NOT NULL UNIQUE,
      sex TEXT,
      email TEXT NOT NULL UNIQUE,
      password_hash TEXT NOT NULL,
      country TEXT,
      phone_number TEXT,
      date_of_birth TEXT,
      created_at TEXT NOT NULL
    );

    -- Password reset codes for account recovery
    CREATE TABLE IF NOT EXISTS password_reset_codes (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      email TEXT NOT NULL,
      code_hash TEXT NOT NULL,
      expires_at INTEGER NOT NULL,
      created_at INTEGER NOT NULL
    );

    -- Index for faster password reset code lookup
    CREATE INDEX IF NOT EXISTS idx_password_reset_codes_email_created_at
      ON password_reset_codes(email, created_at);

    -- User onboarding data for fitness profile
    CREATE TABLE IF NOT EXISTS user_onboarding (
      user_id TEXT PRIMARY KEY,
      height REAL,
      weight REAL,
      target_weight REAL,
      updated_at INTEGER NOT NULL,
      FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE CASCADE
    );

    -- Exercise library
    CREATE TABLE IF NOT EXISTS exercises (
      id TEXT PRIMARY KEY,
      name TEXT NOT NULL,
      main_image_url TEXT,
      video_url TEXT,
      gallery_images TEXT,
      instructions TEXT,
      category TEXT,
      created_at INTEGER NOT NULL
    );

    -- Index for faster exercise category filtering
    CREATE INDEX IF NOT EXISTS idx_exercises_category
      ON exercises(category);

    -- Workout logs for tracking completed workouts
    CREATE TABLE IF NOT EXISTS workout_logs (
      id TEXT PRIMARY KEY,
      user_id TEXT NOT NULL,
      date TEXT NOT NULL,
      exercises TEXT,
      notes TEXT,
      created_at INTEGER NOT NULL,
      FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE CASCADE
    );

    -- Index for faster workout log retrieval by user and date
    CREATE INDEX IF NOT EXISTS idx_workout_logs_user_date
      ON workout_logs(user_id, date);

    -- Body measurements and weight tracking
    CREATE TABLE IF NOT EXISTS body_logs (
      id TEXT PRIMARY KEY,
      user_id TEXT NOT NULL,
      date TEXT NOT NULL,
      weight REAL,
      created_at INTEGER NOT NULL,
      FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE CASCADE
    );

    -- Index for faster body log retrieval by user and date
    CREATE INDEX IF NOT EXISTS idx_body_logs_user_date
      ON body_logs(user_id, date);

    -- Workout plans for structured fitness programs
    CREATE TABLE IF NOT EXISTS workout_plans (
      id TEXT PRIMARY KEY,
      user_id TEXT NOT NULL,
      plan_type TEXT NOT NULL,
      plan_data TEXT,
      start_date TEXT NOT NULL,
      last_completed_date TEXT,
      created_at INTEGER NOT NULL,
      FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE CASCADE
    );

    -- Index for faster workout plan retrieval by user
    CREATE INDEX IF NOT EXISTS idx_workout_plans_user
      ON workout_plans(user_id);
  `);

    console.log('Database initialized successfully.');
}

// Export database instance and initialization function
module.exports = { db, initDb };
