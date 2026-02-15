/// AI (Artificial Intelligence) service for food recognition
///
/// Handles communication with the AI service to analyze food images
/// and provide nutritional information.
library;
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config/app_config.dart';

class AiService {
  /// Analyzes a food image using the AI service
  /// 
  /// Converts the image to base64 and sends it to the backend AI service
  /// for food recognition and nutritional analysis.
  /// 
  /// Parameters:
  /// - imageFile: File object containing the food image to analyze
  // ignore: unintended_html_in_doc_comment
  /// Returns: Future with AI analysis results as Map<String, dynamic>
  Future<Map<String, dynamic>> analyzeFood(File imageFile) async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'auth_token');
    
    // Convert image file to base64 encoded string
    final bytes = await imageFile.readAsBytes();
    final base64Image = base64Encode(bytes);

    final baseUrl = _normalizeBaseUrl(AppConfig.baseUrl);
    final uri = Uri.parse('$baseUrl/ai/food');
    
    // Prepare request headers with authentication token if available
    final headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };

    try {
      // Send POST request to AI service with 30 second timeout
      final response = await http.post(
        uri,
        headers: headers,
        body: jsonEncode({'image': base64Image}),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to analyze image: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      throw Exception('Error connecting to AI service: $e');
    }
  }

  /// Normalizes API base URL by removing trailing slash
  /// 
  /// Parameters:
  /// - url: The URL to normalize
  /// Returns: Normalized URL without trailing slash
  String _normalizeBaseUrl(String url) {
    if (url.endsWith('/')) {
      return url.substring(0, url.length - 1);
    }
    return url;
  }
}
