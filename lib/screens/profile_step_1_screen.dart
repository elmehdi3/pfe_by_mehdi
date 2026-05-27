import 'package:flutter/material.dart';
import '../widgets/app_button.dart';
import '../widgets/app_card.dart';
import '../widgets/app_text_field.dart';
import '../widgets/app_dropdown.dart';
import '../theme/app_colors.dart';

class ProfileStep1Screen extends StatelessWidget {
  const ProfileStep1Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Glows
          Positioned(
            top: 0,
            left: MediaQuery.of(context).size.width * 0.25,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                color: AppColors.primaryContainer.withOpacity(0.1),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryContainer.withOpacity(0.1),
                    blurRadius: 100,
                  ),
                ],
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
                            'STEP 1',
                            style: Theme.of(context).textTheme.labelLarge
                                ?.copyWith(color: AppColors.primary),
                          ),
                          Text(
                            '20%',
                            style: Theme.of(context).textTheme.labelLarge
                                ?.copyWith(color: AppColors.onSurfaceVariant),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: 0.2,
                        backgroundColor: AppColors.surfaceContainerHighest,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColors.primary,
                        ),
                        borderRadius: BorderRadius.circular(4),
                        minHeight: 6,
                      ),
                      const SizedBox(height: 32),

                      // Header
                      Text(
                        'General Info',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Establish your identity in the arena.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Avatar Upload
                      Center(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.primary.withOpacity(0.5),
                                  width: 2,
                                ),
                                color: AppColors.surfaceContainer,
                              ),
                              child: const Icon(
                                Icons.add_a_photo,
                                color: AppColors.primary,
                                size: 40,
                              ),
                            ),
                            // Pulse would go here in a stateful widget
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      const AppTextField(
                        label: 'Gamertag',
                        placeholder: 'Enter your gaming alias',
                        icon: Icons.sports_esports,
                      ),
                      const SizedBox(height: 24),

                      AppDropdown<String>(
                        label: 'Region',
                        placeholder: 'Select Region',
                        icon: Icons.public,
                        items: const [
                          DropdownMenuItem(
                            value: 'na',
                            child: Text('North America'),
                          ),
                          DropdownMenuItem(value: 'eu', child: Text('Europe')),
                          DropdownMenuItem(value: 'asia', child: Text('Asia')),
                          DropdownMenuItem(
                            value: 'latam',
                            child: Text('Latin America'),
                          ),
                          DropdownMenuItem(
                            value: 'oce',
                            child: Text('Oceania'),
                          ),
                        ],
                        onChanged: (val) {},
                      ),
                      const SizedBox(height: 24),

                      AppDropdown<String>(
                        label: 'Primary Language',
                        placeholder: 'Select Language',
                        icon: Icons.translate,
                        items: const [
                          DropdownMenuItem(value: 'en', child: Text('English')),
                          DropdownMenuItem(value: 'es', child: Text('Español')),
                          DropdownMenuItem(
                            value: 'fr',
                            child: Text('Français'),
                          ),
                          DropdownMenuItem(value: 'kr', child: Text('한국어')),
                          DropdownMenuItem(value: 'jp', child: Text('日本語')),
                        ],
                        onChanged: (val) {},
                      ),
                      const SizedBox(height: 32),

                      const Divider(color: Colors.white10),
                      const SizedBox(height: 16),

                      Align(
                        alignment: Alignment.centerRight,
                        child: AppButton(
                          label: 'NEXT',
                          onPressed: () {
                            // Navigate to Step 2
                          },
                          icon: Icons.arrow_forward,
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
    );
  }
}
