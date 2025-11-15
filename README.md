# Calories AI App 🥗📱

Aplicación móvil Android en Flutter para seguimiento de calorías con detección automática de alimentos usando Inteligencia Artificial (Gemini).

## 📋 Características

- ✅ **Autenticación de usuarios** (login/registro)
- ✅ **Onboarding personalizado** con cálculo automático de metas nutricionales
- ✅ **Detección de alimentos con IA** usando Gemini Vision API
- ✅ **Registro manual de alimentos** con búsqueda en base de datos
- ✅ **Alimentos personalizados** - crea tus propios alimentos
- ✅ **Dashboard diario** con resumen de calorías y macros
- ✅ **Estadísticas y gráficas** para seguimiento de progreso
- ✅ **Gestión de perfil** y metas nutricionales
- ✅ **Material Design 3** con tema claro/oscuro

## 🏗️ Arquitectura

```
lib/
├── config/              # Configuración (rutas, tema)
├── core/
│   ├── constants/       # Constantes de la app
│   ├── utils/           # Validadores, formatters, cálculos
│   └── widgets/         # Widgets reutilizables
├── data/
│   ├── models/          # Modelos de datos
│   ├── repositories/    # Lógica de negocio
│   └── services/        # API y Storage
├── providers/           # State management (Provider)
└── screens/             # Pantallas de la UI
```

### Stack Tecnológico

- **Framework:** Flutter 3.2+
- **Lenguaje:** Dart
- **State Management:** Provider
- **Networking:** Dio
- **Storage:** SharedPreferences + Hive
- **Navegación:** go_router
- **Gráficas:** fl_chart
- **Cámara:** image_picker

## 🚀 Instalación

### Requisitos Previos

- Flutter SDK 3.2 o superior
- Android Studio o VS Code con extensiones de Flutter
- JDK 11 o superior
- Android SDK (API level 21+)

### Pasos de Instalación

1. **Clonar el repositorio:**
```bash
git clone <url-del-repo>
cd CaloriesAI-App
```

2. **Instalar dependencias:**
```bash
flutter pub get
```

3. **Configurar el backend:**

Edita `lib/core/constants/api_constants.dart` y actualiza la `baseUrl`:

```dart
// Para desarrollo local en Android emulator
static const String baseUrl = 'http://10.0.2.2:5000/api';

// Para dispositivo físico o producción
static const String baseUrl = 'https://tu-servidor.com/api';
```

4. **Ejecutar la aplicación:**

En emulador:
```bash
flutter run
```

En dispositivo físico:
```bash
flutter run --release
```

## 🔧 Configuración

### API Key de Gemini

Para usar la detección de alimentos con IA:

