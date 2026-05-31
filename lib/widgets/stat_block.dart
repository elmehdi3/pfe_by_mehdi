import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class StatBlock extends StatelessWidget {
  final String label;
  final String value;
  final IconData? icon;

  const StatBlock({
    super.key,
    required this.label,
    required this.value,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest.withOpacity(0.8),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label.toUpperCase(),
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: AppColors.onSurfaceVariant,
              fontSize: 8,
            ),
          ),
          const SizedBox(height: 4),
          if (icon != null)
            Icon(icon, color: AppColors.onSurface, size: 20)
          else
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppColors.primary,
                fontSize: 18,
                shadows: [
                  Shadow(
                    color: AppColors.primary.withOpacity(0.6),
                    blurRadius: 8,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
