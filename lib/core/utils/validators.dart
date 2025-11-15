/// Validadores de formularios
class Validators {
  /// Valida email
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'El email es requerido';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return 'Email inválido';
    }

    return null;
  }

  /// Valida contraseña
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'La contraseña es requerida';
    }

    if (value.length < 6) {
      return 'La contraseña debe tener al menos 6 caracteres';
    }

    return null;
  }

  /// Valida que las contraseñas coincidan
  static String? confirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Confirma tu contraseña';
    }

    if (value != password) {
      return 'Las contraseñas no coinciden';
    }

    return null;
  }

  /// Valida nombre
  static String? name(String? value) {
    if (value == null || value.isEmpty) {
      return 'El nombre es requerido';
    }

    if (value.length < 2) {
      return 'El nombre debe tener al menos 2 caracteres';
    }

    return null;
  }

  /// Valida número positivo
  static String? positiveNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo es requerido';
    }

    final number = double.tryParse(value);
    if (number == null || number <= 0) {
      return 'Debe ser un número mayor a 0';
    }

    return null;
  }

  /// Valida edad
  static String? age(String? value) {
    if (value == null || value.isEmpty) {
      return 'La edad es requerida';
    }

    final number = int.tryParse(value);
    if (number == null || number < 10 || number > 120) {
      return 'Edad inválida (10-120)';
    }

    return null;
  }

  /// Valida peso
  static String? weight(String? value) {
    if (value == null || value.isEmpty) {
      return 'El peso es requerido';
    }

    final number = double.tryParse(value);
    if (number == null || number < 20 || number > 300) {
      return 'Peso inválido (20-300 kg)';
    }

    return null;
  }

  /// Valida altura
  static String? height(String? value) {
    if (value == null || value.isEmpty) {
      return 'La altura es requerida';
    }

    final number = double.tryParse(value);
    if (number == null || number < 100 || number > 250) {
      return 'Altura inválida (100-250 cm)';
    }

    return null;
  }

  /// Valida que no esté vacío
  static String? required(String? value, [String? fieldName]) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? "Este campo"} es requerido';
    }
    return null;
  }
}
