import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class OnboardingReputationScreen extends StatelessWidget {
  final VoidCallback onFinish;

  const OnboardingReputationScreen({super.key, required this.onFinish});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Background Decoration
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: AppColors.primaryContainer.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Illustration Area
                        AspectRatio(
                          aspectRatio: 1.5,
                          child: Container(
                            width: double.infinity,
                            constraints: const BoxConstraints(maxWidth: 500),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceContainerHigh.withOpacity(
                                0.4,
                              ),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.1),
                              ),
                            ),
                            child: Stack(
                              children: [
                                Image.network(
                                  'https://lh3.googleusercontent.com/aida-public/AB6AXuAj0yj0aIABhkPGU51BVxLdso49nwN41RTtQgaepONzED_-0FDzFudpJpzXHhLEVL7N3uTEeGaH9WtGIVK56bA2GU1dlGt2-dF_-zV9-5zkv76W3Hc2uX1WYFAWXyNlsbAxCBeGrexyIlPMl8dIaNH15k5-3kLQbthrTU_xUADoWxJMjMTkDHj4kyeW3oBQICLDqx1q6Vsx4X_a0rCKr-O15b9ODEyFSFe687RRUkevl9iu4ZhBW7jOjMzpS1fZJgkvn4Duo_jGuSM',
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                  opacity: const AlwaysStoppedAnimation(0.6),
                                ),
                                Center(
                                  child: Wrap(
                                    spacing: 16,
                                    runSpacing: 16,
                                    alignment: WrapAlignment.center,
                                    children: const [
                                      _BadgeIcon(
                                        icon: Icons.military_tech,
                                        color: AppColors.primary,
                                        label: 'ELITE TIER',
                                      ),
                                      _BadgeIcon(
                                        icon: Icons.verified,
                                        color: AppColors.tertiary,
                                        label: 'VERIFIED',
                                      ),
                                      _BadgeIcon(
                                        icon: Icons.trending_up,
                                        color: AppColors.secondary,
                                        label: 'TOP 1%',
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 48),
                        Text(
                          'Build Your Legacy',
                          style: Theme.of(
                            context,
                          ).textTheme.displayLarge?.copyWith(fontSize: 32),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Earn badges, climb the ranks, and establish your reputation in the competitive scene.',
                          style: TextStyle(
                            color: AppColors.onSurfaceVariant,
                            fontSize: 18,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),

                // Bottom Controls
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      // Pagination
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.surfaceContainerHighest,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.surfaceContainerHighest,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            width: 32,
                            height: 8,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(4),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withOpacity(0.6),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton(
                        onPressed: onFinish,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.onPrimary,
                          minimumSize: const Size(double.infinity, 56),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 10,
                          shadowColor: AppColors.primary.withOpacity(0.5),
                        ),
                        child: const Text(
                          'GET STARTED',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
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

class _BadgeIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;

  const _BadgeIcon({
    required this.icon,
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHighest.withOpacity(0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 48),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}
