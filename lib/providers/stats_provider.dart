import 'package:flutter/foundation.dart';
import '../data/models/stats_model.dart';
import '../data/repositories/stats_repository.dart';
import '../core/constants/app_constants.dart';

/// Provider para manejar el estado de estadísticas
class StatsProvider with ChangeNotifier {
  final StatsRepository _statsRepository;

  DailyStatsModel? _dailyStats;
  ChartDataModel? _chartData;
  bool _isLoading = false;
  String? _errorMessage;
  int _selectedPeriod = AppConstants.period7Days;

  StatsProvider(this._statsRepository);

  // Getters
  DailyStatsModel? get dailyStats => _dailyStats;
  ChartDataModel? get chartData => _chartData;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get selectedPeriod => _selectedPeriod;

  /// Cambia el período seleccionado y carga los datos
  Future<void> setSelectedPeriod(int period) async {
    _selectedPeriod = period;
    notifyListeners();
    await loadChartData();
  }

  /// Carga las estadísticas diarias
  Future<void> loadDailyStats(DateTime date) async {
    try {
      _setLoading(true);
      _errorMessage = null;

      _dailyStats = await _statsRepository.getDailyStats(date);

      _setLoading(false);
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
    }
  }

  /// Carga los datos para gráficas
  Future<void> loadChartData() async {
    try {
      _setLoading(true);
      _errorMessage = null;

      _chartData = await _statsRepository.getChartData(_selectedPeriod);

      _setLoading(false);
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
    }
  }

  /// Carga los datos para gráficas con rango personalizado
  Future<void> loadChartDataByRange({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      _setLoading(true);
      _errorMessage = null;

      _chartData = await _statsRepository.getChartDataByRange(
        startDate: startDate,
        endDate: endDate,
      );

      _setLoading(false);
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
    }
  }

  /// Limpia el error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Métodos privados
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message.replaceAll('Exception: ', '');
    notifyListeners();
  }
}
