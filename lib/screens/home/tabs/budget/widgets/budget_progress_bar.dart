import 'package:flutter/material.dart';

class BudgetProgressBar extends StatelessWidget {
  final double progress;

  const BudgetProgressBar({required this.progress, super.key});

  Color _getStatusColor(double val) {
    if (val > 1.0) return Colors.red.shade700;
    if (val == 1.0) return Colors.orange.shade700;
    if (val >= 0.8) return Colors.amber.shade600;
    return Colors.green.shade600;
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0.0, end: progress),
      duration: const Duration(milliseconds: 1500),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        final Color color = _getStatusColor(value);
        final double displayValue = value.clamp(0.0, 1.0);

        final bool isOverBudget = value > 1.0;
        final double percentage = isOverBudget
            ? (value - 1.0) * 100
            : value * 100;

        return Column(
          spacing: 4,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LinearProgressIndicator(
              minHeight: 12,
              borderRadius: BorderRadius.circular(12),
              semanticsLabel: 'Progresso do orçamento',
              semanticsValue: '${(value * 100).toStringAsFixed(1)}%',
              color: color,
              value: displayValue,
            ),

            if (progress >= 0.8)
              Text(
                !isOverBudget
                    ? 'Atenção: ${percentage.toStringAsFixed(2)}% do teto atingido.'
                    : 'Atenção: Teto estourado em ${percentage.toStringAsFixed(2)}%.',
                style: TextStyle(
                  fontSize: 12,
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
          ],
        );
      },
    );
  }
}
