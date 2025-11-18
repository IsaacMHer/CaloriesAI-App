import 'package:equatable/equatable.dart';

/// DailySummaryDto - resumen de un día específico
class DailySummaryDto extends Equatable {
  final DateTime date;
  final double totalCalories;
  final double totalProtein;
  final double totalCarbs;
  final double totalFat;
  final double goalCalories;
  final double goalProtein;
  final double goalCarbs;
  final double goalFat;
  final double caloriesProgress;
  final double proteinProgress;
  final double carbsProgress;
  final double fatProgress;
  final double remainingCalories;

  const DailySummaryDto({
    required this.date,
    required this.totalCalories,
    required this.totalProtein,
    required this.totalCarbs,
    required this.totalFat,
    required this.goalCalories,
    required this.goalProtein,
    required this.goalCarbs,
    required this.goalFat,
    required this.caloriesProgress,
    required this.proteinProgress,
    required this.carbsProgress,
    required this.fatProgress,
    required this.remainingCalories,
  });

  factory DailySummaryDto.fromJson(Map<String, dynamic> json) {
    return DailySummaryDto(
      date: DateTime.parse(json['date'] as String),
      totalCalories: (json['totalCalories'] as num).toDouble(),
      totalProtein: (json['totalProtein'] as num).toDouble(),
      totalCarbs: (json['totalCarbs'] as num).toDouble(),
      totalFat: (json['totalFat'] as num).toDouble(),
      goalCalories: (json['goalCalories'] as num).toDouble(),
      goalProtein: (json['goalProtein'] as num).toDouble(),
      goalCarbs: (json['goalCarbs'] as num).toDouble(),
      goalFat: (json['goalFat'] as num).toDouble(),
      caloriesProgress: (json['caloriesProgress'] as num).toDouble(),
      proteinProgress: (json['proteinProgress'] as num).toDouble(),
      carbsProgress: (json['carbsProgress'] as num).toDouble(),
      fatProgress: (json['fatProgress'] as num).toDouble(),
      remainingCalories: (json['remainingCalories'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'totalCalories': totalCalories,
      'totalProtein': totalProtein,
      'totalCarbs': totalCarbs,
      'totalFat': totalFat,
      'goalCalories': goalCalories,
      'goalProtein': goalProtein,
      'goalCarbs': goalCarbs,
      'goalFat': goalFat,
      'caloriesProgress': caloriesProgress,
      'proteinProgress': proteinProgress,
      'carbsProgress': carbsProgress,
      'fatProgress': fatProgress,
      'remainingCalories': remainingCalories,
    };
  }

  @override
  List<Object?> get props => [
        date,
        totalCalories,
        totalProtein,
        totalCarbs,
        totalFat,
        goalCalories,
        goalProtein,
        goalCarbs,
        goalFat,
        caloriesProgress,
        proteinProgress,
        carbsProgress,
        fatProgress,
        remainingCalories,
      ];
}

/// DailyDataPoint - punto de datos para gráficas
class DailyDataPoint extends Equatable {
  final DateTime date;
  final double calories;
  final double protein;
  final double carbs;
  final double fat;
  final double goalCalories;

  const DailyDataPoint({
    required this.date,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.goalCalories,
  });

  factory DailyDataPoint.fromJson(Map<String, dynamic> json) {
    return DailyDataPoint(
      date: DateTime.parse(json['date'] as String),
      calories: (json['calories'] as num).toDouble(),
      protein: (json['protein'] as num).toDouble(),
      carbs: (json['carbs'] as num).toDouble(),
      fat: (json['fat'] as num).toDouble(),
      goalCalories: (json['goalCalories'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
      'goalCalories': goalCalories,
    };
  }

  @override
  List<Object?> get props => [
        date,
        calories,
        protein,
        carbs,
        fat,
        goalCalories,
      ];
}

/// MacrosDistributionDto - distribución de macros
class MacrosDistributionDto extends Equatable {
  final double proteinPercentage;
  final double carbsPercentage;
  final double fatPercentage;
  final double totalProteinGrams;
  final double totalCarbsGrams;
  final double totalFatGrams;

  const MacrosDistributionDto({
    required this.proteinPercentage,
    required this.carbsPercentage,
    required this.fatPercentage,
    required this.totalProteinGrams,
    required this.totalCarbsGrams,
    required this.totalFatGrams,
  });

  factory MacrosDistributionDto.fromJson(Map<String, dynamic> json) {
    return MacrosDistributionDto(
      proteinPercentage: (json['proteinPercentage'] as num).toDouble(),
      carbsPercentage: (json['carbsPercentage'] as num).toDouble(),
      fatPercentage: (json['fatPercentage'] as num).toDouble(),
      totalProteinGrams: (json['totalProteinGrams'] as num).toDouble(),
      totalCarbsGrams: (json['totalCarbsGrams'] as num).toDouble(),
      totalFatGrams: (json['totalFatGrams'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'proteinPercentage': proteinPercentage,
      'carbsPercentage': carbsPercentage,
      'fatPercentage': fatPercentage,
      'totalProteinGrams': totalProteinGrams,
      'totalCarbsGrams': totalCarbsGrams,
      'totalFatGrams': totalFatGrams,
    };
  }

  @override
  List<Object?> get props => [
        proteinPercentage,
        carbsPercentage,
        fatPercentage,
        totalProteinGrams,
        totalCarbsGrams,
        totalFatGrams,
      ];
}

/// ChartDataDto - datos completos para gráficas
class ChartDataDto extends Equatable {
  final List<DailyDataPoint> dailyCalories;
  final MacrosDistributionDto macrosDistribution;

  const ChartDataDto({
    required this.dailyCalories,
    required this.macrosDistribution,
  });

  factory ChartDataDto.fromJson(Map<String, dynamic> json) {
    return ChartDataDto(
      dailyCalories: (json['dailyCalories'] as List<dynamic>?)
              ?.map((item) => DailyDataPoint.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      macrosDistribution: MacrosDistributionDto.fromJson(
          json['macrosDistribution'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dailyCalories': dailyCalories.map((item) => item.toJson()).toList(),
      'macrosDistribution': macrosDistribution.toJson(),
    };
  }

  @override
  List<Object?> get props => [
        dailyCalories,
        macrosDistribution,
      ];
}
