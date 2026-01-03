import 'package:flutter/foundation.dart';

class ScanProvider extends ChangeNotifier {
  List<String> _selectedConcerns = [];
  String? _capturedImagePath;
  Map<String, dynamic>? _analysisResults;

  List<String> get selectedConcerns => _selectedConcerns;

  void toggleConcern(String concern) {
    if (_selectedConcerns.contains(concern)) {
      _selectedConcerns.remove(concern);
    } else {
      _selectedConcerns.add(concern);
    }
    notifyListeners();
  }

  String? get capturedImagePath => _capturedImagePath;

  void setImagePath(String path) {
    _capturedImagePath = path;
    notifyListeners();
  }

  Map<String, dynamic>? get analysisResults => _analysisResults;

  void setAnalysisResults(Map<String, dynamic> results) {
    _analysisResults = results;
    notifyListeners();
  }
}
