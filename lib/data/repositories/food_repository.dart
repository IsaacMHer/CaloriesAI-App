import '../models/food_model.dart';
import '../services/api_service.dart';
import '../../core/constants/api_constants.dart';

/// Repositorio para manejar alimentos y análisis de imágenes
class FoodRepository {
  final ApiService _apiService;

  FoodRepository(this._apiService);

  /// Analiza una imagen con Gemini AI
  /// Retorna lista de alimentos detectados
  Future<List<FoodModel>> analyzeImage(String imagePath) async {
    final response = await _apiService.uploadFile(
      ApiConstants.foodAnalyzeImage,
      imagePath,
      'image',
    );

    final foodsData = response.data['foods'] as List<dynamic>;
    return foodsData.map((json) => FoodModel.fromJson(json)).toList();
  }

  /// Busca alimentos por query
  Future<List<FoodModel>> searchFoods(String query) async {
    final response = await _apiService.get(
      ApiConstants.foodsSearch,
      queryParameters: {'query': query},
    );

    final foodsData = response.data['foods'] as List<dynamic>;
    return foodsData.map((json) => FoodModel.fromJson(json)).toList();
  }

  /// Crea un alimento personalizado
  Future<FoodModel> createCustomFood({
    required String name,
    required double calories,
    required double protein,
    required double carbs,
    required double fats,
    required double servingSize,
    String servingUnit = 'g',
    String? category,
  }) async {
    final response = await _apiService.post(
      ApiConstants.foodsCustom,
      data: {
        'name': name,
        'calories': calories,
        'protein': protein,
        'carbs': carbs,
        'fats': fats,
        'servingSize': servingSize,
        'servingUnit': servingUnit,
        'category': category,
      },
    );

    return FoodModel.fromJson(response.data);
  }

  /// Obtiene los alimentos personalizados del usuario
  Future<List<FoodModel>> getCustomFoods() async {
    final response = await _apiService.get(ApiConstants.foodsCustom);

    final foodsData = response.data['foods'] as List<dynamic>;
    return foodsData.map((json) => FoodModel.fromJson(json)).toList();
  }
}
