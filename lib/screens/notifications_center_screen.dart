import 'package:flutter/material.dart';
import '../widgets/app_card.dart';
import '../theme/app_colors.dart';

class NotificationsCenterScreen extends StatelessWidget {
  const NotificationsCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('System Feed'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: const [
                  _FilterChip(label: 'ALL ACTIVITY', isActive: true),
                  _FilterChip(label: 'INVITES'),
                  _FilterChip(label: 'MATCHES'),
                  _FilterChip(label: 'SYSTEM'),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: const [
                _NotificationItem(
                  type: 'MATCH INVITE',
                  title: 'Ranked Squad Setup',
                  description:
                      'User NeonNinja has invited you to join their lobby for a ranked session.',
                  time: '2M AGO',
                  isUnread: true,
                  icon: Icons.sports_esports,
                  color: AppColors.primary,
                  showActions: true,
                ),
                SizedBox(height: 16),
                _NotificationItem(
                  type: 'SQUAD UPDATE',
                  title: 'Tier Advancement',
                  description:
                      'Your squad Cyber Syndicate reached Tier 2 in the weekly ladder.',
                  time: '1H AGO',
                  icon: Icons.groups,
                  color: AppColors.tertiary,
                ),
                SizedBox(height: 16),
                _NotificationItem(
                  type: 'SYSTEM MAINTENANCE',
                  title: 'Server Upgrades',
                  description:
                      'Scheduled downtime for server upgrades on Friday 02:00 UTC. Expected duration: 2 hours.',
                  time: '4H AGO',
                  icon: Icons.system_update_alt,
                  color: AppColors.secondary,
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
  final bool isActive;
  const _FilterChip({required this.label, this.isActive = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary : AppColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(4),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 10,
                ),
              ]
            : [],
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isActive ? Colors.white : AppColors.onSurface,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _NotificationItem extends StatelessWidget {
  final String type;
  final String title;
  final String description;
  final String time;
  final bool isUnread;
  final IconData icon;
  final Color color;
  final bool showActions;

  const _NotificationItem({
    required this.type,
    required this.title,
    required this.description,
    required this.time,
    this.isUnread = false,
    required this.icon,
    required this.color,
    this.showActions = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerHigh,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          type,
                          style: TextStyle(
                            color: color,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          time,
                          style: const TextStyle(
                            color: AppColors.onSurfaceVariant,
                            fontSize: 8,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: const TextStyle(
                        color: AppColors.onSurfaceVariant,
                        fontSize: 14,
                      ),
                    ),
                    if (showActions) ...[
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryContainer,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            child: const Text('ACCEPT'),
                          ),
                          const SizedBox(width: 12),
                          OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.secondary,
                              side: const BorderSide(
                                color: AppColors.secondary,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            child: const Text('DECLINE'),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              if (isUnread)
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: color.withOpacity(0.5), blurRadius: 5),
                    ],
                  ),
                ),
            ],
          ),
          if (isUnread)
            Positioned(
              left: -16,
              top: -16,
              bottom: -16,
              child: Container(
                width: 4,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: const BorderRadius.horizontal(
                    right: Radius.circular(2),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
