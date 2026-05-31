import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/app_button.dart';
import '../widgets/app_card.dart';

class CreateTeamScreen extends StatefulWidget {
  const CreateTeamScreen({super.key});

  @override
  State<CreateTeamScreen> createState() => _CreateTeamScreenState();
}

class _CreateTeamScreenState extends State<CreateTeamScreen> {
  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Create New Team'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          LinearProgressIndicator(
            value: (_currentStep + 1) / 3,
            backgroundColor: AppColors.surfaceContainerHigh,
            valueColor: const AlwaysStoppedAnimation(AppColors.primary),
          ),
          Expanded(
            child: IndexedStack(
              index: _currentStep,
              children: [_buildStep1(), _buildStep2(), _buildStep3()],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_currentStep > 0)
                  TextButton(
                    onPressed: () => setState(() => _currentStep--),
                    child: const Text(
                      'BACK',
                      style: TextStyle(color: AppColors.onSurfaceVariant),
                    ),
                  )
                else
                  const SizedBox(),
                AppButton(
                  label: _currentStep == 2 ? 'CREATE TEAM' : 'CONTINUE',
                  onPressed: () {
                    if (_currentStep < 2) {
                      setState(() => _currentStep++);
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  icon: _currentStep == 2 ? Icons.check : Icons.arrow_forward,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep1() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Team Identity',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Set the basics for your new squad.',
            style: TextStyle(color: AppColors.onSurfaceVariant),
          ),
          const SizedBox(height: 32),
          _buildField('TEAM NAME', 'e.g. Cyber Ninjas'),
          const SizedBox(height: 24),
          _buildField('TEAM TAG (MAX 4 CHARS)', 'e.g. NINJ'),
          const SizedBox(height: 24),
          const Text(
            'REGION',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          AppCard(
            padding: EdgeInsets.zero,
            child: ListTile(
              title: const Text('Europe West'),
              trailing: const Icon(
                Icons.arrow_drop_down,
                color: AppColors.primary,
              ),
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep2() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select Game',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Which game will this team focus on?',
            style: TextStyle(color: AppColors.onSurfaceVariant),
          ),
          const SizedBox(height: 32),
          _buildGameOption('Valorant', true),
          const SizedBox(height: 16),
          _buildGameOption('League of Legends', false),
          const SizedBox(height: 16),
          _buildGameOption('Counter-Strike 2', false),
        ],
      ),
    );
  }

  Widget _buildStep3() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Final Details',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 32),
          Center(
            child: Column(
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerHigh,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.primary.withOpacity(0.5),
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.add_a_photo_outlined,
                    color: AppColors.primary,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Upload Team Logo',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 48),
          const Text(
            'PRIVACY',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _buildRadioItem('Public', 'Anyone can apply to join', true),
                const Divider(height: 1),
                _buildRadioItem(
                  'Invite Only',
                  'Only invited players can join',
                  false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField(String label, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: AppColors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLow,
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: AppColors.onSurfaceVariant.withOpacity(0.3),
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGameOption(String name, bool selected) {
    return AppCard(
      padding: EdgeInsets.zero,
      child: ListTile(
        title: Text(name),
        trailing: selected
            ? const Icon(Icons.check_circle, color: AppColors.primary)
            : null,
      ),
    );
  }

  Widget _buildRadioItem(String title, String subtitle, bool selected) {
    return ListTile(
      title: Text(title),
      subtitle: Text(
        subtitle,
        style: const TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant),
      ),
      trailing: Radio(
        value: selected,
        groupValue: true,
        onChanged: (v) {},
        activeColor: AppColors.primary,
      ),
    );
  }
}
