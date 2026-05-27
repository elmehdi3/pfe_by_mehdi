import 'package:flutter/material.dart';
import '../widgets/app_card.dart';
import '../widgets/stat_block.dart';
import '../theme/app_colors.dart';

class ProfileStep5Screen extends StatelessWidget {
  const ProfileStep5Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Glows
          Positioned(
            top: 0,
            left: MediaQuery.of(context).size.width * 0.1,
            child: Container(
              width: 500,
              height: 400,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.1),
                    blurRadius: 120,
                  ),
                ],
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Full Progress Bar at top
                Container(
                  height: 4,
                  width: double.infinity,
                  color: AppColors.surfaceContainerHighest,
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: 1.0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(1),
                            blurRadius: 15,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Header
                          Text(
                            'Profile Ready',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.displayLarge
                                ?.copyWith(
                                  color: AppColors.primary,
                                  fontSize: 32,
                                  shadows: [
                                    Shadow(
                                      color: AppColors.primary.withOpacity(0.4),
                                      blurRadius: 10,
                                    ),
                                  ],
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Your dossier is complete. Review before deployment.',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: AppColors.onSurfaceVariant),
                          ),
                          const SizedBox(height: 48),

                          // Summary Card
                          AppCard(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 32,
                            ),
                            child: Column(
                              children: [
                                // Avatar
                                Stack(
                                  alignment: Alignment.bottomRight,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: const LinearGradient(
                                          colors: [
                                            AppColors.primary,
                                            AppColors.primaryContainer,
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppColors.primary
                                                .withOpacity(0.3),
                                            blurRadius: 25,
                                          ),
                                        ],
                                      ),
                                      child: ClipOval(
                                        child: Image.network(
                                          'https://lh3.googleusercontent.com/aida-public/AB6AXuAw2yHSD4hpBIrpe0cz13EC_W8gvQsT-_AyKeB4KmVZ_qNwpqpGi-HtcbBofiTYBATCpe50D24EJ6Ty71zGHJq-SrKYvYusjrOcmbxE9qjJElNPH-HyHJV7uksu-Z4hA0B6hnnOe5i6NPGFCCerO-xwhUQQhoQBpJTtMaTZvluS3t1_n08zznk31JpxRgEc4oIxTqAZPJYHqbfUTrLTbN0P-JivbsPZnq3zXBz2ehokClqI_u-76uw0Z8e9vL_OTwLU6SZWZJIQUDI',
                                          width: 120,
                                          height: 120,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.tertiary,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: Colors.white24,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            width: 6,
                                            height: 6,
                                            decoration: const BoxDecoration(
                                              color: AppColors.onTertiary,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          const Text(
                                            'ONLINE',
                                            style: TextStyle(
                                              color: AppColors.onTertiary,
                                              fontSize: 8,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 24),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '@VoidWalker',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.headlineMedium,
                                    ),
                                    const SizedBox(width: 4),
                                    const Icon(
                                      Icons.verified,
                                      color: AppColors.primary,
                                      size: 18,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),

                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.surfaceContainerHighest
                                        .withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: AppColors.outlineVariant,
                                    ),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.sports_esports,
                                        color: AppColors.primary,
                                        size: 16,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        'VALORANT MAIN',
                                        style: TextStyle(
                                          color: AppColors.onSurfaceVariant,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 32),

                                const Row(
                                  children: [
                                    Expanded(
                                      child: StatBlock(
                                        label: 'K/D Ratio',
                                        value: '1.48',
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: StatBlock(
                                        label: 'Win Rate',
                                        value: '62%',
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: StatBlock(
                                        label: 'Role',
                                        value: '',
                                        icon: Icons.shield,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 48),

                          // CTA Button
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              height: 64,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    AppColors.primaryContainer,
                                    AppColors.secondaryContainer,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primaryContainer
                                        .withOpacity(0.6),
                                    blurRadius: 20,
                                  ),
                                ],
                              ),
                              child: Stack(
                                children: [
                                  Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Activer mon profil'.toUpperCase(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineMedium
                                              ?.copyWith(
                                                color: Colors.white,
                                                fontSize: 18,
                                                shadows: [
                                                  const Shadow(
                                                    color: Colors.white54,
                                                    blurRadius: 8,
                                                  ),
                                                ],
                                              ),
                                        ),
                                        const SizedBox(width: 8),
                                        const Icon(
                                          Icons.bolt,
                                          color: Colors.white,
                                          size: 24,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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
