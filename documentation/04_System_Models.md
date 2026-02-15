# System Models
**Project Name:** 3ASH - Gym & Progress Tracker
**Date:** February 8, 2026

## 1. Use Case Diagram
This diagram illustrates the interactions between the actors (User, System) and the use cases.

```mermaid
usecaseDiagram
    actor User
    actor Backend as "Backend System"

    User --> (Log In)
    User --> (Sign Up)
    User --> (Manage Profile)
    
    package "Workout Management" {
        User --> (View Workout Plan)
        User --> (Start Workout Session)
        User --> (Log Exercise Sets)
        User --> (Finish Workout)
        (Finish Workout) --> Backend : Save Data
    }

    package "Progress Tracking" {
        User --> (View Analysis)
        User --> (Update Body Metrics)
        (Update Body Metrics) --> Backend : Save Data
    }
```

---

## 2. Sequence Diagram (Log Workout)
This diagram details the sequence of events when a user logs a workout session.

```mermaid
sequenceDiagram
    participant U as User
    participant app as Mobile App
    participant API as Backend API
    participant DB as Database

    U->>app: Click "Start Workout"
    app->>app: Initialize Session Timer
    loop Every Exercise
        U->>app: Enter Weight & Reps
        U->>app: Mark Set as Complete
        app-->>U: Start Rest Timer
    end
    U->>app: Click "Finish Workout"
    app->>API: POST /workouts/session (JSON Data)
    API->>DB: INSERT into workouts table
    DB-->>API: Success (ID: 123)
    API-->>app: 200 OK (Saved)
    app-->>U: Display "Workout Complete" Summary
```

---

## 3. Activity Diagram (Workout Flow)
This flowchart represents the user journey during a workout.

```mermaid
flowchart TD
    Start([Start]) --> Login{Logged In?}
    Login -- No --> SignUp[Sign Up / Login]
    Login -- Yes --> Dashboard[Home Dashboard]
    
    Dashboard --> SelectPlan[Select Workout Plan]
    SelectPlan --> StartSession[Start Session]
    
    StartSession --> LogSet[Log Set (Weight/Reps)]
    LogSet --> RestTimer[Rest Timer Countdown]
    RestTimer --> MoreSets{More Sets?}
    
    MoreSets -- Yes --> LogSet
    MoreSets -- No --> NextExercise{Next Exercise?}
    
    NextExercise -- Yes --> LogSet
    NextExercise -- No --> Finish[Finish Workout]
    
    Finish --> ViewSummary[View Summary Stats]
    ViewSummary --> End([End])
```

---

## 4. Class Diagram
This diagram models the data structure of the application.

```mermaid
classDiagram
    class User {
        +int id
        +string username
        +string email
        +float currentWeight
        +login()
        +updateProfile()
    }

    class WorkoutPlan {
        +int id
        +string name
        +string description
        +List~Exercise~ exercises
    }

    class WorkoutSession {
        +int id
        +Date date
        +int durationSeconds
        +User user
        +List~Set~ sets
        +finish()
    }

    class Exercise {
        +int id
        +string name
        +string type
        +string muscleGroup
    }

    class Set {
        +int id
        +float weight
        +int reps
        +int rpe
        +Exercise exercise
    }

    User "1" --> "*" WorkoutSession
    User "1" --> "*" WorkoutPlan
    WorkoutSession "1" --> "*" Set
    Set "*" --> "1" Exercise
    WorkoutPlan "*" --> "*" Exercise
```
