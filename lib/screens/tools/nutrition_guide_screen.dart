import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Nutrition Guide Screen
class NutritionGuideScreen extends StatelessWidget {
  const NutritionGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Nutrition Guide',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
         leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? Colors.white : Colors.black,
          ),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),

            // Macronutrients
            _buildSection(
              theme,
              isDark,
              'Macronutrients',
              'Understanding Protein, Carbs & Fats',
              [
                _buildNutrientCard(
                  theme,
                  isDark,
                  'Protein',
                  'Builds and repairs muscle tissue',
                  '1.6-2.2g per kg of body weight',
                  Colors.blue,
                ),
                _buildNutrientCard(
                  theme,
                  isDark,
                  'Carbohydrates',
                  'Primary fuel source for workouts',
                  '40-50% of daily calories',
                  Colors.green,
                ),
                _buildNutrientCard(
                  theme,
                  isDark,
                  'Fats',
                  'Supports hormone production',
                  '20-30% of daily calories',
                  Colors.orange,
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Meal Timing
            _buildSection(
              theme,
              isDark,
              'Meal Timing',
              'When to eat for optimal results',
              [
                _buildTipCard(
                  theme,
                  isDark,
                  'Pre-Workout (1-2 hours)',
                  'Complex carbs + small protein\n\nExamples:\n• Oatmeal with protein powder\n• Greek yogurt with fruit\n• Whole grain toast with peanut butter',
                ),
                _buildTipCard(
                  theme,
                  isDark,
                  'Post-Workout (30-60 minutes)',
                  'Fast-digesting carbs + protein\n\nExamples:\n• Protein shake with banana\n• Rice cakes with protein spread\n• Fruit smoothie with protein powder',
                ),
                _buildTipCard(
                  theme,
                  isDark,
                  'Daily Hydration',
                  'Maintain optimal performance and recovery\n\n• Drink 3-4 liters of water daily\n• Add electrolytes for intense workouts\n• Monitor urine color - aim for pale yellow',
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Sample Meal Plan
            _buildSection(
              theme,
              isDark,
              'Sample Meal Plan',
              '1500-2000 calorie plan',
              [
                _buildMealCard(
                  theme,
                  isDark,
                  'Breakfast',
                  'Oatmeal with protein powder, berries, and almond butter',
                  '450-500 calories',
                ),
                _buildMealCard(
                  theme,
                  isDark,
                  'Snack',
                  'Greek yogurt with chia seeds and honey',
                  '200-250 calories',
                ),
                _buildMealCard(
                  theme,
                  isDark,
                  'Lunch',
                  'Grilled chicken salad with mixed greens, veggies, and olive oil dressing',
                  '450-550 calories',
                ),
                _buildMealCard(
                  theme,
                  isDark,
                  'Pre-Workout',
                  'Apple with peanut butter or protein bar',
                  '200-300 calories',
                ),
                _buildMealCard(
                  theme,
                  isDark,
                  'Dinner',
                  'Baked salmon with quinoa and roasted vegetables',
                  '400-500 calories',
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Supplements
            _buildSection(
              theme,
              isDark,
              'Supplements',
              'Support your nutrition goals',
              [
                _buildTipCard(
                  theme,
                  isDark,
                  'Protein Powder',
                  'Convenient way to meet daily protein needs\n• Whey, casein, or plant-based options\n• Great for post-workout recovery',
                ),
                _buildTipCard(
                  theme,
                  isDark,
                  'Creatine',
                  'Most researched supplement for strength and muscle\n• 5g daily for optimal results\n• Mix with water or juice',
                ),
                _buildTipCard(
                  theme,
                  isDark,
                  'Omega-3 Fish Oil',
                  'Supports joint health and recovery\n• 1-2g daily\n• Look for EPA and DHA content',
                ),
              ],
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    ThemeData theme,
    bool isDark,
    String title,
    String subtitle,
    List<Widget> children,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: isDark ? Colors.white70 : Colors.black54,
          ),
        ),
        const SizedBox(height: 16),
        ...children,
      ],
    );
  }

  Widget _buildNutrientCard(
    ThemeData theme,
    bool isDark,
    String title,
    String description,
    String recommendation,
    Color color,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getNutrientIcon(title),
                  color: color,
                  size: 24,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isDark ? Colors.white70 : Colors.black54,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFD5FF5F).withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              recommendation,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipCard(
    ThemeData theme,
    bool isDark,
    String title,
    String content,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isDark ? Colors.white70 : Colors.black54,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMealCard(
    ThemeData theme,
    bool isDark,
    String mealTime,
    String description,
    String calories,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                mealTime,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFD5FF5F).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  calories,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isDark ? Colors.white70 : Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getNutrientIcon(String nutrient) {
    switch (nutrient.toLowerCase()) {
      case 'protein':
        return Icons.fitness_center;
      case 'carbohydrates':
        return Icons.fastfood;
      case 'fats':
        return Icons.restaurant;
      default:
        return Icons.food_bank;
    }
  }
}
