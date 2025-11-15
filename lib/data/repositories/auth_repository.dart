import '../models/user_model.dart';
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
    final response = await _apiService.post(
      ApiConstants.authRegister,
      data: {
        'email': email,
        'password': password,
        'name': name,
      },
    );

    final token = response.data['token'];
    final user = UserModel.fromJson(response.data['user']);

    // Guardar token
    await _storage.saveString(AppConstants.tokenKey, token);
    await _storage.saveString(AppConstants.userIdKey, user.id);

    return user;
  }

  /// Inicia sesión
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final response = await _apiService.post(
      ApiConstants.authLogin,
      data: {
        'email': email,
        'password': password,
      },
    );

    final token = response.data['token'];
    final user = UserModel.fromJson(response.data['user']);

    // Guardar token
    await _storage.saveString(AppConstants.tokenKey, token);
    await _storage.saveString(AppConstants.userIdKey, user.id);

    return user;
  }

  /// Obtiene el perfil del usuario autenticado
  Future<UserModel> getProfile() async {
    final response = await _apiService.get(ApiConstants.authProfile);
    return UserModel.fromJson(response.data);
  }

  /// Actualiza el perfil del usuario
  Future<UserModel> updateProfile({
    String? name,
    double? weight,
    double? height,
    int? age,
    String? gender,
    String? activityLevel,
    String? goal,
  }) async {
    final data = <String, dynamic>{};

    if (name != null) data['name'] = name;
    if (weight != null) data['weight'] = weight;
    if (height != null) data['height'] = height;
    if (age != null) data['age'] = age;
    if (gender != null) data['gender'] = gender;
    if (activityLevel != null) data['activityLevel'] = activityLevel;
    if (goal != null) data['goal'] = goal;

    final response = await _apiService.put(
      ApiConstants.authProfile,
      data: data,
    );

    return UserModel.fromJson(response.data);
  }

  /// Actualiza la API Key de Gemini
  Future<UserModel> updateGeminiApiKey(String apiKey) async {
    final response = await _apiService.put(
      ApiConstants.authGeminiKey,
      data: {'geminiApiKey': apiKey},
    );

    return UserModel.fromJson(response.data);
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
