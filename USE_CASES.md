# 3ASH Use Case Specifications

This document outlines the primary functional use cases for the **3ASH** fitness application.

---

## Use Case 1: Daily Body Metric Tracking
**Goal:** Allow users to record their weight and body measurements to track physical progress over time.

**Actors:**
- **Primary Actor:** Registered User
- **Secondary Actor:** Backend Server (Data Storage)

**Pre-conditions:**
- The user is authenticated and logged into the application.
- The user has established initial goals (e.g., target weight) during onboarding.

**Main Success Scenario:**
1. User opens the application and navigates to the "Log Metrics" or "Home" section.
2. User selects the current date (defaulted to today).
3. User enters their current **Weight** (required).
4. User optionally enters body measurements (Chest, Waist, Hips, Arms, Thighs).
5. User clicks "Save".
6. The system validates the input (positive numbers).
7. The system sends a POST request to `/metrics/weight` with the data.
8. The backend saves the data to the database, updating the user's current weight record.
9. The system updates the "Analysis" charts to reflect the new data point.
10. If the new weight reaches or passes the user's **Target Weight**, the system displays a "Goal Achieved" congratulatory message.

**Extensions:**
- **3a. Invalid Data:** If user enters non-numeric or negative values, the system displays an error message and prevents submission.
- **7a. Offline Mode:** If the internet connection is unavailable, the system caches the entry locally and syncs when back online (Pending Implementation).

---

## Use Case 2: Personalized Workout Execution
**Goal:** Guide the user through a structured workout session based on their selected plan.

**Actors:**
- **Primary Actor:** Registered User

**Pre-conditions:**
- The user has selected or created a workout plan.
- Today is a scheduled workout day.

**Main Success Scenario:**
1. User views the "Today's Plan" on the Home dashboard.
2. User clicks "Start Workout".
3. The system displays the first exercise in the routine.
4. User performs the required sets/reps.
5. User logs the actual weight and reps completed for each set.
6. User clicks "Next Exercise" until the routine is complete.
7. User clicks "Finish Workout".
8. The system saves the workout session, calculates total volume, and updates the "Workout History" and "Analysis" screens.

---

## Use Case 3: Progress Analysis & Insights
**Goal:** Provide the user with visual feedback on their fitness journey.

**Actors:**
- **Primary Actor:** Registered User

**Main Success Scenario:**
1. User navigates to the "Analysis" tab.
2. User selects a time period (Week, Month, Year).
3. User selects a metric to view (Weight, Workout Volume, or specific exercise 1RM).
4. The system fetches history data and renders a trend chart.
5. The system displays summary stats (e.g., "Total Weight Lost: 5kg", "Volume Increased by 15%").

---

## Use Case 4: Onboarding & Goal Setting
**Goal:** Successfully register a new user and capture their baseline data.

**Actors:**
- **Primary Actor:** New User

**Main Success Scenario:**
1. User downloads the app and clicks "Sign Up".
2. User enters Email, Username, and Password.
3. User chooses their Country and Language.
4. User enters their **Initial Weight** and **Target Weight**.
5. The system calculates the TDEE (Total Daily Energy Expenditure) based on profile data (Pending Implementation).
6. User is redirected to the Home dashboard to begin their journey.
