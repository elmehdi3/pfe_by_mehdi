import 'package:flutter/material.dart';
import '../widgets/player_card.dart';
import '../theme/app_colors.dart';

class MatchmakingSearchScreen extends StatelessWidget {
  const MatchmakingSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                _FilterChip(label: 'Rank', hasDropdown: true),
                const SizedBox(width: 8),
                _FilterChip(label: 'Ping', hasDropdown: true),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Language: EN',
                  isSelected: true,
                  hasClose: true,
                ),
                const SizedBox(width: 8),
                _FilterChip(label: 'Reputation', hasDropdown: true),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Player List
          Expanded(
            child: ListView(
              children: const [
                PlayerCard(
                  nickname: 'VortexKiller',
                  avatarUrl:
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuAdygboGPS7o_vkalmRD-hy5tfoAl_Qlwj5zSly-oVsPy3wVDjjDGBfq179svxVktQX8hgSobNZlt7Y05pavjt8xhCFMgIU0Qrqo38VYxrKO-Vnmej0kbQ-dff7VloSRZIwi4eqNNnqRdkmy5-Vvpgc66LvZVVUmEqmSN1Kl-uT_5-ApOBeSBL7R4W3eIKFKfGZCR8nuUEP_vJL_e5h5sIfOUoEkHtPky6mUmQVUW6czsUrrZqwQmoOvL52N0kr8pIBC34rWad2YLI',
                  ping: '24ms',
                  matchPercentage: '98%',
                  rank: 'Diamond I',
                  tags: ['MVP x12'],
                  isOnline: true,
                ),
                SizedBox(height: 16),
                PlayerCard(
                  nickname: 'SilentSnipe',
                  avatarUrl:
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuCUWGN2B4DqrX1kw99hq47flup7dzMo04uEMJsQbXPxwQWH2x3wB3aOY1eCFZw7pwWMaof5T-WqEuLn_YcV45KdUoq0mkdELaorEgjeJEMLxUPNeZ7XbtGLc2D6hXJr82g5UFuahvmjCxDZHktP_1jx04yEITXrXdGidIqRW6No01Ey6QOTsBgeKCxqRmDXKqAGLA26Dx-Kn6NN0odw-HpbStwIROwSJxRPIJ_0OPtM_tBA2xq3jcRCu5jortLMIh2IL2YQFuDgQVg',
                  ping: '42ms',
                  matchPercentage: '85%',
                  rank: 'Platinum III',
                  tags: ['Tactician'],
                  isOnline: false,
                ),
              ],
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
  final bool hasClose;

  const _FilterChip({
    required this.label,
    this.isSelected = false,
    this.hasDropdown = false,
    this.hasClose = false,
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
          if (hasClose) ...[
            const SizedBox(width: 4),
            Icon(
              Icons.close,
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
