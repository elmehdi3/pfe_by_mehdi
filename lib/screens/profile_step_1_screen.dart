import 'package:flutter/material.dart';
import '../widgets/app_button.dart';
import '../widgets/app_card.dart';
import '../widgets/app_text_field.dart';
import '../widgets/app_dropdown.dart';
import '../theme/app_colors.dart';

import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

class ProfileStep1Screen extends StatefulWidget {
  const ProfileStep1Screen({super.key});

  @override
  State<ProfileStep1Screen> createState() => _ProfileStep1ScreenState();
}

class _ProfileStep1ScreenState extends State<ProfileStep1Screen> {
  final _nameController = TextEditingController();

  String? selectedRegion;
  String? selectedLanguage;

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
                        child: Container(
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
                      ),
                      const SizedBox(height: 32),

                      AppTextField(
                        label: 'Gamertag',
                        placeholder: 'Enter your gaming alias',
                        icon: Icons.sports_esports,
                        controller: _nameController,
                      ),
                      const SizedBox(height: 24),

                      AppDropdown<String>(
                        label: 'Region',
                        placeholder: 'Select Region',
                        icon: Icons.public,
                        value: selectedRegion,
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
                        onChanged: (val) =>
                            setState(() => selectedRegion = val),
                      ),
                      const SizedBox(height: 24),

                      AppDropdown<String>(
                        label: 'Primary Language',
                        placeholder: 'Select Language',
                        icon: Icons.translate,
                        value: selectedLanguage,
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
                        onChanged: (val) =>
                            setState(() => selectedLanguage = val),
                      ),
                      const SizedBox(height: 32),

                      const Divider(color: Colors.white10),
                      const SizedBox(height: 16),

                      Align(
                        alignment: Alignment.centerRight,
                        child: AppButton(
                          label: 'NEXT',
                          onPressed: () async {
                            await _handleContinue();
                            if (mounted) {
                              // This should be handled by PageController in ProfileFlow
                              // But for now we use an event or callback if needed.
                              // For simplicity I'll assume we navigate or use the flow logic.
                              // I'll check ProfileFlow implementation.
                            }
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

  Future<void> _handleContinue() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.updateProfile({
      'fullName': _nameController.text,
      'region': selectedRegion,
      'language': selectedLanguage,
    });
  }
}
