import 'package:equatable/equatable.dart';

/// Modelo de alimento con información nutricional
class FoodModel extends Equatable {
  final String id;
  final String name;
  final double calories;
  final double protein; // gramos
  final double carbs; // gramos
  final double fats; // gramos
  final double servingSize; // gramos o ml
  final String? servingUnit; // 'g', 'ml', 'unit'
  final String? category;
  final String? source; // 'usda', 'custom', 'ai'
  final String? userId; // si es alimento personalizado
  final DateTime? createdAt;

  const FoodModel({
    required this.id,
    required this.name,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fats,
    required this.servingSize,
    this.servingUnit = 'g',
    this.category,
    this.source,
    this.userId,
    this.createdAt,
  });

  /// Crea una instancia desde JSON
  factory FoodModel.fromJson(Map<String, dynamic> json) {
    return FoodModel(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      calories: (json['calories'] ?? 0).toDouble(),
      protein: (json['protein'] ?? 0).toDouble(),
      carbs: (json['carbs'] ?? 0).toDouble(),
      fats: (json['fats'] ?? 0).toDouble(),
      servingSize: (json['servingSize'] ?? 100).toDouble(),
      servingUnit: json['servingUnit'] ?? 'g',
      category: json['category'],
      source: json['source'],
      userId: json['userId'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
    );
  }

  /// Convierte la instancia a JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fats': fats,
      'servingSize': servingSize,
      'servingUnit': servingUnit,
      'category': category,
      'source': source,
    };
  }

  /// Crea una copia con campos modificados
  FoodModel copyWith({
    String? id,
    String? name,
    double? calories,
    double? protein,
    double? carbs,
    double? fats,
    double? servingSize,
    String? servingUnit,
    String? category,
    String? source,
    String? userId,
    DateTime? createdAt,
  }) {
    return FoodModel(
      id: id ?? this.id,
      name: name ?? this.name,
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      carbs: carbs ?? this.carbs,
      fats: fats ?? this.fats,
      servingSize: servingSize ?? this.servingSize,
      servingUnit: servingUnit ?? this.servingUnit,
      category: category ?? this.category,
      source: source ?? this.source,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        calories,
        protein,
        carbs,
        fats,
        servingSize,
        servingUnit,
        category,
        source,
        userId,
        createdAt,
      ];
}
