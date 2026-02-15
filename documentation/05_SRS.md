# Software Requirements Specification (SRS)
**Project Name:** 3ASH - Gym & Progress Tracker
**Date:** February 8, 2026
**Version:** 1.0

## 1. Introduction
### 1.1 Purpose
The purpose of this document is to define the software requirements for the **3ASH** application. It details the functional and non-functional requirements to guide the development process.

### 1.2 Scope
3ASH is a mobile application developed in Flutter with a Node.js backend. It allows users to:
- Track daily body metrics (weight, measurements).
- Execute personalized workout plans.
- Log exercise sets, reps, and weights.
- Visualize progress through charts and analytics.

---

## 2. Overall Description
### 2.1 Product Perspective
This is a standalone mobile application that communicates with a central server for data synchronization. It replaces traditional paper logs and basic note-taking apps.

### 2.2 User Requirements
- **Gym Goer:** Wants a quick, efficient way to log sets during rest periods.
- **Personal Trainer:** Wants to monitor client progress (future scope).

---

## 3. Specific Requirements (Functional)

### 3.1 Authentication
- **FR-01:** The system shall allow users to sign up with email and password.
- **FR-02:** The system shall allow users to log in and maintain a session.
- **FR-03:** The system shall require the user to set a "Target Weight" during onboarding.

### 3.2 Workout Management
- **FR-04:** The user shall be able to view "Today's Workout Plan" on the dashboard.
- **FR-05:** The user shall be able to start a workout session.
- **FR-06:** The user shall be able to add sets to an exercise with fields for Weight and Reps.
- **FR-07:** The system shall automatically start a rest timer when a set is marked as complete.
- **FR-08:** The user shall be capable of adding ad-hoc exercises to a running workout session.

### 3.3 Progress Tracking
- **FR-09:** The user shall be able to log daily body weight.
- **FR-10:** The system shall generate a line chart showing weight trends over 7, 30, and 90 days.
- **FR-11:** The system shall calculate "Total Volume" (Sum of Weight * Reps) for each workout.

---

## 4. Non-Functional Requirements
### 4.1 Performance
- **NFR-01:** Login shall take no longer than 2 seconds on a 4G connection.
- **NFR-02:** Local data entry (marking a set as done) must correspond immediately (<100ms) without network latency blocking the UI.

### 4.2 Application Security
- **NFR-03:** Passwords must be hashed using bcrypt before storage.
- **NFR-04:** All API communication must occur over HTTPS.

### 4.3 Reliability
- **NFR-05:** The app should function in "Offline Mode" if the internet is lost, syncing data when connectivity is restored.

---

## 5. External Interface Requirements
- **User Interfaces:** 
  - Material Design 3 guidelines.
  - Dark Mode as the default theme.
- **Software Interfaces:**
  - REST API (Node.js/Express).
  - SQLite Database (local dev) / PostgreSQL (production).
