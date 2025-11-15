/// Constantes generales de la aplicación
class AppConstants {
  // Storage keys
  static const String tokenKey = 'auth_token';
  static const String userIdKey = 'user_id';
  static const String themeKey = 'theme_mode';

  // Meal types
  static const String mealTypeBreakfast = 'breakfast';
  static const String mealTypeLunch = 'lunch';
  static const String mealTypeDinner = 'dinner';
  static const String mealTypeSnack = 'snack';

  // Activity levels
  static const String activitySedentary = 'sedentary';
  static const String activityLight = 'light';
  static const String activityModerate = 'moderate';
  static const String activityActive = 'active';
  static const String activityVeryActive = 'very_active';

  // Goals
  static const String goalLose = 'lose';
  static const String goalMaintain = 'maintain';
  static const String goalGain = 'gain';

  // Gender
  static const String genderMale = 'male';
  static const String genderFemale = 'female';
  static const String genderOther = 'other';

  // Nutrition
  static const double proteinCaloriesPerGram = 4.0;
  static const double carbsCaloriesPerGram = 4.0;
  static const double fatsCaloriesPerGram = 9.0;

  // Date formats
  static const String dateFormat = 'dd/MM/yyyy';
  static const String timeFormat = 'HH:mm';
  static const String dateTimeFormat = 'dd/MM/yyyy HH:mm';

  // Debounce
  static const int searchDebounceMs = 500;

  // Image
  static const int imageQuality = 85;
  static const double maxImageWidth = 1024;
  static const double maxImageHeight = 1024;

  // Stats periods
  static const int period7Days = 7;
  static const int period30Days = 30;
}
