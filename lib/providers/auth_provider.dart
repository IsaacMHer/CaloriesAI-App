import 'package:flutter/foundation.dart';
import '../data/models/user_model.dart';
import '../data/repositories/auth_repository.dart';

/// Provider para manejar el estado de autenticación y usuario
class AuthProvider with ChangeNotifier {
  final AuthRepository _authRepository;

  UserModel? _user;
  bool _isLoading = false;
  String? _errorMessage;

  AuthProvider(this._authRepository);

  // Getters
  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _user != null;

  /// Registra un nuevo usuario
  Future<bool> register({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      _setLoading(true);
      _errorMessage = null;

      _user = await _authRepository.register(
        email: email,
        password: password,
        name: name,
      );

      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  /// Inicia sesión
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      _setLoading(true);
      _errorMessage = null;

      _user = await _authRepository.login(
        email: email,
        password: password,
      );

      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  /// Carga el perfil del usuario
  Future<void> loadProfile() async {
    try {
      _setLoading(true);
      _errorMessage = null;

      _user = await _authRepository.getProfile();

      _setLoading(false);
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
    }
  }

  /// Actualiza el perfil del usuario
  Future<bool> updateProfile({
    double? weight,
    double? height,
    int? age,
    Gender? gender,
    ActivityLevel? activityLevel,
  }) async {
    try {
      _setLoading(true);
      _errorMessage = null;

      _user = await _authRepository.updateProfile(
        weight: weight,
        height: height,
        age: age,
        gender: gender,
        activityLevel: activityLevel,
      );

      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  /// Actualiza la API Key de Gemini
  Future<bool> updateGeminiApiKey(String apiKey) async {
    try {
      _setLoading(true);
      _errorMessage = null;

      await _authRepository.updateGeminiApiKey(apiKey);

      // Recargar el perfil para obtener hasGeminiApiKey actualizado
      await loadProfile();

      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  /// Cierra sesión
  Future<void> logout() async {
    await _authRepository.logout();
    _user = null;
    _errorMessage = null;
    notifyListeners();
  }

  /// Verifica si hay una sesión activa y carga el perfil
  Future<bool> checkAuth() async {
    if (_authRepository.isLoggedIn()) {
      await loadProfile();
      return _user != null;
    }
    return false;
  }

  /// Limpia el error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Métodos privados
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message.replaceAll('Exception: ', '');
    notifyListeners();
  }
}
