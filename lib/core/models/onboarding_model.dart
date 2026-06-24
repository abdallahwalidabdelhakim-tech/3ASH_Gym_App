/// Onboarding data model
///
/// Represents all the information collected from the user during the onboarding process.
/// This data is used to calculate personalized workout and nutrition plans.
class OnboardingData {

  /// Creates an OnboardingData instance
  OnboardingData({
    this.sex,
    this.dateOfBirth,
    this.age,
    this.height,
    this.weight,
    this.targetWeight,
  });

  /// Creates an OnboardingData instance from JSON map
  factory OnboardingData.fromJson(Map<String, dynamic> json) {
    return OnboardingData(
      sex: json['sex'],
      dateOfBirth: json['date_of_birth'] != null
          ? DateTime.parse(json['date_of_birth'])
          : null,
      age: json['age'],
      height: json['height']?.toDouble(),
      weight: json['weight']?.toDouble(),
      targetWeight: json['target_weight']?.toDouble(),
    );
  }
  
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
  /// Converts the model to JSON map
  Map<String, dynamic> toJson() {
    return {
      'sex': sex,
      'date_of_birth': dateOfBirth?.toIso8601String(),
      'age': age,
      'height': height,
      'weight': weight,
      'target_weight': targetWeight,
    };
  }
}


