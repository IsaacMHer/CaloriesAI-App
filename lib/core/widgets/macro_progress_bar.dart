import 'package:flutter/material.dart';
import '../utils/formatters.dart';

/// Barra de progreso horizontal para macros
class MacroProgressBar extends StatelessWidget {
  final String label;
  final double current;
  final double goal;
  final Color color;
  final bool showGrams;

  const MacroProgressBar({
    super.key,
    required this.label,
    required this.current,
    required this.goal,
    required this.color,
    this.showGrams = true,
  });

  @override
  Widget build(BuildContext context) {
    final progress = goal > 0 ? (current / goal).clamp(0.0, 1.0) : 0.0;
    final percentage = (progress * 100).round();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.labelLarge,
            ),
            Text(
              showGrams
                  ? '${Formatters.grams(current)} / ${Formatters.grams(goal)}'
                  : '$percentage%',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: color.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 8,
          ),
        ),
      ],
    );
  }
}
