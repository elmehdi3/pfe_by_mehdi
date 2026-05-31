import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'app_card.dart';

class PlayerCard extends StatelessWidget {
  final String nickname;
  final String avatarUrl;
  final String ping;
  final String matchPercentage;
  final String rank;
  final List<String> tags;
  final bool isOnline;

  const PlayerCard({
    super.key,
    required this.nickname,
    required this.avatarUrl,
    required this.ping,
    required this.matchPercentage,
    required this.rank,
    required this.tags,
    this.isOnline = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Stack(
        children: [
          Positioned(
            top: -20,
            right: -20,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundImage: NetworkImage(avatarUrl),
                            backgroundColor: AppColors.surfaceContainer,
                          ),
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: isOnline
                                  ? AppColors.tertiary
                                  : AppColors.outlineVariant,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.surface,
                                width: 2,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            nickname,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.bolt,
                                color: AppColors.onSurfaceVariant,
                                size: 12,
                              ),
                              Text(
                                ping,
                                style: const TextStyle(
                                  color: AppColors.onSurfaceVariant,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        matchPercentage,
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(color: AppColors.tertiary, fontSize: 18),
                      ),
                      const Text(
                        'MATCH',
                        style: TextStyle(
                          color: AppColors.onSurfaceVariant,
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: AppColors.secondary.withOpacity(0.2),
                      ),
                    ),
                    child: Text(
                      rank.toUpperCase(),
                      style: const TextStyle(
                        color: AppColors.secondary,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ...tags.map(
                    (tag) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerHigh.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: AppColors.outlineVariant.withOpacity(0.2),
                        ),
                      ),
                      child: Text(
                        tag.toUpperCase(),
                        style: const TextStyle(
                          color: AppColors.onSurfaceVariant,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {},
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        AppColors.primaryContainer,
                        AppColors.secondaryContainer,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryContainer.withOpacity(0.3),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      'INVITE TO SQUAD',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
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
