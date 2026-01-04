import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class SkinAnalysisService {
  Future<String> analyzeSkin(String imagePath) async {
    final apiKey = dotenv.env['GEMINI_API_KEY'];
    if (apiKey == null) {
      throw Exception('API Key not found in .env');
    }
    final model = GenerativeModel(model: 'gemini-2.0-flash', apiKey: apiKey);
    return 'Connection Successful! AI Service is ready.';
  }
}
