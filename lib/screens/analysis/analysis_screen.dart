import 'package:boda_new/core/models/body_log.dart';
import 'package:boda_new/core/models/workout_log.dart';
import 'package:boda_new/services/data_service.dart';
import 'package:boda_new/screens/analysis/widgets/history_calendar.dart';
import 'package:boda_new/screens/analysis/widgets/body_weight_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:boda_new/core/services/user_service.dart';

/// Analysis and tracking screen for fitness progress
/// 
/// Provides two main tabs:
/// - Overview: Shows weight tracking chart and recent body measurements
/// - History: Displays workout history calendar
class AnalysisScreen extends StatefulWidget {
  const AnalysisScreen({super.key});

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final DataService _dataService = DataService();

  List<BodyLog> _bodyLogs = [];
  List<WorkoutLog> _workoutLogs = [];
  bool _isLoading = true;
  double? _targetWeight;
  String? _weightGoal;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (mounted) setState(() {}); // To update FAB visibility
      if (_tabController.indexIsChanging) {
         // Optionally reload data on tab change
         _loadData();
      }
    });
    _loadData();
  }

  /// Loads all necessary data from the database
  Future<void> _loadData() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    final bodyLogs = await _dataService.getBodyLogs();
    final workoutLogs = await _dataService.getWorkoutLogs();

    if (!mounted) return;
    setState(() {
      _bodyLogs = bodyLogs;
      _workoutLogs = workoutLogs;
      _isLoading = false;
    });

    // Load target info using real UserService
    final userService = context.read<UserService>();
    final onboarding = await userService.getOnboarding();
    if (onboarding['success'] == true && onboarding['onboarding'] != null) {
      final ob = onboarding['onboarding'] as Map<String, dynamic>;
      _targetWeight = ob['target_weight']?.toDouble();
      _weightGoal = ob['goal'];
      
      if (_bodyLogs.isNotEmpty) {
        _checkAchievement(_bodyLogs.first.weight);
      }
    }
  }

  /// Checks if user has reached their weight goal
  /// 
  /// @param currentWeight Current weight of the user
  Future<void> _checkAchievement(double? currentWeight) async {
    if (currentWeight == null || _targetWeight == null || _weightGoal == null) return;

    bool reached = false;
    if (_weightGoal == 'weight_loss') {
      reached = currentWeight <= _targetWeight!;
    } else if (_weightGoal == 'weight_gain') {
      reached = currentWeight >= _targetWeight!;
    } else {
      reached = (currentWeight - _targetWeight!).abs() < 0.5;
    }

    if (reached) {
      final prefs = await SharedPreferences.getInstance();
      final achievedKey = 'achieved_${_weightGoal}_$_targetWeight';
      final alreadyShown = prefs.getBool(achievedKey) ?? false;

      if (!alreadyShown && mounted) {
        await prefs.setBool(achievedKey, true);
        _showCongratulatoryDialog();
      }
    }
  }

  /// Displays a congratulatory dialog when weight goal is reached
  void _showCongratulatoryDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A2A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.emoji_events, color: Color(0xFFD5FF5F), size: 100),
            const SizedBox(height: 20),
            const Text(
              'CONGRATULATIONS!',
              style: TextStyle(
                color: Color(0xFFD5FF5F),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'You have reached your target weight of $_targetWeight kg!',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD5FF5F),
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
              ),
              child: const Text('AWESOME!'),
            ),
          ],
        ),
      ),
    );
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF1A1A1A) : Colors.white,
      // App Bar with tab navigation
      appBar: AppBar(
        title: const Text('Analysis'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        bottom: TabBar(
            controller: _tabController,
            indicatorColor: const Color(0xFFD5FF5F),
            labelColor: const Color(0xFFD5FF5F),
            unselectedLabelColor: isDark ? Colors.grey : Colors.grey[600],
            tabs: const [
              Tab(text: 'Overview'),
              Tab(text: 'History'),
            ],
          ),
      ),
      // Main content area with loading state and tabs
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(isDark),
                _buildHistoryTab(isDark),
              ],
            ),
      // Floating action button to add measurements (only on Overview tab)
      floatingActionButton: _tabController.index == 0
          ? FloatingActionButton(
              onPressed: () => _showAddMeasurementDialog(context),
              backgroundColor: const Color(0xFFD5FF5F),
              child: const Icon(Icons.add, color: Colors.black),
            )
          : null,
    );
  }

  /// Builds the Overview tab with weight tracking chart
  Widget _buildOverviewTab(bool isDark) {
    // Prepare weight data for chart
    final weightData = _bodyLogs
        .where((log) => log.weight != null)
        .map((log) => {
              'date': log.date,
              'weight': log.weight!,
            })
        .toList();
        
    weightData.sort((a, b) => (a['date'] as DateTime).compareTo(b['date'] as DateTime));

    final chartData = weightData.map((e) => {
      'date': e['date'],
      'maxWeight': e['weight'], 
      'totalVolume': 0,
    }).toList();

    return RefreshIndicator(
      onRefresh: _loadData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Weight tracking chart
            if (chartData.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF2A2A2A) : Colors.grey[100],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Body_Weight_Chart(
                  data: chartData,
                  metric: 'maxWeight',
                  title: 'Body Weight (kg)',
                ),
              )
            else
              Container(
                padding: const EdgeInsets.all(32),
                 decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF2A2A2A) : Colors.grey[100],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    'Log your weight to see trends!',
                    style: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
                  ),
                ),
              ),
            
            const SizedBox(height: 24),
            // Recent logs section
            Text(
              'Recent Logs',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            ..._bodyLogs.take(5).map((log) => Card(
              color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
              child: ListTile(
                title: Text(
                  '${log.date.day}/${log.date.month}/${log.date.year}',
                  style: TextStyle(color: isDark ? Colors.white : Colors.black),
                ),
                subtitle: Text(
                  log.weight != null ? '${log.weight} kg' : 'No weight recorded',
                  style: TextStyle(color: isDark ? Colors.grey : Colors.grey[600]),
                ),
                trailing: const Icon(Icons.chevron_right, color: Colors.grey),
              ),
            )),
          ],
        ),
      ),
    );
  }

  /// Builds the History tab with workout calendar
  Widget _buildHistoryTab(bool isDark) {
    return RefreshIndicator(
      onRefresh: _loadData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: HistoryCalendar(workoutLogs: _workoutLogs),
        ),
      ),
    );
  }

  /// Displays a dialog for adding body measurements
  void _showAddMeasurementDialog(BuildContext context) {
    final weightController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF2A2A2A)
            : Colors.white,
        title: const Text(
          'Log Measurements',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: weightController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Weight (kg)',
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFD5FF5F)),
                ),
              ),
            ),
            // Could add fields for body fat, waist, etc. here
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final weight = double.tryParse(weightController.text);
              if (weight != null) {
                final log = BodyLog(
                  date: DateTime.now(),
                  weight: weight,
                );
                await _dataService.saveBodyLog(log);
                if (context.mounted) {
                   Navigator.pop(context);
                   _loadData(); // Refresh integration
                   _checkAchievement(weight);
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD5FF5F),
              foregroundColor: Colors.black,
            ),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
