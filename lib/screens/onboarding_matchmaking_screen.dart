import 'package:flutter/material.dart';
import '../widgets/app_button.dart';
import '../widgets/app_card.dart';
import '../widgets/app_progress_indicator.dart';
import '../theme/app_colors.dart';

class OnboardingMatchmakingScreen extends StatelessWidget {
  final VoidCallback onNext;
  final VoidCallback onSkip;

  const OnboardingMatchmakingScreen({
    super.key,
    required this.onNext,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Glow
          Positioned(
            top: 200,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.1),
                      blurRadius: 100,
                      spreadRadius: 50,
                    ),
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Skip Button
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: AppButton(
                      label: 'SKIP',
                      onPressed: onSkip,
                      isPrimary: false,
                    ),
                  ),
                ),

                const Spacer(),

                // Illustration Placeholder
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.05),
                        ),
                        color: AppColors.surface.withOpacity(0.4),
                      ),
                      child: ClipOval(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Icon(
                              Icons.hub_outlined,
                              size: 150,
                              color: AppColors.primary.withOpacity(0.2),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                const Spacer(),

                // Content Panel
                AppCard(
                  padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
                  borderRadius: 32,
                  child: Column(
                    children: [
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: Theme.of(context).textTheme.displayMedium,
                          children: [
                            const TextSpan(text: 'Precision '),
                            TextSpan(
                              text: 'Matchmaking',
                              style: TextStyle(color: AppColors.primary),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Find teammates that match your skill level and playstyle.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 48),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const AppProgressIndicator(
                            totalSteps: 3,
                            currentStep: 0,
                          ),
                          AppButton(
                            label: 'NEXT',
                            onPressed: onNext,
                            icon: Icons.arrow_forward,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
