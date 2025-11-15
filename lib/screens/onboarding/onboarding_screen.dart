import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/meal_provider.dart';
import '../../core/widgets/custom_text_field.dart';
import '../../core/utils/validators.dart';
import '../../core/utils/calculations.dart';
import '../../core/constants/app_constants.dart';

/// Pantalla de onboarding para configurar perfil inicial
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _pageController = PageController();
  int _currentPage = 0;

  // Controladores
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _ageController = TextEditingController();
  final _geminiKeyController = TextEditingController();

  String? _selectedGender;
  String? _selectedActivityLevel;
  String? _selectedGoal;

  // Metas calculadas
  double? _calculatedCalories;
  double? _calculatedProtein;
  double? _calculatedCarbs;
  double? _calculatedFats;

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    _ageController.dispose();
    _geminiKeyController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 3) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _finish();
    }
  }

  void _previousPage() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _finish() async {
    if (!_formKey.currentState!.validate()) return;

    // Calcular metas si no se han calculado
    if (_calculatedCalories == null) {
      _calculateGoals();
    }

    final authProvider = context.read<AuthProvider>();
    final mealProvider = context.read<MealProvider>();

    // Actualizar perfil
    await authProvider.updateProfile(
      weight: double.parse(_weightController.text),
      height: double.parse(_heightController.text),
      age: int.parse(_ageController.text),
      gender: _selectedGender,
      activityLevel: _selectedActivityLevel,
      goal: _selectedGoal,
    );

    // Actualizar API Key si se proporcionó
    if (_geminiKeyController.text.isNotEmpty) {
      await authProvider.updateGeminiApiKey(_geminiKeyController.text);
    }

    // Actualizar metas
    if (_calculatedCalories != null) {
      await mealProvider.updateGoals(
        dailyCalories: _calculatedCalories!,
        dailyProtein: _calculatedProtein!,
        dailyCarbs: _calculatedCarbs!,
        dailyFats: _calculatedFats!,
      );
    }

    if (!mounted) return;

    context.go('/home');
  }

  void _calculateGoals() {
    final weight = double.tryParse(_weightController.text);
    final height = double.tryParse(_heightController.text);
    final age = int.tryParse(_ageController.text);

    if (weight == null ||
        height == null ||
        age == null ||
        _selectedGender == null ||
        _selectedActivityLevel == null ||
        _selectedGoal == null) {
      return;
    }

    // Calcular BMR
    final bmr = NutritionCalculations.calculateBMR(
      weight: weight,
      height: height,
      age: age,
      gender: _selectedGender!,
    );

    // Calcular TDEE
    final tdee = NutritionCalculations.calculateTDEE(
      bmr: bmr,
      activityLevel: _selectedActivityLevel!,
    );

    // Calcular calorías objetivo
    final goalCalories = NutritionCalculations.calculateGoalCalories(
      tdee: tdee,
      goal: _selectedGoal!,
    );

    // Calcular macros
    final macros = NutritionCalculations.calculateMacros(
      totalCalories: goalCalories,
      goal: _selectedGoal!,
    );

    setState(() {
      _calculatedCalories = goalCalories;
      _calculatedProtein = macros['protein'];
      _calculatedCarbs = macros['carbs'];
      _calculatedFats = macros['fats'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración Inicial'),
        leading: _currentPage > 0
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: _previousPage,
              )
            : null,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            // Indicador de página
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: List.generate(
                  4,
                  (index) => Expanded(
                    child: Container(
                      height: 4,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: index <= _currentPage
                            ? Theme.of(context).colorScheme.primary
                            : Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Páginas
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (page) => setState(() => _currentPage = page),
                children: [
                  _buildPersonalDataPage(),
                  _buildActivityPage(),
                  _buildGoalPage(),
                  _buildGeminiKeyPage(),
                ],
              ),
            ),
            // Botón siguiente
            Padding(
              padding: const EdgeInsets.all(24),
              child: ElevatedButton(
                onPressed: _nextPage,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(_currentPage < 3 ? 'Siguiente' : 'Finalizar'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalDataPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Datos Personales',
            style: Theme.of(context).textTheme.displaySmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Necesitamos algunos datos para calcular tus metas',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 32),
          CustomTextField(
            controller: _weightController,
            label: 'Peso (kg)',
            keyboardType: TextInputType.number,
            validator: Validators.weight,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: _heightController,
            label: 'Altura (cm)',
            keyboardType: TextInputType.number,
            validator: Validators.height,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: _ageController,
            label: 'Edad',
            keyboardType: TextInputType.number,
            validator: Validators.age,
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _selectedGender,
            decoration: const InputDecoration(labelText: 'Género'),
            items: const [
              DropdownMenuItem(value: 'male', child: Text('Masculino')),
              DropdownMenuItem(value: 'female', child: Text('Femenino')),
              DropdownMenuItem(value: 'other', child: Text('Otro')),
            ],
            onChanged: (value) => setState(() => _selectedGender = value),
            validator: (value) =>
                value == null ? 'Selecciona tu género' : null,
          ),
        ],
      ),
    );
  }

  Widget _buildActivityPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Nivel de Actividad',
            style: Theme.of(context).textTheme.displaySmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Selecciona tu nivel de actividad física',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 32),
          _buildActivityTile(
            'Sedentario',
            'Poco o ningún ejercicio',
            AppConstants.activitySedentary,
          ),
          _buildActivityTile(
            'Ligero',
            'Ejercicio 1-3 días/semana',
            AppConstants.activityLight,
          ),
          _buildActivityTile(
            'Moderado',
            'Ejercicio 3-5 días/semana',
            AppConstants.activityModerate,
          ),
          _buildActivityTile(
            'Activo',
            'Ejercicio 6-7 días/semana',
            AppConstants.activityActive,
          ),
          _buildActivityTile(
            'Muy Activo',
            'Ejercicio intenso diario',
            AppConstants.activityVeryActive,
          ),
        ],
      ),
    );
  }

  Widget _buildActivityTile(String title, String subtitle, String value) {
    final isSelected = _selectedActivityLevel == value;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: isSelected
          ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
          : null,
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: isSelected
            ? Icon(Icons.check_circle,
                color: Theme.of(context).colorScheme.primary)
            : null,
        onTap: () => setState(() => _selectedActivityLevel = value),
      ),
    );
  }

  Widget _buildGoalPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tu Objetivo',
            style: Theme.of(context).textTheme.displaySmall,
          ),
          const SizedBox(height: 8),
          Text(
            '¿Qué quieres lograr?',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 32),
          _buildGoalTile(
            'Perder Peso',
            'Déficit calórico de 500 kcal/día',
            AppConstants.goalLose,
            Icons.trending_down,
          ),
          _buildGoalTile(
            'Mantener Peso',
            'Equilibrio calórico',
            AppConstants.goalMaintain,
            Icons.horizontal_rule,
          ),
          _buildGoalTile(
            'Ganar Masa',
            'Superávit calórico de 300 kcal/día',
            AppConstants.goalGain,
            Icons.trending_up,
          ),
        ],
      ),
    );
  }

  Widget _buildGoalTile(
      String title, String subtitle, String value, IconData icon) {
    final isSelected = _selectedGoal == value;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: isSelected
          ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
          : null,
      child: ListTile(
        leading: Icon(icon,
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Colors.grey),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: isSelected
            ? Icon(Icons.check_circle,
                color: Theme.of(context).colorScheme.primary)
            : null,
        onTap: () {
          setState(() => _selectedGoal = value);
          _calculateGoals();
        },
      ),
    );
  }

  Widget _buildGeminiKeyPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'API Key de Gemini',
            style: Theme.of(context).textTheme.displaySmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Configura tu clave API para usar la detección con IA',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 32),
          CustomTextField(
            controller: _geminiKeyController,
            label: 'API Key (opcional)',
            hint: 'Tu clave de API de Gemini',
            maxLines: 2,
          ),
          const SizedBox(height: 16),
          Card(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '¿Cómo obtener tu API Key?',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '1. Visita ai.google.dev\n'
                    '2. Crea una cuenta o inicia sesión\n'
                    '3. Genera una nueva API Key\n'
                    '4. Copia y pega aquí',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
          if (_calculatedCalories != null) ...[
            const SizedBox(height: 32),
            const Divider(),
            const SizedBox(height: 16),
            Text(
              'Tus Metas Calculadas:',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _buildGoalSummary(),
          ],
        ],
      ),
    );
  }

  Widget _buildGoalSummary() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildGoalRow('Calorías',
                '${_calculatedCalories!.round()} kcal', Icons.local_fire_department),
            const Divider(),
            _buildGoalRow(
                'Proteína', '${_calculatedProtein!.round()}g', Icons.egg),
            const Divider(),
            _buildGoalRow('Carbohidratos', '${_calculatedCarbs!.round()}g',
                Icons.bakery_dining),
            const Divider(),
            _buildGoalRow(
                'Grasas', '${_calculatedFats!.round()}g', Icons.water_drop),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 12),
        Text(label, style: Theme.of(context).textTheme.bodyLarge),
        const Spacer(),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }
}
