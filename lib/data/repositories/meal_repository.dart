import '../models/meal_model.dart';
import '../models/goal_model.dart';
import '../models/api_response_model.dart';
import '../services/api_service.dart';
import '../../core/constants/api_constants.dart';
import 'package:intl/intl.dart';

/// Repositorio para manejar comidas y metas nutricionales
class MealRepository {
  final ApiService _apiService;

  MealRepository(this._apiService);

  // ========== MEALS ==========

  /// Crea una nueva comida
  Future<MealModel> createMeal(CreateMealRequest request) async {
    final response = await _apiService.post(
      ApiConstants.meals,
      data: request.toJson(),
    );

    // Desempaquetar ApiResponse<MealDto>
    final apiResponse = ApiResponse<MealModel>.fromJson(
      response.data,
      (json) => MealModel.fromJson(json as Map<String, dynamic>),
    );

    if (!apiResponse.success || apiResponse.data == null) {
      throw Exception(apiResponse.message ?? 'Error al crear comida');
    }

    return apiResponse.data!;
  }

  /// Obtiene las comidas de una fecha específica
  Future<List<MealModel>> getMealsByDate(DateTime date) async {
    final response = await _apiService.get(
      ApiConstants.meals,
      queryParameters: {'date': date.toIso8601String()},
    );

    // Desempaquetar ApiResponse<List<MealDto>>
    final apiResponse = ApiResponse<List<MealModel>>.fromJson(
      response.data,
      (json) => (json as List<dynamic>)
          .map((item) => MealModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );

    if (!apiResponse.success || apiResponse.data == null) {
      throw Exception(apiResponse.message ?? 'Error al obtener comidas');
    }

    return apiResponse.data!;
  }

  /// Obtiene una comida por ID
  Future<MealModel> getMealById(int mealId) async {
    final response = await _apiService.get(ApiConstants.mealById(mealId));

    // Desempaquetar ApiResponse<MealDto>
    final apiResponse = ApiResponse<MealModel>.fromJson(
      response.data,
      (json) => MealModel.fromJson(json as Map<String, dynamic>),
    );

    if (!apiResponse.success || apiResponse.data == null) {
      throw Exception(apiResponse.message ?? 'Error al obtener comida');
    }

    return apiResponse.data!;
  }

  /// Actualiza una comida
  Future<MealModel> updateMeal(int mealId, CreateMealRequest request) async {
    final response = await _apiService.put(
      ApiConstants.updateMeal(mealId),
      data: request.toJson(),
    );

    // Desempaquetar ApiResponse<MealDto>
    final apiResponse = ApiResponse<MealModel>.fromJson(
      response.data,
      (json) => MealModel.fromJson(json as Map<String, dynamic>),
    );

    if (!apiResponse.success || apiResponse.data == null) {
      throw Exception(apiResponse.message ?? 'Error al actualizar comida');
    }

    return apiResponse.data!;
  }

  /// Elimina una comida
  Future<void> deleteMeal(int mealId) async {
    final response = await _apiService.delete(ApiConstants.deleteMeal(mealId));

    // Desempaquetar ApiResponse<Object>
    final apiResponse = ApiResponse<dynamic>.fromJson(response.data, null);

    if (!apiResponse.success) {
      throw Exception(apiResponse.message ?? 'Error al eliminar comida');
    }
  }

  // ========== GOALS ==========

  /// Obtiene las metas nutricionales del usuario
  Future<GoalModel> getGoals() async {
    final response = await _apiService.get(ApiConstants.goals);

    // Desempaquetar ApiResponse<NutritionalGoalDto>
    final apiResponse = ApiResponse<GoalModel>.fromJson(
      response.data,
      (json) => GoalModel.fromJson(json as Map<String, dynamic>),
    );

    if (!apiResponse.success || apiResponse.data == null) {
      throw Exception(apiResponse.message ?? 'Error al obtener metas');
    }

    return apiResponse.data!;
  }

  /// Actualiza las metas nutricionales
  Future<GoalModel> updateGoals(UpdateGoalRequest request) async {
    final response = await _apiService.put(
      ApiConstants.goals,
      data: request.toJson(),
    );

    // Desempaquetar ApiResponse<NutritionalGoalDto>
    final apiResponse = ApiResponse<GoalModel>.fromJson(
      response.data,
      (json) => GoalModel.fromJson(json as Map<String, dynamic>),
    );

    if (!apiResponse.success || apiResponse.data == null) {
      throw Exception(apiResponse.message ?? 'Error al actualizar metas');
    }

    return apiResponse.data!;
  }

  /// Obtiene metas sugeridas basadas en el perfil del usuario
  Future<GoalModel> getSuggestedGoals() async {
    final response = await _apiService.post(ApiConstants.goalsSuggested);

    // Desempaquetar ApiResponse<NutritionalGoalDto>
    final apiResponse = ApiResponse<GoalModel>.fromJson(
      response.data,
      (json) => GoalModel.fromJson(json as Map<String, dynamic>),
    );

    if (!apiResponse.success || apiResponse.data == null) {
      throw Exception(apiResponse.message ?? 'Error al obtener metas sugeridas');
    }

    return apiResponse.data!;
  }
}
