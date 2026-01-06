import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class SkinAnalysisService {
  Future<Map<String, dynamic>> analyzeSkin(String imagePath, {bool isPremium = false}) async {
    try {
      final apiKey = dotenv.env['GEMINI_API_KEY'];
      if (apiKey == null) {
        throw Exception('GEMINI_API_KEY not found in .env file');
      }

      final modelName = isPremium ? 'gemini-2.5-pro' : 'gemini-2.0-flash';
      final model = GenerativeModel(model: modelName, apiKey: apiKey);

      final imageBytes = await File(imagePath).readAsBytes();
      final imagePart = DataPart('image/jpeg', imageBytes);

      const prompt = '''
Analyze this skin image and provide a detailed assessment. Respond ONLY with a valid JSON object in the following exact structure, no additional text, no markdown formatting:

{
  "overallScore": 75,
  "condition": "Good",
  "concerns": [
    {"name": "Acne", "percentage": 20, "level": "Medium", "colorHex": "#FF6B6B"},
    {"name": "Wrinkles", "percentage": 10, "level": "Low", "colorHex": "#4ECDC4"}
  ],
  "summary": "Your skin is in good condition with minor concerns that can be addressed with proper care."
}

Guidelines:
- overallScore: integer from 0-100 representing overall skin health
- condition: string like "Excellent", "Good", "Fair", "Poor", "Needs Care"
- concerns: array of objects, each with name, percentage (0-100), level ("High", "Medium", "Low"), colorHex (hex color code)
- summary: 1-2 sentences describing the analysis
- Ensure the response is pure JSON, no backticks or code blocks
''';

      final content = Content.multi([TextPart(prompt), imagePart]);
      final response = await model.generateContent([content]);
      final responseText = response.text ?? '';

      // Sanitize response: remove potential markdown
      final sanitized = responseText.replaceAll('```json', '').replaceAll('```', '').trim();

      final jsonResponse = json.decode(sanitized) as Map<String, dynamic>;

      // Validate structure
      if (!jsonResponse.containsKey('overallScore') ||
          !jsonResponse.containsKey('condition') ||
          !jsonResponse.containsKey('concerns') ||
          !jsonResponse.containsKey('summary')) {
        throw Exception('Invalid response structure from AI');
      }

      return jsonResponse;
    } catch (e) {
      throw Exception('Failed to analyze skin: $e');
    }
  }
}