1. Visita [Google AI Studio](https://ai.google.dev)
2. Crea una cuenta o inicia sesión
3. Genera una nueva API Key
4. Configúrala en la app durante el onboarding o en Perfil > API Key de Gemini

### Variables de Entorno

Para diferentes entornos (dev/prod), puedes crear archivos de configuración:

```dart
// lib/config/env.dart
class Env {
  static const String apiUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'http://10.0.2.2:5000/api',
  );
}
```

Y ejecutar con:
```bash
flutter run --dart-define=API_URL=https://api.produccion.com
```

## 📱 Funcionalidades Principales

### 1. Registro y Autenticación
- Registro con email y contraseña
- Login con validación
- Token JWT guardado localmente
- Persistencia de sesión

### 2. Onboarding
- **Paso 1:** Datos personales (peso, altura, edad, género)
- **Paso 2:** Nivel de actividad física
- **Paso 3:** Objetivo (perder/mantener/ganar peso)
- **Paso 4:** API Key de Gemini (opcional)
- Cálculo automático de TDEE y macros recomendados

### 3. Home / Dashboard
- Saludo personalizado
- Progreso circular de calorías
- Barras de progreso de macros (proteína, carbos, grasas)
- Secciones por tipo de comida (desayuno, almuerzo, cena, snacks)
- Lista de comidas del día
- FAB para agregar comida rápidamente

### 4. Agregar Comida

#### Con Foto (IA)
1. Tomar foto o seleccionar de galería
2. La IA analiza y detecta alimentos
3. Editar cantidades y alimentos detectados
4. Guardar comida

#### Manual
1. Buscar alimentos en la base de datos
2. Seleccionar alimento y cantidad
3. Crear alimentos personalizados si es necesario
4. Guardar comida

### 5. Estadísticas
- Selector de período (7 días / 30 días)
- Gráfica de calorías diarias (LineChart)
- Gráfica de distribución de macros (PieChart)
- Promedios y días cumpliendo meta
- Historial de comidas

### 6. Perfil
- Ver datos personales
- Editar perfil
- Ver y ajustar metas nutricionales
- Configurar API Key de Gemini
- Cerrar sesión

## 🎨 Tema y Diseño

### Paleta de Colores

```dart
Primary: Verde (#4CAF50)     // Fitness/salud
Accent: Naranja (#FF9800)    // Energía

// Macros
Proteína: Rosa (#E91E63)
Carbos: Azul (#2196F3)
Grasas: Amarillo (#FFC107)
```

### Componentes UI Personalizados

- `CalorieCircularProgress` - Progreso circular grande para calorías
- `MacroProgressBar` - Barra horizontal para macros
- `CustomTextField` - Input con validación
- `LoadingIndicator` / `LoadingOverlay` - Indicadores de carga

## 🧮 Cálculos Nutricionales

La app utiliza fórmulas científicas estándar:

### BMR (Basal Metabolic Rate)
Fórmula Mifflin-St Jeor:
- **Hombres:** (10 × peso kg) + (6.25 × altura cm) - (5 × edad) + 5
- **Mujeres:** (10 × peso kg) + (6.25 × altura cm) - (5 × edad) - 161

### TDEE (Total Daily Energy Expenditure)
BMR × factor de actividad:
- Sedentario: 1.2
- Ligero: 1.375
- Moderado: 1.55
- Activo: 1.725
- Muy Activo: 1.9

### Calorías Objetivo
- **Perder peso:** TDEE - 500 kcal
- **Mantener:** TDEE
- **Ganar masa:** TDEE + 300 kcal

## 📦 Build y Deploy

### Build APK
```bash
flutter build apk --release
```

### Build App Bundle (Google Play)
```bash
flutter build appbundle --release
```

### Ofuscación de código
```bash
flutter build apk --obfuscate --split-debug-info=build/debug-info
```

## 🧪 Testing

```bash
# Tests unitarios
flutter test

# Tests de integración
flutter test integration_test

# Análisis de código
flutter analyze
```

## 🐛 Debugging

Para habilitar logs detallados:

```dart
// En lib/data/services/api_service.dart
final Logger _logger = Logger(
  printer: PrettyPrinter(
    methodCount: 2,
    errorMethodCount: 8,
    lineLength: 120,
    colors: true,
    printEmojis: true,
  ),
);
```

## 📄 Licencia

Este proyecto es de uso educativo y demostrativo.

## 👨‍💻 Desarrollo Futuro

### Funcionalidades pendientes:
- [ ] Pantalla de detalle de comida completa
- [ ] Edición de comidas existentes
- [ ] Búsqueda de alimentos con filtros
- [ ] Alimentos favoritos
- [ ] Recordatorios de comidas
- [ ] Exportar datos a CSV/PDF
- [ ] Modo offline completo
- [ ] Sincronización con Google Fit
- [ ] Escaneo de códigos de barras
- [ ] Recetas con cálculo automático
- [ ] Progreso de peso con gráficas

## 🤝 Contribuciones

Las contribuciones son bienvenidas. Por favor:
1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## 📞 Soporte

Para reportar bugs o solicitar features, abre un issue en el repositorio.

---

Desarrollado con ❤️ usando Flutter
