/// Body measurement log data model
///
/// Represents a single entry of body measurements taken on a specific date.
/// Stores various body measurements and metrics.
class BodyLog {

  /// Creates a BodyLog instance
  BodyLog({
    this.id = '',
    required this.date,
    this.weight,
    this.bodyFat,
    this.chest,
    this.waist,
    this.hips,
    this.arms,
    this.thighs,
    this.calves,
  });

  /// Creates a BodyLog instance from JSON map
  factory BodyLog.fromJson(Map<String, dynamic> json) {
    return BodyLog(
      id: json['id'] ?? '',
      date: DateTime.parse(json['date']),
      weight: json['weight']?.toDouble(),
      bodyFat: json['bodyFat']?.toDouble(),
      chest: json['chest']?.toDouble(),
      waist: json['waist']?.toDouble(),
      hips: json['hips']?.toDouble(),
      arms: json['arms']?.toDouble(),
      thighs: json['thighs']?.toDouble(),
      calves: json['calves']?.toDouble(),
    );
  }
  /// Unique identifier for the log entry
  final String id;
  
  /// Date when the measurements were taken
  final DateTime date;
  
  /// Weight in kilograms
  final double? weight;
  
  /// Body fat percentage
  final double? bodyFat;
  
  /// Chest circumference in centimeters
  final double? chest;
  
  /// Waist circumference in centimeters
  final double? waist;
  
  /// Hips circumference in centimeters
  final double? hips;
  
  /// Arms circumference in centimeters
  final double? arms;
  
  /// Thighs circumference in centimeters
  final double? thighs;
  
  /// Calves circumference in centimeters
  final double? calves;

  /// Converts the model to JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'weight': weight,
      'bodyFat': bodyFat,
      'chest': chest,
      'waist': waist,
      'hips': hips,
      'arms': arms,
      'thighs': thighs,
      'calves': calves,
    };
  }

  /// Creates a copy of the BodyLog with optional field updates
  /// 
  /// Parameters:
  /// - id: New ID (optional)
  /// - date: New date (optional)
  /// - weight: New weight (optional)
  /// - bodyFat: New body fat percentage (optional)
  /// - chest: New chest measurement (optional)
  /// - waist: New waist measurement (optional)
  /// - hips: New hips measurement (optional)
  /// - arms: New arms measurement (optional)
  /// - thighs: New thighs measurement (optional)
  /// - calves: New calves measurement (optional)
  /// Returns: New BodyLog instance with updated fields
  BodyLog copyWith({
    String? id,
    DateTime? date,
    double? weight,
    double? bodyFat,
    double? chest,
    double? waist,
    double? hips,
    double? arms,
    double? thighs,
    double? calves,
  }) {
    return BodyLog(
      id: id ?? this.id,
      date: date ?? this.date,
      weight: weight ?? this.weight,
      bodyFat: bodyFat ?? this.bodyFat,
      chest: chest ?? this.chest,
      waist: waist ?? this.waist,
      hips: hips ?? this.hips,
      arms: arms ?? this.arms,
      thighs: thighs ?? this.thighs,
      calves: calves ?? this.calves,
    );
  }
}
