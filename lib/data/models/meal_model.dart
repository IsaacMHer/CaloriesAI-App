import 'package:equatable/equatable.dart';
import 'food_model.dart';

/// MealType enum del backend
enum MealType {
  breakfast, // 0
  lunch, // 1
  dinner, // 2
  snack, // 3
}

extension MealTypeExtension on MealType {
  int toInt() => index;

  static MealType fromInt(int value) => MealType.values[value];

  String get displayName {
    switch (this) {
      case MealType.breakfast:
        return 'Desayuno';
      case MealType.lunch:
        return 'Almuerzo';
      case MealType.dinner:
        return 'Cena';
      case MealType.snack:
        return 'Snack';
    }
  }
}

/// MealFoodDto - alimento dentro de una comida
class MealFoodDto extends Equatable {
  final int id;
  final int foodId;
  final String foodName;
  final double quantity;
  final String unit;
  final double calories;
  final double protein;
  final double carbs;
  final double fat;
  final FoodModel? foodDetails;

  const MealFoodDto({
    required this.id,
    required this.foodId,
    required this.foodName,
    required this.quantity,
    required this.unit,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    this.foodDetails,
  });

  factory MealFoodDto.fromJson(Map<String, dynamic> json) {
    return MealFoodDto(
      id: json['id'] as int,
      foodId: json['foodId'] as int,
      foodName: json['foodName'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      unit: json['unit'] as String,
      calories: (json['calories'] as num).toDouble(),
      protein: (json['protein'] as num).toDouble(),
      carbs: (json['carbs'] as num).toDouble(),
      fat: (json['fat'] as num).toDouble(),
      foodDetails: json['foodDetails'] != null
          ? FoodModel.fromJson(json['foodDetails'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'foodId': foodId,
      'foodName': foodName,
      'quantity': quantity,
      'unit': unit,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
      'foodDetails': foodDetails?.toJson(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        foodId,
        foodName,
        quantity,
        unit,
        calories,
        protein,
        carbs,
        fat,
        foodDetails,
      ];
}

/// MealDto - comida completa
class MealModel extends Equatable {
  final int id;
  final int userId;
  final DateTime date;
  final MealType mealType;
  final String? photoUrl;
  final String? notes;
  final double totalCalories;
  final double totalProtein;
  final double totalCarbs;
  final double totalFat;
  final DateTime createdAt;
  final List<MealFoodDto> foods;

  const MealModel({
    required this.id,
    required this.userId,
    required this.date,
    required this.mealType,
    this.photoUrl,
    this.notes,
    required this.totalCalories,
    required this.totalProtein,
    required this.totalCarbs,
    required this.totalFat,
    required this.createdAt,
    required this.foods,
  });

  String get mealTypeName => mealType.displayName;

  factory MealModel.fromJson(Map<String, dynamic> json) {
    return MealModel(
      id: json['id'] as int,
      userId: json['userId'] as int,
      date: DateTime.parse(json['date'] as String),
      mealType: MealTypeExtension.fromInt(json['mealType'] as int),
      photoUrl: json['photoUrl'] as String?,
      notes: json['notes'] as String?,
      totalCalories: (json['totalCalories'] as num).toDouble(),
      totalProtein: (json['totalProtein'] as num).toDouble(),
      totalCarbs: (json['totalCarbs'] as num).toDouble(),
      totalFat: (json['totalFat'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      foods: (json['foods'] as List<dynamic>?)
              ?.map((item) => MealFoodDto.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'date': date.toIso8601String(),
      'mealType': mealType.toInt(),
      'photoUrl': photoUrl,
      'notes': notes,
      'totalCalories': totalCalories,
      'totalProtein': totalProtein,
      'totalCarbs': totalCarbs,
      'totalFat': totalFat,
      'createdAt': createdAt.toIso8601String(),
      'foods': foods.map((f) => f.toJson()).toList(),
    };
  }

  MealModel copyWith({
    int? id,
    int? userId,
    DateTime? date,
    MealType? mealType,
    String? photoUrl,
    String? notes,
    double? totalCalories,
    double? totalProtein,
    double? totalCarbs,
    double? totalFat,
    DateTime? createdAt,
    List<MealFoodDto>? foods,
  }) {
    return MealModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      date: date ?? this.date,
      mealType: mealType ?? this.mealType,
      photoUrl: photoUrl ?? this.photoUrl,
      notes: notes ?? this.notes,
      totalCalories: totalCalories ?? this.totalCalories,
      totalProtein: totalProtein ?? this.totalProtein,
      totalCarbs: totalCarbs ?? this.totalCarbs,
      totalFat: totalFat ?? this.totalFat,
      createdAt: createdAt ?? this.createdAt,
      foods: foods ?? this.foods,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        date,
        mealType,
        photoUrl,
        notes,
        totalCalories,
        totalProtein,
        totalCarbs,
        totalFat,
        createdAt,
        foods,
      ];
}

/// MealFoodItemRequest - request para agregar alimento a comida
class MealFoodItemRequest {
  final int foodId;
  final double quantity;
  final String unit;

  MealFoodItemRequest({
    required this.foodId,
    required this.quantity,
    required this.unit,
  });

  Map<String, dynamic> toJson() {
    return {
      'foodId': foodId,
      'quantity': quantity,
      'unit': unit,
    };
  }
}

/// CreateMealRequest - request para crear/actualizar comida
class CreateMealRequest {
  final DateTime date;
  final MealType mealType;
  final String? photoUrl;
  final String? notes;
  final List<MealFoodItemRequest> foods;

  CreateMealRequest({
    required this.date,
    required this.mealType,
    this.photoUrl,
    this.notes,
    required this.foods,
  });

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'mealType': mealType.toInt(),
      'photoUrl': photoUrl,
      'notes': notes,
      'foods': foods.map((f) => f.toJson()).toList(),
    };
  }
}

/// AnalyzeImageResponse - respuesta de análisis de imagen
class AnalyzeImageResponse {
  final String? photoUrl;
  final List<DetectedFoodDto> detectedFoods;

  AnalyzeImageResponse({
    this.photoUrl,
    required this.detectedFoods,
  });

  factory AnalyzeImageResponse.fromJson(Map<String, dynamic> json) {
    return AnalyzeImageResponse(
      photoUrl: json['photoUrl'] as String?,
      detectedFoods: (json['detectedFoods'] as List<dynamic>?)
              ?.map((item) => DetectedFoodDto.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
