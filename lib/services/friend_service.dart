import 'package:cloud_firestore/cloud_firestore.dart';

/// Manages all friend-related Firestore operations.
/// Firestore schema:
///   users/{uid}/friends/{friendId}  → { status: 'accepted' }
///   friendRequests/{requestId}      → { from, to, status, createdAt }
class FriendService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ─────────────────────────────────────────────
  // Search
  // ─────────────────────────────────────────────

  /// Search users whose gamertag starts with [query] (case-insensitive trick).
  Future<List<Map<String, dynamic>>> searchUsers(String query) async {
    final lower = query.toLowerCase();
    final upper =
        lower.substring(0, lower.length - 1) +
        String.fromCharCode(lower.codeUnitAt(lower.length - 1) + 1);

    final snapshot = await _db
        .collection('users')
        .where('gamertagLower', isGreaterThanOrEqualTo: lower)
        .where('gamertagLower', isLessThan: upper)
        .limit(20)
        .get();

    return snapshot.docs.map((d) => {'id': d.id, ...d.data()}).toList();
  }

  // ─────────────────────────────────────────────
  // Friend Requests
  // ─────────────────────────────────────────────

  /// Send a friend request from [fromUid] to [toUid].
  Future<void> sendFriendRequest(String fromUid, String toUid) async {
    final requestId = '${fromUid}_$toUid';
    await _db.collection('friendRequests').doc(requestId).set({
      'from': fromUid,
      'to': toUid,
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  /// Accept a friend request, marking both users as friends.
  Future<void> acceptFriendRequest(String requestId) async {
    final requestDoc = await _db
        .collection('friendRequests')
        .doc(requestId)
        .get();
    if (!requestDoc.exists) return;

    final data = requestDoc.data()!;
    final String fromUid = data['from'];
    final String toUid = data['to'];

    final batch = _db.batch();

    // Add each other as friends
    batch.set(
      _db.collection('users').doc(toUid).collection('friends').doc(fromUid),
      {'status': 'accepted', 'since': FieldValue.serverTimestamp()},
    );
    batch.set(
      _db.collection('users').doc(fromUid).collection('friends').doc(toUid),
      {'status': 'accepted', 'since': FieldValue.serverTimestamp()},
    );

    // Update request status
    batch.update(_db.collection('friendRequests').doc(requestId), {
      'status': 'accepted',
    });

    await batch.commit();
  }

  /// Decline or cancel a friend request.
  Future<void> declineFriendRequest(String requestId) async {
    await _db.collection('friendRequests').doc(requestId).update({
      'status': 'declined',
    });
  }

  // ─────────────────────────────────────────────
  // Streams
  // ─────────────────────────────────────────────

  /// Real-time stream of incoming friend requests for [uid].
  Stream<List<Map<String, dynamic>>> incomingRequestsStream(String uid) {
    return _db
        .collection('friendRequests')
        .where('to', isEqualTo: uid)
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .map((s) => s.docs.map((d) => {'id': d.id, ...d.data()}).toList());
  }

  /// Real-time stream of [uid]'s accepted friends (returns friend UIDs + meta).
  Stream<List<Map<String, dynamic>>> friendsStream(String uid) {
    return _db
        .collection('users')
        .doc(uid)
        .collection('friends')
        .where('status', isEqualTo: 'accepted')
        .snapshots()
        .map((s) => s.docs.map((d) => {'id': d.id, ...d.data()}).toList());
  }

  // ─────────────────────────────────────────────
  // Remove
  // ─────────────────────────────────────────────

  Future<void> removeFriend(String uid, String friendId) async {
    final batch = _db.batch();
    batch.delete(
      _db.collection('users').doc(uid).collection('friends').doc(friendId),
    );
    batch.delete(
      _db.collection('users').doc(friendId).collection('friends').doc(uid),
    );
    await batch.commit();
  }
}
