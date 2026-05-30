import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Get or create a direct chat room between two users
  Future<String?> getOrCreateDirectChat(String uid1, String uid2) async {
    try {
      // Create a deterministic chatId based on UIDs
      final sortedUids = [uid1, uid2]..sort();
      final chatId = '${sortedUids[0]}_${sortedUids[1]}';

      final chatDoc = await _db.collection('chats').doc(chatId).get();

      if (!chatDoc.exists) {
        await _db.collection('chats').doc(chatId).set({
          'type': 'direct',
          'participants': [uid1, uid2],
          'createdAt': FieldValue.serverTimestamp(),
          'lastMessage': '',
          'lastMessageTime': FieldValue.serverTimestamp(),
        });
      }

      return chatId;
    } catch (e) {
      print('Error getting/creating chat: $e');
      return null;
    }
  }

  /// Get or create a squad chat room
  Future<String?> getOrCreateSquadChat(String squadId) async {
    try {
      final chatId = 'squad_$squadId';

      final chatDoc = await _db.collection('chats').doc(chatId).get();

      if (!chatDoc.exists) {
        // Fetch squad members to initialize participants
        final squadDoc = await _db.collection('squads').doc(squadId).get();
        final squadData = squadDoc.data();
        final members = squadData?['members'] ?? [];

        await _db.collection('chats').doc(chatId).set({
          'type': 'squad',
          'squadId': squadId,
          'participants': members,
          'createdAt': FieldValue.serverTimestamp(),
          'lastMessage': '',
          'lastMessageTime': FieldValue.serverTimestamp(),
        });
      }

      return chatId;
    } catch (e) {
      print('Error getting/creating squad chat: $e');
      return null;
    }
  }

  /// Send a message in a chat room
  Future<bool> sendMessage(String chatId, String senderId, String text) async {
    try {
      final timestamp = FieldValue.serverTimestamp();

      // Ensure text is not empty
      if (text.trim().isEmpty) return false;

      // 1. Add message to messages subcollection
      await _db.collection('chats').doc(chatId).collection('messages').add({
        'senderId': senderId,
        'text': text,
        'timestamp': timestamp,
      });

      // 2. Update last message in the chat document
      await _db.collection('chats').doc(chatId).update({
        'lastMessage': text,
        'lastMessageTime': timestamp,
      });

      return true;
    } catch (e) {
      print('Error sending message: $e');
      return false;
    }
  }

  /// Stream of messages in a specific chat
  Stream<List<Map<String, dynamic>>> chatMessagesStream(String chatId) {
    return _db
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return {'id': doc.id, ...doc.data()};
          }).toList();
        });
  }

  /// Stream of all chats (direct and squad) a user is part of
  Stream<List<Map<String, dynamic>>> userChatsStream(String uid) {
    return _db
        .collection('chats')
        .where('participants', arrayContains: uid)
        .orderBy('lastMessageTime', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return {'id': doc.id, ...doc.data()};
          }).toList();
        });
  }

  /// Optionally mark messages as read, or update typing status here
}
