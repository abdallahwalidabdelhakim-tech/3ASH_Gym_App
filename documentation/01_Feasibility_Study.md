# Feasibility Study Report
**Project Name:** 3ASH - Gym & Progress Tracker
**Date:** February 8, 2026
**Version:** 1.0

## 1. Executive Summary
The proposed project, **3ASH**, is a mobile application designed to assist gym-goers in tracking their workouts, body metrics, and overall fitness progress. This feasibility study assesses the viability of developing and deploying the application using Flutter for the frontend and a Node.js/Express backend. The analysis covers Technical, Economic, Operational, Scheduling, and Legal feasibility.

**Conclusion:** The project is feasible across all dimensions with manageable risks.

---

## 2. Technical Feasibility
*Can we build it?*

### Hardware Requirements
- **Development:** Standard developer workstation (Windows/Mac/Linux) capable of running Android Studio/VS Code and emulators.
- **Server:** Minimal server requirements for Node.js + SQLite (initially). Scalable to cloud instances (AWS EC2, DigitalOcean) with PostgreSQL/MongoDB for production.
- **Client:** Android 6.0+ and iOS 11+ devices.

### Software Requirements
- **Frontend Framework:** Flutter (Dart). Well-documented, cross-platform, high performance.
- **Backend Framework:** Node.js with Express. Allows for rapid API development.
- **Database:** SQLite (local/dev), scalable to PostgreSQL/MySQL (production).
- **Versioning:** Git & GitHub.

### Technical Skills
The development team possesses the necessary skills in Dart/Flutter for mobile development and JavaScript/Node.js for backend services. No obscure or bleeding-edge technologies are required that would introduce high technical risk.

---

## 3. Economic Feasibility
*Should we build it?*

### Cost Analysis
- **Development Costs:**
  - **Personnel:** Time investment by the developer (User).
  - **Tools:** VS Code (Free), Android Studio (Free), Git (Free).
  - **Design:** Figma (Free tier).
- **Operational Costs:**
  - **Hosting:** Low initially (e.g., Free tiers on Render/Heroku/Railway or low-cost VPS ~$5/mo).
  - **App Store Fees:** Google Play ($25 one-time), Apple App Store ($99/year).

### Benefit Analysis
- **Tangible Benefits:**
  - Potential revenue from premium features (subscription model).
  - Advertising revenue (optional).
- **Intangible Benefits:**
  - Improved user health and fitness discipline.
  - Portfolio asset for the developer.

**Analysis:** The project has a low financial barrier to entry, making it economically viable for an independent developer or small team.

---

## 4. Operational Feasibility
*Will it be used?*

### User Adoption
- **Target Audience:** Gym enthusiasts, beginners, and personal trainers.
- **Usability:** The app solves a specific problem (replacing paper logs/notes) with a digital, analytical solution.
- **Value Proposition:** "Data-driven gains" – visualizing progress encourages continued usage.

### Process Integration
- The app fits naturally into the user's workflow (during rest periods between sets).
- No complex setup is required; users can start logging immediately.

---

## 5. Schedule Feasibility
*Can we build it in time?*

### Estimated Timeline (4-6 Weeks)
1.  **Week 1:** Requirements Gathering & Design (UI/UX).
2.  **Week 2-3:** Core Development (Authentication, Workout Logger).
3.  **Week 4:** Metric Tracking & Analysis Features.
4.  **Week 5:** Testing (Unit, Integration, User Acceptance).
5.  **Week 6:** Deployment & Release.

**Analysis:** The timeline is realistic given the scope of the MVP (Minimum Viable Product).

---

## 6. Legal & Ethical Feasibility
- **Data Privacy:** Must comply with GDPR/CCPA if users are in respective regions. User data (metrics) is sensitive.
  - *Mitigation:* Secure storage, encryption, clear Privacy Policy.
- **Intellectual Property:** Code and assets owned by the creator.
- **Liability:** Disclaimer required stating the app provides tracking, not medical advice.

---

## 7. Recommendation
**Proceed with the project.** The technical risks are low, the cost is minimal, and there is a clear user need for a streamlined fitness tracking solution.
