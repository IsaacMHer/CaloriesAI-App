import '../../core/constants/app_constants.dart';

/// Utilidades para cálculos nutricionales
class NutritionCalculations {
  /// Calcula BMR (Basal Metabolic Rate) usando la fórmula de Mifflin-St Jeor
  /// weight: peso en kg
  /// height: altura en cm
  /// age: edad en años
  /// gender: 'male' o 'female'
  static double calculateBMR({
    required double weight,
    required double height,
    required int age,
    required String gender,
  }) {
    // Fórmula Mifflin-St Jeor
    // Hombres: (10 × peso en kg) + (6.25 × altura en cm) - (5 × edad en años) + 5
    // Mujeres: (10 × peso en kg) + (6.25 × altura en cm) - (5 × edad en años) - 161

    final baseBMR = (10 * weight) + (6.25 * height) - (5 * age);

    if (gender == AppConstants.genderMale) {
      return baseBMR + 5;
    } else if (gender == AppConstants.genderFemale) {
      return baseBMR - 161;
    } else {
      // Para 'other', usar promedio
      return baseBMR - 78;
    }
  }

  /// Calcula TDEE (Total Daily Energy Expenditure)
  /// BMR multiplicado por factor de actividad
  static double calculateTDEE({
    required double bmr,
    required String activityLevel,
  }) {
    double activityMultiplier;

    switch (activityLevel) {
      case AppConstants.activitySedentary:
        activityMultiplier = 1.2; // Poco o ningún ejercicio
        break;
      case AppConstants.activityLight:
        activityMultiplier = 1.375; // Ejercicio ligero 1-3 días/semana
        break;
      case AppConstants.activityModerate:
        activityMultiplier = 1.55; // Ejercicio moderado 3-5 días/semana
        break;
      case AppConstants.activityActive:
        activityMultiplier = 1.725; // Ejercicio intenso 6-7 días/semana
        break;
      case AppConstants.activityVeryActive:
        activityMultiplier = 1.9; // Ejercicio muy intenso, trabajo físico
        break;
      default:
        activityMultiplier = 1.2;
    }

    return bmr * activityMultiplier;
  }

  /// Calcula calorías objetivo basado en el goal
  static double calculateGoalCalories({
    required double tdee,
    required String goal,
  }) {
    switch (goal) {
      case AppConstants.goalLose:
        return tdee - 500; // Déficit de 500 kcal para perder ~0.5kg/semana
      case AppConstants.goalMaintain:
        return tdee;
      case AppConstants.goalGain:
        return tdee + 300; // Superávit de 300 kcal para ganar masa
      default:
        return tdee;
    }
  }

  /// Calcula macros recomendados
  /// Retorna Map con 'protein', 'carbs', 'fats' en gramos
  static Map<String, double> calculateMacros({
    required double totalCalories,
    required String goal,
  }) {
    double proteinGrams;
    double fatsGrams;
    double carbsGrams;

    if (goal == AppConstants.goalLose) {
      // Alto en proteína para preservar músculo
      // 30% proteína, 25% grasa, 45% carbos
      proteinGrams = (totalCalories * 0.30) / AppConstants.proteinCaloriesPerGram;
      fatsGrams = (totalCalories * 0.25) / AppConstants.fatsCaloriesPerGram;
      carbsGrams = (totalCalories * 0.45) / AppConstants.carbsCaloriesPerGram;
    } else if (goal == AppConstants.goalGain) {
      // Balance para ganar masa
      // 25% proteína, 25% grasa, 50% carbos
      proteinGrams = (totalCalories * 0.25) / AppConstants.proteinCaloriesPerGram;
      fatsGrams = (totalCalories * 0.25) / AppConstants.fatsCaloriesPerGram;
      carbsGrams = (totalCalories * 0.50) / AppConstants.carbsCaloriesPerGram;
    } else {
      // Mantenimiento balanceado
      // 25% proteína, 30% grasa, 45% carbos
      proteinGrams = (totalCalories * 0.25) / AppConstants.proteinCaloriesPerGram;
      fatsGrams = (totalCalories * 0.30) / AppConstants.fatsCaloriesPerGram;
      carbsGrams = (totalCalories * 0.45) / AppConstants.carbsCaloriesPerGram;
    }

    return {
      'protein': proteinGrams,
      'carbs': carbsGrams,
      'fats': fatsGrams,
    };
  }

  /// Calcula el porcentaje de progreso
  static double calculateProgress(double current, double goal) {
    if (goal <= 0) return 0;
    final progress = (current / goal) * 100;
    return progress.clamp(0, 100);
  }

  /// Verifica si se cumplió la meta (dentro del 5% de tolerancia)
  static bool isGoalMet(double current, double goal) {
    final tolerance = goal * 0.05; // 5% de tolerancia
    return current >= (goal - tolerance) && current <= (goal + tolerance);
  }
}
