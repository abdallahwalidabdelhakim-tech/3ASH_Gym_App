/// Exercise data model
///
/// Represents a single exercise with all related information including
/// media assets and instructions.
class Exercise {

  /// Creates an Exercise instance
  const Exercise({
    required this.name,
    this.mainImageUrl,
    this.videoUrl,
    this.galleryImages = const [],
    this.instructions = const [],
  });

  /// Creates an Exercise instance from JSON map
  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      name: json['name'] ?? '',
      mainImageUrl: json['mainImageUrl'],
      videoUrl: json['videoUrl'],
      galleryImages: List<String>.from(json['galleryImages'] ?? []),
      instructions: List<String>.from(json['instructions'] ?? []),
    );
  }
  /// Name of the exercise
  final String name;
  
  /// URL to the main image of the exercise
  final String? mainImageUrl;
  
  /// URL to the video demonstration of the exercise
  final String? videoUrl;
  
  /// List of gallery image URLs for the exercise
  final List<String> galleryImages;
  
  /// List of step-by-step instructions for performing the exercise
  final List<String> instructions;

  /// Converts the model to JSON map
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'mainImageUrl': mainImageUrl,
      'videoUrl': videoUrl,
      'galleryImages': galleryImages,
      'instructions': instructions,
    };
  }
}
