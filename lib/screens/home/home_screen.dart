import 'package:calories_ai_app/data/models/meal_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/auth_provider.dart';
import '../../providers/meal_provider.dart';
import '../../core/widgets/calorie_circular_progress.dart';
import '../../core/widgets/macro_progress_bar.dart';
import '../../config/theme.dart';
import '../../core/utils/formatters.dart';

/// Pantalla principal con resumen diario
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    final mealProvider = context.read<MealProvider>();
    await mealProvider.loadGoals();
    await mealProvider.loadMeals();
  }

  Future<void> _refreshData() async {
    await _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calories AI'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () => context.push('/statistics'),
            tooltip: 'Estadísticas',
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => context.push('/profile'),
            tooltip: 'Perfil',
          ),
        ],
      ),
      body: Consumer2<AuthProvider, MealProvider>(
        builder: (context, authProvider, mealProvider, _) {
          final user = authProvider.user;
          final goals = mealProvider.goals;

          return RefreshIndicator(
            onRefresh: _refreshData,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Header con saludo
                _buildHeader(user?.name ?? 'Usuario'),
                const SizedBox(height: 24),

                // Card de resumen diario
                _buildDailySummaryCard(mealProvider, goals),
                const SizedBox(height: 24),

                // Secciones de comidas
                _buildMealTypeSection(
                  context,
                  'Desayuno',
                  MealType.breakfast,
                  Icons.wb_sunny,
                  mealProvider,
                ),
                const SizedBox(height: 16),
                _buildMealTypeSection(
                  context,
                  'Almuerzo',
                  MealType.lunch,
                  Icons.restaurant,
                  mealProvider,
                ),
                const SizedBox(height: 16),
                _buildMealTypeSection(
                  context,
                  'Cena',
                  MealType.dinner,
                  Icons.nightlight_round,
                  mealProvider,
                ),
                const SizedBox(height: 16),
                _buildMealTypeSection(
                  context,
                  'Snacks',
                  MealType.snack,
                  Icons.cookie,
                  mealProvider,
                ),
                const SizedBox(height: 80),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/add-meal'),
        icon: const Icon(Icons.add),
        label: const Text('Agregar Comida'),
      ),
    );
  }

  Widget _buildHeader(String name) {
    final now = DateTime.now();
    final greeting = now.hour < 12
        ? 'Buenos días'
        : now.hour < 18
            ? 'Buenas tardes'
            : 'Buenas noches';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$greeting, $name',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 4),
        Text(
          DateFormat('EEEE, d MMMM', 'es').format(now),
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildDailySummaryCard(MealProvider mealProvider, goals) {
    final dailyCalories = goals?.dailyCalories ?? 2000;
    final dailyProtein = goals?.dailyProtein ?? 150;
    final dailyCarbs = goals?.dailyCarbs ?? 200;
    final dailyFats = goals?.dailyFats ?? 65;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Progreso circular de calorías
            CalorieCircularProgress(
              current: mealProvider.totalCalories,
              goal: dailyCalories,
              color: AppTheme.primaryGreen,
            ),
            const SizedBox(height: 24),

            // Macros
            MacroProgressBar(
              label: 'Proteína',
              current: mealProvider.totalProtein,
              goal: dailyProtein,
              color: AppTheme.proteinColor,
            ),
            const SizedBox(height: 16),
            MacroProgressBar(
              label: 'Carbohidratos',
              current: mealProvider.totalCarbs,
              goal: dailyCarbs,
              color: AppTheme.carbsColor,
            ),
            const SizedBox(height: 16),
            MacroProgressBar(
              label: 'Grasas',
              current: mealProvider.totalFat,
              goal: dailyFats,
              color: AppTheme.fatsColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMealTypeSection(
    BuildContext context,
    String title,
    MealType mealType,
    IconData icon,
    MealProvider mealProvider,
  ) {
    final meals = mealProvider.getMealsByType(mealType);
    final totalCalories =
        meals.fold(0.0, (sum, meal) => sum + meal.totalCalories);

    return Card(
      child: Column(
        children: [
          ListTile(
            leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
            title: Text(title,
                style: Theme.of(context).textTheme.titleLarge),
            subtitle: Text('${totalCalories.round()} kcal'),
            trailing: IconButton(
              icon: const Icon(Icons.add_circle_outline),
              color: Theme.of(context).colorScheme.primary,
              onPressed: () => context.push('/add-meal?type=$mealType'),
            ),
          ),
          if (meals.isNotEmpty)
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: meals.length,
              itemBuilder: (context, index) {
                final meal = meals[index];
                return ListTile(
                  leading: meal.photoUrl != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            meal.photoUrl!,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                const Icon(Icons.image_not_supported),
                          ),
                        )
                      : const Icon(Icons.fastfood),
                  title: Text(
                    '${meal.foods.length} alimento${meal.foods.length > 1 ? 's' : ''}',
                  ),
                  subtitle: Text(
                    '${meal.totalCalories.round()} kcal • ${Formatters.time(meal.createdAt)}',
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push('/meal/${meal.id}'),
                );
              },
            ),
        ],
      ),
    );
  }
}
