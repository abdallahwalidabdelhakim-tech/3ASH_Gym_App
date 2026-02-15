/// Onboarding data model
///
/// Represents all the information collected from the user during the onboarding process.
/// This data is used to calculate personalized workout and nutrition plans.
class OnboardingData {

  /// Creates an OnboardingData instance
  OnboardingData({
    this.goal,
    this.activityLevel,
    this.sex,
    this.dateOfBirth,
    this.age,
    this.height,
    this.weight,
    this.targetWeight,
    this.objective,
    this.targetCalories,
  });

  /// Creates an OnboardingData instance from JSON map
  factory OnboardingData.fromJson(Map<String, dynamic> json) {
    return OnboardingData(
      goal: json['goal'],
      activityLevel: json['activity_level'],
      sex: json['sex'],
      dateOfBirth: json['date_of_birth'] != null
          ? DateTime.parse(json['date_of_birth'])
          : null,
      age: json['age'],
      height: json['height']?.toDouble(),
      weight: json['weight']?.toDouble(),
      targetWeight: json['target_weight']?.toDouble(),
      objective: json['objective'],
      targetCalories: json['target_calories'],
    );
  }
  /// User's fitness goal (weight_loss, maintain_weight, weight_gain)
  String? goal; 
  
  /// User's activity level (not_very_active, little_active, active, very_active)
  String? activityLevel; 
  
  /// User's biological sex (male, female)
  String? sex; 
  
  /// User's date of birth
  DateTime? dateOfBirth;
  
  /// User's age (calculated from date of birth)
  int? age;
  
  /// User's height in centimeters
  double? height; 
  
  /// User's current weight in kilograms
  double? weight; 
  
  /// User's target weight in kilograms
  double? targetWeight; 
  
  /// Weekly weight change objective in kilograms ('0.25', '0.5', '1.5', '2')
  String? objective; 
  
  /// Daily calorie target based on user's goals
  int? targetCalories;

  /// Converts the model to JSON map
  Map<String, dynamic> toJson() {
    return {
      'goal': goal,
      'activity_level': activityLevel,
      'sex': sex,
      'date_of_birth': dateOfBirth?.toIso8601String(),
      'age': age,
      'height': height,
      'weight': weight,
      'target_weight': targetWeight,
      'objective': objective,
      'target_calories': targetCalories,
    };
  }
}


