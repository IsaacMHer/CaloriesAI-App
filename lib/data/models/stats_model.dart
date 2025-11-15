import 'package:equatable/equatable.dart';

/// Estadísticas diarias
class DailyStatsModel extends Equatable {
  final DateTime date;
  final double totalCalories;
  final double totalProtein;
  final double totalCarbs;
  final double totalFats;
  final int mealsCount;

  const DailyStatsModel({
    required this.date,
    required this.totalCalories,
    required this.totalProtein,
    required this.totalCarbs,
    required this.totalFats,
    required this.mealsCount,
  });

  /// Crea una instancia desde JSON
  factory DailyStatsModel.fromJson(Map<String, dynamic> json) {
    return DailyStatsModel(
      date: json['date'] != null
          ? DateTime.parse(json['date'])
          : DateTime.now(),
      totalCalories: (json['totalCalories'] ?? 0).toDouble(),
      totalProtein: (json['totalProtein'] ?? 0).toDouble(),
      totalCarbs: (json['totalCarbs'] ?? 0).toDouble(),
      totalFats: (json['totalFats'] ?? 0).toDouble(),
      mealsCount: json['mealsCount'] ?? 0,
    );
  }

  /// Convierte la instancia a JSON
  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'totalCalories': totalCalories,
      'totalProtein': totalProtein,
      'totalCarbs': totalCarbs,
      'totalFats': totalFats,
      'mealsCount': mealsCount,
    };
  }

  @override
  List<Object?> get props => [
        date,
        totalCalories,
        totalProtein,
        totalCarbs,
        totalFats,
        mealsCount,
      ];
}

/// Datos para gráficas de estadísticas
class ChartDataModel extends Equatable {
  final List<DailyStatsModel> dailyStats;
  final double averageCalories;
  final double averageProtein;
  final double averageCarbs;
  final double averageFats;
  final int daysOnTrack; // días cumpliendo meta
  final String? mostConsumedFood;

  const ChartDataModel({
    required this.dailyStats,
    required this.averageCalories,
    required this.averageProtein,
    required this.averageCarbs,
    required this.averageFats,
    required this.daysOnTrack,
    this.mostConsumedFood,
  });

  /// Crea una instancia desde JSON
  factory ChartDataModel.fromJson(Map<String, dynamic> json) {
    return ChartDataModel(
      dailyStats: (json['dailyStats'] as List<dynamic>?)
              ?.map((item) => DailyStatsModel.fromJson(item))
              .toList() ??
          [],
      averageCalories: (json['averageCalories'] ?? 0).toDouble(),
      averageProtein: (json['averageProtein'] ?? 0).toDouble(),
      averageCarbs: (json['averageCarbs'] ?? 0).toDouble(),
      averageFats: (json['averageFats'] ?? 0).toDouble(),
      daysOnTrack: json['daysOnTrack'] ?? 0,
      mostConsumedFood: json['mostConsumedFood'],
    );
  }

  /// Convierte la instancia a JSON
  Map<String, dynamic> toJson() {
    return {
      'dailyStats': dailyStats.map((item) => item.toJson()).toList(),
      'averageCalories': averageCalories,
      'averageProtein': averageProtein,
      'averageCarbs': averageCarbs,
      'averageFats': averageFats,
      'daysOnTrack': daysOnTrack,
      'mostConsumedFood': mostConsumedFood,
    };
  }

  @override
  List<Object?> get props => [
        dailyStats,
        averageCalories,
        averageProtein,
        averageCarbs,
        averageFats,
        daysOnTrack,
        mostConsumedFood,
      ];
}
