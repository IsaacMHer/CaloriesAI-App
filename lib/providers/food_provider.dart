import 'package:flutter/foundation.dart';
import '../data/models/food_model.dart';
import '../data/repositories/food_repository.dart';

/// Provider para manejar el estado de alimentos y búsqueda
class FoodProvider with ChangeNotifier {
  final FoodRepository _foodRepository;

  List<FoodModel> _searchResults = [];
  List<FoodModel> _detectedFoods = [];
  List<FoodModel> _customFoods = [];
  bool _isLoading = false;
  bool _isAnalyzing = false;
  String? _errorMessage;

  FoodProvider(this._foodRepository);

  // Getters
  List<FoodModel> get searchResults => _searchResults;
  List<FoodModel> get detectedFoods => _detectedFoods;
  List<FoodModel> get customFoods => _customFoods;
  bool get isLoading => _isLoading;
  bool get isAnalyzing => _isAnalyzing;
  String? get errorMessage => _errorMessage;

  /// Analiza una imagen con IA
  Future<bool> analyzeImage(String imagePath) async {
    try {
      _isAnalyzing = true;
      _errorMessage = null;
      notifyListeners();

      _detectedFoods = await _foodRepository.analyzeImage(imagePath);

      _isAnalyzing = false;
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      _isAnalyzing = false;
      notifyListeners();
      return false;
    }
  }

  /// Busca alimentos
  Future<void> searchFoods(String query) async {
    if (query.isEmpty) {
      _searchResults = [];
      notifyListeners();
      return;
    }

    try {
      _setLoading(true);
      _errorMessage = null;

      _searchResults = await _foodRepository.searchFoods(query);

      _setLoading(false);
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
    }
  }

  /// Crea un alimento personalizado
  Future<bool> createCustomFood({
    required String name,
    required double calories,
    required double protein,
    required double carbs,
    required double fats,
    required double servingSize,
    String servingUnit = 'g',
    String? category,
  }) async {
    try {
      _setLoading(true);
      _errorMessage = null;

      final food = await _foodRepository.createCustomFood(
        name: name,
        calories: calories,
        protein: protein,
        carbs: carbs,
        fats: fats,
        servingSize: servingSize,
        servingUnit: servingUnit,
        category: category,
      );

      _customFoods.add(food);

      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  /// Carga los alimentos personalizados del usuario
  Future<void> loadCustomFoods() async {
    try {
      _setLoading(true);
      _errorMessage = null;

      _customFoods = await _foodRepository.getCustomFoods();

      _setLoading(false);
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
    }
  }

  /// Limpia los resultados de búsqueda
  void clearSearchResults() {
    _searchResults = [];
    notifyListeners();
  }

  /// Limpia los alimentos detectados
  void clearDetectedFoods() {
    _detectedFoods = [];
    notifyListeners();
  }

  /// Limpia el error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Métodos privados
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message.replaceAll('Exception: ', '');
    notifyListeners();
  }
}
