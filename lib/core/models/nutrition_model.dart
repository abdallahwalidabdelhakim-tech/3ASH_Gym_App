/// Nutrition data model
///
/// Represents the daily nutrition log including calories and macronutrients.
class NutritionModel {
  NutritionModel({
    required this.date,
    this.calories = 0,
    this.protein = 0,
    this.carbs = 0,
    this.lipid = 0,
    this.targetCalories = 2400,
    this.targetProtein = 115,
    this.targetCarbs = 160,
    this.targetLipid = 43,
  });

  factory NutritionModel.fromJson(Map<String, dynamic> json) {
    return NutritionModel(
      date: json['date'] as String,
      calories: (json['calories'] as num?)?.toInt() ?? 0,
      protein: (json['protein'] as num?)?.toDouble() ?? 0,
      carbs: (json['carbs'] as num?)?.toDouble() ?? 0,
      lipid: (json['lipid'] as num?)?.toDouble() ?? 0,
      targetCalories: (json['target_calories'] as num?)?.toInt() ?? 2400,
      targetProtein: (json['target_protein'] as num?)?.toDouble() ?? 115,
      targetCarbs: (json['target_carbs'] as num?)?.toDouble() ?? 160,
      targetLipid: (json['target_lipid'] as num?)?.toDouble() ?? 43,
    );
  }

  final String date;
  final int calories;
  final double protein;
  final double carbs;
  final double lipid;
  
  // Targets can be customizable per day or user settings
  final int targetCalories;
  final double targetProtein;
  final double targetCarbs;
  final double targetLipid;

  NutritionModel copyWith({
    String? date,
    int? calories,
    double? protein,
    double? carbs,
    double? lipid,
    int? targetCalories,
    double? targetProtein,
    double? targetCarbs,
    double? targetLipid,
  }) {
    return NutritionModel(
      date: date ?? this.date,
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      carbs: carbs ?? this.carbs,
      lipid: lipid ?? this.lipid,
      targetCalories: targetCalories ?? this.targetCalories,
      targetProtein: targetProtein ?? this.targetProtein,
      targetCarbs: targetCarbs ?? this.targetCarbs,
      targetLipid: targetLipid ?? this.targetLipid,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'lipid': lipid,
      'target_calories': targetCalories,
      'target_protein': targetProtein,
      'target_carbs': targetCarbs,
      'target_lipid': targetLipid,
    };
  }
}
