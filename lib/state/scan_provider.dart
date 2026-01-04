import 'package:flutter/foundation.dart';

class ScanProvider extends ChangeNotifier {
  List<String> _selectedConcerns = [];
  bool _noConcerns = false;
  String? _capturedImagePath;
  Map<String, dynamic>? _analysisResults;

  List<String> get selectedConcerns => _selectedConcerns;
  bool get noConcerns => _noConcerns;

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
