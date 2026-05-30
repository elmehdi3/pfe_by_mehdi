import 'package:flutter/material.dart';
import '../widgets/app_card.dart';
import '../widgets/stat_block.dart';
import '../theme/app_colors.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

class ProfileStep5Screen extends StatefulWidget {
  const ProfileStep5Screen({super.key});

  @override
  State<ProfileStep5Screen> createState() => _ProfileStep5ScreenState();
}

class _ProfileStep5ScreenState extends State<ProfileStep5Screen> {
  bool _isLoading = false;

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
                  child: const FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: 1.0,
                    child: DecoratedBox(
                      decoration: BoxDecoration(color: AppColors.primary),
                    ),
                  ),
                ),

                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24.0),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 480),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Profile Ready',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.displayLarge
                                  ?.copyWith(
                                    color: AppColors.primary,
                                    fontSize: 32,
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

                            AppCard(
                              padding: const EdgeInsets.all(32),
                              child: Column(
                                children: [
                                  // Avatar
                                  Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: AppColors.primary,
                                        width: 2,
                                      ),
                                    ),
                                    child: const CircleAvatar(
                                      radius: 60,
                                      backgroundColor:
                                          AppColors.surfaceContainerHigh,
                                      child: Icon(
                                        Icons.person,
                                        size: 60,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 24),

                                  Text(
                                    '@VoidWalker',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.headlineMedium,
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
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 48),

                            if (_isLoading)
                              const CircularProgressIndicator()
                            else
                              GestureDetector(
                                onTap: _handleActivate,
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
                                  ),
                                  child: Center(
                                    child: Text(
                                      'ACTIVER MON PROFIL',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium
                                          ?.copyWith(
                                            color: Colors.white,
                                            fontSize: 18,
                                          ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
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

  Future<void> _handleActivate() async {
    setState(() => _isLoading = true);
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      await userProvider.updateProfile({'onboardingCompleted': true});
      if (mounted) {
        // Navigator.pushAndRemoveUntil...
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}
