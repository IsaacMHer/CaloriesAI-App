import '../models/meal_model.dart';
import '../models/goal_model.dart';
import '../services/api_service.dart';
import '../../core/constants/api_constants.dart';
import 'package:intl/intl.dart';

/// Repositorio para manejar comidas y metas nutricionales
class MealRepository {
  final ApiService _apiService;

  MealRepository(this._apiService);

  // ========== MEALS ==========

  /// Crea una nueva comida
  Future<MealModel> createMeal({
    required String mealType,
    required List<Map<String, dynamic>> items,
    String? imageUrl,
    String? notes,
    DateTime? dateTime,
  }) async {
    final response = await _apiService.post(
      ApiConstants.meals,
      data: {
        'mealType': mealType,
        'items': items,
        'imageUrl': imageUrl,
        'notes': notes,
        'dateTime': (dateTime ?? DateTime.now()).toIso8601String(),
      },
    );

    return MealModel.fromJson(response.data);
  }

  /// Obtiene las comidas de una fecha específica
  Future<List<MealModel>> getMealsByDate(DateTime date) async {
    final dateStr = DateFormat('yyyy-MM-dd').format(date);

    final response = await _apiService.get(
      ApiConstants.meals,
      queryParameters: {'date': dateStr},
    );

    final mealsData = response.data['meals'] as List<dynamic>;
    return mealsData.map((json) => MealModel.fromJson(json)).toList();
  }

  /// Obtiene una comida por ID
  Future<MealModel> getMealById(String mealId) async {
    final response = await _apiService.get('${ApiConstants.meals}/$mealId');
    return MealModel.fromJson(response.data);
  }

  /// Actualiza una comida
  Future<MealModel> updateMeal({
    required String mealId,
    String? mealType,
    List<Map<String, dynamic>>? items,
    String? imageUrl,
    String? notes,
  }) async {
    final data = <String, dynamic>{};

    if (mealType != null) data['mealType'] = mealType;
    if (items != null) data['items'] = items;
    if (imageUrl != null) data['imageUrl'] = imageUrl;
    if (notes != null) data['notes'] = notes;

    final response = await _apiService.put(
      '${ApiConstants.meals}/$mealId',
      data: data,
    );

    return MealModel.fromJson(response.data);
  }

  /// Elimina una comida
  Future<void> deleteMeal(String mealId) async {
    await _apiService.delete('${ApiConstants.meals}/$mealId');
  }

  // ========== GOALS ==========

  /// Obtiene las metas nutricionales del usuario
  Future<GoalModel> getGoals() async {
    final response = await _apiService.get(ApiConstants.goals);
    return GoalModel.fromJson(response.data);
  }

  /// Actualiza las metas nutricionales
  Future<GoalModel> updateGoals({
    required double dailyCalories,
    required double dailyProtein,
    required double dailyCarbs,
    required double dailyFats,
    bool autoCalculate = true,
  }) async {
    final response = await _apiService.put(
      ApiConstants.goals,
      data: {
        'dailyCalories': dailyCalories,
        'dailyProtein': dailyProtein,
        'dailyCarbs': dailyCarbs,
        'dailyFats': dailyFats,
        'autoCalculate': autoCalculate,
      },
    );

    return GoalModel.fromJson(response.data);
  }
}
