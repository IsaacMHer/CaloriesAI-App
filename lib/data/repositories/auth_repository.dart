import '../models/user_model.dart';
import '../models/api_response_model.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';
import '../../core/constants/api_constants.dart';
import '../../core/constants/app_constants.dart';

/// Repositorio para manejar autenticación y perfil de usuario
class AuthRepository {
  final ApiService _apiService;
  final StorageService _storage;

  AuthRepository(this._apiService, this._storage);

  /// Registra un nuevo usuario
  Future<UserModel> register({
    required String email,
    required String password,
    required String name,
  }) async {
    final request = RegisterRequest(
      email: email,
      password: password,
      name: name,
    );

    final response = await _apiService.post(
      ApiConstants.authRegister,
      data: request.toJson(),
    );

    // Desempaquetar ApiResponse<LoginResponse>
    final apiResponse = ApiResponse<LoginResponse>.fromJson(
      response.data,
      (json) => LoginResponse.fromJson(json as Map<String, dynamic>),
    );

    if (!apiResponse.success || apiResponse.data == null) {
      throw Exception(apiResponse.message ?? 'Error al registrar usuario');
    }

    final loginResponse = apiResponse.data!;

    // Guardar token
    await _storage.saveString(AppConstants.tokenKey, loginResponse.token);
    await _storage.saveString(AppConstants.userIdKey, loginResponse.user.id.toString());

    return loginResponse.user;
  }

  /// Inicia sesión
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final request = LoginRequest(
      email: email,
      password: password,
    );

    final response = await _apiService.post(
      ApiConstants.authLogin,
      data: request.toJson(),
    );

    // Desempaquetar ApiResponse<LoginResponse>
    final apiResponse = ApiResponse<LoginResponse>.fromJson(
      response.data,
      (json) => LoginResponse.fromJson(json as Map<String, dynamic>),
    );

    if (!apiResponse.success || apiResponse.data == null) {
      throw Exception(apiResponse.message ?? 'Error al iniciar sesión');
    }

    final loginResponse = apiResponse.data!;

    // Guardar token
    await _storage.saveString(AppConstants.tokenKey, loginResponse.token);
    await _storage.saveString(AppConstants.userIdKey, loginResponse.user.id.toString());

    return loginResponse.user;
  }

  /// Obtiene el perfil del usuario autenticado
  Future<UserModel> getProfile() async {
    final response = await _apiService.get(ApiConstants.authProfile);

    // Desempaquetar ApiResponse<UserProfileDto>
    final apiResponse = ApiResponse<UserModel>.fromJson(
      response.data,
      (json) => UserModel.fromJson(json as Map<String, dynamic>),
    );

    if (!apiResponse.success || apiResponse.data == null) {
      throw Exception(apiResponse.message ?? 'Error al obtener perfil');
    }

    return apiResponse.data!;
  }

  /// Actualiza el perfil del usuario
  Future<UserModel> updateProfile({
    double? weight,
    double? height,
    int? age,
    Gender? gender,
    ActivityLevel? activityLevel,
  }) async {
    final request = UpdateProfileRequest(
      weight: weight,
      height: height,
      age: age,
      gender: gender,
      activityLevel: activityLevel,
    );

    final response = await _apiService.put(
      ApiConstants.authProfile,
      data: request.toJson(),
    );

    // Desempaquetar ApiResponse<UserProfileDto>
    final apiResponse = ApiResponse<UserModel>.fromJson(
      response.data,
      (json) => UserModel.fromJson(json as Map<String, dynamic>),
    );

    if (!apiResponse.success || apiResponse.data == null) {
      throw Exception(apiResponse.message ?? 'Error al actualizar perfil');
    }

    return apiResponse.data!;
  }

  /// Actualiza la API Key de Gemini
  Future<void> updateGeminiApiKey(String apiKey) async {
    final request = UpdateGeminiKeyRequest(geminiApiKey: apiKey);

    final response = await _apiService.put(
      ApiConstants.authGeminiKey,
      data: request.toJson(),
    );

    // Desempaquetar ApiResponse<Object>
    final apiResponse = ApiResponse<dynamic>.fromJson(
      response.data,
      null,
    );

    if (!apiResponse.success) {
      throw Exception(apiResponse.message ?? 'Error al actualizar API Key');
    }
  }

  /// Cierra sesión
  Future<void> logout() async {
    await _storage.remove(AppConstants.tokenKey);
    await _storage.remove(AppConstants.userIdKey);
  }

  /// Verifica si hay una sesión activa
  bool isLoggedIn() {
    final token = _storage.getString(AppConstants.tokenKey);
    return token != null && token.isNotEmpty;
  }

  /// Obtiene el token guardado
  String? getToken() {
    return _storage.getString(AppConstants.tokenKey);
  }

  /// Obtiene el ID del usuario guardado
  String? getUserId() {
    return _storage.getString(AppConstants.userIdKey);
  }
}
