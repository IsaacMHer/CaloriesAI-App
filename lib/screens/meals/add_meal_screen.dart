import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../providers/food_provider.dart';
import '../../providers/meal_provider.dart';
import '../../core/widgets/loading_indicator.dart';

/// Pantalla para agregar una comida (con foto o manualmente)
class AddMealScreen extends StatefulWidget {
  final String? initialMealType;

  const AddMealScreen({super.key, this.initialMealType});

  @override
  State<AddMealScreen> createState() => _AddMealScreenState();
}

class _AddMealScreenState extends State<AddMealScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ImagePicker _imagePicker = ImagePicker();
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await _imagePicker.pickImage(
      source: source,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  Future<void> _analyzeImage() async {
    if (_selectedImage == null) return;

    final foodProvider = context.read<FoodProvider>();
    final success = await foodProvider.analyzeImage(_selectedImage!.path);

    if (!mounted) return;

    if (success) {
      // Ir a la pantalla de resultados
      context.push('/food-detection-result', extra: _selectedImage);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(foodProvider.errorMessage ??
              'Error al analizar la imagen. Intenta agregar manualmente.'),
          backgroundColor: Colors.red,
          action: SnackBarAction(
            label: 'Manual',
            textColor: Colors.white,
            onPressed: () => _tabController.animateTo(1),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Comida'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.camera_alt), text: 'Tomar Foto'),
            Tab(icon: Icon(Icons.edit), text: 'Manual'),
          ],
        ),
      ),
      body: Consumer<FoodProvider>(
        builder: (context, foodProvider, _) {
          return LoadingOverlay(
            isLoading: foodProvider.isAnalyzing,
            message: 'Analizando imagen con IA...',
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildPhotoTab(foodProvider),
                _buildManualTab(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPhotoTab(FoodProvider foodProvider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          if (_selectedImage != null) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.file(
                _selectedImage!,
                height: 300,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _analyzeImage,
              icon: const Icon(Icons.auto_awesome),
              label: const Text('Analizar con IA'),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () => setState(() => _selectedImage = null),
              icon: const Icon(Icons.refresh),
              label: const Text('Tomar Otra Foto'),
            ),
          ] else ...[
            Icon(
              Icons.camera_alt_outlined,
              size: 100,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 24),
            Text(
              'Toma una foto de tu comida',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'La IA detectará automáticamente los alimentos y sus valores nutricionales',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => _pickImage(ImageSource.camera),
              icon: const Icon(Icons.camera_alt),
              label: const Text('Abrir Cámara'),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () => _pickImage(ImageSource.gallery),
              icon: const Icon(Icons.photo_library),
              label: const Text('Elegir de Galería'),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildManualTab() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search,
              size: 100,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 24),
            Text(
              'Buscar Alimentos',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Busca en nuestra base de datos o crea alimentos personalizados',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => context.push('/food-search'),
              icon: const Icon(Icons.search),
              label: const Text('Buscar Alimentos'),
            ),
          ],
        ),
      ),
    );
  }
}
