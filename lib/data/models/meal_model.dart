import 'package:equatable/equatable.dart';
import 'food_model.dart';

/// Item de alimento dentro de una comida con su cantidad específica
class MealItemModel extends Equatable {
  final FoodModel food;
  final double quantity; // cantidad en la unidad del alimento
  final String unit; // 'g', 'ml', 'unit'

  const MealItemModel({
    required this.food,
    required this.quantity,
    this.unit = 'g',
  });

  /// Calorías totales de este item
  double get totalCalories => (food.calories / food.servingSize) * quantity;

  /// Proteína total de este item
  double get totalProtein => (food.protein / food.servingSize) * quantity;

  /// Carbohidratos totales de este item
  double get totalCarbs => (food.carbs / food.servingSize) * quantity;

  /// Grasas totales de este item
  double get totalFats => (food.fats / food.servingSize) * quantity;

  /// Crea una instancia desde JSON
  factory MealItemModel.fromJson(Map<String, dynamic> json) {
    return MealItemModel(
      food: FoodModel.fromJson(json['food']),
      quantity: (json['quantity'] ?? 0).toDouble(),
      unit: json['unit'] ?? 'g',
    );
  }

  /// Convierte la instancia a JSON
  Map<String, dynamic> toJson() {
    return {
      'foodId': food.id,
      'quantity': quantity,
      'unit': unit,
    };
  }

  /// Crea una copia con campos modificados
  MealItemModel copyWith({
    FoodModel? food,
    double? quantity,
    String? unit,
  }) {
    return MealItemModel(
      food: food ?? this.food,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
    );
  }

  @override
  List<Object?> get props => [food, quantity, unit];
}

/// Modelo de comida que agrupa alimentos con información adicional
class MealModel extends Equatable {
  final String id;
  final String userId;
  final String mealType; // 'breakfast', 'lunch', 'dinner', 'snack'
  final List<MealItemModel> items;
  final String? imageUrl;
  final String? notes;
  final DateTime dateTime;
  final DateTime? createdAt;

  const MealModel({
    required this.id,
    required this.userId,
    required this.mealType,
    required this.items,
    this.imageUrl,
    this.notes,
    required this.dateTime,
    this.createdAt,
  });

  /// Calorías totales de la comida
  double get totalCalories =>
      items.fold(0, (sum, item) => sum + item.totalCalories);

  /// Proteína total de la comida
  double get totalProtein =>
      items.fold(0, (sum, item) => sum + item.totalProtein);

  /// Carbohidratos totales de la comida
  double get totalCarbs => items.fold(0, (sum, item) => sum + item.totalCarbs);

  /// Grasas totales de la comida
  double get totalFats => items.fold(0, (sum, item) => sum + item.totalFats);

  /// Nombre del tipo de comida en español
  String get mealTypeName {
    switch (mealType.toLowerCase()) {
      case 'breakfast':
        return 'Desayuno';
      case 'lunch':
        return 'Almuerzo';
      case 'dinner':
        return 'Cena';
      case 'snack':
        return 'Snack';
      default:
        return mealType;
    }
  }

  /// Crea una instancia desde JSON
  factory MealModel.fromJson(Map<String, dynamic> json) {
    return MealModel(
      id: json['_id'] ?? json['id'] ?? '',
      userId: json['userId'] ?? '',
      mealType: json['mealType'] ?? 'snack',
      items: (json['items'] as List<dynamic>?)
              ?.map((item) => MealItemModel.fromJson(item))
              .toList() ??
          [],
      imageUrl: json['imageUrl'],
      notes: json['notes'],
      dateTime: json['dateTime'] != null
          ? DateTime.parse(json['dateTime'])
          : DateTime.now(),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
    );
  }

  /// Convierte la instancia a JSON
  Map<String, dynamic> toJson() {
    return {
      'mealType': mealType,
      'items': items.map((item) => item.toJson()).toList(),
      'imageUrl': imageUrl,
      'notes': notes,
      'dateTime': dateTime.toIso8601String(),
    };
  }

  /// Crea una copia con campos modificados
  MealModel copyWith({
    String? id,
    String? userId,
    String? mealType,
    List<MealItemModel>? items,
    String? imageUrl,
    String? notes,
    DateTime? dateTime,
    DateTime? createdAt,
  }) {
    return MealModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      mealType: mealType ?? this.mealType,
      items: items ?? this.items,
      imageUrl: imageUrl ?? this.imageUrl,
      notes: notes ?? this.notes,
      dateTime: dateTime ?? this.dateTime,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        mealType,
        items,
        imageUrl,
        notes,
        dateTime,
        createdAt,
      ];
}
