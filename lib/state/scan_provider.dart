import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  Future<void> loadState() async {
    final prefs = await SharedPreferences.getInstance();
    final selectedConcernsString = prefs.getString('selected_concerns');
    if (selectedConcernsString != null) {
      _selectedConcerns = List<String>.from(json.decode(selectedConcernsString));
    }
    _isPremiumMode = prefs.getBool('is_premium') ?? false;
    final analysisResultsString = prefs.getString('analysis_results');
    if (analysisResultsString != null) {
      _analysisResults = Map<String, dynamic>.from(json.decode(analysisResultsString));
    }
    notifyListeners();
  }

  Future<void> _saveState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_concerns', json.encode(_selectedConcerns));
    await prefs.setBool('is_premium', _isPremiumMode);
    if (_analysisResults != null) {
      await prefs.setString('analysis_results', json.encode(_analysisResults));
    }
  }

  void togglePremiumMode() {
    _isPremiumMode = !_isPremiumMode;
    notifyListeners();
    _saveState();
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
    _saveState();
  }

  void setNoConcerns(bool value) {
    _noConcerns = value;
    if (value) {
      _selectedConcerns.clear();
    }
    notifyListeners();
    _saveState();
  }

  void clearConcerns() {
    _selectedConcerns.clear();
    notifyListeners();
    _saveState();
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
    _saveState();
  }

  Future<String> _compressImage(String sourcePath) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final targetPath = '${tempDir.path}/compressed_image.jpg';

      final compressedFile = await FlutterImageCompress.compressAndGetFile(
        sourcePath,
        targetPath,
        minWidth: 1080,
        minHeight: 1080,
        quality: 85,
      );

      if (compressedFile != null) {
        return compressedFile.path;
      } else {
        // Compression failed, return original
        return sourcePath;
      }
    } catch (e) {
      // Error during compression, return original
      debugPrint('Image compression failed: $e');
      return sourcePath;
    }
  }

  Future<void> analyzeSkin() async {
    if (_capturedImagePath == null) {
      throw Exception('No captured image to analyze');
    }

    try {
      // Compress the image
      final compressedImagePath = await _compressImage(_capturedImagePath!);

      // Log original vs compressed sizes
      final originalSize = File(_capturedImagePath!).lengthSync();
      final compressedSize = File(compressedImagePath).lengthSync();
      debugPrint('Original image size: ${originalSize / 1024} KB');
      debugPrint('Compressed image size: ${compressedSize / 1024} KB');
      debugPrint('Compression ratio: ${(originalSize / compressedSize).toStringAsFixed(2)}x');

      final service = SkinAnalysisService();
      final results = await service.analyzeSkin(compressedImagePath, isPremium: _isPremiumMode);
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
