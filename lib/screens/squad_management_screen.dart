import 'package:flutter/material.dart';
import '../widgets/app_card.dart';
import '../theme/app_colors.dart';
import 'create_team_screen.dart';

class SquadManagementScreen extends StatelessWidget {
  const SquadManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CreateTeamScreen()),
        ),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: AppColors.onPrimary),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 32),
            LayoutBuilder(
              builder: (context, constraints) {
                bool isMobile = constraints.maxWidth < 900;
                if (isMobile) {
                  return Column(
                    children: [
                      _buildActionPanel(),
                      const SizedBox(height: 24),
                      _buildRoster(),
                    ],
                  );
                }
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 2, child: _buildRoster()),
                    const SizedBox(width: 32),
                    Expanded(child: _buildActionPanel()),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Echo Squadron', style: Theme.of(context).textTheme.displaySmall),
        const SizedBox(height: 4),
        const Row(
          children: [
            Icon(
              Icons.fiber_manual_record,
              color: AppColors.tertiary,
              size: 12,
            ),
            SizedBox(width: 8),
            Text(
              'Online: 4/5',
              style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 14),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainer.withOpacity(0.4),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.meeting_room,
                color: AppColors.onSurfaceVariant,
                size: 18,
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'ROOM ID',
                    style: TextStyle(
                      color: AppColors.onSurfaceVariant,
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'VAL-992-X',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 24),
              const Icon(
                Icons.content_copy,
                color: AppColors.onSurfaceVariant,
                size: 18,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRoster() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.group, color: AppColors.primary),
            SizedBox(width: 8),
            Text(
              'Roster',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const _PlayerRosterItem(
          name: 'Xenon',
          role: 'Entry Fragger',
          isLeader: true,
          isReady: true,
          imageUrl:
              'https://lh3.googleusercontent.com/aida-public/AB6AXuBaJzrLvLbjSiUJPT9YJghsBJGW0eVxSDz25tzKd2LRK1C9W1nsieKfOf_GOWbMwt3Ypi1FUFo4a1fvENAp9MT25gyHZYNOI_irSd8kwuA8TD8EXL4EK2G8mXJm1cIOYb7dlTya6yNvG1iVXF0HXjcTOo1ZdaNOaxUmqaYSaJtshLT6mU37fbm_lWv59u6enHAplfYy8aUD3tHh6MpRwU0VlW6GbYhBgM-_BPAzwmLqdOlxkL9pJcb6u2VrrFLhp3fLCy2Ban6v4uA',
        ),
        const SizedBox(height: 12),
        const _PlayerRosterItem(
          name: 'Valkyrie',
          role: 'Support',
          isReady: false,
          imageUrl:
              'https://lh3.googleusercontent.com/aida-public/AB6AXuDPHp3sH4x2MTwpKWpHDf7aCgy9fpDLDWbvwXweNKmRSo5y7oHUiygw9z4eJ-IsXfahciooetdpUgQex5IvILyz2ff6fNmrv9BmNi7Ni1pKkxzeIJoJqBhOkbUgGRiaXv4NAbf0dS_t0x6Xn6voB5knXHJSTODR5LbmRJEdc8em-TIfKtjtp5CMVn4iVgiNOZ8LeOEhrEPE2Y5vWqthxWExyFTGAnUSO47R-FsO6Zh77fEpm0pVx-y7YirCy2N1RW3vduxcMj9nO0I',
        ),
      ],
    );
  }

  Widget _buildActionPanel() {
    return Column(
      children: [
        AppCard(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Ready for Action?',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Ensure all members are ready before initiating the sequence.',
                style: TextStyle(
                  color: AppColors.onSurfaceVariant,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.rocket_launch, size: 20),
                label: const Text('LAUNCH SESSION'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryContainer,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 10,
                  shadowColor: AppColors.primaryContainer.withOpacity(0.5),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Row(
          children: [
            Expanded(
              child: _SmallStatCard(
                label: 'WIN STREAK',
                value: '4',
                subValue: 'Matches',
                color: AppColors.tertiary,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: _SmallStatCard(
                label: 'AVG RATING',
                value: 'S',
                subValue: 'Tier',
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _PlayerRosterItem extends StatelessWidget {
  final String name;
  final String role;
  final String imageUrl;
  final bool isLeader;
  final bool isReady;

  const _PlayerRosterItem({
    required this.name,
    required this.role,
    required this.imageUrl,
    this.isLeader = false,
    this.isReady = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                radius: 24,
                backgroundImage: NetworkImage(imageUrl),
                backgroundColor: AppColors.surfaceContainer,
              ),
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: AppColors.tertiary,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.surface, width: 2),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    if (isLeader) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: AppColors.primary.withOpacity(0.3),
                          ),
                        ),
                        child: const Text(
                          'LEADER',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.my_location,
                      color: AppColors.onSurfaceVariant,
                      size: 12,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      role,
                      style: const TextStyle(
                        color: AppColors.onSurfaceVariant,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isReady
                  ? AppColors.tertiary.withOpacity(0.1)
                  : AppColors.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isReady
                    ? AppColors.tertiary.withOpacity(0.3)
                    : Colors.white10,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isReady ? Icons.check_circle : Icons.hourglass_empty,
                  color: isReady
                      ? AppColors.tertiary
                      : AppColors.onSurfaceVariant,
                  size: 14,
                ),
                const SizedBox(width: 6),
                Text(
                  isReady ? 'READY' : 'PENDING',
                  style: TextStyle(
                    color: isReady
                        ? AppColors.tertiary
                        : AppColors.onSurfaceVariant,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          const Icon(Icons.more_vert, color: AppColors.onSurfaceVariant),
        ],
      ),
    );
  }
}

class _SmallStatCard extends StatelessWidget {
  final String label;
  final String value;
  final String subValue;
  final Color color;

  const _SmallStatCard({
    required this.label,
    required this.value,
    required this.subValue,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.onSurfaceVariant,
              fontSize: 8,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(width: 4),
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  subValue,
                  style: const TextStyle(
                    color: AppColors.onSurfaceVariant,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
