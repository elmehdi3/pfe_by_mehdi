import 'package:flutter/material.dart';
import '../widgets/chat_bubble.dart';
import '../theme/app_colors.dart';
import '../services/chat_service.dart';
import 'package:provider/provider.dart';
import '../providers/squad_provider.dart';
import '../providers/user_provider.dart';

class RealTimeChatScreen extends StatefulWidget {
  final String squadId;
  const RealTimeChatScreen({super.key, required this.squadId});

  @override
  State<RealTimeChatScreen> createState() => _RealTimeChatScreenState();
}

class _RealTimeChatScreenState extends State<RealTimeChatScreen> {
  final _chatService = ChatService();
  final _messageController = TextEditingController();

  Future<void> _sendMessage(String squadId) async {
    if (_messageController.text.trim().isEmpty) return;

    final user = Provider.of<UserProvider>(context, listen: false).user;
    if (user != null) {
      final message = ChatMessage(
        id: '',
        senderId: user.id,
        senderName: user.fullName,
        text: _messageController.text.trim(),
        timestamp: DateTime.now(),
      );

      await _chatService.sendMessage(squadId, message);
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Sidebar (Desktop only)
        if (MediaQuery.of(context).size.width > 900)
          Container(
            width: 300,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow.withOpacity(0.4),
              border: const Border(right: BorderSide(color: Colors.white10)),
            ),
            child: _buildSidebar(),
          ),

        // Chat Area
        Expanded(
          child: Column(
            children: [
              // Chat Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.background.withOpacity(0.5),
                  border: const Border(
                    bottom: BorderSide(color: Colors.white10),
                  ),
                ),
                child: const Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: AppColors.primaryContainer,
                      child: Icon(Icons.group, color: AppColors.primary),
                    ),
                    SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Squad Chat',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          'Online',
                          style: TextStyle(
                            color: AppColors.onSurfaceVariant,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Messages
              Expanded(
                child: Consumer<SquadProvider>(
                  builder: (context, squadProvider, child) {
                    final squadId = widget.squadId;
                    return StreamBuilder<List<ChatMessage>>(
                      stream: _chatService.getMessages(squadId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Center(
                            child: Text('No messages yet. Say hi!'),
                          );
                        }

                        final messages = snapshot.data!;
                        final currentUserId = Provider.of<UserProvider>(
                          context,
                          listen: false,
                        ).user?.id;
                        return ListView.builder(
                          reverse: true,
                          padding: const EdgeInsets.all(24),
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            final msg = messages[index];
                            final isMe = msg.senderId == currentUserId;
                            return ChatBubble(
                              text: msg.text,
                              sender: isMe ? "Me" : msg.senderName,
                              time:
                                  "${msg.timestamp.hour}:${msg.timestamp.minute}",
                              avatarUrl: "https://via.placeholder.com/150",
                              isMe: isMe,
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),

              // Input Area
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.white10)),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.add_circle_outline,
                        color: AppColors.onSurfaceVariant,
                      ),
                      onPressed: () {},
                    ),
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        onSubmitted: (_) => _sendMessage(widget.squadId),
                        decoration: const InputDecoration(
                          hintText: 'Type a message...',
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            color: Colors.white24,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send, color: AppColors.primary),
                      onPressed: () => _sendMessage(widget.squadId),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSidebar() {
    return const Center(child: Text('Squads List Placeholder'));
  }
}
