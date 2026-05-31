import 'package:flutter/material.dart';
import '../widgets/app_card.dart';
import '../widgets/activity_item.dart';
import '../theme/app_colors.dart';
import 'notifications_center_screen.dart';
import 'detailed_stats_screen.dart';
import 'settings_screen.dart';

class HomeDashboardScreen extends StatelessWidget {
  const HomeDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'TEAMUP',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.settings_outlined,
                      color: AppColors.primary,
                    ),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SettingsScreen(),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.notifications_outlined,
                      color: AppColors.primary,
                    ),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NotificationsCenterScreen(),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Text(
            'Welcome back, Alex',
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
              shadows: [
                Shadow(
                  color: AppColors.primary.withOpacity(0.5),
                  blurRadius: 10,
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Ready to dominate today?',
            style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 18),
          ),
          const SizedBox(height: 32),

          // Bento Grid Layout
          LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                children: [
                  _buildProfileSummary(context),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: _buildRankBadge(context)),
                      const SizedBox(width: 16),
                      Expanded(child: _buildStatsBento(context)),
                    ],
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 48),

          // Recent Activity Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.only(left: 12),
                decoration: const BoxDecoration(
                  border: Border(
                    left: BorderSide(color: AppColors.primary, width: 4),
                  ),
                ),
                child: Text(
                  'Recent Activity',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              Text(
                'VIEW ALL',
                style: Theme.of(
                  context,
                ).textTheme.labelLarge?.copyWith(color: AppColors.primary),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const ActivityItem(
            title: 'Victory - Ranked Match',
            subtitle: 'Map: Neon City • +24 RP',
            time: '2h ago',
            icon: Icons.emoji_events,
            iconColor: AppColors.tertiary,
          ),
          const ActivityItem(
            title: 'Joined Squad "Cyber Ninjas"',
            subtitle: 'Role: Support',
            time: '1d ago',
            icon: Icons.group_add,
            iconColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSummary(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(
              'https://lh3.googleusercontent.com/aida-public/AB6AXuBC-FaYlSmsexrG2HL3dS7h1dreSNqJ3ZBtDHc3MosvAmmVEN0iVk3Tg6eosgwI4tvsE9lQyxIp80WUk3xW1IBN2N6aLS2U30OeXiN4Vd5ASOMDFPW0KFl9qJxFgPih3vw4jsybDhtQiSBFEmk1rNlVRYZ47GsqX3kuCBorgRMCovcHMWul4wp313B91g0OFje0ZA3nwNZImZhqQbJIt7j8RQKyuRxFj_PxI59VTvj9rhQAXcuuR6mvmAs1JMu4EfIAGiZe4sOY6EEk',
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'XenonStrike',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Server: Europe West',
                  style: TextStyle(
                    color: AppColors.onSurfaceVariant.withOpacity(0.7),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.qr_code, color: AppColors.primary, size: 24),
        ],
      ),
    );
  }

  Widget _buildRankBadge(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Text(
            'RANK',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          const Icon(Icons.shield, color: AppColors.tertiary, size: 40),
          const SizedBox(height: 4),
          const Text(
            'Platinum II',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.tertiary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsBento(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const DetailedStatsScreen()),
      ),
      child: AppCard(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'WIN RATE',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: const [
                Text(
                  '68%',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 4),
                Text(
                  '+2.4%',
                  style: TextStyle(
                    fontSize: 10,
                    color: AppColors.tertiary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
