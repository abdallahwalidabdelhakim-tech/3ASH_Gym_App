import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/localization/app_localizations.dart';

import '../../core/models/exercise.dart';
import '../../core/data/exercise_data.dart';
import 'exercise_detail_screen.dart';

/// Screen for displaying exercise library with muscle group categories and search functionality
class ExerciseLibraryScreen extends StatefulWidget {
  const ExerciseLibraryScreen({super.key});

  @override
  State<ExerciseLibraryScreen> createState() => _ExerciseLibraryScreenState();
}

class _ExerciseLibraryScreenState extends State<ExerciseLibraryScreen> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  List<Exercise> _searchResults = [];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Handles search query changes
  void _onSearchChanged(String query) {
    setState(() {
      if (query.isEmpty) {
        _searchResults = [];
      } else {
        _searchResults = ExerciseData.searchExercises(query);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const neonGreen = Color(0xFFD5FF5F);

    final List<Map<String, String>> muscleGroups = [
      {'name': 'Upper back', 'image': 'assets/upper back.png'},
      {'name': 'Lower back', 'image': 'assets/lower back.png'},
      {'name': 'Chest', 'image': 'assets/Chest.png'},
      {'name': 'Abs', 'image': 'assets/abs.png'}, 
      {'name': 'Legs', 'image': 'assets/legs.png'},
      {'name': 'Arms', 'image': 'assets/arms.png'},
      {'name': 'Shoulders', 'image': 'assets/Shoulders.png'},
      {'name': 'Cardio', 'image': 'assets/cardio.png'},
    ];

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF1A1A1A) : Colors.white,
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF1A1A1A) : Colors.white,
        elevation: 0,
        centerTitle: true,
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                onChanged: _onSearchChanged,
                style: TextStyle(color: isDark ? Colors.white : Colors.black),
                decoration: InputDecoration(
                  hintText: 'Search exercises...',
                  hintStyle: TextStyle(color: (isDark ? Colors.white : Colors.black).withValues(alpha: .5)),
                  border: InputBorder.none,
                ),
              )
            : Text(
                localizations?.exerciseLibrary ?? 'Exercise Library',
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
        leading: _isSearching
            ? IconButton(
                icon: Icon(Icons.close, color: isDark ? Colors.white : Colors.black),
                onPressed: () {
                  setState(() {
                    _isSearching = false;
                    _searchController.clear();
                    _searchResults = [];
                  });
                },
              )
            : IconButton(
                icon: Icon(Icons.arrow_back, color: isDark ? Colors.white : Colors.black),
                onPressed: () => context.pop(),
              ),
        actions: [
          if (!_isSearching)
            IconButton(
              icon: Icon(Icons.search, color: isDark ? Colors.white : Colors.black),
              onPressed: () {
                setState(() {
                  _isSearching = true;
                });
              },
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            const SizedBox(height: 16),
            Expanded(
              child: _isSearching && _searchController.text.isNotEmpty
                  ? _buildSearchResults(neonGreen)
                  : _buildMuscleGroupGrid(muscleGroups),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds muscle group grid for category selection
  Widget _buildMuscleGroupGrid(List<Map<String, String>> muscleGroups) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.85,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: muscleGroups.length,
      itemBuilder: (context, index) {
        return _buildMuscleCard(
          context, 
          muscleGroups[index]['name']!, 
          muscleGroups[index]['image']!
        );
      },
    );
  }

  /// Builds search results grid
  Widget _buildSearchResults(Color neonGreen) {
    if (_searchResults.isEmpty) {
      return const Center(
        child: Text(
          'No exercises found',
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      );
    }

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final exercise = _searchResults[index];
        return _ExerciseSearchCard(exercise: exercise, neonGreen: neonGreen);
      },
    );
  }

  /// Builds individual muscle group card
  Widget _buildMuscleCard(BuildContext context, String title, String imagePath) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(
          'exercise-list',
          pathParameters: {'category': title},
        );
      },
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: const Color(0xFF2C2C2E), // Card background color
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
            opacity: 0.8,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1C1C1E).withValues(alpha: .9),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: .1),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Color(0xFFD5FF5F), 
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget for displaying search result cards
class _ExerciseSearchCard extends StatelessWidget {

  const _ExerciseSearchCard({
    required this.exercise,
    required this.neonGreen,
  });
  final Exercise exercise;
  final Color neonGreen;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ExerciseDetailScreen(exercise: exercise),
          ),
        );
      },
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: neonGreen, width: 3),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: exercise.mainImageUrl != null
                  ? Image.asset(
                      exercise.mainImageUrl!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) => Icon(
                        Icons.fitness_center,
                        color: Colors.grey[700],
                        size: 40,
                      ),
                    )
                  : Icon(
                      Icons.fitness_center,
                      color: Colors.grey[700],
                      size: 40,
                    ),
            ),
            Container(
              height: 2,
              color: neonGreen,
            ),
            Expanded(
              flex: 2,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                alignment: Alignment.center,
                child: Text(
                  exercise.name.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: neonGreen,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
