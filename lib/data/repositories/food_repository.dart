import '../models/food_model.dart';
import '../models/meal_model.dart';
import '../models/api_response_model.dart';
import '../services/api_service.dart';
import '../../core/constants/api_constants.dart';

/// Repositorio para manejar alimentos y análisis de imágenes
class FoodRepository {
  final ApiService _apiService;

  FoodRepository(this._apiService);

  /// Analiza una imagen con Gemini AI
  Future<AnalyzeImageResponse> analyzeImage(String imagePath) async {
    final response = await _apiService.uploadFile(
      ApiConstants.mealsAnalyzeImage,
      imagePath,
      'image',
    );

    // Desempaquetar ApiResponse<AnalyzeImageResponse>
    final apiResponse = ApiResponse<AnalyzeImageResponse>.fromJson(
      response.data,
      (json) => AnalyzeImageResponse.fromJson(json as Map<String, dynamic>),
    );

    if (!apiResponse.success || apiResponse.data == null) {
      throw Exception(apiResponse.message ?? 'Error al analizar imagen');
    }

    return apiResponse.data!;
  }

  /// Busca alimentos por query
  Future<List<FoodModel>> searchFoods(String query, {int limit = 20}) async {
    final response = await _apiService.get(
      ApiConstants.foodsSearch,
      queryParameters: {
        'query': query,
        'limit': limit,
      },
    );

    // Desempaquetar ApiResponse<List<FoodDto>>
    final apiResponse = ApiResponse<List<FoodModel>>.fromJson(
      response.data,
      (json) => (json as List<dynamic>)
          .map((item) => FoodModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );

    if (!apiResponse.success || apiResponse.data == null) {
      throw Exception(apiResponse.message ?? 'Error al buscar alimentos');
    }

    return apiResponse.data!;
  }

  /// Obtiene un alimento por ID
  Future<FoodModel> getFoodById(int id) async {
    final response = await _apiService.get(ApiConstants.foodById(id));

    // Desempaquetar ApiResponse<FoodDto>
    final apiResponse = ApiResponse<FoodModel>.fromJson(
      response.data,
      (json) => FoodModel.fromJson(json as Map<String, dynamic>),
    );

    if (!apiResponse.success || apiResponse.data == null) {
      throw Exception(apiResponse.message ?? 'Error al obtener alimento');
    }

    return apiResponse.data!;
  }

  /// Crea un alimento personalizado
  Future<FoodModel> createCustomFood(CreateCustomFoodRequest request) async {
    final response = await _apiService.post(
      ApiConstants.foodsCustom,
      data: request.toJson(),
    );

    // Desempaquetar ApiResponse<FoodDto>
    final apiResponse = ApiResponse<FoodModel>.fromJson(
      response.data,
      (json) => FoodModel.fromJson(json as Map<String, dynamic>),
    );

    if (!apiResponse.success || apiResponse.data == null) {
      throw Exception(apiResponse.message ?? 'Error al crear alimento personalizado');
    }

    return apiResponse.data!;
  }

  // Obtener alimentos personalizados
  Future<List<FoodModel>> getCustomFoods() async {
    try {
      // Usamos search con un query vacío o "*" para obtener todos
      // y luego filtramos solo los custom
      final allFoods = await searchFoods('', limit: 100);
      
      // Filtrar solo los alimentos custom (isCustom = true)
      return allFoods.where((food) => food.isCustom == true).toList();
    } catch (e) {
      throw Exception('Error al obtener alimentos personalizados: $e');
    }
  }

  /// Actualiza un alimento personalizado
  Future<FoodModel> updateCustomFood(int id, CreateCustomFoodRequest request) async {
    final response = await _apiService.put(
      ApiConstants.updateCustomFood(id),
      data: request.toJson(),
    );

    // Desempaquetar ApiResponse<FoodDto>
    final apiResponse = ApiResponse<FoodModel>.fromJson(
      response.data,
      (json) => FoodModel.fromJson(json as Map<String, dynamic>),
    );

    if (!apiResponse.success || apiResponse.data == null) {
      throw Exception(apiResponse.message ?? 'Error al actualizar alimento');
    }

    return apiResponse.data!;
  }

  /// Elimina un alimento personalizado
  Future<void> deleteCustomFood(int id) async {
    final response = await _apiService.delete(ApiConstants.deleteCustomFood(id));

    // Desempaquetar ApiResponse<Object>
    final apiResponse = ApiResponse<dynamic>.fromJson(response.data, null);

    if (!apiResponse.success) {
      throw Exception(apiResponse.message ?? 'Error al eliminar alimento');
    }
  }

  /// Obtiene las categorías de alimentos
  Future<List<String>> getCategories() async {
    final response = await _apiService.get(ApiConstants.foodCategories);

    // Desempaquetar ApiResponse<List<String>>
    final apiResponse = ApiResponse<List<String>>.fromJson(
      response.data,
      (json) => (json as List<dynamic>).map((item) => item.toString()).toList(),
    );

    if (!apiResponse.success || apiResponse.data == null) {
      throw Exception(apiResponse.message ?? 'Error al obtener categorías');
    }

    return apiResponse.data!;
  }
}
