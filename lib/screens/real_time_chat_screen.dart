import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../widgets/chat_bubble.dart';
import '../theme/app_colors.dart';
import '../services/chat_service.dart';
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
  late String _chatId;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initChat();
  }

  Future<void> _initChat() async {
    // Determine the chat room id for this squad
    final chatId = await _chatService.getOrCreateSquadChat(widget.squadId);
    if (mounted) {
      setState(() {
        _chatId = chatId ?? 'invalid_chat';
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
                  stream: _chatService.chatMessagesStream(_chatId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
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
                      reverse: true, // Scroll from bottom to top
                      padding: const EdgeInsets.all(24),
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final msg = messages[index];
                        final isMe = msg['senderId'] == currentUserId;

                        // Parse timestamp
                        final timestamp = msg['timestamp'] as Timestamp?;
                        final timeString = timestamp != null
                            ? "${timestamp.toDate().hour.toString().padLeft(2, '0')}:${timestamp.toDate().minute.toString().padLeft(2, '0')}"
                            : "Just now";

                        return ChatBubble(
                          text: msg['text'] ?? '',
                          sender: isMe ? "Me" : "Teammate",
                          time: timeString,
                          avatarUrl: "https://via.placeholder.com/150",
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
