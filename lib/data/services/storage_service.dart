import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';

/// Servicio para manejar el almacenamiento local usando SharedPreferences
class StorageService {
  final SharedPreferences _prefs;
  final Logger _logger = Logger();

  StorageService(this._prefs);

  /// Inicializa el servicio
  static Future<StorageService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return StorageService(prefs);
  }

  /// Guarda un string
  Future<bool> saveString(String key, String value) async {
    try {
      return await _prefs.setString(key, value);
    } catch (e) {
      _logger.e('Error saving string: $key', error: e);
      return false;
    }
  }

  /// Obtiene un string
  String? getString(String key) {
    try {
      return _prefs.getString(key);
    } catch (e) {
      _logger.e('Error getting string: $key', error: e);
      return null;
    }
  }

  /// Guarda un int
  Future<bool> saveInt(String key, int value) async {
    try {
      return await _prefs.setInt(key, value);
    } catch (e) {
      _logger.e('Error saving int: $key', error: e);
      return false;
    }
  }

  /// Obtiene un int
  int? getInt(String key) {
    try {
      return _prefs.getInt(key);
    } catch (e) {
      _logger.e('Error getting int: $key', error: e);
      return null;
    }
  }

  /// Guarda un bool
  Future<bool> saveBool(String key, bool value) async {
    try {
      return await _prefs.setBool(key, value);
    } catch (e) {
      _logger.e('Error saving bool: $key', error: e);
      return false;
    }
  }

  /// Obtiene un bool
  bool? getBool(String key) {
    try {
      return _prefs.getBool(key);
    } catch (e) {
      _logger.e('Error getting bool: $key', error: e);
      return null;
    }
  }

  /// Guarda un double
  Future<bool> saveDouble(String key, double value) async {
    try {
      return await _prefs.setDouble(key, value);
    } catch (e) {
      _logger.e('Error saving double: $key', error: e);
      return false;
    }
  }

  /// Obtiene un double
  double? getDouble(String key) {
    try {
      return _prefs.getDouble(key);
    } catch (e) {
      _logger.e('Error getting double: $key', error: e);
      return null;
    }
  }

  /// Elimina un valor
  Future<bool> remove(String key) async {
    try {
      return await _prefs.remove(key);
    } catch (e) {
      _logger.e('Error removing key: $key', error: e);
      return false;
    }
  }

  /// Limpia todo el almacenamiento
  Future<bool> clear() async {
    try {
      return await _prefs.clear();
    } catch (e) {
      _logger.e('Error clearing storage', error: e);
      return false;
    }
  }

  /// Verifica si existe una key
  bool containsKey(String key) {
    return _prefs.containsKey(key);
  }
}
