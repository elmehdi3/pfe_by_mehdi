import 'package:flutter/material.dart';
import '../widgets/app_button.dart';
import '../widgets/app_card.dart';
import '../widgets/app_dropdown.dart';
import '../theme/app_colors.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

class ProfileStep2Screen extends StatefulWidget {
  const ProfileStep2Screen({super.key});

  @override
  State<ProfileStep2Screen> createState() => _ProfileStep2ScreenState();
}

class _ProfileStep2ScreenState extends State<ProfileStep2Screen> {
  String? selectedGame;
  String? selectedRank;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Glows
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                color: AppColors.secondaryContainer.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),

          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Progress Indicator
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'STEP 2',
                            style: Theme.of(context).textTheme.labelLarge
                                ?.copyWith(color: AppColors.primary),
                          ),
                          Text(
                            '40%',
                            style: Theme.of(context).textTheme.labelLarge
                                ?.copyWith(color: AppColors.onSurfaceVariant),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: 0.4,
                        backgroundColor: AppColors.surfaceContainerHighest,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColors.primary,
                        ),
                        borderRadius: BorderRadius.circular(4),
                        minHeight: 6,
                      ),
                      const SizedBox(height: 32),

                      Text(
                        'Gaming Stats',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Show off your skills and preferred battlegrounds.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 48),

                      AppDropdown<String>(
                        label: 'Favorite Game',
                        placeholder: 'Select Game',
                        icon: Icons.sports_esports,
                        value: selectedGame,
                        items: const [
                          DropdownMenuItem(
                            value: 'VALORANT',
                            child: Text('VALORANT'),
                          ),
                          DropdownMenuItem(
                            value: 'CS:2',
                            child: Text('CS:GO 2'),
                          ),
                          DropdownMenuItem(
                            value: 'LEAGUE OF LEGENDS',
                            child: Text('League of Legends'),
                          ),
                          DropdownMenuItem(
                            value: 'APEX LEGENDS',
                            child: Text('Apex Legends'),
                          ),
                        ],
                        onChanged: (val) => setState(() => selectedGame = val),
                      ),
                      const SizedBox(height: 24),

                      AppDropdown<String>(
                        label: 'Current Rank',
                        placeholder: 'Select Rank',
                        icon: Icons.military_tech,
                        value: selectedRank,
                        items: const [
                          DropdownMenuItem(
                            value: 'iron',
                            child: Text('Iron/Bronze'),
                          ),
                          DropdownMenuItem(
                            value: 'silver',
                            child: Text('Silver/Gold'),
                          ),
                          DropdownMenuItem(
                            value: 'platinum',
                            child: Text('Platinum/Diamond'),
                          ),
                          DropdownMenuItem(
                            value: 'ascendant',
                            child: Text('Ascendant/Immortal'),
                          ),
                          DropdownMenuItem(
                            value: 'radiant',
                            child: Text('Radiant/Challenger'),
                          ),
                        ],
                        onChanged: (val) => setState(() => selectedRank = val),
                      ),
                      const SizedBox(height: 48),

                      const Divider(color: Colors.white10),
                      const SizedBox(height: 16),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('BACK'),
                          ),
                          AppButton(
                            label: 'NEXT',
                            onPressed: () async {
                              await _handleContinue();
                              if (mounted) {
                                // Navigator should be handled by PageController in flow
                              }
                            },
                            icon: Icons.arrow_forward,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleContinue() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (selectedGame != null && selectedRank != null) {
      await userProvider.updateProfile({
        'favoriteGame': selectedGame,
        'gameRank': selectedRank,
      });
    }
  }
}
