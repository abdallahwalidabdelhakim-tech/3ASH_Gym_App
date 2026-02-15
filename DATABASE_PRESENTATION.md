# Boda Fitness App - Database Presentation

## Overview

The Boda Fitness App is a comprehensive gym and progress tracking application built with Flutter (frontend) and Node.js (backend) using SQLite as the database. This document presents the database architecture, schema design, and data flow within the application.

## Application Overview

**App Name:** Boda Fitness App  
**Description:** GYM & Progress Tracker  
**Platform:** Cross-platform (iOS, Android, Web)  
**Tech Stack:**
- Frontend: Flutter (Dart)
- Backend: Node.js with Express.js
- Database: SQLite with better-sqlite3
- State Management: Provider
- Navigation: GoRouter

## Database Architecture

### System Architecture

```
┌──────────────────────────────────────────────────────────────────────┐
│                      Flutter Frontend                               │
├──────────────────────────────────────────────────────────────────────┤
│ • User Interface Components                                         │
│ • State Management (Provider)                                       │
│ • Local Storage (SharedPreferences, Flutter Secure Storage)         │
│ • API Integration (HTTP)                                            │
└──────────────────────────────────────────┬───────────────────────────┘
                                           │
                                           │ RESTful API (JSON)
                                           │
┌──────────────────────────────────────────▼───────────────────────────┐
│                     Node.js Backend Server                          │
├──────────────────────────────────────────────────────────────────────┤
│ • Express.js API Routes                                             │
│ • Authentication & Authorization (JWT)                              │
│ • Business Logic & Use Cases                                        │
│ • Database Connection Management                                    │
└──────────────────────────────────────────┬───────────────────────────┘
                                           │
                                           │ SQLite Database
                                           │
┌──────────────────────────────────────────▼───────────────────────────┐
│                     SQLite Database (data.db)                       │
├──────────────────────────────────────────────────────────────────────┤
│ • User Management                                                   │
│ • Workout Tracking                                                  │
│ • Exercise Library                                                  │
│ • Body Measurements                                                │
│ • Nutrition Tracking                                               │
└──────────────────────────────────────────────────────────────────────┘
```

## Database Schema Design

### 1. Users Table

**Purpose:** Stores user account information and authentication data.

```sql
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
```

**Key Fields:**
- `id`: Unique user identifier (UUID)
- `username`: User's chosen username (unique)
- `email`: Email address (unique, used for login)
- `password_hash`: bcrypt-hashed password
- `sex`: User's gender
- `country`: Country of residence
- `phone_number`: Contact number
- `date_of_birth`: Date of birth
- `created_at`: Account creation timestamp

### 2. Password Reset Codes Table

**Purpose:** Manages password reset functionality with time-limited codes.

```sql
CREATE TABLE IF NOT EXISTS password_reset_codes (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  email TEXT NOT NULL,
  code_hash TEXT NOT NULL,
  expires_at INTEGER NOT NULL,
  created_at INTEGER NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_password_reset_codes_email_created_at
  ON password_reset_codes(email, created_at);
```

**Key Fields:**
- `email`: Email associated with the reset request
- `code_hash`: Hashed reset code
- `expires_at`: Expiration timestamp
- `created_at`: Creation timestamp

### 3. User Onboarding Table

**Purpose:** Stores fitness profile and onboarding information.

```sql
CREATE TABLE IF NOT EXISTS user_onboarding (
  user_id TEXT PRIMARY KEY,
  height REAL,
  weight REAL,
  target_weight REAL,
  updated_at INTEGER NOT NULL,
  FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE CASCADE
);
```

**Key Fields:**
- `user_id`: Foreign key to users table
- `height`: User's height in centimeters
- `weight`: Current weight in kilograms
- `target_weight`: Goal weight in kilograms
- `updated_at`: Last update timestamp

### 4. Exercises Table

**Purpose:** Stores exercise library with media assets and instructions.

```sql
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

CREATE INDEX IF NOT EXISTS idx_exercises_category
  ON exercises(category);
```

**Key Fields:**
- `id`: Unique exercise identifier (UUID)
- `name`: Exercise name
- `main_image_url`: Main image path
- `video_url`: Video demonstration path
- `gallery_images`: JSON array of additional image paths
- `instructions`: JSON array of exercise instructions
- `category`: Exercise category (chest, back, shoulders, arms, legs, abs, cardio)

