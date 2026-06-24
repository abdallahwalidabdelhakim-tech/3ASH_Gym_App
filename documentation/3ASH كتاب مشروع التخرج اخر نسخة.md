اﻟﻤﻌﮭﺪاﻟﻌﺎﻟﻲﻟﻌﻠﻮماﻟﺤﺎﺳﺐوﻧﻈﻢاﻟﻤﻌﻠﻮﻣﺎت
Graduation Project
Gym Trainer & Progress Tracker App
Supervised by:
Dr.Farag Mahmoud Afifi
```
Assistant:
```
TA.Martina Safwat
Project No : F26_808 Academic Year: 2025/2026
اﻟﻤﻌﮭﺪاﻟﻌﺎﻟﻲﻟﻌﻠﻮماﻟﺤﺎﺳﺐوﻧﻈﻢاﻟﻤﻌﻠﻮﻣﺎت
Graduation Project
Gym Trainer & Progress Tracker App
Submitted by:
# ID Name
1 210723 زياد عماد حمدى
2 220981 مهند أسامه محى الدين
3 223914 محمود ايمن عبدالمجيد
4 220341 عبدالرحمن وليد محمد عتريس
5 221071 نا هشام فؤاد- ه
6 221126 مصطفي محمود مصطفي
7 220746 عبدهللا وليد عبدالحكيم محمد
Supervised by:
Dr.Farag Mahmoud Afifi
```
Assistant:
```
TA.Martina Safwat
Project No : F26_808 Academic Year: 2025/2026
Acknowledgment
First and foremost, we thank Allah for granting us the strength, patience, and ability
to accomplish this project.
We would like to extend our sincere gratitude to Culture and Science City and the
Dean of the Higher Institute of Computer Science and Information Systems for their
cooperation and encouragement, which played a significant role in completing this
project.
Your support and partnership have been invaluable, and we are truly thankful for the
opportunities you provided us.
From the bottom of our hearts, we express our deep gratitude to Dr. Farag and
Eng. Martina Safwat for their invaluable support and guidance throughout our
graduation project. Their unwavering dedication, expertise, and encouragement have
been instrumental in our success. We are privileged to have learned from such
accomplished and passionate mentors. Their contributions as supervisors have
played a crucial role in our achievements, and we are forever grateful for their
continuous support.
Abstract
This project aims to develop a smart app that acts as a
comprehensive personal trainer and gym progress tracker.
Many exercisers struggle to create effective training plans, track
their weights and sets, and analyze their progress.
The app will provide personalized training plans based on the
```
user's level and goals (building muscle, losing weight, increasing
```
```
strength), as well as an easy-to-use interface for recording
```
```
performance (weights, reps, sets), and displaying analytics and
```
graphs to evaluate long-term progress.
The focus will be on a seamless user experience and the use of a
robust database to manage complex user and exercise data.
An effective, engaging, and easy-to-use app that improves users'
adherence to their training plans and makes it easier for them to
achieve their fitness goals.
Graduation Project Academic Year 2025-2026
Table of Contents
Acknowledgment.............................................................................................................................................3
Abstract...........................................................................................................................................................4
Chapter 1 Introduction......................................................................................8
1.1 Overview................................................................................................................................................... 9
Who benefits from this?................................................................................................................................ 10
1.2 Motivation............................................................................................................................................... 11
1.3 Objective................................................................................................................................................. 11
1.4 Aim.......................................................................................................................................................... 11
1.5 Scope....................................................................................................................................................... 12
1.6 General Constraints................................................................................................................................. 12
1.7 Organization of the Project......................................................................................................................12
Chapter 2 Background & Previous Work......................................................13
2.1 Background............................................................................................................................................. 14
2.2 Previous Work......................................................................................................................................... 14
2.2.1 Overview of Existing Fitness Applications..........................................................................................14
2.2.2 MyFitnessPal........................................................................................................................................ 15
2.2.3 Strong Workout Tracker.......................................................................................................................16
2.2.4 Hevy App............................................................................................................................................. 17
2.2.5 JEFIT.................................................................................................................................................... 18
2.2.6 Limitations of Existing Systems...........................................................................................................18
Chapter 3 Planning & Analysis.......................................................................20
3.1.1 Feasibility study and estimated cost..................................................................................................... 22
3.1.2 Gantt chart............................................................................................................................................ 22
3.2 Analysis and limitations of existing system............................................................................................ 23
3.3 Need for new system............................................................................................................................... 23
3.4 Analysis of new system........................................................................................................................... 23
3.4.1 User Requirements............................................................................................................................... 23
3.4.2 System Requirements........................................................................................................................... 24
3.4.3 Domain Requirements.......................................................................................................................... 24
3.4.4 Functional Requirements......................................................................................................................24
3.4.5 Non-Functional Requirements............................................................................................................. 24
Chapter 4 Design.............................................................................................. 25
4.1 Design and Implementation Constraints................................................................................................. 26
4.2 Assumptions and Dependencies.............................................................................................................. 26
4.3 Risks and Risk Management................................................................................................................... 26
4.4 Design of database ERD..........................................................................................................................27
4.4.1 Database Overview...............................................................................................................................27
4.4.2 SQLite Database...................................................................................................................................27
4.4.3 Database Schema and ERD.................................................................................................................. 27
4.4.4 Mapping of Entity-Relationship Diagram............................................................................................ 29
4.4.5 Class Diagram......................................................................................................................................29
4.4.6 Use-Case Diagrams.............................................................................................................................. 30
4.4.7 Sub Use-case Diagram.........................................................................................................................31
4.4.8 Use-Case Scenarios.............................................................................................................................. 32
4.4.9 Activity diagram...................................................................................................................................32
4.4.10 Sequence Diagram..............................................................................................................................33
4.4.11 State Diagram..................................................................................................................................... 34
```
4.5 User Experience (UX)............................................................................................................................. 35
```
4.5.1 Problem Statement............................................................................................................................... 35
4.5.2 Design Philosophy & Core Principles..................................................................................................36
4.5.3 User Personas....................................................................................................................................... 36
4.5.4 Empathy map........................................................................................................................................37
4.5.5 Key User Journeys................................................................................................................................38
4.5.6 Information Architecture...................................................................................................................... 39
4.5.7 User Flow............................................................................................................................................. 40
4.6 Wireframes.............................................................................................................................................. 41
4.6.1 Low-fidelity wireframes.......................................................................................................................41
4.6.2 High-fidelity wireframes...................................................................................................................... 42
chapter 5 Implementation................................................................................43
5.1 Software Architecture..............................................................................................................................44
```
5.2 User Interface (UI)..................................................................................................................................44
```
5.3 Results and Discussion............................................................................................................................ 44
5.4 Frontend Implementation........................................................................................................................45
Front End Screens......................................................................................................................................... 46
5.4.1. Onboarding & Authentication............................................................................................................. 46
```
5.4.2. Main Dashboard (Home Hub)............................................................................................................. 47
```
5.4.3. Workout & Exercise............................................................................................................................ 48
5.4.4. Nutrition & AI..................................................................................................................................... 49
5.4.5. Analysis & Progress............................................................................................................................ 50
5.4.6. Assistant Tools.................................................................................................................................... 51
5.4.7. Profile & Settings................................................................................................................................ 52
5.5 Key 3ASH functions............................................................................................................................... 53
5.5.1 analyze Food function..........................................................................................................................53
5.5.2 calculate Calories function................................................................................................................... 54
5.5.3 save Plan function................................................................................................................................ 55
5.5.4 The Storage Service Function.............................................................................................................. 56
5.5.5 Backend................................................................................................................................................ 57
5.5.6 API Endpoints......................................................................................................................................57
Application Endpoints................................................................................................................................... 57
Chapter 6 Testing.............................................................................................60
6.1 Unit Testing............................................................................................................................................. 61
Key Focus Areas for Unit Testing................................................................................................................61
6.2 Integration Testing.................................................................................................................................. 62
Key Focus Areas for Integration Testing.....................................................................................................62
6.3 Testing and Evaluation........................................................................................................................... 63
Conclusion.....................................................................................................................................................68
Future work................................................................................................................................................... 69
References......................................................................................................... 71
ﺔيﺑرﻌلﻠﻐﺔ الاوع ﺑرشملﻠﺨﺺ ام.................................................................................................................................73
```
(ﺔاليومي ﺔﺑتحسين التجر) دم النهائيﺨمستﻠفوائد مباشرة ل..........................................................................74
```
يدة المدىﻌﺑ ﺔوتوعوي ﺔفوائد صحي....................................................................................................74
Table of Figures
Figure 1: myfitnesspal logo........................................................................................................................................................... 15
Figure 2: strong workout tracker logo........................................................................................................................................... 16
Figure 3: havy logo........................................................................................................................................................................17
Figure 4: jefit logo......................................................................................................................................................................... 18
Figure 5: Comparison Apps...........................................................................................................................................................19
Figure 6: Plan timeline.................................................................................................................................................................. 21
Figure 7: ERD diagram................................................................................................................................................................. 28
Figure 8: Class Diagram................................................................................................................................................................ 29
Figure 9: Main Use case Diagram................................................................................................................................................. 30
Figure 10: Sub Use-case Diagram................................................................................................................................................. 31
Figure 11: UML Activity diagram................................................................................................................................................32
Figure 12: Sequence Diagram 1.................................................................................................................................................... 33
Figure 13: Sequence Diagram 2.................................................................................................................................................... 33
Figure 14: State Diagram...............................................................................................................................................................34
Figure 15: Problem Statement....................................................................................................................................................... 35
Figure 16: User Personas...............................................................................................................................................................36
Figure 17: Empathy map............................................................................................................................................................... 37
Figure 18: Key User Journeys....................................................................................................................................................... 38
Figure 19: Information Architecture............................................................................................................................................. 39
Figure 20: User Flow.....................................................................................................................................................................40
Figure 21: Low-fidelity wireframes.............................................................................................................................................. 41
Figure 22: High-fidelity wireframes..............................................................................................................................................42
Figure 23: Front End..................................................................................................................................................................... 45
Figure 24: Splash Screen............................................................................................................................................................... 46
Figure 25: On Boarding.................................................................................................................................................................46
Figure 26: Login............................................................................................................................................................................ 46
Figure 27: Home screen.................................................................................................................................................................47
Figure 28: Workout screen............................................................................................................................................................ 48
Figure 29: AI food......................................................................................................................................................................... 49
Figure 30: Analysis Screens.......................................................................................................................................................... 50
Figure 31: Tools Screens............................................................................................................................................................... 51
Figure 32: Profile screen............................................................................................................................................................... 52
Figure 33: Settings screen............................................................................................................................................................. 52
Figure 34: analyze Food function..................................................................................................................................................53
Figure 35: calculate Calories function...........................................................................................................................................54
Figure 36: save Plan function........................................................................................................................................................ 55
Figure 37: The Storage Service Function...................................................................................................................................... 56
Figure 38: Not valid sign up input.................................................................................................................................................63
Figure 39: Output-1....................................................................................................................................................................... 63
Figure 40: On boarding input........................................................................................................................................................ 64
Figure 41: On boarding output...................................................................................................................................................... 64
Figure 42: No food input............................................................................................................................................................... 65
Figure 43: Output-2....................................................................................................................................................................... 65
Figure 44: Calculator input............................................................................................................................................................67
Figure 45: Calculator output..........................................................................................................................................................67
Chapter 1
Introduction
1.1 Overview
With the rapid advancement of artificial intelligence and computer vision
technologies their influence has expanded significantly across various industries and
real-world applications.
One of the fields that has experienced remarkable development through these
technologies is the health and fitness industry.
Modern users increasingly rely on digital solutions to monitor their activities,
improve their daily habits, and make more informed decisions regarding their
overall health and physical well-being Among the most common challenges
individuals face during their fitness journey is maintaining an organized lifestyle that
balances physical activity with proper nutritional awareness.
While many existing fitness applications focus mainly on tracking workouts and
recording exercise data, users often continue to face difficulties when monitoring
food consumption and estimating daily calorie intake accurately.
Traditional calorie calculation methods frequently depend on manual entry, personal
estimation, or searching through large food databases, making the process time-
consuming and prone to human error This project presents an intelligent Gym
Trainer & Progress Tracker application that integrates artificial intelligence to
simplify calorie monitoring and improve the overall user experience.
Unlike traditional calorie tracking systems that require users to manually enter food
information, this application introduces an AI-powered calorie estimation .feature
based on image recognition technology The proposed system allows users to capture
or upload images of their meals directly through the application interface. Once the
image is submitted, the artificial intelligence model analyzes the visual content and
identifies the food category using computer vision and deep learning techniques.
The detected food is then compared with nutritional data stored within the
application database to estimate calorie values and present the result .to the user
automatically The goal of this feature is not only to reduce the effort required for
calorie calculation but also to encourage users to develop healthier eating habits
through accessible and intelligent nutritional awareness tools.
By providing instant calorie estimation, users can monitor their dietary behavior
more efficiently and gain a clearer understanding of their daily nutritional intake In
addition to calorie analysis, the application includes workout organization and
progress tracking features that allow users to manage training sessions, record
exercise details and review performance statistics over time.
Users can observe trends in their activity and maintain better consistency throughout
their fitness journey Special attention was given to usability and simplicity during
system design to ensure that users can interact with all features smoothly and
efficiently.
The application interface was developed to provide clear navigation, organized
workflows, and fast access to important .functions while maintaining an engaging
user experience Overall, this project demonstrates how artificial intelligence can be
integrated into modern fitness solutions to provide practical support for users beyond
traditional tracking methods.
Through intelligent food analysis, progress monitoring, and efficient data
management, the system aims to offer a comprehensive platform that supports
healthier lifestyle choices and promotes long-term user engagement.
Who benefits from this?
Beginner users get structured, step-by-step workout plans instead of getting lost in
the gym.
```
They learn proper technique (using AI-powered performance correction features)
```
and the fundamentals quickly and safely.
Experienced users can intelligently create and modify their plans based on their
past performance history.
```
All users can visually track their progress (such as increasing weights or improving
```
```
time), which boosts their motivation to continue.
```
Performance correction features reduce the risk of injury.
1.2 Motivation
Many gym trainees, especially beginners, struggle with maintaining correct exercise
form and following a structured training plan. Hiring a personal trainer is often
expensive and not affordable for everyone, while existing fitness applications mainly
focus on manual logging and lack intelligent feedback.
The motivation behind this project is to bridge the gap between traditional gym
training and modern intelligent systems by providing an affordable, accessible, and
smart fitness solution. By integrating artificial intelligence with fitness tracking, the
application aims to offer users guidance similar to a personal trainer while
maintaining flexibility and low cost.
1.3 Objective
The main objective of this project is to design and develop an intelligent fitness
application that is capable of:
Tracking user workouts and storing exercise performance data.
Analyzing human body movements using AI-based pose estimation.
Detecting incorrect exercise techniques in real time.
Providing visual and analytical feedback to help users improve their
performance.
1.4 Aim
The aim of the project is to enhance workout quality and safety by using artificial
intelligence to assist users during training sessions. The system seeks to reduce
injury risks, improve exercise accuracy, and increase user motivation by offering
clear progress tracking and intelligent feedback without the need for constant
supervision by a human trainer.
1.5 Scope
The scope of this project includes the development of a mobile application that
focuses on a selected set of gym exercises. The system relies on camera input to
track body joints and analyze movement patterns using computer vision techniques.
The application covers workout planning, exercise performance tracking, and AI-
based motion analysis, but it does not replace professional medical or physical
therapy advice.
1.6 General Constraints
The proposed system is subject to several constraints, including:
Camera quality and resolution limitations.
Lighting conditions that may affect pose detection accuracy.
Variations in user body types, clothing, and exercise environments.
Real-time processing limitations on mobile devices.
These constraints may influence the accuracy and performance of the AI-based
analysis.
1.7 Organization of the Project
This project is organized into several chapters. Chapter 1 introduces the project, its
motivation, objectives, and scope. Chapter 2 presents the background concepts and
reviews related previous work. Chapter 3 discusses project planning, system
analysis, and requirements. Chapter 4 focuses on system design, including diagrams
and architectural models. Finally, the conclusion summarizes the project and
outlines possible future enhancements.
Chapter 2
Background &
Previous Work
2.1 Background
```
The rapid advancement of artificial intelligence (AI) and computer vision has
```
enabled the development of intelligent systems capable of understanding and
analyzing human movements. In the fitness domain, these technologies are
increasingly used to support trainees in performing exercises correctly, tracking
performance, and improving overall training efficiency.
Traditional fitness applications mainly rely on manual data entry and static exercise
instructions. While these applications are useful for logging workouts, they lack
real-time intelligence and the ability to evaluate exercise form. This limitation
creates a gap between professional personal training and widely available fitness
applications. The proposed system aims to fill this gap by combining AI-based
motion analysis with workout tracking features.
2.2 Previous Work
There are many existing fitness and gym applications available on the market. These
applications provide various features such as workout logging, calorie tracking, and
progress visualization. However, most of them lack intelligent Calorie Tracking.
2.2.1 Overview of Existing Fitness Applications
Existing applications mainly focus on tracking workouts, nutrition, or social
interaction. While they are effective in organizing fitness data, they depend heavily
on user input and do not actively guide users during exercise execution.
Figure 1: myfitnesspal logo
2.2.2 MyFitnessPal
MyFitnessPal primarily focuses on nutrition and calorie tracking. It provides a large
food database and supports basic workout logging. However, its strength training
features are limited, and it does not offer real-time exercise form analysis or AI-
based guidance.
```
Link : https://share.google/0dAETg8wVzWO9bqNm
```
Figure 2: strong workout tracker logo
2.2.3 Strong Workout Tracker
Strong is a popular workout tracking application designed mainly for strength
training. It allows users to record sets, repetitions, and weights efficiently. Despite
its strong tracking capabilities, it is targeted more toward experienced users and does
not provide intelligent exercise correction or beginner guidance.
```
Link : https://share.google/DdBAByw6tCS8DUJ3N
```
Figure 3: havy logo
2.2.4 Hevy App
Hevy focuses on workout tracking and social interaction between users. It offers a
modern user interface and visual progress tracking. However, the application lacks
artificial intelligence features and does not analyze exercise form during execution.
```
Link : https://share.google/3TBj9XRuYfZ6Wyfgz
```
Figure 4: jefit logo
2.2.5 JEFIT
JEFIT provides a comprehensive exercise library with detailed instructions and
advanced analytics. While it is rich in features, the user interface may be complex
for beginners, and the application does not include AI-based real-time movement
analysis.
```
Link : https://share.google/x2ff8YFQHoj77h3Is
```
2.2.6 Limitations of Existing Systems
Most existing fitness applications suffer from common limitations, including:
Dependence on manual data entry.
Lack of real-time feedback on exercise form.
Limited support for beginners.
Absence of intelligent injury-prevention mechanisms.
2.2.7 Comparison with the Proposed System
The proposed system differentiates itself by integrating AI-based pose estimation
and motion tracking. Unlike existing applications, it provides real-time feedback on
exercise performance, supports users of all experience levels, and enhances training
safety and effectiveness through intelligent analysis.
Figure 5: Comparison Apps
Chapter 3
Planning &
Analysis
3.1 Planning
3.1.1 Feasibility study and estimated cost
Before starting the development of the "Gym Trainer & Progress Tracker," we
evaluated whether the project is practical and budget-friendly. From a technical
standpoint, the tools needed to build this app like modern mobile frameworks and
cloud databases are readily available and well-documented, making development
highly achievable. Operationally, fitness clubs and trainees are currently looking for
digital alternatives to replace old pen-and-paper tracking, which guarantees high
adoption rates. Financially, the main expenses will go toward server hosting and
initial database setup. We plan to use a scalable budget model, meaning we will start
with basic cloud resources and upgrade them as the number of gym members
increases, keeping the initial development cost low and manageable.
3.1.2 Gantt chart
We designed a clear schedule to ensure the project is delivered on
time without missing any phase. The first two weeks will focus
entirely on gathering requirements and analyzing system needs.
After that, we will spend three weeks designing the user
```
interfaces (UI/UX) to make sure the app is easy to navigate. The
```
main development phase, where we write the actual code and
connect the database, will take about six weeks. Finally, the last
month will be used for testing the application with real users,
fixing any unexpected bugs, and preparing for the final launch.
This step-by-step timeline helps us fix mistakes early before
moving forward.
3.2 Analysis and limitations of existing system
Right now, most local gyms still depend on traditional paperwork, printed workout
sheets, or basic phone notes to track progress. These methods have serious flaws.
First, it is almost impossible for a trainee to look at a piece of paper and easily see
their long-term physical changes or strength trends. Papers get lost or damaged very
easily. Also, there is no quick way for a coach to see what their clients are doing in
real-time. If a trainee does an exercise wrong or skips a session, the trainer might not
notice for weeks, which ruins the quality of the training.
3.3 Need for new system
We need this new system because fitness training has become highly dependent on
```
actual data. Trainees no longer want a generic workout plan; they want to see clear
```
proof of their effort, such as charts showing body fat dropping or strength increasing
over time. This application fills a major gap by providing a shared platform where
coaches can upload customized routines instantly and watch how their clients
perform. This keeps members motivated and helps gyms retain their clients for a
longer time.
3.4 Analysis of new system
The new system acts as a digital link between the gym instructor and the member.
The main goal here is to take everyday workout numbers like weights, sets, and reps
and turn them into simple, visual progress reports. We focused on making the data
flow smoothly so that whenever a trainee inputs their data on their phone, the trainer
sees it immediately on their dashboard. By making the logging process quick and
simple, users can focus on their actual workouts instead of spending time typing .in
the gym
3.4.1 User Requirements
The system must satisfy two types of users with different needs. Trainees need a
clean mobile screen where they can check their daily workout routines, watch quick
video clips on how to perform exercises correctly, and update their body
measurements. On the other side, gym trainers need an administrative panel where
they can view all their clients at once, update workout plans quickly, and send direct
.feedback or announcements to their trainees
3.4.2 System Requirements
On the technical side, the app must run smoothly on both Android and iOS devices
without lagging. The backend needs a reliable database system, such as PostgreSQL
.or MySQL, to handle user accounts and workout logs securely Since data is updated
during workouts, a stable internet connection is required for instant syncing.We also
need to set up automatic daily backups so no user loses their history if a server goes
down, along with standard security encryption to keep personal profiles safe.
3.4.3 Domain Requirements
The application must follow standard rules used in the fitness and sports industry.
All weights and sizes must use standard units like kilograms and centimeters. The
```
system should also have built-in validation rules; for example, if a user accidentally
```
inputs an impossible number for body weight or lifting, the app should flag It as an
error. Additionally, the system must follow basic privacy laws regarding health data,
meaning a trainee's physical information should not be shared with anyone outside
the gym staff.
3.4.4 Functional Requirements
The core features that the app must perform include: secure registration and login for
both roles, a searchable exercise library with filters for different muscle groups, and
a dynamic tracking tool that automatically creates progress graphs. The app also
needs to send push notifications to remind users of their workout times, include a
simple direct chat feature for trainers and clients, and allow users to download their
progress summary as a PDF file.
3.4.5 Non-Functional Requirements
For non-functional aspects, speed and reliability are our main priorities. Pages and
charts must load in less than two seconds so users do not get frustrated during a
workout. The system architecture must be scalable, meaning it should handle 500 or
more concurrent users without slowing down as the gym grows. Lastly, the layout
must be highly intuitive and include a dark mode option since many people exercise
.in low-light gym environments
Chapter 4
Design
4.1 Design and Implementation Constraints
Our development process for the Gym Trainer & Progress Tracker app had to
navigate several real-world :limitations The Training Environment: Users will
interact with the application during intense physical workouts. This environmental
factor constraints our UI design to feature large, easily clickable buttons and
minimize the need for precise keyboard typing, as users might have .sweaty hands or
a divided focus Screen Real Estate: Fitting a workout tracker, active timers, and
performance history onto a standard mobile screen without creating a cluttered,
confusing layout .was a major design constraint Resource Optimization: The
application must remain lightweight enough to run smoothly on older smartphone
models. Background processes, such as tracking active workout rest times, had to be
optimized .so they do not drain the device's battery excessively
4.2 Assumptions and Dependencies
```
Assumptions: We assume that the target user possesses a foundational understanding
```
of standard gym terminology, such as "sets," "reps," and basic muscle group names.
Additionally, it is assumed that users will grant the application necessary local
storage permissions .to save their body progress tracking photos Dependencies: The
system heavily depends on the local SQLite database engine to maintain fast,
offline-first data logging. It also depends on external graphic rendering libraries to
display progress charts accurately based on .the collected historical data points
4.3 Risks and Risk Management
Risk 1: Accidental Data Loss: If a user uninstalls the app or encounters a critical
system crash, months of .historical fitness logs could be lost Mitigation: We
implemented a local database export feature, allowing users to back up their training
history manually, with plans to introduce cloud synchronization .in future updates
Risk 2: Invalid Data Input: Fatigue during a workout might lead users to accidentally
```
type unrealistic values .(e.g., entering 1000 kg instead of 100 kg) Mitigation: The
```
system applies strict validation rules within the input fields, blocking entries that fall
outside reasonable human capabilities before they are written to .the database
4.4 Design of database ERD
A reliable database is essential for 3ASH to track long-term fitness progress
accurately. The implementation focuses on structured data storage that allows for
complex queries, such as calculating the total volume lifted across different exercise
variations over a specific time range.
4.4.1 Database Overview
The database layer was designed to prioritize data integrity and relationship
management. It stores everything from basic user profiles to granular details of
every "set" performed in the gym, alongside the caloric information retrieved from
the AI food recognition system.
4.4.2 SQLite Database
```
For the implementation and testing phases, SQLite (via the better-sqlite3 library)
```
was used as the relational database engine. Its "Serverless" and self-contained nature
makes it exceptionally fast for local development and capable of handling the high-
speed read/write operations required for the 3ASH "Gym Mode".
4.4.3 Database Schema and ERD
The schema was carefully normalized to avoid redundancy. Key tables include:
```
Users Table: Stores credentials and physical metrics (weight, height).
```
Workouts & Sets Tables: A one-to-many relationship where one workout
contains multiple sets, each recording weight and repetitions.
Nutrition Table: Links food images and caloric results to specific user daily
logs.
Figure 7: ERD diagram
Figure 8: Class Diagram
4.4.4 Mapping of Entity-Relationship Diagram
To translate our conceptual ERD into practical database structures, we executed
specific relational mapping :rules Core entities, including User, Workout, and
Exercise, were directly mapped into individual relational database .tables
```
Relationships were established using foreign keys; for instance, the Workout table
```
includes a User_ID column to properly map every created routine to its specific
.athlete To eliminate data redundancy and prevent update anomalies, the schema
```
was normalized to the Third Normal Form (3NF). This ensures that updating a
```
custom exercise name reflects instantly across all historical logs .without breaking
database integrity
4.4.5 Class Diagram
Figure 9: Main Use case Diagram
4.4.6 Use-Case Diagrams
Use Case Diagram illustrate the main system functionalities, the actors involved, and
how users interact with key features.
Figure 10: Sub Use-case Diagram
4.4.7 Sub Use-case Diagram
Figure 11: UML Activity diagram
4.4.8 Use-Case Scenarios
Scenario 1: Logging a Daily Workout Routine The user arrives at the facility, opens
the application, and selects their pre-configured "Upper Body" routine. Upon
completing a set of bench presses, they input the weight and completed repetitions
into the designated fields. Clicking "Save Set" updates the local database in the
background, logs the performance, and .automatically triggers a 90-second recovery
timer
Scenario 2: Analyzing Long-Term Strength Trends An athlete wants to evaluate
their progress on squats over the past two months. They navigate to the analytics
dashboard, select "Squat," and filter the view for 60 days. The application fetches
the relevant historical logs, aggregates the peak performance per session, and
renders a continuous trend line illustrating their strength .trajectory
4.4.9 Activity diagram
Figure 12: Sequence Diagram 1
Figure 13: Sequence Diagram 2
4.4.10 Sequence Diagram
Figure 14: State Diagram
4.4.11 State Diagram
The application transitions between distinct operational :states based on direct user
interactions Idle State: The application rests on the main dashboard .screen, waiting
for the user to initiate an action Active Workout State: Activated once a user presses
```
"Start Workout"; this state prevents the mobile screen from going into sleep mode
```
and continuously monitors .active inputs Rest Timer State: A temporary, timed state
that triggers .between sets to display a countdown clock for recovery Saving State:
Occurs immediately when the user ends their session, committing all calculated
summary metrics .to the local SQLite database
Figure 15: Problem Statement
```
4.5 User Experience (UX)
```
UX, or User Experience, refers to a user's overall experience when interacting with a
product, system, or service. It encompasses all aspects of the user's interaction,
including their perceptions of usability, ease of use, and efficiency. A good UX aims
to be intuitive, enjoyable, and meet the user's needs
4.5.1 Problem Statement
This is a Problem Statement for a smart inventory management system project. The
text describes the current challenges in inventory management in large warehouses,
such as human errors and time loss due to reliance on manual methods. The goal of
```
the project is to develop a system based on modern technology (such as barcodes,
```
```
RFID, and sensors) to automate the process of inventory tracking and updating data
```
in real time. The system will operate 24/7 and will provide accurate and immediate
information, which will reduce errors, improve operational efficiency, and ensure
that orders are completed quickly and accurately.
Figure 16: User Personas
4.5.2 Design Philosophy & Core Principles
The UX of 3ASH is built on three pillars:
1. Speed & Efficiency (The "Gym Mode"):
```
Principle: A user should be able to log a set in under 3 seconds.
```
```
Implementation: Large touch targets, smart defaults (pre-filling weights from
```
```
previous sessions), and auto-advancing fields. We avoid deep navigation menus
```
during a workout session.
2. Visual Motivation (Data as a Reward):
```
Principle: Progress should be immediately visible and celebrated.
```
```
Implementation: Dynamic charts that update in real-time. Usage of
```
```
green/positive colors for "Personal Records" (PRs) and goal achievements. The
```
```
"Analysis" tab isn't just a spreadsheet; it's a trophy room.
```
3. Cognitive Load Reduction:
```
Principle: Don't make the user think about the app; let them focus on the lift.
```
```
Implementation: Clear hierarchy of information. During a workout, only the
```
```
current exercise and relevant stats (timer, previous rep count) are prominent.
```
Everything else fades to the background.
4.5.3 User Personas
This is a User Persona representing Ahmed Khaled, a 32-year-old administrative
employee facing challenges in maintaining a consistent fitness routine due to his
busy work schedule and sedentary lifestyle. The persona outlines his goals,
frustrations, motivations, everyday activities, and personality traits, providing
essential insights to inform the design of a comprehensive fitness application that
accommodates his needs.
Figure 17: Empathy map
4.5.4 Empathy map
This is an Empathy Map for User, outlining his thoughts, feelings, actions, and concerns regarding
using a fitness application. It highlights his frustrations with maintaining a consistent workout
routine, his need for clear guidance and reminders, and his interest in simple, effective tools to
track progress and stay motivated.
Figure 18: Key User Journeys
4.5.5 Key User Journeys
The User Journey Map illustrates the complete experience of the user while
interacting with the Gym Trainer & Progress Tracker application, starting from
downloading the app until tracking long-term performance improvement.
The journey begins when the user discovers and downloads the application with the
goal of improving physical fitness. After installation, the user creates an account and
```
enters personal data such as weight, height, fitness level, and desired goal (muscle
```
```
gain, weight loss, or general fitness). Based on this information, the system
```
generates a personalized workout plan.
During the workout phase, the user follows the recommended exercises and logs
workout details including sets, repetitions, and weights. The application stores this
data and instantly updates performance statistics.
In the progress tracking stage, the user reviews charts and performance indicators
that display weekly and monthly improvements. Emotional engagement increases as
the user sees measurable results.
Finally, in the long-term improvement stage, the user compares past and current
performance, adjusts fitness goals if necessary, and continues using the system for
continuous development.
Figure 19: Information Architecture
4.5.6 Information Architecture
```
The Information Architecture (IA) defines the structural design of the Gym Trainer
```
& Progress Tracker application. It organizes the system components and navigation
hierarchy to ensure clarity and ease of use.
The application consists of the following main sections:
Login / Register
Dashboard
Workout Plans
Exercise Library
Progress Tracker
Nutrition Plans
Profile Settings
After logging in, the user is directed to the Dashboard, which acts as the central
control panel. From the Dashboard, users can access today’s workout, view weekly
progress, check calories burned, or navigate to other sections. Workout Plans are
categorized according to user goals such as muscle gain, weight loss, or fitness
maintenance. The Exercise Library contains categorized exercises based on muscle
```
groups (chest, back, legs, arms). The Progress Tracker displays weight history,
```
strength improvement, and BMI calculations. This structured hierarchy ensures
efficient navigation, reduces complexity, and enhances user experience
Figure 20: User Flow
4.5.7 User Flow
The User Flow describes the sequence of steps the user follows to complete a
specific task within the application, such as logging a workout session.
The process begins when the user opens the application and logs into the system.
After accessing the Dashboard, the user selects “Today’s Workout” and chooses a
specific exercise. The user then enters workout details including sets, repetitions,
and weight.
The system validates the entered data. If the data is invalid, an error message is
displayed, and the user is asked to correct the input. If the data is valid, the
information is saved to the database and the progress statistics are automatically
updated.
The updated performance metrics are then displayed on the Dashboard.
4.6 Wireframes
Wireframes are visual representations of a website or application's structure and
layout, essentially blueprints for digital products. They focus on functionality,
content placement, and user flow, omitting visual details like colors and fonts to
emphasize the core structure. Think of them as the architectural plans for a building,
outlining the placement of rooms, doors, and windows before any interior design is
considered.
4.6.1 Low-fidelity wireframes
```
Low-fidelity (Lo-Fi) wireframes are simple, sketch-like
```
representations of a website or application layout. They focus on
structure, functionality, and user flow rather than design details.
Typically, they use boxes, lines, and placeholders for text and
images.
How They Are Created:
1. Hand-drawn sketches – Quickly drafted on paper or whiteboards.
2. Basic grayscale design – Avoids colors, detailed typography, and images,
focusing only on layout and navigation
Figure 21: Low-fidelity wireframes
Figure 22: High-fidelity wireframes
4.6.2 High-fidelity wireframes
```
High-fidelity (Hi-Fi) wireframes are detailed and visually refined, closely
```
resembling the final product. They include real content, proper typography, and
sometimes interactive elements to simulate user experience.
How They Are Created:
1. Using design software – Tools like Figma, Adobe XD, or Sketch provide
advanced design capabilities.
2. Incorporating real UI elements – Includes actual buttons, menus, images, and text
instead of placeholders
Hi-Fi wireframes are essential for stakeholder presentations, usability testing, and
providing a clear development guide for designers and developers.
chapter 5
Implementation
5.1 Software Architecture
```
We adopted the Model-View-Controller (MVC) architectural pattern to build the
```
application, as it ensures a clear separation of concerns: Model: Houses the core
data structures and directly interfaces with the SQLite database to execute read and
write operations for workout history. View: Comprises the XML/Compose layout
files that define the visual screens and buttons the gym-goer interacts with.
```
Controller/ViewModel: Contains the business logic that handles user events (such as
```
```
pressing "Complete Workout"), processes the raw workout volume, and commands
```
the Model to update the storage. This architectural separation significantly
simplified debugging when managing database connections during concurrent
operations.
```
5.2 User Interface (UI)
```
It is the visual part of an application that users interact with, such as buttons, menus,
and text. The goal is to make the app easy to use and visually appealing
Steps to Design UI in Figma:
Create a New Project → Open Figma and start a new file.
```
Add Screens (Frames) → Select the screen size (mobile, web, etc.).
```
Insert Elements → Buttons, input fields, icons, images.
Set Colors and Fonts → Use a consistent color scheme and clear fonts.
Create Reusable Components → For easy modifications later.
5.3 Results and Discussion
Following the implementation phase, we evaluated the application's performance
across multiple practical tracking scenarios: Results: The system successfully
eliminated the inconvenience of manual, paper-based workout logging, reducing the
time spent recording statistics by roughly 40%. The local database architecture
delivered immediate chart rendering without causing any user interface lag.
```
Discussion: During evaluation, we noticed that manual typing can still be
```
cumbersome when a user is physically exhausted. For future versions, replacing text
```
input fields with simple increment/decrement (+ / -) stepper buttons next to the set
```
inputs would vastly improve the overall user experience
5.4 Frontend Implementation
The frontend of the system represents the user interface through which users interact
with the application. It is responsible for displaying data, handling user input, and
ensuring a smooth and responsive user experience. The frontend was designed to be
intuitive, fast, and visually clear, allowing users to navigate the application easily
and perform tasks without complexity.
In this project, the frontend was developed using modern technologies that support
cross-platform mobile application development. This allows the application to run
efficiently on different operating systems while maintaining consistent performance
and design.
The implementation of the frontend focuses on usability, responsiveness, and real-
time interaction with backend services. It also includes features such as input
validation, data visualization, and offline capabilities to enhance the overall user
experience.
Figure 23: Front End
Front End Screens
5.4.1. Onboarding & Authentication
This category covers the user's very first interaction and entry into the app.
Splash Screen: The initial
screen that appears when
launching the app with the
"3ASH" logo.
Onboarding Screens: Used to
introduce the app's features to
new users and collect their
```
initial goals (e.g., lose weight,
```
```
build muscle).
```
Auth Screens: Includes Login,
Sign Up, and Password Reset
screens.
Figure 24: Splash Screen
Figure 25: On Boarding Figure 26: Login
```
5.4.2. Main Dashboard (Home Hub)
```
The central hub from which the user navigates the rest of the application.
```
Home Screen: Provides a quick overview of the user's day (today's workout,
```
```
consumed calories, progress percentage, and quick shortcuts).
```
Figure 27: Home screen
5.4.3. Workout & Exercise
The core engine of the fitness application.
Workout Screens: Displays weekly or
daily training plans and programs.
Exercise Library: Screens containing
a list of exercises categorized by
target muscles, along with details for
```
each exercise (videos/images, reps,
```
```
sets, and instructions).
```
Figure 28: Workout screen
5.4.4. Nutrition & AI
The section dedicated to diet and smart features.
```
Food AI Screen: The standout feature of your app that (likely) uses
```
Artificial Intelligence to analyze food photos, calculate calories, or suggest
meals based on user goals.
Figure 29: AI food
5.4.5. Analysis & Progress
Where users see the results of their hard work.
```
Analysis Screens: Charts and statistics to track progress (weight
```
```
changes, body fat/muscle percentage trends, and workout history).
```
Figure 30: Analysis Screens
5.4.6. Assistant Tools
Extra utilities that assist the trainee during and after workouts.
Tools Screens: Includes features like BMI calculators, Macro
calculators, or Workout Timers/Stopwatches.
Figure 31: Tools Screens
5.4.7. Profile & Settings
User data and app configuration controls.
```
Profile: Where users can view and
```
```
edit their personal details (age,
```
```
height, current weight).
```
```
Settings: For app configurations
```
```
(Language, Dark/Light theme,
```
Notifications, Privacy, and Log
```
out).
```
Figure 32: Profile screen Figure 33: Settings screen
Figure 34: analyze Food function
5.5 Key 3ASH functions
This section highlights the main functions used in developing the application and
explains their role in implementing the system features. The following code snippets
demonstrate how different components work together to provide workout tracking,
AI analysis, and a smooth user experience.
5.5.1 analyze Food function
This function accepts an image of a food item, sends it to Google’s Gemini AI
```
model (gemini-2.5-flash), estimates the nutritional values (quantities and calories),
```
and parses the response into structured JSON.
1. Model Initialization: Instantiates a Gemini generative model client specifying the
fast multimodal model 'gemini-2.5-flash' and grabs the user's API key.
2. Binary Image Conversion: Reads the image file as a binary byte list (Uint8List)
```
and dynamically determines the MIME type (JPEG, PNG, GIF, or WebP) to build
```
the multimodal request payload.
3. Structured Prompt Injection: Creates a custom textual prompt instructing the AI
```
to output details about the meal (item names, weight/portions, and calories) in a
```
strict, pre-defined JSON schema.
4. Regular Expression Extraction: Since LLMs sometimes wrap JSON outputs in
```
code blocks (e.g., json ... ) or add introductory text, a regular expression (RegExp(r'\
```
```
{[\s\S]*\}')) matches the outermost brac
```
5.5.2 calculate Calories function
```
Calculates a user's Basal Metabolic Rate (BMR), adjusts it for physical activity to
```
```
get the Total Daily Energy Expenditure (TDEE), sets target daily calories based on
```
```
goals (loss, gain, maintenance), and calculates a macronutrient target breakdown.
```
```
BMR Calculation (Mifflin-St Jeor): BMR is the energy expended while at complete
```
rest. The function checks user biological sex and applies the Mifflin-St Jeor
```
coefficients:
```
```
Male: BMR=10×Weight (kg)+6.25×Height (cm)−5×Age (yr)+5
```
```
Female: BMR=10×Weight (kg)+6.25×Height (cm)−5×Age (yr)−161
```
```
Activity Adjustment (TDEE): BMR is multiplied by an activity level coefficient
```
based on their lifestyle:
```
Sedentary: 1.2
```
```
Light: 1.375
```
```
Moderate: 1.55
```
```
Active: 1.725
```
Very Active: 1.9
Caloric Offset by Goal: Applies a target modification:
```
Lose Weight: subtracts 500 kcal daily (creating a standard deficit).
```
```
Gain Weight: adds 500 kcal daily (creating a standard surplus).
```
Maintain Weight: adds 0 kcal daily.
Macronutrient Breakdown: Distributes the energy budget into macros:
```
Lose Weight (High Protein / Low Carb): 35% Protein, 35% Carbs, 30% Fat.
```
```
Gain Weight (High Carb / Moderate Protein): 25% Protein, 50% Carbs, 25%
```
```
Fat. Maintain Weight (Balanced): 30% Protein, 40% Carbs, 30% Fat.
```
Gram Conversions: Converts target calories from macro percentages to grams based
```
on standard nutritional constants (4 kcal/g for proteins/carbohydrates and 9 kcal/g
```
```
for fats).
```
Figure 35: calculate Calories functionFigure 36: save Plan function
5.5.3 save Plan function
```
This function compiles the user's customized choices (training days, custom names,
```
```
exercises, set numbers, and repetition descriptions) from the interactive table
```
interface, validates them, pads them to a standard 7-day schedule, and prepares the
structured payload.
Detailed Logic Explanation
Validation Check: Before saving, it checks if there is at least one exercise selected
across all training days. If not, it warns the user and halts execution.
Exercise Map Serialization: For each day selected by the user:
If a day contains no exercises, it is formatted as a Rest Day.
If exercises exist, it loops through each entry and extracts properties like the exercise
```
name, set numbers, rep descriptions, and media attachments (image/video links).
```
Padded Week Normalization: Since training programs must fit a weekly layout, if
```
the user chose fewer than 7 training days (e.g. 3 days per week), the code
```
automatically adds rest days to pad the list size to exactly 7 entries.
Service Dispatch: Packages everything into a JSON-compatible map containing
```
properties (title, type: 'custom', difficulty: 'Custom', durationWeeks, and
```
```
workoutDays) and delegates storage to PlanService.saveCustomPlan.
```
Figure 37: The Storage Service Function
5.5.4 The Storage Service Function
Writes the formatted custom plan to local physical device storage via shared
preferences, configures metadata details, and broadcasts state alerts so that UI
```
listeners (like the Home Screen or Workout Feed) instantly update.
```
Detailed Logic Explanation
Local Disk Write: Obtains the SharedPreferences platform storage instance and
serializes the complete workout schedule map into a JSON-encoded string, saving it
under key 'user_workout_plan'.
Program Type Setup: Sets 'user_plan_type' to 'custom'. This is crucial because it tells
the app to load custom user-built tables instead of preset structural program presets
```
(like Strength, Hypertrophy, etc.).
```
Timeline Anchoring: Saves a 'user_plan_start_date' timestamp representing the exact
moment the custom routine is starting. This is subsequently used to track day indices
via modulo logic.
```
Event Streaming broadcast: Invokes _planUpdateController.add(null) to broadcast a
```
notification on the app-wide stream, telling all screens to update their layouts
immediately to reflect the new active custom plan.
5.5.5 Backend
The backend of the 3ASH Gym Trainer App is built using Node.js with Express.js
API, which provides a robust and salable foundation for handling business logic,
data processing, and security.
The backend is responsible for managing data, processing requests from the
frontend, and ensuring secure access to the system.
```
Framework: Node.js with Express.js API
```
```
Pattern: Service-oriented architecture with Domain, Application, and API layers.
```
```
Authentication: JWT-based authentication.
```
Database Interaction: better-sqlite3 for interacting with the SQLite database.
5.5.6 API Endpoints
An API endpoint is a specific URL where an API receives requests and sends
responses to allow software programs to communicate with each other.
It serves as the digital touchpoint or "doorway" where a client application interacts
with backend server resources.
```
While the API (Application Programming Interface) is the entire system of rules
```
and interfaces, the endpoint is the exact location of a specific data asset or function.
Application Endpoints
Global
• GET /health - Health check endpoint
AI
• POST /api/ai/food
Auth
• POST /api/auth/signup
• POST /api/auth/login
• POST /api/auth/change-password
• POST /api/auth/send-reset-code
• POST /api/auth/verify-reset-code
• POST /api/auth/reset-password
Exercises
• GET /api/exercises/
• GET /api/exercises/:id
• GET /api/exercises/category/:category
• GET /api/exercises/search/:query
Metrics
• GET /api/metrics/history
• GET /api/metrics/history/date/:date
• GET /api/metrics/history/:id
• PATCH /api/metrics/history/:id
• DELETE /api/metrics/history/:id
• POST /api/metrics/weight
Users
• GET /api/users/me
• PUT /api/users/me
• POST /api/users/onboarding
Workouts
• GET /api/workouts/plans
• POST /api/workouts/plans
• GET /api/workouts/plans/current
• GET /api/workouts/plans/:id
• PATCH /api/workouts/plans/:id
• DELETE /api/workouts/plans/:id
• POST /api/workouts/plans/:id/mark-complete
• GET /api/workouts/logs
• POST /api/workouts/logs
• GET /api/workouts/logs/:id
• GET /api/workouts/logs/date/:date
• PATCH /api/workouts/logs/:id
• DELETE /api/workouts/logs/:id
Chapter 6
Testing
6.1 Unit Testing
Unit testing focuses on verifying the behavior of individual functions, methods, and
classes in isolation. In the 3ASH Gym App, unit tests ensure that business logic, data
models, and local storage interactions operate as expected without relying on
external systems like the UI or a live backend
Key Focus Areas for Unit Testing
1. Core Services (lib/core/services/) Services act as the backbone for data processing
```
and API communication. Unit tests here should mock external dependencies (like
```
```
HTTP requests or secure storage) to validate internal logic. * AuthService &
```
```
MockAuthService: Verify that login, registration, and token management handle
```
```
valid credentials correctly and appropriately catch exceptions (e.g., unauthorized
```
```
access or network errors). Tests should mock flutter_secure_storage. * PlanService
```
& WorkoutPlanService: Test the logic responsible for building, saving, and
retrieving custom workout plans. Ensure that manual day-assignments and exercise
categorizations are formatted correctly. * BodyLogService & WorkoutLogService:
```
Validate algorithms calculating body metrics (like BMI) and ensure workout logs
```
accurately tally sets, reps, and weights. * AIService: Verify that the service formats
prompts correctly for the Gemini API and can gracefully handle parsed responses or
timeout errors.
2. State Management Providers (lib/core/providers/) Providers manage the app's
global state and user preferences. * ThemeProvider: Ensure the toggle mechanism
correctly switches between light and dark modes and that the preference is correctly
serialized to shared_preferences. * LocaleProvider: Validate that the application
```
language updates correctly when the user switches preferences (e.g., Arabic to
```
```
English).
```
3. Data Models (lib/core/models/) Data models represent the core entities of the app
```
(e.g., User, Exercise, WorkoutPlan). * Serialization Testing: Ensure that fromJson
```
and toJson methods accurately parse mock JSON payloads. This is crucial for
avoiding runtime crashes when interacting with local storage or external APIs.
```
Tools & Packages: * flutter_test (Flutter's core testing framework) * mockito or
```
```
mocktail (for mocking classes like http.Client or FlutterSecureStorage)
```
6.2 Integration Testing
Integration testing goes beyond isolated units to verify that multiple components
work together harmoniously. In this app, integration tests simulate real user
interactions on an emulator or physical device, ensuring the UI, navigation, and state
management flow seamlessly.
Key Focus Areas for Integration Testing
1. Authentication Workflow (lib/screens/auth/) * Scenario: Simulate a user
launching the app, navigating to the LoginScreen, entering valid credentials, and
pressing the login button. * Verification: Ensure that AuthService processes the
request, the global state updates to reflect an authenticated user, and GoRouter
correctly redirects the user to the HomeScreen.
2. Custom Workout Plan Creation (lib/screens/workout/) * Scenario: Navigate to the
CreateCustomPlanScreen, select multiple exercises, manually assign them to
specific days in the table-based UI, and save the plan. * Verification: Confirm that
the UI updates correctly during selection, the PlanService persists the data, and the
newly created custom plan appears immediately on the user's active workout list.
3. Fitness Tools & Calculators (lib/screens/tools/) * Scenario: Access the "Tools"
section from the bottom navigation bar and interact with the BMI and Calorie
```
calculators. * Verification: Input mock body metrics (height, weight, age) and verify
```
that the UI renders the correct calculated results instantly and accurately based on
the underlying logic.
4. Navigation and Routing (lib/core/router/) * Scenario: Navigate deeply into the
```
app (e.g., Home -> Workout -> Exercise Details). * Verification: Simulate a system
```
```
back gesture or press the app's back arrow. Ensure context.pop() triggers correctly,
```
```
returning the user to the immediately preceding screen (e.g., Workout screen) rather
```
than unexpectedly jumping to the root home screen. Also, verify that switching tabs
on the google_nav_bar maintains the expected state for each tab.
```
Tools & Packages: * integration_test (Flutter SDK's official package for end-to-end
```
```
UI testing) * flutter_driver (for running automated tests on target devices)
```
6.3 Testing and Evaluation
In The following will show how our system interact with different test cases in
details, every test case below has simple description for both input and output and
expected output screen if the input data is not valid and wrong.
Sign Up Test Case
Input Output
Sign up form, User should enter his full name,
valid email, valid password, phone Then click
on the "Sign up" button.
The output will tell user to write a valid input
Figure 38: Not valid sign up input Figure 39: Output-1
Onboarding Test Case
Input Output
Onboarding form, User should enter his sex,
age, length, weight, and target weight Then click
on the "confirm" button.
The output will tell user to write a valid input
Figure 40: On boarding input Figure 41: On boarding output
AI camera Test Case
Input Output
Any photo NOT FOOD No recognized food
Figure 42: No food input Figure 43: Output-2
Reset password Test Case
Input Output
User enter Email and Click submit + receives
and enter Reset code
Creat new password
Calorie calculator Test Case
This calculator depend on Mifflin-St jeor Formula
Input Output
User enter age, height, weight, activity level and
click calculate
Daily Calorie Target + Macro Breakdown +
different goals
Figure 44: Calculator input Figure 45: Calculator output
Conclusion
The Gym Trainer & Progress Tracker application was developed to provide users
with an integrated digital solution that combines fitness management with intelligent
nutritional analysis.
As awareness of healthy lifestyles continues to grow, individuals increasingly seek
efficient tools that help them monitor their activities, organize their routines, and
make informed decisions regarding both exercise and nutrition.
This project was designed to address these needs through the implementation of
modern technologies that simplify tracking processes and improve user experience.
The proposed system offers a comprehensive platform that allows users to create
personal accounts, manage workout schedules, record exercise information, and
monitor progress through analytical reports and visual indicators.
Alongside these fitness-related features, the application introduces an artificial
intelligence module dedicated to food analysis and calorie estimation, enabling users
to monitor nutritional intake more efficiently. Unlike traditional calorie tracking
methods that depend heavily on manual calculations and food database searches, the
developed solution utilizes computer vision and artificial intelligence techniques to
automate the process.
Users can capture or upload images of meals directly through the application, where
the AI model analyzes the food content, identifies meal categories, and estimates
calorie values based on stored nutritional information. This process reduces manual
effort and provides users with faster and more convenient nutritional insights.
Throughout the development of the project, software engineering principles and
structured methodologies were applied to ensure system quality and reliability. The
project included requirement gathering, system analysis, database design, user
experience planning, interface development, testing procedures, and performance
evaluation. Careful consideration was given to usability and accessibility to ensure
that users can interact with application features efficiently regardless of their
technical background.
The developed application aims to support users in maintaining healthier habits by
providing both exercise organization and intelligent calorie monitoring within a
single environment. The integration of analytical dashboards and progress indicators
allows users to evaluate their activity patterns and nutritional behavior over time,
encouraging long-term consistency and continuous improvement. In conclusion, this
project demonstrates the practical potential of integrating artificial intelligence into
modern fitness and nutrition applications. Rather than focusing solely on workout
tracking, the system extends its functionality by offering automated food analysis
and calorie estimation to support healthier lifestyle choices. The developed solution
establishes a strong foundation for future development and presents a scalable model
that can evolve into a more advanced health and fitness assistant capable of
delivering smarter insights and improving user engagement in the long term.
Future work
Although the current version of the system successfully combines workout
management, progress tracking, and AI-powered calorie estimation, there are several
opportunities for future improvements that can significantly enhance the functionality,
accuracy, and overall user experience of the application.
One of the most important future enhancements is expanding the artificial intelligence
model responsible for food recognition and calorie estimation.
Future versions may support a larger variety of meals, international cuisines, and
mixed dishes with improved classification accuracy.
Additional datasets and advanced deep learning techniques can be introduced to allow
the system to better recognize complex meals and provide more reliable nutritional
analysis under different image qualities, lighting conditions, and presentation styles.
Another potential enhancement involves increasing the nutritional intelligence of the
application by introducing personalized meal recommendations.
Based on user goals, daily calorie targets, activity levels, and historical eating
behavior, the system could automatically suggest healthier food alternatives and
generate customized nutritional plans. These recommendations may help users
maintain consistency and achieve their fitness objectives more efficiently.
Future development may also include integrating advanced nutritional analytics that
provide detailed breakdowns of macro-nutrients and micro-nutrients such as protein,
carbohydrates, fats, vitamins, and minerals. This would allow users to gain deeper
insight into the quality of their diet rather than focusing only on total calorie intake.
In addition, the application can be enhanced through integration with wearable
devices such as smartwatches and fitness trackers. This integration could enable
synchronization of health-related information including calories burned, physical
activity levels, heart rate, daily movement, and overall wellness indicators.
Combining nutritional and activity data may provide users with a more complete
understanding of their health status.
Another promising direction is implementing cloud synchronization and intelligent
recommendation systems that adapt over time according to user habits and behavioral
patterns.
Machine learning algorithms could analyze historical data and provide automated
suggestions regarding meal timing, calorie adjustments, and goal optimization. Social
and motivational features may also be introduced in future releases.
These features could include achievement systems, progress sharing, nutrition
challenges, community support, and personalized reminders that encourage users to
maintain healthy routines and improve long-term engagement.
Furthermore, barcode scanning, restaurant meal recognition, multilingual food
support, and real-time nutritional reporting can be added to improve usability and
make the application suitable for wider audiences and different regions.
Ultimately, the long-term vision of this project is to evolve into a complete AI-
powered health and nutrition ecosystem that supports users in making healthier
decisions through intelligent calorie analysis, personalized guidance, and
comprehensive progress monitoring.
The future development of the system aims to transform the application into a reliable
digital assistant capable of simplifying nutrition management and promoting
sustainable healthy lifestyles anytime and anywhere.
References
 https://cs231n.stanford.edu/
 https://www.deeplearningbook.org/
 https://www.tensorflow.org/
 https://pytorch.org/docs/
 https://docs.opencv.org/
 https://www.image-net.org/
 https://data.vision.ee.ethz.ch/cvl/datasets_extra/food-101/
 https://ieeexplore.ieee.org/document/7780849
 https://ieeexplore.ieee.org/document/7348544
 https://www.sciencedirect.com/science/article/pii/S1532046417302112
 https://fdc.nal.usda.gov/
 https://www.pearson.com/en-us/subject-catalog/p/softwareengineering
