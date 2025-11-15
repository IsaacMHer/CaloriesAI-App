import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/meal_provider.dart';
import '../../core/utils/formatters.dart';

/// Pantalla de perfil del usuario
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
      ),
      body: Consumer2<AuthProvider, MealProvider>(
        builder: (context, authProvider, mealProvider, _) {
          final user = authProvider.user;
          final goals = mealProvider.goals;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Avatar y nombre
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      child: Text(
                        user?.name.substring(0, 1).toUpperCase() ?? 'U',
                        style: const TextStyle(
                          fontSize: 40,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      user?.name ?? 'Usuario',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user?.email ?? '',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Datos personales
              _buildSectionTitle(context, 'Datos Personales'),
              Card(
                child: Column(
                  children: [
                    if (user?.weight != null)
                      ListTile(
                        leading: const Icon(Icons.monitor_weight),
                        title: const Text('Peso'),
                        trailing: Text(Formatters.weight(user!.weight!)),
                      ),
                    if (user?.height != null)
                      ListTile(
                        leading: const Icon(Icons.height),
                        title: const Text('Altura'),
                        trailing: Text(Formatters.height(user!.height!)),
                      ),
                    if (user?.age != null)
                      ListTile(
                        leading: const Icon(Icons.cake),
                        title: const Text('Edad'),
                        trailing: Text('${user!.age} años'),
                      ),
                    ListTile(
                      leading: const Icon(Icons.edit),
                      title: const Text('Editar Perfil'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => context.push('/edit-profile'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Metas
              _buildSectionTitle(context, 'Metas Nutricionales'),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.local_fire_department),
                      title: const Text('Calorías Diarias'),
                      trailing: Text('${goals?.dailyCalories.round() ?? 0} kcal'),
                    ),
                    ListTile(
                      leading: const Icon(Icons.egg),
                      title: const Text('Proteína'),
                      trailing: Text(Formatters.grams(goals?.dailyProtein ?? 0)),
                    ),
                    ListTile(
                      leading: const Icon(Icons.bakery_dining),
                      title: const Text('Carbohidratos'),
                      trailing: Text(Formatters.grams(goals?.dailyCarbs ?? 0)),
                    ),
                    ListTile(
                      leading: const Icon(Icons.water_drop),
                      title: const Text('Grasas'),
                      trailing: Text(Formatters.grams(goals?.dailyFats ?? 0)),
                    ),
                    ListTile(
                      leading: const Icon(Icons.edit),
                      title: const Text('Ajustar Metas'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => context.push('/goals-settings'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Configuración
              _buildSectionTitle(context, 'Configuración'),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.key),
                      title: const Text('API Key de Gemini'),
                      subtitle: user?.geminiApiKey != null
                          ? const Text('Configurada')
                          : const Text('No configurada'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => _showApiKeyDialog(context, authProvider),
                    ),
                    ListTile(
                      leading: const Icon(Icons.logout),
                      title: const Text('Cerrar Sesión'),
                      textColor: Colors.red,
                      iconColor: Colors.red,
                      onTap: () => _showLogoutDialog(context, authProvider),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  void _showApiKeyDialog(BuildContext context, AuthProvider authProvider) {
    final controller = TextEditingController(
      text: authProvider.user?.geminiApiKey ?? '',
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('API Key de Gemini'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'API Key',
            hintText: 'Ingresa tu API Key',
          ),
          maxLines: 2,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              await authProvider.updateGeminiApiKey(controller.text);
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('API Key actualizada')),
                );
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, AuthProvider authProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cerrar Sesión'),
        content: const Text('¿Estás seguro de que quieres cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              await authProvider.logout();
              if (context.mounted) {
                context.go('/login');
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Cerrar Sesión'),
          ),
        ],
      ),
    );
  }
}
