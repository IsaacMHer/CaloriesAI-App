import 'package:equatable/equatable.dart';

/// Modelo de usuario que representa los datos del usuario en la aplicación
class UserModel extends Equatable {
  final String id;
  final String email;
  final String name;
  final double? weight; // kg
  final double? height; // cm
  final int? age;
  final String? gender; // 'male', 'female', 'other'
  final String? activityLevel; // 'sedentary', 'light', 'moderate', 'active', 'very_active'
  final String? goal; // 'lose', 'maintain', 'gain'
  final String? geminiApiKey;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const UserModel({
    required this.id,
    required this.email,
    required this.name,
    this.weight,
    this.height,
    this.age,
    this.gender,
    this.activityLevel,
    this.goal,
    this.geminiApiKey,
    this.createdAt,
    this.updatedAt,
  });

  /// Crea una instancia desde JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? json['id'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      weight: json['weight']?.toDouble(),
      height: json['height']?.toDouble(),
      age: json['age'],
      gender: json['gender'],
      activityLevel: json['activityLevel'],
      goal: json['goal'],
      geminiApiKey: json['geminiApiKey'],
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
      'email': email,
      'name': name,
      'weight': weight,
      'height': height,
      'age': age,
      'gender': gender,
      'activityLevel': activityLevel,
      'goal': goal,
      'geminiApiKey': geminiApiKey,
    };
  }

  /// Crea una copia con campos modificados
  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    double? weight,
    double? height,
    int? age,
    String? gender,
    String? activityLevel,
    String? goal,
    String? geminiApiKey,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      activityLevel: activityLevel ?? this.activityLevel,
      goal: goal ?? this.goal,
      geminiApiKey: geminiApiKey ?? this.geminiApiKey,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        email,
        name,
        weight,
        height,
        age,
        gender,
        activityLevel,
        goal,
        geminiApiKey,
        createdAt,
        updatedAt,
      ];
}
