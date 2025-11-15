import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'data/services/storage_service.dart';
import 'data/services/api_service.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/food_repository.dart';
import 'data/repositories/meal_repository.dart';
import 'data/repositories/stats_repository.dart';
import 'providers/auth_provider.dart';
import 'providers/meal_provider.dart';
import 'providers/food_provider.dart';
import 'providers/stats_provider.dart';

/// Punto de entrada de la aplicación
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar servicios
  final storageService = await StorageService.init();
  final apiService = ApiService(storageService);

  // Inicializar repositorios
  final authRepository = AuthRepository(apiService, storageService);
  final foodRepository = FoodRepository(apiService);
  final mealRepository = MealRepository(apiService);
  final statsRepository = StatsRepository(apiService);

  // Inicializar providers
  final authProvider = AuthProvider(authRepository);
  final mealProvider = MealProvider(mealRepository);
  final foodProvider = FoodProvider(foodRepository);
  final statsProvider = StatsProvider(statsRepository);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: authProvider),
        ChangeNotifierProvider.value(value: mealProvider),
        ChangeNotifierProvider.value(value: foodProvider),
        ChangeNotifierProvider.value(value: statsProvider),
      ],
      child: const CaloriesAIApp(),
    ),
  );
}
