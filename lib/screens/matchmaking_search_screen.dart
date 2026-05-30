import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/player_card.dart';
import '../theme/app_colors.dart';
import '../services/matchmaking_service.dart';
import '../providers/user_provider.dart';
import '../models/user_model.dart';

class MatchmakingSearchScreen extends StatefulWidget {
  const MatchmakingSearchScreen({super.key});

  @override
  State<MatchmakingSearchScreen> createState() =>
      _MatchmakingSearchScreenState();
}

class _MatchmakingSearchScreenState extends State<MatchmakingSearchScreen> {
  final MatchmakingService _matchmakingService = MatchmakingService();
  bool _isLoading = true;
  List<UserModel> _matches = [];

  @override
  void initState() {
    super.initState();
    _fetchMatches();
  }

  Future<void> _fetchMatches() async {
    setState(() => _isLoading = true);

    final user = Provider.of<UserProvider>(context, listen: false).user;
    if (user != null) {
      final matches = await _matchmakingService.findMatches(
        myUid: user.id,
        game: user.favoriteGame ?? 'Valorant',
        rank: user.gameRank ?? 'Unranked',
      );
      setState(() {
        _matches = matches;
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search & Filters
          TextField(
            decoration: InputDecoration(
              hintText: 'Search by ID or role...',
              prefixIcon: const Icon(
                Icons.search,
                color: AppColors.outlineVariant,
              ),
              filled: true,
              fillColor: AppColors.surfaceContainerLow,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: AppColors.outlineVariant.withOpacity(0.3),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: AppColors.outlineVariant.withOpacity(0.3),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _FilterChip(label: user?.gameRank ?? 'Rank', isSelected: true),
                const SizedBox(width: 8),
                _FilterChip(
                  label: user?.favoriteGame ?? 'Game',
                  isSelected: true,
                ),
                const SizedBox(width: 8),
                const _FilterChip(label: 'Ping < 50ms', hasDropdown: true),
                const SizedBox(width: 8),
                const _FilterChip(label: 'Reputation', hasDropdown: true),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Player List
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  )
                : _matches.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.person_search_outlined,
                          color: AppColors.onSurfaceVariant,
                          size: 64,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'No matches found',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Try adjusting your search criteria\nor playing another game.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.onSurfaceVariant.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _fetchMatches,
                    color: AppColors.primary,
                    backgroundColor: AppColors.surfaceContainerHigh,
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 0.65,
                          ),
                      itemCount: _matches.length,
                      itemBuilder: (context, index) {
                        final player = _matches[index];
                        return PlayerCard(
                          nickname: player.fullName,
                          avatarUrl:
                              player.profileImage ??
                              'https://via.placeholder.com/150',
                          ping: '24ms', // Mock ping
                          matchPercentage: '98%', // Mock match percentage
                          rank: player.gameRank ?? 'Unranked',
                          tags: player.servers ?? [],
                          isOnline:
                              true, // We could implement a presence system later
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final bool hasDropdown;

  const _FilterChip({
    required this.label,
    this.isSelected = false,
    this.hasDropdown = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.primary.withOpacity(0.2)
            : AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected
              ? AppColors.primary
              : AppColors.outlineVariant.withOpacity(0.3),
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.2),
                  blurRadius: 10,
                ),
              ]
            : [],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isSelected
                  ? AppColors.primary
                  : AppColors.onSurfaceVariant,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          if (hasDropdown) ...[
            const SizedBox(width: 4),
            Icon(
              Icons.expand_more,
              color: isSelected
                  ? AppColors.primary
                  : AppColors.onSurfaceVariant,
              size: 14,
            ),
          ],
        ],
      ),
    );
  }
}
