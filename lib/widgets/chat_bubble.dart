import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class ChatBubble extends StatelessWidget {
  final String text;
  final String sender;
  final String time;
  final String avatarUrl;
  final bool isMe;

  const ChatBubble({
    super.key,
    required this.text,
    required this.sender,
    required this.time,
    required this.avatarUrl,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (!isMe)
            CircleAvatar(
              radius: 16,
              backgroundImage: NetworkImage(avatarUrl),
              backgroundColor: AppColors.surfaceContainer,
            ),
          if (!isMe) const SizedBox(width: 12),
          Column(
            crossAxisAlignment: isMe
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!isMe)
                    Text(
                      sender,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: AppColors.secondary,
                      ),
                    ),
                  if (!isMe) const SizedBox(width: 8),
                  Text(
                    time,
                    style: TextStyle(
                      color: AppColors.onSurfaceVariant.withOpacity(0.5),
                      fontSize: 10,
                    ),
                  ),
                  if (isMe) const SizedBox(width: 8),
                  if (isMe)
                    const Text(
                      'Me',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: AppColors.primary,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 4),
              Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.6,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  gradient: isMe
                      ? const LinearGradient(
                          colors: [
                            AppColors.primaryContainer,
                            AppColors.secondaryContainer,
                          ],
                        )
                      : null,
                  color: isMe ? null : AppColors.surfaceContainerHigh,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(12),
                    topRight: const Radius.circular(12),
                    bottomLeft: Radius.circular(isMe ? 12 : 0),
                    bottomRight: Radius.circular(isMe ? 0 : 12),
                  ),
                  border: isMe
                      ? null
                      : Border.all(color: Colors.white.withOpacity(0.05)),
                  boxShadow: isMe
                      ? [
                          BoxShadow(
                            color: AppColors.primaryContainer.withOpacity(0.3),
                            blurRadius: 10,
                          ),
                        ]
                      : [],
                ),
                child: Text(text, style: const TextStyle(fontSize: 14)),
              ),
            ],
          ),
          if (isMe) const SizedBox(width: 12),
          if (isMe)
            CircleAvatar(
              radius: 16,
              backgroundImage: NetworkImage(avatarUrl),
              backgroundColor: AppColors.surfaceContainer,
            ),
        ],
      ),
    );
  }
}
