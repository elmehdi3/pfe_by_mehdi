import 'package:flutter/material.dart';
import '../widgets/app_card.dart';
import '../theme/app_colors.dart';

class PlayerProfileScreen extends StatelessWidget {
  const PlayerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          // Hero Section
          LayoutBuilder(
            builder: (context, constraints) {
              bool isMobile = constraints.maxWidth < 700;
              return Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Avatar
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Container(
                            width: isMobile ? 120 : 180,
                            height: isMobile ? 120 : 180,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.surfaceContainerHighest,
                                width: 4,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withOpacity(0.2),
                                  blurRadius: 20,
                                ),
                              ],
                            ),
                            child: const ClipOval(
                              child: Image(
                                image: NetworkImage(
                                  'https://lh3.googleusercontent.com/aida-public/AB6AXuD7pZdHTt4F2gVqI4JckaBON1SJ-b-kkNzo3xmpeJJxbzHDoaDXAFM3vruuktbhS5X9k1br3DRHwZqss2gMHj4YeV_HqFITkFAqc3g644EkmaZcGCBFqmj7MyURwtAfZvofp9kcdnmtMXXcQvuYLzQ5HTHCwdppMV7x1UkjR4Ic30ZVWmafEoB-3ALgDsdSd5tjid6Sn9cEnysDguG9ez4BnzFXGaFQoXR2b_jQp1x2Uso4sq0rhhKX1wtiXcjOsffeEmUHjVBIAXc',
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: AppColors.tertiary,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.surface,
                                width: 3,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.tertiary.withOpacity(0.5),
                                  blurRadius: 5,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Xenon',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.displaySmall,
                                  ),
                                  TextSpan(
                                    text: 'Strike',
                                    style: Theme.of(context)
                                        .textTheme
                                        .displaySmall
                                        ?.copyWith(color: AppColors.primary),
                                  ),
                                ],
                              ),
                            ),
                            const Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: AppColors.outlineVariant,
                                  size: 14,
                                ),
                                Text(
                                  ' Server: NA East',
                                  style: TextStyle(
                                    color: AppColors.onSurfaceVariant,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                _Badge(
                                  label: 'Verified Pro',
                                  icon: Icons.verified,
                                  color: AppColors.primary,
                                ),
                                _Badge(
                                  label: 'Elite Tier',
                                  icon: Icons.workspace_premium,
                                  color: AppColors.tertiary,
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            if (!isMobile) _buildActionButtons(),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (isMobile) ...[
                    const SizedBox(height: 24),
                    _buildActionButtons(),
                  ],
                ],
              );
            },
          ),

          const SizedBox(height: 48),

          // Stats & Info Grid
          LayoutBuilder(
            builder: (context, constraints) {
              bool isMobile = constraints.maxWidth < 600;
              return Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: AppCard(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                children: [
                                  Icon(
                                    Icons.bar_chart,
                                    color: AppColors.primary,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Performance Metrics',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              GridView.count(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                crossAxisCount: isMobile ? 2 : 4,
                                childAspectRatio: isMobile ? 1.5 : 1,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                                children: const [
                                  _StatBox(
                                    label: 'K/D Ratio',
                                    value: '3.42',
                                    trend: '+0.12',
                                  ),
                                  _StatBox(
                                    label: 'Win Rate',
                                    value: '68%',
                                    trend: '+2%',
                                  ),
                                  _StatBox(label: 'Matches', value: '1,204'),
                                  _StatBox(label: 'Hours', value: '842h'),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (!isMobile) const SizedBox(width: 16),
                      if (!isMobile)
                        Expanded(
                          child: AppCard(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Row(
                                  children: [
                                    Icon(
                                      Icons.gamepad,
                                      color: AppColors.secondary,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Main Titles',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                const _GameRow(
                                  name: 'Valorant',
                                  rank: 'Radiant',
                                ),
                                const SizedBox(height: 12),
                                const _GameRow(
                                  name: 'League of Legends',
                                  rank: 'Grandmaster',
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                  if (isMobile) const SizedBox(height: 16),
                  if (isMobile)
                    AppCard(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.gamepad, color: AppColors.secondary),
                              SizedBox(width: 8),
                              Text(
                                'Main Titles',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          const _GameRow(name: 'Valorant', rank: 'Radiant'),
                          const SizedBox(height: 12),
                          const _GameRow(
                            name: 'League of Legends',
                            rank: 'Grandmaster',
                          ),
                        ],
                      ),
                    ),
                ],
              );
            },
          ),

          const SizedBox(height: 16),

          // Availability
          AppCard(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.schedule, color: AppColors.tertiary),
                        SizedBox(width: 8),
                        Text(
                          'Availability',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Currently Online'.toUpperCase(),
                      style: const TextStyle(
                        color: AppColors.tertiary,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainer,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Row(
                    children: [
                      _TimeBlock(label: 'Morning', flex: 1),
                      _TimeBlock(
                        label: 'Afternoon',
                        flex: 1,
                        color: AppColors.primary.withOpacity(0.2),
                      ),
                      _TimeBlock(
                        label: 'Evening (Peak)',
                        flex: 1,
                        color: AppColors.primary.withOpacity(0.4),
                        isPeak: true,
                      ),
                      _TimeBlock(label: 'Late Night', flex: 1),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.group_add, size: 18),
            label: const Text('INVITE'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryContainer,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.chat, size: 18),
            label: const Text('MESSAGE'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.secondary,
              side: const BorderSide(color: AppColors.secondary),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;

  const _Badge({required this.label, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  final String? trend;

  const _StatBox({required this.label, required this.value, this.trend});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              color: AppColors.onSurfaceVariant,
              fontSize: 8,
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          if (trend != null)
            Text(
              '$trend this week',
              style: const TextStyle(color: AppColors.tertiary, fontSize: 8),
            ),
        ],
      ),
    );
  }
}

class _GameRow extends StatelessWidget {
  final String name;
  final String rank;

  const _GameRow({required this.name, required this.rank});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.surfaceContainer,
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Icon(
            Icons.videogame_asset,
            color: AppColors.outlineVariant,
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            Text(
              'Rank: $rank',
              style: const TextStyle(
                color: AppColors.onSurfaceVariant,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _TimeBlock extends StatelessWidget {
  final String label;
  final int flex;
  final Color? color;
  final bool isPeak;

  const _TimeBlock({
    required this.label,
    required this.flex,
    this.color,
    this.isPeak = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          border: isPeak
              ? const Border(
                  top: BorderSide(color: AppColors.primary, width: 2),
                )
              : null,
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 8,
              color: isPeak
                  ? Colors.white
                  : AppColors.onSurfaceVariant.withOpacity(0.5),
              fontWeight: isPeak ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
