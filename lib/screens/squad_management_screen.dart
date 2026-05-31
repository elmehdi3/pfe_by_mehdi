import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/app_card.dart';
import 'create_team_screen.dart';
import '../services/squad_management_service.dart';
import '../services/database_service.dart';
import '../models/user_model.dart';
import 'package:provider/provider.dart';
import '../providers/squad_provider.dart';
import '../providers/user_provider.dart';
import '../providers/friend_provider.dart';

class SquadManagementScreen extends StatefulWidget {
  const SquadManagementScreen({super.key});

  @override
  State<SquadManagementScreen> createState() => _SquadManagementScreenState();
}

class _SquadManagementScreenState extends State<SquadManagementScreen> {
  final _squadService = SquadManagementService();
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
              (memberId) => FutureBuilder<UserModel?>(
                future: _dbService.getUserProfile(memberId),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const SizedBox.shrink();
                  final profile = snapshot.data!;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: _PlayerRosterItem(
                      uid: profile.id,
                      name: profile.fullName.isNotEmpty
                          ? profile.fullName
                          : 'Unknown',
                      role: profile.gameRank ?? 'Player',
                      imageUrl:
                          profile.profileImage ??
                          'https://via.placeholder.com/150',
                      isReady: true,
                      onRemove: () async {
                        // Implement remove logic
                        final squadProvider = Provider.of<SquadProvider>(
                          context,
                          listen: false,
                        );
                        final activeSquadId =
                            (squadProvider.activeSquad ??
                                    squadProvider.squads.first)['id']
                                as int;
                        await _squadService.removeMember(
                          activeSquadId,
                          profile.id,
                        );
                        // SquadProvider should auto-update since it listens to stream
                      },
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
            onPressed: () => _showInviteDialog(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary.withOpacity(0.1),
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.primary),
            ),
            child: const Text('INVITE FRIEND'),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryContainer,
              foregroundColor: AppColors.onPrimary,
            ),
            child: const Text('LAUNCH MATCHMAKING'),
          ),
        ],
      ),
    );
  }

  void _showInviteDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.background,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) => Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(24.0),
              child: Text(
                'Invite Friends',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Expanded(
              child: Consumer<FriendProvider>(
                builder: (context, friendProvider, child) {
                  final friends = friendProvider.friends;
                  if (friends.isEmpty) {
                    return const Center(child: Text('No friends found.'));
                  }
                  return ListView.builder(
                    controller: scrollController,
                    itemCount: friends.length,
                    itemBuilder: (context, index) {
                      final friend = friends[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                            friend['profileImage'] ??
                                'https://via.placeholder.com/150',
                          ),
                        ),
                        title: Text(friend['fullName'] ?? 'Unknown'),
                        subtitle: Text(friend['gameRank'] ?? 'No Rank'),
                        trailing: ElevatedButton(
                          onPressed: () async {
                            final squadProvider = Provider.of<SquadProvider>(
                              context,
                              listen: false,
                            );
                            final userProvider = Provider.of<UserProvider>(
                              context,
                              listen: false,
                            );
                            final activeSquadId =
                                (squadProvider.activeSquad ??
                                        squadProvider.squads.first)['id']
                                    as int;

                            final success = await _squadService.sendSquadInvite(
                              activeSquadId,
                              userProvider.user!.id,
                              friend['id'] is String
                                  ? int.parse(friend['id'])
                                  : friend['id'] as int,
                            );

                            if (mounted) {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    success
                                        ? 'Invite sent!'
                                        : 'Failed to send invite',
                                  ),
                                  backgroundColor: success
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              );
                            }
                          },
                          child: const Text('INVITE'),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlayerRosterItem extends StatelessWidget {
  final int uid;
  final String name;
  final String role;
  final String imageUrl;
  final bool isReady;
  final VoidCallback? onRemove;

  const _PlayerRosterItem({
    required this.uid,
    required this.name,
    required this.role,
    required this.imageUrl,
    this.isReady = false,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(imageUrl),
            backgroundColor: AppColors.surfaceContainerHigh,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  role,
                  style: const TextStyle(
                    color: AppColors.onSurfaceVariant,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          if (isReady)
            const Icon(Icons.check_circle, color: AppColors.primary, size: 20),
          if (onRemove != null) ...[
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.close, color: Colors.red, size: 18),
              onPressed: onRemove,
            ),
          ],
        ],
      ),
    );
  }
}
