import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Progress circular grande para mostrar calorías consumidas
class CalorieCircularProgress extends StatelessWidget {
  final double current;
  final double goal;
  final Color color;
  final double size;

  const CalorieCircularProgress({
    super.key,
    required this.current,
    required this.goal,
    this.color = Colors.green,
    this.size = 200,
  });

  @override
  Widget build(BuildContext context) {
    final progress = goal > 0 ? (current / goal).clamp(0.0, 1.0) : 0.0;
    final remaining = math.max(0, goal - current);

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Círculo de progreso
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 12,
              backgroundColor: color.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
          // Texto central
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                current.round().toString(),
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
              ),
              Text(
                'de ${goal.round()}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
              Text(
                '${remaining.round()} restantes',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.color
                          ?.withOpacity(0.7),
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
