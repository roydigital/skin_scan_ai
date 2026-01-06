import 'package:flutter/foundation.dart';
import 'package:skin_scan_ai/services/ai_service.dart';

class ScanProvider extends ChangeNotifier {
  List<String> _selectedConcerns = [];
  bool _noConcerns = false;
  String? _capturedImagePath;
  Map<String, dynamic>? _analysisResults;
  bool _isPremiumMode = false;

  List<String> get selectedConcerns => _selectedConcerns;
  bool get noConcerns => _noConcerns;
  bool get isPremiumMode => _isPremiumMode;

  void togglePremiumMode() {
    _isPremiumMode = !_isPremiumMode;
    notifyListeners();
  }

  void toggleConcern(String concern) {
    if (_selectedConcerns.contains(concern)) {
      _selectedConcerns.remove(concern);
    } else {
      _selectedConcerns.add(concern);
    }
    if (_noConcerns && _selectedConcerns.isNotEmpty) {
      _noConcerns = false;
    }
    notifyListeners();
  }

  void setNoConcerns(bool value) {
    _noConcerns = value;
    if (value) {
      _selectedConcerns.clear();
    }
    notifyListeners();
  }

  void clearConcerns() {
    _selectedConcerns.clear();
    notifyListeners();
  }

  String? get capturedImagePath => _capturedImagePath;

  void setCapturedImage(String path) {
    _capturedImagePath = path;
    notifyListeners();
  }

  Map<String, dynamic>? get analysisResults => _analysisResults;

  void setAnalysisResults(Map<String, dynamic> results) {
    _analysisResults = results;
    notifyListeners();
  }

  Future<void> analyzeSkin() async {
    if (_capturedImagePath == null) {
      throw Exception('No captured image to analyze');
    }

    try {
      final service = SkinAnalysisService();
      final results = await service.analyzeSkin(_capturedImagePath!, isPremium: _isPremiumMode);
      setAnalysisResults(results);
    } catch (e) {
      // Fallback to mock logic if API fails
      _setMockAnalysisResults();
    }
  }

  void _setMockAnalysisResults() {
    // Calculate overall score: start at 95, subtract 10 for each concern
    int overallScore = 95 - (selectedConcerns.length * 10);

    // Determine condition
    String condition = overallScore > 80 ? 'Excellent' : 'Needs Care';

    // Generate concerns list
    List<Map<String, dynamic>> concerns = [];

    // Add concerns based on selectedConcerns
    for (final concern in selectedConcerns) {
      concerns.add({
        'name': concern,
        'percentage': 50, // Fixed for mock
        'level': 'Moderate',
        'colorHex': '#FFA500',
      });
    }

    // Add one "Good" trait for positive feedback
    concerns.add({
      'name': 'Texture',
      'percentage': 15,
      'level': 'Great',
      'colorHex': '#32CD32',
    });

    // Create results map
    final results = {
      'overallScore': overallScore,
      'condition': condition,
      'concerns': concerns,
      'summary': 'Mock analysis due to API failure. Please try again later.',
    };

    setAnalysisResults(results);
  }
}
