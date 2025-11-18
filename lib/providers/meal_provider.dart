import 'package:flutter/foundation.dart';
import '../data/models/meal_model.dart';
import '../data/models/goal_model.dart';
import '../data/repositories/meal_repository.dart';

/// Provider para manejar el estado de comidas y metas
class MealProvider with ChangeNotifier {
  final MealRepository _mealRepository;

  List<MealModel> _meals = [];
  GoalModel? _goals;
  bool _isLoading = false;
  String? _errorMessage;
  DateTime _selectedDate = DateTime.now();

  MealProvider(this._mealRepository);

  // Getters
  List<MealModel> get meals => _meals;
  GoalModel? get goals => _goals;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  DateTime get selectedDate => _selectedDate;

  /// Comidas agrupadas por tipo
  List<MealModel> getMealsByType(MealType mealType) {
    return _meals.where((meal) => meal.mealType == mealType).toList();
  }

  /// Total de calorías consumidas hoy
  double get totalCalories =>
      _meals.fold(0, (sum, meal) => sum + meal.totalCalories);

  /// Total de proteína consumida hoy
  double get totalProtein =>
      _meals.fold(0, (sum, meal) => sum + meal.totalProtein);

  /// Total de carbohidratos consumidos hoy
  double get totalCarbs => _meals.fold(0, (sum, meal) => sum + meal.totalCarbs);

  /// Total de grasas consumidas hoy
  double get totalFat => _meals.fold(0, (sum, meal) => sum + meal.totalFat);

  /// Porcentaje de calorías consumidas
  double get caloriesProgress {
    if (_goals == null || _goals!.dailyCalories <= 0) return 0;
    return (totalCalories / _goals!.dailyCalories) * 100;
  }

  /// Porcentaje de proteína consumida
  double get proteinProgress {
    if (_goals == null || _goals!.dailyProtein <= 0) return 0;
    return (totalProtein / _goals!.dailyProtein) * 100;
  }

  /// Porcentaje de carbohidratos consumidos
  double get carbsProgress {
    if (_goals == null || _goals!.dailyCarbs <= 0) return 0;
    return (totalCarbs / _goals!.dailyCarbs) * 100;
  }

  /// Porcentaje de grasas consumidas
  double get fatProgress {
    if (_goals == null || _goals!.dailyFat <= 0) return 0;
    return (totalFat / _goals!.dailyFat) * 100;
  }

  /// Cambia la fecha seleccionada y carga las comidas
  Future<void> setSelectedDate(DateTime date) async {
    _selectedDate = date;
    notifyListeners();
    await loadMeals();
  }

  /// Carga las metas nutricionales
  Future<void> loadGoals() async {
    try {
      _goals = await _mealRepository.getGoals();
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    }
  }

  /// Actualiza las metas nutricionales
  Future<bool> updateGoals({
    required double dailyCalories,
    required double dailyProtein,
    required double dailyCarbs,
    required double dailyFat,
  }) async {
    try {
      _setLoading(true);
      _errorMessage = null;

      _goals = await _mealRepository.updateGoals(
        dailyCalories: dailyCalories,
        dailyProtein: dailyProtein,
        dailyCarbs: dailyCarbs,
        dailyFat: dailyFat,
      );

      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  /// Carga las comidas de la fecha seleccionada
  Future<void> loadMeals() async {
    try {
      _setLoading(true);
      _errorMessage = null;

      _meals = await _mealRepository.getMealsByDate(_selectedDate);

      _setLoading(false);
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
    }
  }

  /// Crea una nueva comida
  Future<bool> createMeal(CreateMealRequest request) async {
    try {
      _setLoading(true);
      _errorMessage = null;

      final meal = await _mealRepository.createMeal(request);

      // Agregar a la lista si es de la fecha seleccionada
      final mealDate = DateTime(
        meal.date.year,
        meal.date.month,
        meal.date.day,
      );
      final selectedDateOnly = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
      );

      if (mealDate == selectedDateOnly) {
        _meals.add(meal);
      }

      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  /// Actualiza una comida
  Future<bool> updateMeal({
    required int mealId,
    MealType? mealType,
    List<MealFoodItemRequest>? foods,
    String? imageUrl,
    String? notes,
  }) async {
    try {
      _setLoading(true);
      _errorMessage = null;

      final updatedMeal = await _mealRepository.updateMeal(
        mealId: mealId,
        mealType: mealType,
        foods: foods,
        imageUrl: imageUrl,
        notes: notes,
      );

      // Actualizar en la lista
      final index = _meals.indexWhere((m) => m.id == mealId);
      if (index != -1) {
        _meals[index] = updatedMeal;
      }

      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  /// Elimina una comida
  Future<bool> deleteMeal(int mealId) async {
    try {
      _setLoading(true);
      _errorMessage = null;

      await _mealRepository.deleteMeal(mealId);

      // Eliminar de la lista
      _meals.removeWhere((m) => m.id == mealId);

      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
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
