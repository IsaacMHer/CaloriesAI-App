import 'package:equatable/equatable.dart';

/// Modelo de metas nutricionales del usuario
class GoalModel extends Equatable {
  final String id;
  final String userId;
  final double dailyCalories;
  final double dailyProtein; // gramos
  final double dailyCarbs; // gramos
  final double dailyFats; // gramos
  final bool autoCalculate; // si se calculan automáticamente
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const GoalModel({
    required this.id,
    required this.userId,
    required this.dailyCalories,
    required this.dailyProtein,
    required this.dailyCarbs,
    required this.dailyFats,
    this.autoCalculate = true,
    this.createdAt,
    this.updatedAt,
  });

  /// Calorías de proteína (4 kcal por gramo)
  double get proteinCalories => dailyProtein * 4;

  /// Calorías de carbohidratos (4 kcal por gramo)
  double get carbsCalories => dailyCarbs * 4;

  /// Calorías de grasas (9 kcal por gramo)
  double get fatsCalories => dailyFats * 9;

  /// Porcentaje de proteína
  double get proteinPercentage =>
      dailyCalories > 0 ? (proteinCalories / dailyCalories) * 100 : 0;

  /// Porcentaje de carbohidratos
  double get carbsPercentage =>
      dailyCalories > 0 ? (carbsCalories / dailyCalories) * 100 : 0;

  /// Porcentaje de grasas
  double get fatsPercentage =>
      dailyCalories > 0 ? (fatsCalories / dailyCalories) * 100 : 0;

  /// Crea una instancia desde JSON
  factory GoalModel.fromJson(Map<String, dynamic> json) {
    return GoalModel(
      id: json['_id'] ?? json['id'] ?? '',
      userId: json['userId'] ?? '',
      dailyCalories: (json['dailyCalories'] ?? 2000).toDouble(),
      dailyProtein: (json['dailyProtein'] ?? 150).toDouble(),
      dailyCarbs: (json['dailyCarbs'] ?? 200).toDouble(),
      dailyFats: (json['dailyFats'] ?? 65).toDouble(),
      autoCalculate: json['autoCalculate'] ?? true,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  /// Convierte la instancia a JSON
  Map<String, dynamic> toJson() {
    return {
      'dailyCalories': dailyCalories,
      'dailyProtein': dailyProtein,
      'dailyCarbs': dailyCarbs,
      'dailyFats': dailyFats,
      'autoCalculate': autoCalculate,
    };
  }

  /// Crea una copia con campos modificados
  GoalModel copyWith({
    String? id,
    String? userId,
    double? dailyCalories,
    double? dailyProtein,
    double? dailyCarbs,
    double? dailyFats,
    bool? autoCalculate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return GoalModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      dailyCalories: dailyCalories ?? this.dailyCalories,
      dailyProtein: dailyProtein ?? this.dailyProtein,
      dailyCarbs: dailyCarbs ?? this.dailyCarbs,
      dailyFats: dailyFats ?? this.dailyFats,
      autoCalculate: autoCalculate ?? this.autoCalculate,
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
        dailyFats,
        autoCalculate,
        createdAt,
        updatedAt,
      ];
}
