import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/chat_bubble.dart';
import '../theme/app_colors.dart';
import '../services/chat_service.dart';
import '../providers/user_provider.dart';

class RealTimeChatScreen extends StatefulWidget {
  final int squadId;
  const RealTimeChatScreen({super.key, required this.squadId});

  @override
  State<RealTimeChatScreen> createState() => _RealTimeChatScreenState();
}

class _RealTimeChatScreenState extends State<RealTimeChatScreen> {
  final _chatService = ChatService();
  final _messageController = TextEditingController();
  int _chatId = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initChat();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _initChat() async {
    final chatId = await _chatService.getOrCreateSquadChat(widget.squadId);
    if (mounted) {
      setState(() {
        _chatId = chatId ?? 0;
        _isLoading = false;
      });
    }
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    final user = Provider.of<UserProvider>(context, listen: false).user;
    if (user != null) {
      await _chatService.sendMessage(_chatId, user.id, text);
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

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
                child: StreamBuilder<List<Map<String, dynamic>>>(
                  stream: _chatId == 0
                      ? const Stream.empty()
                      : _chatService.chatMessagesStream(_chatId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      );
                    }
                    if (_chatId == 0) {
                      return const Center(child: Text('Could not load chat.'));
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
                        final isMe = msg['senderId'] == currentUserId;

                        // Parse ISO timestamp from backend
                        final rawTimestamp = msg['timestamp'] as String?;
                        String timeString = 'Just now';
                        if (rawTimestamp != null) {
                          try {
                            final dt = DateTime.parse(rawTimestamp).toLocal();
                            timeString =
                                '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
                          } catch (_) {}
                        }

                        return ChatBubble(
                          text: msg['content'] ?? msg['text'] ?? '',
                          sender: isMe ? 'Me' : 'Teammate',
                          time: timeString,
                          avatarUrl: 'https://via.placeholder.com/150',
                          isMe: isMe,
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
                        onSubmitted: (_) => _sendMessage(),
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
                      onPressed: _sendMessage,
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
