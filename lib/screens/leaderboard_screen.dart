import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/leaderboard_service.dart';
import '../theme/app_colors.dart';
import '../widgets/app_card.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final _service = LeaderboardService();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Leaderboard',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
      body: StreamBuilder<List<UserModel>>(
        stream: _service.topPlayersStream(sortField: 'reputationScore'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return _buildEmpty();
          }

          final players = snapshot.data!;
          return CustomScrollView(
            slivers: [
              // ── Top 3 podium ──────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
                  child: _buildPodium(context, players),
                ),
              ),

              // ── Section header ────────────────────────
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                sliver: SliverToBoxAdapter(
                  child: Row(
                    children: const [
                      Icon(
                        Icons.leaderboard,
                        color: AppColors.primary,
                        size: 18,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'RANKINGS',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 12)),

              // ── Full ranked list ──────────────────────
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, i) {
                    final player = players[i];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _RankCard(rank: i + 1, player: player),
                    );
                  }, childCount: players.length),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 32)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPodium(BuildContext context, List<UserModel> players) {
    // Podium: 2nd | 1st | 3rd
    final first = players.isNotEmpty ? players[0] : null;
    final second = players.length > 1 ? players[1] : null;
    final third = players.length > 2 ? players[2] : null;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withOpacity(0.12),
            AppColors.secondary.withOpacity(0.08),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // 2nd place
          Expanded(child: _PodiumSlot(rank: 2, player: second, height: 80)),
          const SizedBox(width: 12),
          // 1st place
          Expanded(child: _PodiumSlot(rank: 1, player: first, height: 110)),
          const SizedBox(width: 12),
          // 3rd place
          Expanded(child: _PodiumSlot(rank: 3, player: third, height: 60)),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.leaderboard, color: AppColors.primary, size: 64),
          SizedBox(height: 16),
          Text(
            'Leaderboard is empty',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Be the first to earn a reputation score!',
            style: TextStyle(color: AppColors.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
//  Podium slot (1st / 2nd / 3rd)
// ─────────────────────────────────────────────────────────

class _PodiumSlot extends StatelessWidget {
  final int rank;
  final UserModel? player;
  final double height;

  const _PodiumSlot({
    required this.rank,
    required this.player,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    final colors = {
      1: const Color(0xFFFFD700), // gold
      2: const Color(0xFFC0C0C0), // silver
      3: const Color(0xFFCD7F32), // bronze
    };
    final color = colors[rank]!;
    final name = player?.fullName ?? '—';
    final imageUrl = player?.profileImage;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Crown for 1st
        if (rank == 1) const Text('👑', style: TextStyle(fontSize: 24)),
        const SizedBox(height: 4),
        CircleAvatar(
          radius: rank == 1 ? 36 : 28,
          backgroundColor: color.withOpacity(0.2),
          backgroundImage: imageUrl != null ? NetworkImage(imageUrl) : null,
          child: imageUrl == null
              ? Text(
                  name.isNotEmpty ? name[0].toUpperCase() : '?',
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: rank == 1 ? 22 : 16,
                  ),
                )
              : null,
        ),
        const SizedBox(height: 8),
        Text(medalsIcons(rank), style: const TextStyle(fontSize: 20)),
        const SizedBox(height: 4),
        Text(
          name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: rank == 1 ? 14 : 12,
            color: color,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        // Podium block
        Container(
          height: height,
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Center(
            child: Text(
              '#$rank',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w900,
                fontSize: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }

  String medalsIcons(int rank) {
    switch (rank) {
      case 1:
        return '🥇';
      case 2:
        return '🥈';
      case 3:
        return '🥉';
      default:
        return '';
    }
  }
}

// ─────────────────────────────────────────────────────────
//  Rank card (4th place and below)
// ─────────────────────────────────────────────────────────

class _RankCard extends StatelessWidget {
  final int rank;
  final UserModel player;

  const _RankCard({required this.rank, required this.player});

  @override
  Widget build(BuildContext context) {
    final imageUrl = player.profileImage;
    final name = player.fullName;
    final rank_ = player.gameRank ?? 'Unranked';
    final game = player.favoriteGame ?? '—';

    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Rank number
          SizedBox(
            width: 32,
            child: Text(
              '#$rank',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: rank <= 10
                    ? AppColors.primary
                    : AppColors.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(width: 12),
          CircleAvatar(
            radius: 22,
            backgroundColor: AppColors.surfaceContainerHigh,
            backgroundImage: imageUrl != null ? NetworkImage(imageUrl) : null,
            child: imageUrl == null
                ? Text(
                    name.isNotEmpty ? name[0].toUpperCase() : '?',
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    const Icon(
                      Icons.sports_esports,
                      color: AppColors.onSurfaceVariant,
                      size: 12,
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        game,
                        style: const TextStyle(
                          color: AppColors.onSurfaceVariant,
                          fontSize: 11,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.primary.withOpacity(0.3)),
            ),
            child: Text(
              rank_,
              style: const TextStyle(
                color: AppColors.primary,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
