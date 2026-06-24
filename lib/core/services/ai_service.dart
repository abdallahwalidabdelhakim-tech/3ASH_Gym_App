/// AI (Artificial Intelligence) service for food recognition
///
/// Handles communication with the Google AI (Gemini) service to analyze food images
/// and provide nutritional information including calorie calculation.
library;

import 'dart:convert';
import 'dart:io';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../config/app_config.dart';

class AiService {
  /// Analyzes a food image using Google's Gemini 2.5 Flash model
  ///
  /// Sends the image directly to the Google AI service for food recognition
  /// and nutritional analysis including calorie calculation.
  ///
  /// Parameters:
  /// - imageFile: File object containing the food image to analyze
  /// Returns: Future with AI analysis results as Map
  Future<Map<String, dynamic>> analyzeFood(File imageFile) async {
    try {
      // Initialize the generative model with Google AI API key
      final apiKey = AppConfig.googleAiApiKey;

      if (apiKey.isEmpty) {
        throw Exception('Google AI API key not configured');
      }

      final model = GenerativeModel(model: 'gemini-2.5-flash', apiKey: apiKey);

      // Convert image file to bytes
      final imageBytes = await imageFile.readAsBytes();
      final mimeType = _getImageMimeType(imageFile.path);

      if (mimeType == null) {
        throw Exception('Unsupported image format');
      }

      // Create content with both text prompt and image
      // Use Content.data for binary image data
      final prompt = Content.text(
        '''Please analyze this food image and provide:
1. A list of all food items recognized in the image
2. For each food item, provide:
   - Name of the food
   - Estimated quantity (in grams or pieces)
   - Estimated calorie count
3. Total calorie count for all food items in the image

Return the analysis in JSON format with the following structure:
{
  "success": true,
  "total_calories": <total_calories>,
  "food_items": [
    {
      "name": <food_name>,
      "quantity": <quantity>,
      "calories": <calories>
    }
  ]
}

If no food items are recognized, return {"success": false, "message": "No food items recognized"}.''',
      );

      // Use Content.data for the image (Uint8List)
      final imageContent = Content.data(mimeType, imageBytes);

      // Generate content with the model
      final response = await model.generateContent([prompt, imageContent]);

      // Parse the response
      if (response.text != null) {
        // Extract JSON from response (sometimes Gemini may include text before/after JSON)
        final jsonMatch = RegExp(r'\{[\s\S]*\}').firstMatch(response.text!);
        if (jsonMatch != null) {
          final jsonString = jsonMatch.group(0)!;
          final result = jsonDecode(jsonString);
          return result;
        }
        throw Exception('Failed to parse response as JSON');
      } else {
        throw Exception('No response received from AI service');
      }
    } catch (e) {
      final errorStr = e.toString();
      if (errorStr.contains('503') ||
          errorStr.contains('high demand') ||
          errorStr.contains('UNAVAILABLE')) {
        throw Exception(
          'The AI model is currently experiencing high demand. Please try again later.',
        );
      }
      throw Exception('Error analyzing image: $e');
    }
  }

  /// Determines the MIME type of an image file based on its extension
  String? _getImageMimeType(String path) {
    final extension = path.toLowerCase().split('.').last;
    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'webp':
        return 'image/webp';
      default:
        return null;
    }
  }
}
