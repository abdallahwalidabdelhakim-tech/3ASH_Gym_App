# Prototype Design Description
**Project Name:** 3ASH - Gym & Progress Tracker
**Date:** February 8, 2026

## 1. Introduction
This detailed description serves as the blueprint for the **3ASH** high-fidelity prototype. It outlines the visual layout, user interactions, and flow for the key screens of the application.

---

## 2. Screen Descriptions

### 2.1 Home Dashboard
**Purpose:** The central hub where users land upon opening the app.
**Visual Layout:**
- **Header:** "Good Morning, [User]!" with a small circular profile picture in the top-right corner.
- **Primary Card (Top-Center):** "Today's Workout".
  - *Content:* Displays the name of the scheduled workout (e.g., "Push Day A").
  - *Action:* Large "Start Workout" button in an accent color (Teal/Blue).
- **Secondary Section:** "Weekly Consistency".
  - *Content:* A row of 7 bubbles representing days of the week. Completed workout days are filled; rest days are outlined.
- **Bottom Navigation Bar:** Fixed at the bottom with 4 icons:
  1.  **Home** (Active)
  2.  **Logs** (Calendar view of history)
  3.  **Analysis** (Charts)
  4.  **Profile** (Settings)

### 2.2 Workout Logger (Active Session)
**Purpose:** The interface used while the user is actually working out.
**Visual Layout:**
- **Header:** Workout Name (e.g., "Leg Day") and a running timer (00:15:30).
- **Exercise List:** Vertical scrollable list of exercises.
- **Exercise Card Structure:**
  - *Title:* Exercise Name (e.g., "Squats").
  - *Table Header:* Set | Weight (kg) | Reps | Done
  - *Rows:* Input fields for each set.
  - *Interaction:* Tapping the "Done" checkbox dims the row and starts a generic rest timer overlay.
- **Footer:** "Add Exercise" button (Secondary style) and "Finish Workout" button (Primary style, Red/Danger color to prevent accidental clicks, or requiring a long-press).

### 2.3 Analysis & Progress
**Purpose:** To visualize gains and body metrics.
**Visual Layout:**
- **Tabs:** "Body Metrics" vs "Workout Volume".
- **Chart Area:**
  - Large interactive line chart.
  - X-Axis: Dates (Weeks/Months).
  - Y-Axis: Weight (kg) or Volume.
  - *Interaction:* Tapping a point on the line shows the exact value and date tooltip.
- **Stats Grid:** Below the chart, 2x2 grid of metric cards:
  - "Current Weight"
  - "Total Volume (Week)"
  - "Best Bench Press"
  - "Workouts this Month"

### 2.4 Onboarding Flow
**Purpose:** Collect initial data for personalization.
**Screens:**
1.  **SPLASH:** App Logo with "3ASH" branding.
2.  **LOGIN / SIGNUP:** Simple email/password fields with "Continue with Google" option.
3.  **PROFILE SETUP:**
    - "What is your main goal?" (Gain Muscle, Lose Fat, Maintain).
    - "Current Weight" & "Target Weight" sliders.
    - "Days you want to train?" (Multi-select Mon-Sun).

---

## 3. Design System Notes
- **Color Palette:**
  - *Background:* Dark Grey (#121212)
  - *Surface:* Dark Blue-Grey (#1E1E1E)
  - *Primary Accent:* Electric Teal (#03DAC6)
  - *Secondary Accent:* Vivid Purple (#BB86FC)
- **Typography:**
  - *Headings:* 'Montserrat' (Bold, Modern)
  - *Body:* 'Roboto' or 'Inter' (Clean, Readable)
- **Icons:** Rounded, outlined style (e.g., Iconly or Feather Icons).
