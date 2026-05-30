import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

/// Fetches ranked player data from Firestore for the leaderboard.
class LeaderboardService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Returns top [limit] players sorted by [sortField] descending.
  Future<List<UserModel>> getTopPlayers({
    String sortField = 'reputationScore',
    int limit = 50,
  }) async {
    final snapshot = await _db
        .collection('users')
        .orderBy(sortField, descending: true)
        .limit(limit)
        .get();

    return snapshot.docs
        .map((doc) => UserModel.fromMap(doc.id, doc.data()))
        .toList();
  }

  /// Real-time stream of top players.
  Stream<List<UserModel>> topPlayersStream({
    String sortField = 'reputationScore',
    int limit = 50,
  }) {
    return _db
        .collection('users')
        .orderBy(sortField, descending: true)
        .limit(limit)
        .snapshots()
        .map(
          (s) => s.docs
              .map((doc) => UserModel.fromMap(doc.id, doc.data()))
              .toList(),
        );
  }
}