### 5. Workout Logs Table

**Purpose:** Tracks completed workout sessions.

```sql
CREATE TABLE IF NOT EXISTS workout_logs (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL,
  date TEXT NOT NULL,
  exercises TEXT,
  notes TEXT,
  created_at INTEGER NOT NULL,
  FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_workout_logs_user_date
  ON workout_logs(user_id, date);
```

**Key Fields:**
- `id`: Unique log identifier (UUID)
- `user_id`: Foreign key to users table
- `date`: Workout date and time
- `exercises`: JSON array of exercise sets (including reps, weight, PR flags)
- `notes`: Optional workout notes
- `created_at`: Creation timestamp

### 6. Body Logs Table

**Purpose:** Tracks body measurements and weight over time.

```sql
CREATE TABLE IF NOT EXISTS body_logs (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL,
  date TEXT NOT NULL,
  weight REAL,
  created_at INTEGER NOT NULL,
  FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_body_logs_user_date
  ON body_logs(user_id, date);
```

**Key Fields:**
- `id`: Unique log identifier (UUID)
- `user_id`: Foreign key to users table
- `date`: Measurement date
- `weight`: Weight in kilograms
- `created_at`: Creation timestamp

### 7. Workout Plans Table

**Purpose:** Manages structured workout plans for users.

```sql
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

CREATE INDEX IF NOT EXISTS idx_workout_plans_user
  ON workout_plans(user_id);
```

**Key Fields:**
- `id`: Unique plan identifier (UUID)
- `user_id`: Foreign key to users table
- `plan_type`: Type of plan (custom, predefined, AI-generated)
- `plan_data`: JSON data containing plan details (exercises, schedule)
- `start_date`: Plan start date
- `last_completed_date`: Last completed workout date
- `created_at`: Creation timestamp

## Data Models & Relationships

### Entity-Relationship Diagram (ERD)

```
┌────────────┐       ┌─────────────────┐
│   Users    │       │ PasswordReset   │
├────────────┤       ├─────────────────┤
│ id (PK)    │<──────┤ email           │
│ username   │       │ code_hash       │
│ email      │       │ expires_at      │
│ password_hash│     │ created_at      │
│ sex        │       └─────────────────┘
│ country    │
│ phone_number│
│ date_of_birth│
│ created_at │
└────────────┘
        │
        │
        ▼
┌──────────────────┐
│ UserOnboarding   │
├──────────────────┤
│ user_id (PK, FK) │
│ height           │
│ weight           │
│ target_weight    │
│ updated_at       │
└──────────────────┘
        │
        │
        ▼
┌──────────────┐   ┌──────────────┐   ┌──────────────┐
│ WorkoutLogs  │   │ BodyLogs     │   │ WorkoutPlans │
├──────────────┤   ├──────────────┤   ├──────────────┤
│ id (PK)      │   │ id (PK)      │   │ id (PK)      │
│ user_id (FK) │◄──│ user_id (FK) │◄──│ user_id (FK) │
│ date         │   │ date         │   │ plan_type    │
│ exercises    │   │ weight       │   │ plan_data    │
│ notes        │   │ created_at   │   │ start_date   │
│ created_at   │   └──────────────┘   │ last_completed│
└──────────────┘                      │ created_at   │
                                      └──────────────┘

┌──────────────┐
│  Exercises   │
├──────────────┤
│ id (PK)      │
│ name         │
│ category     │
│ main_image_url│
│ video_url    │
│ gallery_images│
│ instructions │
│ created_at   │
└──────────────┘
```

## Data Flow & Operations

### User Registration Flow

```
1. User signs up via Flutter frontend
2. Frontend sends registration data to backend API
3. Backend validates data and creates user record
4. Password is hashed using bcrypt
5. User record is stored in `users` table
6. Onboarding data is stored in `user_onboarding` table
7. JWT token is generated and returned to frontend
8. User is authenticated and can access protected routes
```

### Workout Tracking Flow

```
1. User selects workout from library or plan
2. User records exercise sets (reps, weight)
3. Frontend sends workout data to backend API
4. Backend validates and stores in `workout_logs` table
5. Data is stored as JSON array for flexibility
6. Workout completion is recorded with timestamp
7. Frontend updates UI with progress
```

### Body Measurement Tracking

