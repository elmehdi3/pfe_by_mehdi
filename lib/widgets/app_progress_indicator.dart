import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AppProgressIndicator extends StatelessWidget {
  final int totalSteps;
  final int currentStep;

  const AppProgressIndicator({
    super.key,
    required this.totalSteps,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(totalSteps, (index) {
        final isActive = index == currentStep;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.only(right: 4),
          width: isActive ? 48 : 4,
          height: 4,
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.primary
                : AppColors.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(4),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.5),
                      blurRadius: 8,
                    ),
                  ]
                : [],
          ),
        );
      }),
    );
  }
}
