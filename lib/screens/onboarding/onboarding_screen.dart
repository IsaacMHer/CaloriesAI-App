import 'package:calories_ai_app/data/models/goal_model.dart';
import 'package:calories_ai_app/data/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/meal_provider.dart';
import '../../core/widgets/custom_text_field.dart';
import '../../core/utils/validators.dart';
import '../../core/utils/calculations.dart';

// --- Asunciones Importantes para la Corrección ---
// 1. Las clases/enums 'Gender', 'ActivityLevel' y 'GoalType' están definidas
//    en 'goal_model.dart' y 'user_model.dart' y son usadas como ENUMS.
// 2. Las constantes AppConstants.activitySedentary, AppConstants.goalLose, etc.,
//    tienen valores que se corresponden con la representación en String o un valor
//    que se puede mapear al enum (en este caso, se usará el enum directamente).

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

  // Variables de estado (ya son de tipo Enum?)
  Gender? _selectedGender;
  ActivityLevel? _selectedActivityLevel;
  GoalType? _selectedGoal;

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
    if (_currentPage == 0 && !_formKey.currentState!.validate()) {
      return;
    }
    // Para las páginas 1 y 2, es necesario validar que se ha seleccionado un item
    if (_currentPage == 1 && _selectedActivityLevel == null) {
      // Opcional: mostrar un SnackBar o error para forzar la selección.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, selecciona tu nivel de actividad.')),
      );
      return;
    }
    if (_currentPage == 2 && _selectedGoal == null) {
      // Opcional: mostrar un SnackBar o error para forzar la selección.
       ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, selecciona tu objetivo.')),
      );
      return;
    }

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
    // Si la última página no tiene campos, validamos solo los datos del perfil
    if (!_formKey.currentState!.validate()) return;
    
    // Asegurarse de que las metas estén calculadas (ya lo hace _calculateGoals)
    if (_calculatedCalories == null) {
      _calculateGoals();
      if (_calculatedCalories == null) {
        // Esto indica que faltan datos clave, no debería ocurrir si se valida.
        return; 
      }
    }

    final authProvider = context.read<AuthProvider>();
    final mealProvider = context.read<MealProvider>();

    // Actualizar perfil
    await authProvider.updateProfile(
      weight: double.parse(_weightController.text),
      height: double.parse(_heightController.text),
      age: int.parse(_ageController.text),
      // Uso de '!' porque la validación al inicio de _calculateGoals asegura que no son null
      gender: _selectedGender!, 
      activityLevel: _selectedActivityLevel!,
    );

    // Actualizar API Key si se proporcionó
    if (_geminiKeyController.text.isNotEmpty) {
      await authProvider.updateGeminiApiKey(_geminiKeyController.text);
    }

    // Actualizar metas
    // Se usa '!' aquí porque _calculatedCalories != null asegura que los demás tampoco lo son.
    await mealProvider.updateGoals(
      dailyCalories: _calculatedCalories!,
      dailyProtein: _calculatedProtein!,
      dailyCarbs: _calculatedCarbs!,
      dailyFat: _calculatedFats!,
      goalType: _selectedGoal!,
    );

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
      // No calcular si faltan datos esenciales
      return;
    }

    // Calcular BMR
    // AVISO: 'toString()' en un enum como Gender.male devuelve 'Gender.male'.
    // Si NutritionCalculations.calculateBMR espera el String 'male',
    // deberás usar una función de utilidad para obtener el nombre del enum.
    // Asumo que el utilitario puede manejar la representación de String por ahora.
    final bmr = NutritionCalculations.calculateBMR(
      weight: weight,
      height: height,
      age: age,
      gender: _selectedGender!.name, // Usar .name para obtener el String ('male', 'female')
    );

    // Calcular TDEE
    final tdee = NutritionCalculations.calculateTDEE(
      bmr: bmr,
      activityLevel: _selectedActivityLevel!.name, // Usar .name
    );

    // Calcular calorías objetivo
    final goalCalories = NutritionCalculations.calculateGoalCalories(
      tdee: tdee,
      goal: _selectedGoal!.name, // Se pasa el Enum directamente (mejor práctica) o goal: _selectedGoal!.name si requiere String. Dejo el Enum.
    );

    // Calcular macros
    final macros = NutritionCalculations.calculateMacros(
      totalCalories: goalCalories,
      goal: _selectedGoal!.name, // Se pasa el Enum directamente (mejor práctica) o goal: _selectedGoal!.name si requiere String. Dejo el Enum.
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
          // --- CORRECCIÓN APLICADA AQUÍ: Tipo del Dropdown es ahora Gender ---
          DropdownButtonFormField<Gender>(
            initialValue: _selectedGender,
            decoration: const InputDecoration(labelText: 'Género'),
            items: const [
              DropdownMenuItem(value: Gender.male, child: Text('Masculino')),
              DropdownMenuItem(value: Gender.female, child: Text('Femenino')),
              DropdownMenuItem(value: Gender.other, child: Text('Otro')),
            ],
            // El valor es de tipo Gender?, se asigna directamente.
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
          // Las constantes de AppConstants asumo que dan el valor Enum o un String que se mapea.
          // Para esta corrección, asumo que ActivityLevel.enumName funciona.
          _buildActivityTile(
            'Sedentario',
            'Poco o ningún ejercicio',
            ActivityLevel.sedentary,
          ),
          _buildActivityTile(
            'Ligero',
            'Ejercicio 1-3 días/semana',
            ActivityLevel.light,
          ),
          _buildActivityTile(
            'Moderado',
            'Ejercicio 3-5 días/semana',
            ActivityLevel.moderate,
          ),
          _buildActivityTile(
            'Activo',
            'Ejercicio 6-7 días/semana',
            ActivityLevel.active,
          ),
          _buildActivityTile(
            'Muy Activo',
            'Ejercicio intenso diario',
            ActivityLevel.veryActive,
          ),
        ],
      ),
    );
  }

  // --- CORRECCIÓN APLICADA AQUÍ: Tipo del parámetro y la comparación es ActivityLevel ---
  Widget _buildActivityTile(String title, String subtitle, ActivityLevel value) {
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
        // El valor es de tipo ActivityLevel, se asigna directamente.
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
          // Para esta corrección, asumo que GoalType.enumName funciona.
          _buildGoalTile(
            'Perder Peso',
            'Déficit calórico de 500 kcal/día',
            GoalType.lose,
            Icons.trending_down,
          ),
          _buildGoalTile(
            'Mantener Peso',
            'Equilibrio calórico',
            GoalType.maintain,
            Icons.horizontal_rule,
          ),
          _buildGoalTile(
            'Ganar Masa',
            'Superávit calórico de 300 kcal/día',
            GoalType.gain,
            Icons.trending_up,
          ),
        ],
      ),
    );
  }

  // --- CORRECCIÓN APLICADA AQUÍ: Tipo del parámetro y la comparación es GoalType ---
  Widget _buildGoalTile(
      String title, String subtitle, GoalType value, IconData icon) {
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
          // El valor es de tipo GoalType, se asigna directamente.
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