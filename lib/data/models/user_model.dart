import 'package:equatable/equatable.dart';

/// Enums del backend

enum Gender {
  male, // 0
  female, // 1
  other, // 2
}

enum ActivityLevel {
  sedentary, // 0
  light, // 1
  moderate, // 2
  active, // 3
  veryActive, // 4
}

/// Extension para convertir Gender a/desde int
extension GenderExtension on Gender {
  int toInt() {
    return index;
  }

  static Gender fromInt(int value) {
    return Gender.values[value];
  }

  static Gender? fromString(String? value) {
    if (value == null) return null;
    switch (value.toLowerCase()) {
      case 'male':
        return Gender.male;
      case 'female':
        return Gender.female;
      case 'other':
        return Gender.other;
      default:
        return null;
    }
  }
}

/// Extension para convertir ActivityLevel a/desde int
extension ActivityLevelExtension on ActivityLevel {
  int toInt() {
    return index;
  }

  static ActivityLevel fromInt(int value) {
    return ActivityLevel.values[value];
  }
}

/// UserProfileDto - coincide exactamente con el backend
class UserModel extends Equatable {
  final int id;
  final String email;
  final String name;
  final double? weight;
  final double? height;
  final int? age;
  final Gender? gender;
  final ActivityLevel? activityLevel;
  final bool hasGeminiApiKey;
  final DateTime createdAt;

  const UserModel({
    required this.id,
    required this.email,
    required this.name,
    this.weight,
    this.height,
    this.age,
    this.gender,
    this.activityLevel,
    required this.hasGeminiApiKey,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      email: json['email'] as String,
      name: json['name'] as String,
      weight: json['weight']?.toDouble(),
      height: json['height']?.toDouble(),
      age: json['age'] as int?,
      gender: json['gender'] != null
          ? GenderExtension.fromInt(json['gender'] as int)
          : null,
      activityLevel: json['activityLevel'] != null
          ? ActivityLevelExtension.fromInt(json['activityLevel'] as int)
          : null,
      hasGeminiApiKey: json['hasGeminiApiKey'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'weight': weight,
      'height': height,
      'age': age,
      'gender': gender?.toInt(),
      'activityLevel': activityLevel?.toInt(),
      'hasGeminiApiKey': hasGeminiApiKey,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  UserModel copyWith({
    int? id,
    String? email,
    String? name,
    double? weight,
    double? height,
    int? age,
    Gender? gender,
    ActivityLevel? activityLevel,
    bool? hasGeminiApiKey,
    DateTime? createdAt,
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
      hasGeminiApiKey: hasGeminiApiKey ?? this.hasGeminiApiKey,
      createdAt: createdAt ?? this.createdAt,
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
        hasGeminiApiKey,
        createdAt,
      ];
}

/// RegisterRequest
class RegisterRequest {
  final String email;
  final String password;
  final String name;

  RegisterRequest({
    required this.email,
    required this.password,
    required this.name,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'name': name,
    };
  }
}

/// LoginRequest
class LoginRequest {
  final String email;
  final String password;

  LoginRequest({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}

/// LoginResponse
class LoginResponse {
  final String token;
  final DateTime expiresAt;
  final UserModel user;

  LoginResponse({
    required this.token,
    required this.expiresAt,
    required this.user,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'] as String,
      expiresAt: DateTime.parse(json['expiresAt'] as String),
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
    );
  }
}

/// UpdateProfileRequest
class UpdateProfileRequest {
  final double? weight;
  final double? height;
  final int? age;
  final Gender? gender;
  final ActivityLevel? activityLevel;

  UpdateProfileRequest({
    this.weight,
    this.height,
    this.age,
    this.gender,
    this.activityLevel,
  });

  Map<String, dynamic> toJson() {
    return {
      'weight': weight,
      'height': height,
      'age': age,
      'gender': gender?.toInt(),
      'activityLevel': activityLevel?.toInt(),
    };
  }
}

/// UpdateGeminiKeyRequest
class UpdateGeminiKeyRequest {
  final String geminiApiKey;

  UpdateGeminiKeyRequest({required this.geminiApiKey});

  Map<String, dynamic> toJson() {
    return {
      'geminiApiKey': geminiApiKey,
    };
  }
}
