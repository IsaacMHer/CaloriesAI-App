import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../providers/stats_provider.dart';
import '../../core/widgets/loading_indicator.dart';
import '../../config/theme.dart';

/// Pantalla de estadísticas con gráficas
class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StatsProvider>().loadChartData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Estadísticas'),
      ),
      body: Consumer<StatsProvider>(
        builder: (context, statsProvider, _) {
          if (statsProvider.isLoading) {
            return const LoadingIndicator(message: 'Cargando estadísticas...');
          }

          final chartData = statsProvider.chartData;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Selector de período
              _buildPeriodSelector(statsProvider),
              const SizedBox(height: 24),

              // Resumen
              if (chartData != null) ...[
                _buildSummaryCard(chartData),
                const SizedBox(height: 24),

                // Gráfica de calorías
                _buildCaloriesChart(chartData),
                const SizedBox(height: 24),

                // Gráfica de macros
                _buildMacrosChart(chartData),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _buildPeriodSelector(StatsProvider statsProvider) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Expanded(
              child: _buildPeriodChip('7 días', 7, statsProvider),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildPeriodChip('30 días', 30, statsProvider),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodChip(String label, int days, StatsProvider statsProvider) {
    final isSelected = statsProvider.selectedPeriod == days;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          statsProvider.setSelectedPeriod(days);
        }
      },
    );
  }

  Widget _buildSummaryCard(chartData) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Resumen',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildSummaryItem(
                    'Promedio',
                    '${chartData.averageCalories.round()} kcal',
                    Icons.local_fire_department,
                  ),
                ),
                Expanded(
                  child: _buildSummaryItem(
                    'Días en Meta',
                    '${chartData.daysOnTrack}',
                    Icons.check_circle,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: AppTheme.primaryGreen, size: 32),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }

  Widget _buildCaloriesChart(chartData) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Calorías Diarias',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: false),
                  titlesData: const FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: List.generate(
                        chartData.dailyStats.length,
                        (index) => FlSpot(
                          index.toDouble(),
                          chartData.dailyStats[index].totalCalories,
                        ),
                      ),
                      isCurved: true,
                      color: AppTheme.primaryGreen,
                      barWidth: 3,
                      dotData: const FlDotData(show: true),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMacrosChart(chartData) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Distribución de Macros',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      value: chartData.averageProtein,
                      title: 'Proteína',
                      color: AppTheme.proteinColor,
                      radius: 80,
                    ),
                    PieChartSectionData(
                      value: chartData.averageCarbs,
                      title: 'Carbos',
                      color: AppTheme.carbsColor,
                      radius: 80,
                    ),
                    PieChartSectionData(
                      value: chartData.averageFats,
                      title: 'Grasas',
                      color: AppTheme.fatsColor,
                      radius: 80,
                    ),
                  ],
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
