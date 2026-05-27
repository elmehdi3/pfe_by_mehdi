import 'package:flutter/material.dart';
import '../widgets/app_button.dart';
import '../widgets/app_card.dart';
import '../widgets/game_card.dart';
import '../widgets/app_text_field.dart';
import '../theme/app_colors.dart';

class ProfileStep2Screen extends StatefulWidget {
  const ProfileStep2Screen({super.key});

  @override
  State<ProfileStep2Screen> createState() => _ProfileStep2ScreenState();
}

class _ProfileStep2ScreenState extends State<ProfileStep2Screen> {
  String selectedGame = 'VALORANT';
  String selectedRole = 'Duelist';
  double competitiveIntent = 3.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.onSurfaceVariant),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'TEAMUP',
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.w900,
            letterSpacing: -1,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header & Progress
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Gaming Identity',
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                Text(
                  'STEP 2 OF 5',
                  style: Theme.of(
                    context,
                  ).textTheme.labelLarge?.copyWith(color: AppColors.primary),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Tell us what you play and how well you play it.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: 0.4,
              backgroundColor: AppColors.surfaceContainerHighest,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.primary,
              ),
              borderRadius: BorderRadius.circular(4),
              minHeight: 4,
            ),
            const SizedBox(height: 32),

            // Main Content Grid
            LayoutBuilder(
              builder: (context, constraints) {
                bool isMobile = constraints.maxWidth < 600;
                return Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left Side: Games List
                        Expanded(
                          flex: isMobile ? 1 : 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Primary Games',
                                style: Theme.of(
                                  context,
                                ).textTheme.headlineMedium,
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Select the main titles you play competitively.',
                                style: TextStyle(
                                  color: AppColors.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(height: 16),
                              GridView.count(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                crossAxisCount: 2,
                                mainAxisSpacing: 12,
                                crossAxisSpacing: 12,
                                children: [
                                  GameCard(
                                    title: 'VALORANT',
                                    imageUrl:
                                        'https://lh3.googleusercontent.com/aida-public/AB6AXuCaQgS0DFNzS54VSkN3goWMJJfMt-1guj7bpPQSDlXC3h7_XddCtO-HYNiSm7kNrQEiO7gMR33Hhle5C6m9A8sFqyT5CFjyvHvjqKk99V8zIHkJ01OFJeVHS52-Dm5UC-4Z9Zq4LIu-Q900EgcYv8aSe243x8lsWEIRR1MoOYX7DEuG5UiO5aGFMQgS4KLQmSgKhdCj_Vtk_7TThMjLgnrPqoWjU2i3ZzEncJABFhV5gZC8W9HujuUvlPGcMwTCwSeNRVz0Y0bS36I',
                                    isActive: selectedGame == 'VALORANT',
                                    onTap: () => setState(
                                      () => selectedGame = 'VALORANT',
                                    ),
                                  ),
                                  GameCard(
                                    title: 'LEAGUE OF LEGENDS',
                                    imageUrl:
                                        'https://lh3.googleusercontent.com/aida-public/AB6AXuB1SQYC1oEK7Th_gG_X9wQ6sQbR3iKfrL3xcKnEvFeAdtQaTaIPqPfUh-0ENkJvCzZW5S-o6tE5ao_4usTLtK4ddog4wPjanCUUOW2ihFpU0uQ2M3ZGH8r5XVCzcrcEHyCsKoUzup8AmZOczyhUU8wJIx3SidPXPWOaHXGjjog5D2qEYCqpLK0dFe3SyLLZBBIy5dY-ytIZgfrKz5HcuqXitlp3oyC0--Q4naGn7XXshW_4XS0vEhj2jlh4y2G2RpV6IuCA3dCi12k',
                                    isActive:
                                        selectedGame == 'LEAGUE OF LEGENDS',
                                    onTap: () => setState(
                                      () => selectedGame = 'LEAGUE OF LEGENDS',
                                    ),
                                  ),
                                  GameCard(
                                    title: 'CS:2',
                                    imageUrl:
                                        'https://lh3.googleusercontent.com/aida-public/AB6AXuD677vnTKTvsMwSYjV_gA4oHns5tR69JW2Jy80g-N6ajntziKbMhNIRopG-c6m7jfxMzwUUotpAYiuqhfw2-2VUwM6L1mJ-rnwx4pSW_uppCk2i-5ucz1aNRBN37hFv5L5uNiYq8e4LiAxHZJRT-LjcOvgOEny5Tw8EnIipJQLBBQBbyqGes1D5EmO2c529R1fscuzhGY14q8QnUoZs0ECI4hs8i9O5IETjxZMc72EHYEQkQbjPbh8Hn3OkEl8jpbhMewFDiDkBWuo',
                                    isActive: selectedGame == 'CS:2',
                                    onTap: () =>
                                        setState(() => selectedGame = 'CS:2'),
                                  ),
                                  // Add Game Placeholder
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: AppColors.outlineVariant
                                            .withOpacity(0.3),
                                        style: BorderStyle.solid,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(
                                      Icons.add,
                                      color: AppColors.outlineVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        if (!isMobile) const SizedBox(width: 32),

                        // Right Side: Game Details
                        if (!isMobile)
                          Expanded(flex: 1, child: _buildGameDetailsPanel()),
                      ],
                    ),
                    if (isMobile) const SizedBox(height: 32),
                    if (isMobile) _buildGameDetailsPanel(),
                  ],
                );
              },
            ),

            const SizedBox(height: 48),
            // Footer Actions
            const Divider(color: Colors.white10),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.secondary),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  child: const Text(
                    'SKIP FOR NOW',
                    style: TextStyle(color: AppColors.secondary),
                  ),
                ),
                const SizedBox(width: 16),
                AppButton(
                  label: 'CONTINUE',
                  onPressed: () {
                    // Next Step
                  },
                  icon: Icons.arrow_forward,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameDetailsPanel() {
    return AppCard(
      padding: const EdgeInsets.all(24),
      borderRadius: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'EDITING',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '$selectedGame Profile',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
          const SizedBox(height: 24),
          const AppTextField(
            label: 'CURRENT RANK / ELO',
            placeholder: 'e.g. Diamond 2, Immortal...',
            icon: Icons.military_tech,
          ),
          const SizedBox(height: 24),
          const Text(
            'MAIN ROLE',
            style: TextStyle(
              color: AppColors.onSurfaceVariant,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: ['Duelist', 'Initiator', 'Controller', 'Sentinel'].map((
              role,
            ) {
              bool isSelected = selectedRole == role;
              return InkWell(
                onTap: () => setState(() => selectedRole = role),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary.withOpacity(0.1)
                        : Colors.transparent,
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.outlineVariant.withOpacity(0.5),
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    role,
                    style: TextStyle(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.onSurfaceVariant,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'COMPETITIVE INTENT',
                style: TextStyle(
                  color: AppColors.onSurfaceVariant,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                competitiveIntent == 1.0
                    ? 'CASUAL'
                    : (competitiveIntent == 2.0 ? 'RANKED' : 'HARDCORE'),
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Slider(
            value: competitiveIntent,
            min: 1,
            max: 3,
            divisions: 2,
            activeColor: AppColors.primary,
            inactiveColor: AppColors.outlineVariant.withOpacity(0.3),
            onChanged: (val) => setState(() => competitiveIntent = val),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'CASUAL',
                style: TextStyle(color: AppColors.outlineVariant, fontSize: 10),
              ),
              const Text(
                'RANKED',
                style: TextStyle(color: AppColors.outlineVariant, fontSize: 10),
              ),
              Text(
                'HARDCORE',
                style: TextStyle(
                  color: competitiveIntent == 3.0
                      ? AppColors.primary
                      : AppColors.outlineVariant,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
