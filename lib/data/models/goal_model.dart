import 'package:equatable/equatable.dart';

/// GoalType enum del backend
enum GoalType {
  lose, // 0
  maintain, // 1
  gain, // 2
}

extension GoalTypeExtension on GoalType {
  int toInt() => index;

  static GoalType fromInt(int value) => GoalType.values[value];

  String get displayName {
    switch (this) {
      case GoalType.lose:
        return 'Perder peso';
      case GoalType.maintain:
        return 'Mantener peso';
      case GoalType.gain:
        return 'Ganar peso';
    }
  }
}

/// NutritionalGoalDto - metas nutricionales del usuario
class GoalModel extends Equatable {
  final int id;
  final int userId;
  final double dailyCalories;
  final double dailyProtein;
  final double dailyCarbs;
  final double dailyFat;
  final GoalType goalType;
  final DateTime createdAt;
  final DateTime updatedAt;

  const GoalModel({
    required this.id,
    required this.userId,
    required this.dailyCalories,
    required this.dailyProtein,
    required this.dailyCarbs,
    required this.dailyFat,
    required this.goalType,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Calorías de proteína (4 kcal por gramo)
  double get proteinCalories => dailyProtein * 4;

  /// Calorías de carbohidratos (4 kcal por gramo)
  double get carbsCalories => dailyCarbs * 4;

  /// Calorías de grasas (9 kcal por gramo)
  double get fatCalories => dailyFat * 9;

  /// Porcentaje de proteína
  double get proteinPercentage =>
      dailyCalories > 0 ? (proteinCalories / dailyCalories) * 100 : 0;

  /// Porcentaje de carbohidratos
  double get carbsPercentage =>
      dailyCalories > 0 ? (carbsCalories / dailyCalories) * 100 : 0;

  /// Porcentaje de grasas
  double get fatPercentage =>
      dailyCalories > 0 ? (fatCalories / dailyCalories) * 100 : 0;

  factory GoalModel.fromJson(Map<String, dynamic> json) {
    return GoalModel(
      id: json['id'] as int,
      userId: json['userId'] as int,
      dailyCalories: (json['dailyCalories'] as num).toDouble(),
      dailyProtein: (json['dailyProtein'] as num).toDouble(),
      dailyCarbs: (json['dailyCarbs'] as num).toDouble(),
      dailyFat: (json['dailyFat'] as num).toDouble(),
      goalType: GoalTypeExtension.fromInt(json['goalType'] as int),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'dailyCalories': dailyCalories,
      'dailyProtein': dailyProtein,
      'dailyCarbs': dailyCarbs,
      'dailyFat': dailyFat,
      'goalType': goalType.toInt(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  GoalModel copyWith({
    int? id,
    int? userId,
    double? dailyCalories,
    double? dailyProtein,
    double? dailyCarbs,
    double? dailyFat,
    GoalType? goalType,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return GoalModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      dailyCalories: dailyCalories ?? this.dailyCalories,
      dailyProtein: dailyProtein ?? this.dailyProtein,
      dailyCarbs: dailyCarbs ?? this.dailyCarbs,
      dailyFat: dailyFat ?? this.dailyFat,
      goalType: goalType ?? this.goalType,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        dailyCalories,
        dailyProtein,
        dailyCarbs,
        dailyFat,
        goalType,
        createdAt,
        updatedAt,
      ];
}

/// UpdateGoalRequest - request para actualizar metas
class UpdateGoalRequest {
  final double dailyCalories;
  final double dailyProtein;
  final double dailyCarbs;
  final double dailyFat;
  final GoalType goalType;

  UpdateGoalRequest({
    required this.dailyCalories,
    required this.dailyProtein,
    required this.dailyCarbs,
    required this.dailyFat,
    required this.goalType,
  });

  Map<String, dynamic> toJson() {
    return {
      'dailyCalories': dailyCalories,
      'dailyProtein': dailyProtein,
      'dailyCarbs': dailyCarbs,
      'dailyFat': dailyFat,
      'goalType': goalType.toInt(),
    };
  }
}