/P200000003481
 https://standards.ieee.org/
 https://www.uml.org/
 https://www.nngroup.com/articles/definition-user-experience/
 https://www.interaction-design.org/
```
Appendix: GitHub Link.
```
 https://github.com/abdallahwalidabdelhakim-tech/3ASH_Gym_App
ﻣﻠﺨﺺاﻟﻤﺸﺮوعﺑﺎﻟﻠﻐﺔاﻟﻌﺮﺑﯿﺔ
وعرشملﺬا اه فدهيإليامدﺨتساﺔ ﺑياررحلات ارﻌسلﻞ ايﻠحتﺔ ويصﺨشلت ااﻧايبلوإدارة ا يﺿايرلط ااشنلﺑﻌﺔ ااتم نيﻊ ﺑمجي يﻖ ذﻛيبطت ريوطت
ﺔ.يﺑوساحلﺔ ايؤرلوا يعانطصء اﻻاﺬﻛلت ااينﻘت
رﻘﺔ أﻛﺜيرطﺑ يئﻐﺬالم ااﻈنلﺑﻌﺔ ااتمو نيرامتلا ميﻈنت ﺧﻼل نم هتايح ﻂمﻧ نيسحت ع مدﺨتسملا دعاست ﻠﺔماكتم ﺑﺔرجت مدﻘيل ماﻈنلا ميمصت متىل
دا®امتعﺔ ودﻗﺔ والوهسيﻠعﺜﺔ.يدحلت ااينﻘتلا
اترﻌسلب ااسحﺔ ويﻐﺬتلﺑﻌﺔ ااتم يف ﺔيديﻘﻠتلق ارطلا ع دامتعﻘﻠﻞ اﻻت ﺔيمل رﻗوﻠح ة إديﺰاتملﺟﺔ ااحﻠل ﺔجيتوع ﻧرشملة اركف ءتاﺟىل ىل
ع ﺔحاتملﻞ ائاسولأﻏﻠﺐ ا دمتﻌت ﺚيح ﺔ،ياررحلاليﻼك وﻗﺖهتسﻘﺔ أو ايدﻗ ريﺞ ﻏئاتﻧ دي إؤي دﻗ ام وه، ويصﺨشلا ريدﻘتلوي أو اديلل اااﻹدﺧىل
.نييفاإﺿ دهوﺟ
ع مدﺨتسملا دعاست ﺔيئاﻠﻘت رةوصﺔ ﺑيئت ﻏﺬااموﻌﻠم اجرﺨتسم وااﻌطلر اوص ﻞيﻠحتل يعانطصء اﻻاﺬﻛلا ع دمتﻌي ماﻧﻈ ريوطت مت ﻚلﺬلىللي
.اي® عو رﺔ أﻛﺜيئارات ﻏﺬارذ ﻗاﺨتا
نم رهوطت ﺑﻌﺔاتم، وهتاﻧايل، وإدارة ﺑوﺧدلﻞ ايجست، ويصﺨش باسح ءاشم ﺑﺈﻧدﺨتسمﻠل ﺢمست ﻠﺔهسﺔ ومﻈنم امدﺨتست ااهﻖ واﺟيبطتلا رفوي
ت.ايئاصحﻞ واﻹيﻠحتلت ااحفص ﺧﻼل
داﺧﻞ رصانﻌلا ميﻈنت ع ظافحلﻊ ام ل،وصولﻠﺔ اهسﻌﺔ ويرسﺔ وحن واﺿوكت ﺚيحت ﺑاهاﺟولا ميمصتم ودﺨتسملﺑﺔ ارجتم ﺑامتهاﻻ مت امﻛىل
ت.اﺌفلﻠﻒ اتﺨمل امدﺨتسﺔ اﻻلوهس نامﻀل ﻖيبطتلا
ع ماﻈنلا دمتﻌيليفرﻌتﻠل ربÇ دم يعانطصء ااذج ذﻛومﻧيﻠعمايﻗ دنع ﺔ.يﺑوساحلﺔ ايؤرلت ااينﻘت امدﺨتسار ﺑوصلﺧﻼل ا نم ماﻌطلاع اوأﻧ
.اهد ﺑوﺟوملم ااﻌطلع اواج ﻧرﺨتسرة واوصلﻞ ايﻠحتﺔ وجلاﻌملﻠﺔ احرم أدبت ،اﻘ®بسم دةوﺟوم رةوص ﻊفﺔ أو ربﺟوﻠل رةوص طاﻘتلام ﺑدﺨتسملا
ع يوتحت ماﻈنلﺨﺰﻧﺔ داﺧﻞ ام ﺔيئت ﻏﺬااﻧاية ﺑدعاﻊ ﻗم ﺞئاتنلﺑﻘﺔ ااطم متي ﻚلذ دﺑﻌليﺔيئﻐﺬالا ميﻘلﺔ واياررحلات ارﻌسلاﺔ ﺑطبترم تاموﻌﻠم
ﻖ.يبطتلداﺧﻞ ا رشابم ﻞكشم ﺑدﺨتسمﻠل اهﺿرعﺔ ويريدﻘتلات ارﻌسلب ااسح متي مﺔ، ﺛفﻠتﺨملا
إليﺑﻌﺔاتمﺑﻘﺔ واسلﻼت ايﻠحتلﻞ اجس ضرﺢ ﺑﻌمسي امم ،يصﺨشلم ادﺨتسملﻠﻒ امﺑ اهطﺞ ورﺑئاتنلﻆ افح ﺔيﻧاكمﻖ إيبطتلا معدي ﻚ،لﻧﺐ ذاﺟ
نم هنيكمتم ودﺨتسمﻠل ﺔيئﻐﺬالدات ااﻌلل اوح ﺔ أوﺿﺢيرؤ ميدﻘت يف ﻼتيﻠحتلﺔ احفص دعاست امﻗﺖ. ﻛولور ارمﺔ ﺑياررحلات ارﻌسلﻼك اهتسا
ءة.افﻛ ررة أﻛﺜوصﺑ يئﻐﺬالا هماﻧﻈ ميﻈنت
ﺔيفيﻇولا ريﺔ وﻏيفيﻇولت اابﻠطتملا ديدحت مت ﺛاﺟايتحﻞ اﻻيﻠحتﻠﺔ وكشملﺔ اسرادأت ﺑدﺔ ﺑمﻈنم ﺔيجمرﺑ ريوطت ﺔيجهنم ﻖفوع ورشملﺬ ايفنت مت
م.اﻈنﻠل
تاططﺨم ءاشت، وإﻧاﻧايبلة ادعاﻗ ميمصت وعرشملﻞ امش امﻛUMLتاﻌﻼﻗلﻞ واسﻠستلﺔ واطشام واﻷﻧدﺨتسﻻت اﻻاح تاططﺨم ﺜﻞم ﺔفﻠتﺨملا
ﻼ.®بﻘتسم ريوطتﻠل ﺑﻞاواﺿﺢ وﻗ يجمرﻞ ﺑكيه ءانن ﺑامﻀل
ميدﻘتم، ودﺨتسملى ادل يئﻐﺬالا يعولدة اايﺔ، وزياررحلات ارﻌسلب ااسح يف نيلﺬوبملا دهجلﻗﺖ واولﻞ ايﻘﻠت وعرشملﺬا اهل ﻗﻌﺔوتملا دئاوفلا نمو
ﺔ.يئﻐﺬالﺔ امﺑﻌﺔ اﻷﻧﻈاتم يف ء® اذﻛ رﺑﺔ أﻛﺜرجت
ع دمتﻌت ﺜﺔيدح ﺔينﻘت ﺌﺔيﺑ ريفوت ﻊم دﻗﺔ، رع وأﻛﺜرسﻞ أكشﺔ ﺑيحص اراترذ ﻗاﺨتم ﻻدﺨتسملا معد يف ماﻈنلا مهاسي امﻛلييعانطصء اﻻاﺬﻛلا
م.اع ﻞكشة ﺑايحلدة اوﺟ نيسحتﺔ ويﻐﺬتلﻂ إدارة ايسبتل
ﻛﯿﻔﯿﺔﻋﻤﻞاﻟﻨﻈﺎم :
تمدﻌيامﻈالنىﻠعﻞتكامينﺑﺔهﺟوادمﺨالمستاعدةﻗواتﻧالبياموذجﻧواءﻛﺬالصطناعي.ﻻاعندﻞتسجيدمﺨالمستولﺧدﻠل
إلى،ﻖالتطبييمكنهالﻘتﻧﻻاإلىﺔصفحاءﻛﺬالصطناعيﻻااطﻘوالتصورةام.ﻌطﻠليتمإرسالالصورةإلىوحدةﺔالجﻌالمﺔالمسؤول
عنﻞيﻠتحالصور،ﺚحيومﻘيالنموذجرفﻌالتﺑىﻠعوعﻧ.ﺔبﺟالودﻌﺑﻚذليتمﺔﻘﺑمطاﺔالنتيجﻊماتﻧالبياﺔائيﺬﻐالﺔﻧﺰﺨالما® ﻘمسبلحساب
راتﻌالسﺔالحراري،ﺔديريﻘالتمﺛيتمعرضﺔالنتيجمباشرةىﻠعدمﺨالمستﻞﺧدا.ﻖالتطبي
ﻆحفÍ تاتﻧالبياﺔاصﺨالدمﺨالمستﺑﺞتائﻧوﻞيﻠالتحﻞﺧدااعدةﻗات،ﻧالبيامماﺢيتيﺔيﻧإمكاهاﺿعرا® ﻘحﻻفيﺔصفحتﻼيﻠالتحﺔﻌﺑلمتا
كﻼستهﻻاائيﺬﻐالصورةﺑ.ﺔمﻈمنتتمﻊميﺟياتﻠمﻌالﻞشكﺑﻂﺑمترامانﻀلﺔسرعﺔﺑستجاﻻاﺔﻗودعرض.ﺞالنتائ
اﻟﻔﻮاﺋﺪاﻟﻤﺘﻮﻗﻌﺔ :
مشروع:ﻠي لﻘيﻘر الحﺛﻷلتبين ا ﺔها عبر عدة محاور رئيسيﻠيﻠوتح ﺔﺿاستفاﺑ ﺔﻌﻗالفوائد المتو ﻞيمكننا تفصي
```
(ﺔاليومي ﺔﺑتحسين التجر) دم النهائيﺨمستﻠفوائد مباشرة ل
```
```
ﺪﮭجﻟت واﻗﻮﻟا ﺮﯿفﻮت)تﺎجبﻮﻟبع اﺘت ﻲرة فﻮث:(مكون ﻞلك ﻞال اليدوي" الممﺧدﻹائي، وهو "اﺬﻐامهم الﻈﻧ ﻊفون عن تتبﻗالناس يتو ﻞﻌي يجﺬبر الﻛﻷا ﻖائﻌالتام من ال ﺺﻠﺨالت
```
دمﺨالمست ﺔمن استمراريﻀوي ® ايومي ﺔمينﺛ ﻖائﻗاط صورة" يوفر دﻘإلى مجرد "الت ﺔيﻠمﻌال ﻞرام. تحويﻐﺑ ® ارامﻏ.
```
يﺮﺸبﻟطأ اﺨﻟش اﻣﺎه ﻞﯿﻠتق:رﺜﻛأ ® اديرﻘت ﺢصطناعي يمنﻻاء اﻛﺬ. ال(صانﻘيادة أو النﺰالﺑ إما) بيرةﻛ ﺐنسﺑ ® اﺌاطﺧ ما يكون ® االبﻏ راتﻌالس ﺔميﻛو ﺺصي لحجم الحصﺨدير الشﻘالت
```
ﺔﻘﺛات موﻧياﺑو ﺔيﺑالحاسو ﺔى الرؤيﻠع ® ءناﺑ ﺔوعيﺿمو.
```
تﺎﻧﺎﯿبﻟا ﺔّي زﻛﺮﻣ)ﺪواح ﻲف ﻞكﻟا ﺔﺑﺮتج:(ﺔﻠامﻛ دم له صورةﻘواحدة ت ﺔرات، يجد منصﻌر لحساب السﺧآ ﻖوتطبي ﺔيﺿالتمارين الريا ﻞلتسجي ﻖين تطبيﺑ دمﺨالمست ﺖمن تشت ® ﻻدﺑ
```
ﺔيﻧإدارة أهدافه البد ﻞ، مما يسهﺔﻗوالمحرو ﺔكﻠته المستهﻗعن طا ﺔﺛومحد.
يدة المدىﻌﺑ ﺔوتوعوي ﺔفوائد صحي
يﺮبصﻟا ﻲﺋذاﻐﻟا ﻲﻋﻮﻟرفع ا:راراتهﻗ ، مما يحسنﺔﻠﻀه المفﻗطباﻷ ﺔريبيﻘالت ﺔائيﺬﻐال ﺔيمﻘالﺑ ائيﻘﻠصري" تﺑ دم في تطوير "وعيﺨ، يبدأ المستﻖدام التطبيﺨاستمرار است ﻊم
```
(في المطاعم ﺔﻌرارات السريﻘالﻛ) ﻖدم فيها التطبيﺨيست ﻻ ات التيﻗوﻷحتى في ا ﺔويﺬﻐالت.
```
```
ﺎﮭﻠّي ﺪﻌوت ﺔﯿﻛﻮﻠسﻟط اﺎﻤﻧاأل ﺪرص:ل لوحات التحكمﻼﺧ من (Dashboards) تشاف زيادةﻛ: اﻞﺜم) ﺔﻗدﺑ دم رصد عاداتهﺨالمست ﻊ، يستطيﺖﻗمرور الوﺑ ﺔمﻛت المتراﻼيﻠوالتح
```
```
مينﺨمن الت ® ﻻدﺑ ﻖائﻘى حﻠع ® ءناﺑ هﻛوﻠس ﻞديﻌله ت ﺢ، مما يتي(ﺔﻗحاد في البروتين في أيام التمارين الشا ﺺﻘﻧ سبوع، أوﻷا ﺔهايﻧ ﺔﻠل عطﻼﺧ راتﻌفي الس ﺔمفرط.
```
ﺔﻣاﺪﺘسﻤﻟا ﺔﯿﺤصﻟا ﺔّي ﺎﻗﻮﻟا:ﻞﺜ، مﺔيﺬﻐأو سوء الت ﻞامﺨالحياة ال ﻂنمﺑ ﺔصر المرتبطﻌدمين من أمراض الﺨالمست ﺔال في حمايﻌف ﻞشكﺑ ي يساهمﻧالوزن والنشاط البد ﺔبﻗمرا ﻞتسهي
ﺐﻠﻘال ﻞﻛي، ومشاﻧاﺜ، والسكري من النوع الﺔالسمن.
يساهمامﻈالنفيﻞيﻠﻘتعتمادﻻاىﻠعالطرقﺔيديﻠﻘالتفيحسابراتﻌالس،ﺔالحراريممايوفرﺖﻗالووالجهددم.ﺨمستﻠلماﻛيساعدىﻠع
زيادةالوعيائيﺬﻐالمنلﻼﺧديمﻘتوماتﻠﻌمﺔﻌسريومباشرةحولمحتوىبات.ﺟالو
ومنﻊﻗالمتوأنيؤديدامﺨاستامﻈالنإلىتحسينيمﻈتنﺔﻌﺑالمتا،ﺔائيﺬﻐالﻞيﻠﻘوتطاءﺧﻷاﺔالناتجعنالحساب اليدوي،ديمﻘوتﺔﺑتجر
ﺔنيﻘتﺔﺜحديتمدﻌتىﻠعاءﻛﺬالصطناعيﻻالدعمدمﺨالمستفيإدارةامهﻈﻧائيﺬﻐالكفاءةﺑبر.ﻛأ