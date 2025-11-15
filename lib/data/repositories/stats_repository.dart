import '../models/stats_model.dart';
import '../services/api_service.dart';
import '../../core/constants/api_constants.dart';
import 'package:intl/intl.dart';

/// Repositorio para manejar estadísticas
class StatsRepository {
  final ApiService _apiService;

  StatsRepository(this._apiService);

  /// Obtiene las estadísticas diarias de una fecha
  Future<DailyStatsModel> getDailyStats(DateTime date) async {
    final dateStr = DateFormat('yyyy-MM-dd').format(date);

    final response = await _apiService.get(
      ApiConstants.statsDaily,
      queryParameters: {'date': dateStr},
    );

    return DailyStatsModel.fromJson(response.data);
  }

  /// Obtiene datos para gráficas según el período
  /// period: número de días (7, 30, etc.)
  Future<ChartDataModel> getChartData(int period) async {
    final response = await _apiService.get(
      ApiConstants.statsCharts,
      queryParameters: {'period': period},
    );

    return ChartDataModel.fromJson(response.data);
  }

  /// Obtiene datos para gráficas con rango de fechas personalizado
  Future<ChartDataModel> getChartDataByRange({
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

    return ChartDataModel.fromJson(response.data);
  }
}
