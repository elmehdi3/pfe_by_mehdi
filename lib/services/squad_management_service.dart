import 'package:cloud_firestore/cloud_firestore.dart';

class SquadManagementService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Create a new squad
  Future<String?> createSquad({
    required String name,
    required String game,
    required String creatorUid,
    String? logoUrl,
  }) async {
    try {
      final docRef = await _db.collection('squads').add({
        'name': name,
        'game': game,
        'logoUrl': logoUrl,
        'adminId': creatorUid,
        'createdAt': FieldValue.serverTimestamp(),
        'members': [creatorUid],
      });
      return docRef.id;
    } catch (e) {
      print('Error creating squad: $e');
      return null;
    }
  }

  // Stream of a user's squads
  Stream<List<Map<String, dynamic>>> userSquadsStream(String uid) {
    return _db
        .collection('squads')
        .where('members', arrayContains: uid)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return {'id': doc.id, ...doc.data()};
          }).toList();
        });
  }

  // Stream of a specific squad's details
  Stream<Map<String, dynamic>?> squadStream(String squadId) {
    return _db.collection('squads').doc(squadId).snapshots().map((doc) {
      if (!doc.exists) return null;
      return {'id': doc.id, ...doc.data() as Map<String, dynamic>};
    });
  }

  // Add a member to a squad
  Future<bool> addMember(String squadId, String newMemberUid) async {
    try {
      await _db.collection('squads').doc(squadId).update({
        'members': FieldValue.arrayUnion([newMemberUid]),
      });
      return true;
    } catch (e) {
      print('Error adding member: $e');
      return false;
    }
  }

  // Remove a member from a squad
  Future<bool> removeMember(String squadId, String memberUid) async {
    try {
      await _db.collection('squads').doc(squadId).update({
        'members': FieldValue.arrayRemove([memberUid]),
      });
      return true;
    } catch (e) {
      print('Error removing member: $e');
      return false;
    }
  }

  // Send a squad invitation
  Future<bool> sendSquadInvite(
    String squadId,
    String fromUid,
    String toUid,
  ) async {
    try {
      await _db
          .collection('users')
          .doc(toUid)
          .collection('squad_invites')
          .doc(squadId)
          .set({
            'squadId': squadId,
            'from': fromUid,
            'timestamp': FieldValue.serverTimestamp(),
          });
      return true;
    } catch (e) {
      print('Error sending squad invite: $e');
      return false;
    }
  }

  // Stream of incoming squad invites
  Stream<List<Map<String, dynamic>>> incomingSquadInvitesStream(String uid) {
    return _db
        .collection('users')
        .doc(uid)
        .collection('squad_invites')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map((doc) {
            return {'id': doc.id, ...doc.data()};
          }).toList(),
        );
  }

  // Accept squad invite
  Future<bool> acceptInvite(String uid, String squadId) async {
    try {
      // Add member to squad
      final success = await addMember(squadId, uid);
      if (success) {
        // Remove invite
        await _db
            .collection('users')
            .doc(uid)
            .collection('squad_invites')
            .doc(squadId)
            .delete();
        return true;
      }
      return false;
    } catch (e) {
      print('Error accepting invite: $e');
      return false;
    }
  }

  // Decline squad invite
  Future<bool> declineInvite(String uid, String squadId) async {
    try {
      await _db
          .collection('users')
          .doc(uid)
          .collection('squad_invites')
          .doc(squadId)
          .delete();
      return true;
    } catch (e) {
      print('Error declining invite: $e');
      return false;
    }
  }
}
