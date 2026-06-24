import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:boda_new/core/models/workout_log.dart';

/// Widget to display workout history in a calendar format
/// 
/// Shows a monthly calendar view with workout indicators and 
/// displays detailed workout information when a date is selected.
class HistoryCalendar extends StatefulWidget {

  const HistoryCalendar({super.key, required this.workoutLogs});
  final List<WorkoutLog> workoutLogs;

  @override
  State<HistoryCalendar> createState() => _HistoryCalendarState();
}

class _HistoryCalendarState extends State<HistoryCalendar> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  /// Filters workouts for a specific day
  /// 
  /// @param day The day to get workouts for
  List<WorkoutLog> _getWorkoutsForDay(DateTime day) {
    return widget.workoutLogs.where((log) => 
      log.date.year == day.year && 
      log.date.month == day.month && 
      log.date.day == day.day
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Column(
      children: [
        // Table calendar widget for selecting dates and showing workout indicators
        TableCalendar(
          firstDay: DateTime.utc(2023, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: _focusedDay,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
          },
          eventLoader: _getWorkoutsForDay,
          calendarStyle: CalendarStyle(
             markerDecoration: const BoxDecoration(
               color: Color(0xFFD5FF5F),
               shape: BoxShape.circle,
             ),
             todayDecoration: BoxDecoration(
               color: const Color(0xFFD5FF5F).withValues(alpha:0.5),
               shape: BoxShape.circle,
             ),
             selectedDecoration: const BoxDecoration(
               color: Color(0xFFD5FF5F),
               shape: BoxShape.circle,
             ),
             defaultTextStyle: TextStyle(color: isDark ? Colors.white : Colors.black),
             weekendTextStyle: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
          ),
          headerStyle: HeaderStyle(
            titleCentered: true,
            formatButtonVisible: false,
            titleTextStyle: TextStyle(
              color: isDark ? Colors.white : Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            leftChevronIcon: Icon(Icons.chevron_left, color: isDark ? Colors.white : Colors.black),
            rightChevronIcon: Icon(Icons.chevron_right, color: isDark ? Colors.white : Colors.black),
          ),
        ),
        const SizedBox(height: 16),
        // Workout details for selected date
        if (_selectedDay != null) ...[
           Padding(
             padding: const EdgeInsets.symmetric(horizontal: 16.0),
             child: Align(
               alignment: Alignment.centerLeft,
               child: Text(
                 'Workouts on ${_selectedDay!.day}/${_selectedDay!.month}:', 
                 style: TextStyle(
                   fontWeight: FontWeight.bold,
                   color: isDark ? Colors.white : Colors.black,
                 ),
               ),
             ),
           ),
           const SizedBox(height: 8),
           ..._getWorkoutsForDay(_selectedDay!).map((video) => ListTile(
             title: Text(
               video.workoutName,
               style: TextStyle(color: isDark ? Colors.white : Colors.black),
             ),
              subtitle: Text(
                '${video.exercises.map((e) => e.exerciseName).toSet().length} Exercises • ${video.durationSeconds ~/ 60} mins',
                 style: TextStyle(color: isDark ? Colors.grey : Colors.black54),
              ),
             leading: const Icon(Icons.fitness_center, color: Color(0xFFD5FF5F)),
           )),
           if (_getWorkoutsForDay(_selectedDay!).isEmpty)
             Padding(
               padding: const EdgeInsets.all(16.0),
               child: Text(
                 'No workouts recorded.',
                 style: TextStyle(color: isDark ? Colors.grey : Colors.grey),
               ),
             ),
        ],
      ],
    );
  }
}
