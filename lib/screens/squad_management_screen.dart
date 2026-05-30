import 'package:flutter/material.dart';
import 'create_team_screen.dart';
import '../widgets/app_card.dart';
import '../theme/app_colors.dart';
import '../services/database_service.dart';
import '../services/auth_service.dart';
import 'package:provider/provider.dart';
import '../providers/squad_provider.dart';
import '../providers/user_provider.dart';

class SquadManagementScreen extends StatefulWidget {
  const SquadManagementScreen({super.key});

  @override
  State<SquadManagementScreen> createState() => _SquadManagementScreenState();
}

class _SquadManagementScreenState extends State<SquadManagementScreen> {
  final _dbService = DatabaseService();

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
      body: Consumer<SquadProvider>(
        builder: (context, squadProvider, child) {
          if (squadProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (squadProvider.squads.isEmpty) {
            return const Center(child: Text('No squads found. Create one!'));
          }

          final activeSquad =
              squadProvider.activeSquad ?? squadProvider.squads.first;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, activeSquad),
                const SizedBox(height: 32),
                LayoutBuilder(
                  builder: (context, constraints) {
                    bool isMobile = constraints.maxWidth < 900;
                    if (isMobile) {
                      return Column(
                        children: [
                          _buildActionPanel(),
                          const SizedBox(height: 24),
                          _buildRoster(activeSquad['members'] ?? []),
                        ],
                      );
                    }
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: _buildRoster(activeSquad['members'] ?? []),
                        ),
                        const SizedBox(width: 32),
                        Expanded(child: _buildActionPanel()),
                      ],
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Map<String, dynamic> squad) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          squad['name'] ?? 'Unnamed Squad',
          style: Theme.of(context).textTheme.displaySmall,
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            const Icon(
              Icons.fiber_manual_record,
              color: AppColors.tertiary,
              size: 12,
            ),
            const SizedBox(width: 8),
            Text(
              'Members: ${(squad['members'] as List?)?.length ?? 0}',
              style: const TextStyle(
                color: AppColors.onSurfaceVariant,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRoster(List members) {
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
        ...members
            .map(
              (memberId) => FutureBuilder<Map<String, dynamic>?>(
                future: _dbService.getUserProfile(memberId),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const SizedBox.shrink();
                  final profile = snapshot.data!;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: _PlayerRosterItem(
                      name: profile['fullName'] ?? 'Unknown',
                      role: profile['gameRank'] ?? 'Player',
                      imageUrl: 'https://via.placeholder.com/150',
                      isReady: true,
                    ),
                  );
                },
              ),
            )
            .toList(),
      ],
    );
  }

  Widget _buildActionPanel() {
    return AppCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Session Status',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryContainer,
            ),
            child: const Text('LAUNCH MATCHMAKING'),
          ),
        ],
      ),
    );
  }
}

class _PlayerRosterItem extends StatelessWidget {
  final String name;
  final String role;
  final String imageUrl;
  final bool isReady;

  const _PlayerRosterItem({
    required this.name,
    required this.role,
    required this.imageUrl,
    this.isReady = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          CircleAvatar(backgroundImage: NetworkImage(imageUrl)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(
                  role,
                  style: const TextStyle(
                    color: AppColors.onSurfaceVariant,
                    fontSize: 12,
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
