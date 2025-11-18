/// Constantes relacionadas con la API - coinciden EXACTAMENTE con el backend ASP.NET
class ApiConstants {
  // Base URL - Cambiar según el entorno (ya incluye /api)
  static const String baseUrl = 'http://192.168.100.53:5015/api';
  // Para desarrollo local en Android emulator: 'http://10.0.2.2:5000/api'
  // Para desarrollo local en iOS simulator: 'http://localhost:5000/api'
  // Para producción: 'https://tu-vps.com/api'

  // Timeout
  static const int connectTimeout = 30000; // 30 segundos
  static const int receiveTimeout = 30000; // 30 segundos

  // Auth endpoints
  static const String authRegister = '/Auth/register';
  static const String authLogin = '/Auth/login';
  static const String authProfile = '/Auth/profile';
  static const String authGeminiKey = '/Auth/gemini-key';

  // Goals endpoints
  static const String goals = '/Goals';
  static const String goalsSuggested = '/Goals/suggested';

  // Food endpoints
  static const String foodsSearch = '/Foods/search';
  static String foodById(int id) => '/Foods/$id';
  static const String foodsCustom = '/Foods/custom';
  static String updateCustomFood(int id) => '/Foods/custom/$id';
  static String deleteCustomFood(int id) => '/Foods/custom/$id';
  static const String foodCategories = '/Foods/categories';

  // Meals endpoints
  static const String mealsAnalyzeImage = '/Meals/analyze-image';
  static const String meals = '/Meals';
  static String mealById(int id) => '/Meals/$id';
  static String updateMeal(int id) => '/Meals/$id';
  static String deleteMeal(int id) => '/Meals/$id';

  // Stats endpoints
  static const String statsDaily = '/Stats/daily';
  static const String statsWeekly = '/Stats/weekly';
  static const String statsMonthly = '/Stats/monthly';
  static const String statsCharts = '/Stats/charts';

  // Headers
  static const String contentTypeJson = 'application/json';
  static const String authorizationHeader = 'Authorization';
  static const String bearerPrefix = 'Bearer';
}
