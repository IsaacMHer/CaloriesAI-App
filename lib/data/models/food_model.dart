import 'package:equatable/equatable.dart';

/// FoodSource enum del backend
enum FoodSource {
  usda, // 0
  custom, // 1
  other, // 2
}

extension FoodSourceExtension on FoodSource {
  int toInt() => index;

  static FoodSource fromInt(int value) => FoodSource.values[value];
}

/// FoodDto - coincide con el backend
class FoodModel extends Equatable {
  final int id;
  final String name;
  final double calories;
  final double protein;
  final double carbs;
  final double fat;
  final String servingSize;
  final String? category;
  final bool isCustom;
  final FoodSource source;
  final String? externalId;

  const FoodModel({
    required this.id,
    required this.name,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.servingSize,
    this.category,
    required this.isCustom,
    required this.source,
    this.externalId,
  });

  factory FoodModel.fromJson(Map<String, dynamic> json) {
    return FoodModel(
      id: json['id'] as int,
      name: json['name'] as String,
      calories: (json['calories'] as num).toDouble(),
      protein: (json['protein'] as num).toDouble(),
      carbs: (json['carbs'] as num).toDouble(),
      fat: (json['fat'] as num).toDouble(),
      servingSize: json['servingSize'] as String,
      category: json['category'] as String?,
      isCustom: json['isCustom'] as bool,
      source: FoodSourceExtension.fromInt(json['source'] as int),
      externalId: json['externalId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
      'servingSize': servingSize,
      'category': category,
      'isCustom': isCustom,
      'source': source.toInt(),
      'externalId': externalId,
    };
  }

  FoodModel copyWith({
    int? id,
    String? name,
    double? calories,
    double? protein,
    double? carbs,
    double? fat,
    String? servingSize,
    String? category,
    bool? isCustom,
    FoodSource? source,
    String? externalId,
  }) {
    return FoodModel(
      id: id ?? this.id,
      name: name ?? this.name,
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      carbs: carbs ?? this.carbs,
      fat: fat ?? this.fat,
      servingSize: servingSize ?? this.servingSize,
      category: category ?? this.category,
      isCustom: isCustom ?? this.isCustom,
      source: source ?? this.source,
      externalId: externalId ?? this.externalId,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        calories,
        protein,
        carbs,
        fat,
        servingSize,
        category,
        isCustom,
        source,
        externalId,
      ];
}

/// DetectedFoodDto - alimento detectado por IA
class DetectedFoodDto extends Equatable {
  final String name;
  final double estimatedQuantity;
  final String unit;
  final double calories;
  final double protein;
  final double carbs;
  final double fat;

  const DetectedFoodDto({
    required this.name,
    required this.estimatedQuantity,
    required this.unit,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
  });

  factory DetectedFoodDto.fromJson(Map<String, dynamic> json) {
    return DetectedFoodDto(
      name: json['name'] as String,
      estimatedQuantity: (json['estimatedQuantity'] as num).toDouble(),
      unit: json['unit'] as String,
      calories: (json['calories'] as num).toDouble(),
      protein: (json['protein'] as num).toDouble(),
      carbs: (json['carbs'] as num).toDouble(),
      fat: (json['fat'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'estimatedQuantity': estimatedQuantity,
      'unit': unit,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
    };
  }

  @override
  List<Object?> get props => [
        name,
        estimatedQuantity,
        unit,
        calories,
        protein,
        carbs,
        fat,
      ];
}

/// CreateCustomFoodRequest - request para crear alimento personalizado
class CreateCustomFoodRequest {
  final String name;
  final double calories;
  final double protein;
  final double carbs;
  final double fat;
  final String servingSize;
  final String? category;

  CreateCustomFoodRequest({
    required this.name,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.servingSize,
    this.category,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
      'servingSize': servingSize,
      'category': category,
    };
  }
}
