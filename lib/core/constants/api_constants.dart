/// Constantes relacionadas con la API
class ApiConstants {
  // Base URL - Cambiar según el entorno
  // static const String baseUrl = 'https://tu-vps.com/api';
  static const String baseUrl = 'http://192.168.100.53:5015/api';
  // Para desarrollo local en Android emulator: 'http://10.0.2.2:5000/api'
  // Para desarrollo local en iOS simulator: 'http://localhost:5000/api'

  // Timeout
  static const int connectTimeout = 30000; // 30 segundos
  static const int receiveTimeout = 30000; // 30 segundos

  // Auth endpoints
  static const String authRegister = '/auth/register';
  static const String authLogin = '/auth/login';
  static const String authProfile = '/auth/profile';
  static const String authGeminiKey = '/auth/gemini-key';

  // Goals endpoints
  static const String goals = '/goals';

  // Food endpoints
  static const String foodAnalyzeImage = '/food/analyze-image';
  static const String foodsSearch = '/foods/search';
  static const String foodsCustom = '/foods/custom';

  // Meals endpoints
  static const String meals = '/meals';

  // Stats endpoints
  static const String statsDaily = '/stats/daily';
  static const String statsCharts = '/stats/charts';

  // Headers
  static const String contentTypeJson = 'application/json';
  static const String authorizationHeader = 'Authorization';
  static const String bearerPrefix = 'Bearer';
}
