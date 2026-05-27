import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/app_card.dart';
import '../widgets/app_button.dart';
import 'login_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              context,
              title: 'Account Settings',
              items: [
                _buildSettingItem(
                  Icons.person_outline,
                  'Edit Profile',
                  'Change avatar, banner, and bio',
                ),
                _buildSettingItem(
                  Icons.lock_outline,
                  'Change Password',
                  'Update your security credentials',
                ),
                _buildSettingItem(
                  Icons.email_outlined,
                  'Email Notifications',
                  'Manage your email preferences',
                ),
              ],
            ),
            const SizedBox(height: 32),
            _buildSection(
              context,
              title: 'Privacy & Security',
              items: [
                _buildSettingItem(
                  Icons.visibility_off_outlined,
                  'Private Profile',
                  'Only friends can see your stats',
                  isToggle: true,
                  value: false,
                ),
                _buildSettingItem(
                  Icons.security,
                  'Two-Factor Authentication',
                  'Add an extra layer of security',
                ),
                _buildSettingItem(
                  Icons.block_outlined,
                  'Blocked Players',
                  'Manage restricted accounts',
                ),
              ],
            ),
            const SizedBox(height: 32),
            _buildSection(
              context,
              title: 'App Preferences',
              items: [
                _buildSettingItem(Icons.language, 'Language', 'English (US)'),
                _buildSettingItem(
                  Icons.dark_mode_outlined,
                  'Dark Mode',
                  'Currently forced dark',
                  isToggle: true,
                  value: true,
                ),
              ],
            ),
            const SizedBox(height: 48),
            AppButton(
              label: 'LOGOUT',
              onPressed: () => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              ),
              isPrimary: false,
              icon: Icons.logout,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required List<Widget> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: const TextStyle(
            color: AppColors.primary,
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 16),
        AppCard(
          padding: EdgeInsets.zero,
          child: Column(children: items),
        ),
      ],
    );
  }

  Widget _buildSettingItem(
    IconData icon,
    String title,
    String subtitle, {
    bool isToggle = false,
    bool value = false,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.onSurfaceVariant, size: 20),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(fontSize: 11, color: AppColors.onSurfaceVariant),
      ),
      trailing: isToggle
          ? Switch(
              value: value,
              onChanged: (v) {},
              activeThumbColor: AppColors.primary,
            )
          : const Icon(Icons.chevron_right, color: AppColors.outline, size: 16),
    );
  }
}
