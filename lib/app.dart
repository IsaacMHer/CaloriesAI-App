import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'config/routes.dart';
import 'config/theme.dart';
import 'providers/auth_provider.dart';
import 'providers/meal_provider.dart';
import 'providers/food_provider.dart';
import 'providers/stats_provider.dart';

/// Widget raíz de la aplicación
class CaloriesAIApp extends StatelessWidget {
  const CaloriesAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => context.read<AuthProvider>()),
        ChangeNotifierProvider(create: (_) => context.read<MealProvider>()),
        ChangeNotifierProvider(create: (_) => context.read<FoodProvider>()),
        ChangeNotifierProvider(create: (_) => context.read<StatsProvider>()),
      ],
      child: MaterialApp.router(
        title: 'Calories AI',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        routerConfig: AppRoutes.router,
        locale: const Locale('es', 'ES'),
      ),
    );
  }
}