```
1. User records body measurements
2. Frontend sends data to backend API
3. Backend validates and stores in `body_logs` table
4. Measurements include weight and optionally other metrics
5. Data is used for progress visualization
6. Trends are analyzed over time
```

## Database Configuration

### Connection Details

- **Database Type:** SQLite (File-based)
- **Location:** `/backend/data.db`
- **Driver:** better-sqlite3 (v11.8.1)
- **Journal Mode:** WAL (Write-Ahead Logging) for better performance
- **Synchronous Mode:** Normal

### Initialization

```javascript
// Database connection setup in src/db/index.js
const db = new Database(config.dbPath, { 
  verbose: config.env === 'development' ? console.log : null 
});
db.pragma('journal_mode = WAL');
```

### Performance Optimizations

1. **Indexes:**
   - `idx_password_reset_codes_email_created_at`: For faster password reset lookups
   - `idx_exercises_category`: For exercise category filtering
   - `idx_workout_logs_user_date`: For workout log retrieval by user and date
   - `idx_body_logs_user_date`: For body log retrieval by user and date
   - `idx_workout_plans_user`: For workout plan retrieval by user

2. **WAL Mode:** Enables concurrent reads and writes
3. **JSON Storage:** Allows flexible data structures
4. **Foreign Key Constraints:** Ensures data integrity

## Seeding & Initialization

### Exercise Library Seeding

```javascript
// src/scripts/seed.js
- Predefines 38 exercises across 7 categories
- Automatically matches videos and images from assets
- Generates standard exercise instructions
- Runs automatically if table is empty
```

**Exercise Categories:**
- Chest: 5 exercises
- Back: 4 exercises
- Shoulders: 4 exercises
- Arms: 8 exercises
- Legs: 5 exercises
- Abs: 4 exercises
- Cardio: 4 exercises

## Data Types & Storage

### Storage Patterns

1. **JSON Serialization:** Complex data (exercises, plans) stored as JSON strings
2. **Timestamps:** Unix timestamps for efficient sorting
3. **UUIDs:** Unique identifiers for all records
4. **Hashing:** bcrypt for password storage
5. **Normalization:** Proper foreign key relationships

### Frontend Data Models

```dart
// lib/core/models/
- UserModel: User account information
- BodyLog: Body measurements
- WorkoutLog: Workout session data
- Exercise: Exercise details
- NutritionModel: Nutrition tracking
- ExerciseSetLog: Exercise set details
```

## Security Features

### Authentication

- **JWT Tokens:** Secure API access
- **bcrypt Hashing:** Password storage
- **Input Validation:** Zod schema validation
- **Rate Limiting:** Protection against brute force attacks

### Data Security

- **HTTPS:** All API requests encrypted
- **CORS:** Cross-origin resource sharing configuration
- **Helmet:** Security headers
- **Input Sanitization:** Protection against SQL injection

## Future Improvements

### Database Enhancements

1. **Relational Structure:** Split JSON fields into separate tables
2. **Full-Text Search:** Improve search capabilities
3. **Data Partitioning:** Optimize for large datasets
4. **Analytics:** Add reporting and analytics tables
5. **Offline Sync:** Support for offline data synchronization
6. **Backup & Restore:** Automated backup functionality

### Performance Optimizations

1. **Query Optimization:** Analyze and optimize slow queries
2. **Caching:** Implement Redis for frequently accessed data
3. **Database Clustering:** Scale horizontally
4. **Connection Pooling:** Improve concurrent connections
5. **Compression:** Reduce storage requirements

## Testing & Maintenance

### Database Testing

- **Unit Tests:** Test individual queries and operations
- **Integration Tests:** Test database interactions
- **Migration Tests:** Ensure schema changes are backward compatible

### Maintenance Procedures

1. **Backup:** Regular database backups
2. **Monitoring:** Performance and error monitoring
3. **Cleanup:** Remove expired password reset codes
4. **Index Optimization:** Rebuild indexes periodically
5. **Vacuum:** Optimize database file size

## Summary

The Boda Fitness App database is a well-structured, lightweight SQLite database designed for fitness tracking and workout management. It efficiently stores user data, exercise information, workout logs, and body measurements while maintaining data integrity through proper relational design and foreign key constraints. The use of JSON storage provides flexibility for complex data structures, and indexing ensures efficient query performance.

The database is tightly integrated with both the Flutter frontend and Node.js backend, providing a seamless data flow for users tracking their fitness progress through the application.
