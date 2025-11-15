import 'package:intl/intl.dart';

/// Formateadores de datos para mostrar en la UI
class Formatters {
  /// Formatea número decimal con 1 decimal
  static String decimal(double value) {
    return value.toStringAsFixed(1);
  }

  /// Formatea número entero
  static String integer(double value) {
    return value.round().toString();
  }

  /// Formatea fecha
  static String date(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  /// Formatea hora
  static String time(DateTime date) {
    return DateFormat('HH:mm').format(date);
  }

  /// Formatea fecha y hora
  static String dateTime(DateTime date) {
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  }

  /// Formatea fecha en formato relativo (hoy, ayer, etc.)
  static String relativeDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateOnly = DateTime(date.year, date.month, date.day);

    if (dateOnly == today) {
      return 'Hoy';
    } else if (dateOnly == yesterday) {
      return 'Ayer';
    } else {
      return DateFormat('dd MMM', 'es').format(date);
    }
  }

  /// Formatea porcentaje
  static String percentage(double value) {
    return '${value.round()}%';
  }

  /// Formatea calorías
  static String calories(double value) {
    return '${value.round()} kcal';
  }

  /// Formatea macros (gramos)
  static String grams(double value) {
    return '${value.round()}g';
  }

  /// Formatea peso
  static String weight(double value) {
    return '${value.toStringAsFixed(1)} kg';
  }

  /// Formatea altura
  static String height(double value) {
    return '${value.round()} cm';
  }

  /// Capitaliza la primera letra
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}
