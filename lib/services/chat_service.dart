import 'api_service.dart';

class ChatService extends BaseApiService {
  /// Get or create a direct chat room between two users
  Future<int?> getOrCreateDirectChat(int uid1, int uid2) async {
    try {
      final response = await dio.post(
        '/chat/conversations/private',
        data: {'user1Id': uid1, 'user2Id': uid2},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data['data']['id'] as int?;
      }
      return null;
    } catch (e) {
      print('Error getting/creating chat: $e');
      return null;
    }
  }

  /// Get or create a squad chat room
  Future<int?> getOrCreateSquadChat(int squadId) async {
    try {
      final response = await dio.post(
        '/chat/conversations/squad',
        data: {'squadId': squadId},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data['data']['id'] as int?;
      }
      // Fallback: use squadId directly as conversation ID
      return squadId;
    } catch (e) {
      print('Error getting squad chat: $e');
      return squadId; // best-effort fallback
    }
  }

  /// Send a message in a chat room
  Future<bool> sendMessage(
    int conversationId,
    int senderId,
    String text,
  ) async {
    try {
      if (text.trim().isEmpty) return false;

      final response = await dio.post(
        '/chat/messages',
        data: {
          'conversationId': conversationId,
          'senderId': senderId,
          'content': text,
        },
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('Error sending message: $e');
      return false;
    }
  }

  /// Get messages in a specific chat
  Future<List<Map<String, dynamic>>> getChatMessages(int conversationId) async {
    try {
      final response = await dio.get('/chat/history/$conversationId');
      if (response.statusCode == 200) {
        final List<dynamic> messages = response.data['data']['content'];
        return messages.cast<Map<String, dynamic>>();
      }
      return [];
    } catch (e) {
      print('Error fetching messages: $e');
      return [];
    }
  }

  /// Stream of messages (simulated or using WebSockets)
  Stream<List<Map<String, dynamic>>> chatMessagesStream(
    int conversationId,
  ) async* {
    // Basic polling or just initial fetch for now to fix errors
    final messages = await getChatMessages(conversationId);
    yield messages;
  }

  /// Get all chats for a user
  Future<List<Map<String, dynamic>>> getUserConversations(int userId) async {
    try {
      final response = await dio.get('/chat/conversations/$userId');
      if (response.statusCode == 200) {
        final List<dynamic> convs = response.data['data'];
        return convs.cast<Map<String, dynamic>>();
      }
      return [];
    } catch (e) {
      print('Error fetching conversations: $e');
      return [];
    }
  }

  /// Optionally mark messages as read, or update typing status here
}
