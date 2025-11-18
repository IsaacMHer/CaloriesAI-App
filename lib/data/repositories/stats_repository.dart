import '../models/stats_model.dart';
import '../models/api_response_model.dart';
import '../services/api_service.dart';
import '../../core/constants/api_constants.dart';
import 'package:intl/intl.dart';

/// Repositorio para manejar estadísticas
class StatsRepository {
  final ApiService _apiService;

  StatsRepository(this._apiService);

  /// Obtiene las estadísticas diarias de una fecha
  Future<DailySummaryDto> getDailyStats(DateTime date) async {
    final dateStr = DateFormat('yyyy-MM-dd').format(date);

    final response = await _apiService.get(
      ApiConstants.statsDaily,
      queryParameters: {'date': dateStr},
    );

    // Desempaquetar ApiResponse<DailySummaryDto>
    final apiResponse = ApiResponse<DailySummaryDto>.fromJson(
      response.data,
      (json) => DailySummaryDto.fromJson(json as Map<String, dynamic>),
    );

    if (!apiResponse.success || apiResponse.data == null) {
      throw Exception(apiResponse.message ?? 'Error al obtener estadísticas diarias');
    }

    return apiResponse.data!;
  }

  /// Obtiene estadísticas semanales
  Future<List<DailySummaryDto>> getWeeklyStats(DateTime startDate) async {
    final dateStr = DateFormat('yyyy-MM-dd').format(startDate);

    final response = await _apiService.get(
      ApiConstants.statsWeekly,
      queryParameters: {'startDate': dateStr},
    );

    // Desempaquetar ApiResponse<List<DailySummaryDto>>
    final apiResponse = ApiResponse<List<DailySummaryDto>>.fromJson(
      response.data,
      (json) {
        final list = json as List<dynamic>;
        return list.map((item) => DailySummaryDto.fromJson(item as Map<String, dynamic>)).toList();
      },
    );

    if (!apiResponse.success || apiResponse.data == null) {
      throw Exception(apiResponse.message ?? 'Error al obtener estadísticas semanales');
    }

    return apiResponse.data!;
  }

  /// Obtiene estadísticas mensuales
  Future<List<DailySummaryDto>> getMonthlyStats(DateTime startDate) async {
    final dateStr = DateFormat('yyyy-MM-dd').format(startDate);

    final response = await _apiService.get(
      ApiConstants.statsMonthly,
      queryParameters: {'startDate': dateStr},
    );

    // Desempaquetar ApiResponse<List<DailySummaryDto>>
    final apiResponse = ApiResponse<List<DailySummaryDto>>.fromJson(
      response.data,
      (json) {
        final list = json as List<dynamic>;
        return list.map((item) => DailySummaryDto.fromJson(item as Map<String, dynamic>)).toList();
      },
    );

    if (!apiResponse.success || apiResponse.data == null) {
      throw Exception(apiResponse.message ?? 'Error al obtener estadísticas mensuales');
    }

    return apiResponse.data!;
  }

  /// Obtiene datos para gráficas con rango de fechas
  Future<ChartDataDto> getChartData({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final startStr = DateFormat('yyyy-MM-dd').format(startDate);
    final endStr = DateFormat('yyyy-MM-dd').format(endDate);

    final response = await _apiService.get(
      ApiConstants.statsCharts,
      queryParameters: {
        'startDate': startStr,
        'endDate': endStr,
      },
    );

    // Desempaquetar ApiResponse<ChartDataDto>
    final apiResponse = ApiResponse<ChartDataDto>.fromJson(
      response.data,
      (json) => ChartDataDto.fromJson(json as Map<String, dynamic>),
    );

    if (!apiResponse.success || apiResponse.data == null) {
      throw Exception(apiResponse.message ?? 'Error al obtener datos de gráficas');
    }

    return apiResponse.data!;
  }
}
