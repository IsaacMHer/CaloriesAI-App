import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/onboarding/onboarding_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/meals/add_meal_screen.dart';
import '../screens/statistics/statistics_screen.dart';
import '../screens/profile/profile_screen.dart';

/// Configuración de rutas de la aplicación usando GoRouter
class AppRoutes {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      // Splash
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),

      // Auth
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),

      // Onboarding
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),

      // Home
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),

      // Meals
      GoRoute(
        path: '/add-meal',
        builder: (context, state) {
          final mealType = state.uri.queryParameters['type'];
          return AddMealScreen(initialMealType: mealType);
        },
      ),

      // Statistics
      GoRoute(
        path: '/statistics',
        builder: (context, state) => const StatisticsScreen(),
      ),

      // Profile
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),

      // Placeholder routes (estas pantallas se pueden implementar después)
      GoRoute(
        path: '/food-search',
        builder: (context, state) => const _PlaceholderScreen(
          title: 'Buscar Alimentos',
          message: 'Esta funcionalidad estará disponible pronto',
        ),
      ),
      GoRoute(
        path: '/food-detection-result',
        builder: (context, state) => const _PlaceholderScreen(
          title: 'Resultado de Detección',
          message: 'Procesando alimentos detectados...',
        ),
      ),
      GoRoute(
        path: '/meal/:id',
        builder: (context, state) {
          final mealId = state.pathParameters['id']!;
          return _PlaceholderScreen(
            title: 'Detalle de Comida',
            message: 'ID: $mealId',
          );
        },
      ),
      GoRoute(
        path: '/edit-profile',
        builder: (context, state) => const _PlaceholderScreen(
          title: 'Editar Perfil',
          message: 'Esta funcionalidad estará disponible pronto',
        ),
      ),
      GoRoute(
        path: '/goals-settings',
        builder: (context, state) => const _PlaceholderScreen(
          title: 'Configurar Metas',
          message: 'Esta funcionalidad estará disponible pronto',
        ),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 80, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Página no encontrada',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(state.uri.toString()),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/home'),
              child: const Text('Ir al Inicio'),
            ),
          ],
        ),
      ),
    ),
  );
}

/// Pantalla placeholder para rutas no implementadas
class _PlaceholderScreen extends StatelessWidget {
  final String title;
  final String message;

  const _PlaceholderScreen({
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.construction,
                size: 80,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 24),
              Text(
                message,
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
