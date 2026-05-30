import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class MatchmakingService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Find players matching specific criteria
  Future<List<UserModel>> findMatches({
    required String myUid,
    required String game,
    required String rank,
    String? requiredHardware,
  }) async {
    try {
      // Base query: same game
      Query query = _db
          .collection('users')
          .where('favoriteGame', isEqualTo: game);

      // We handle the 'rank' matching.
      // Firestore allows one equality/inequality on a single field,
      // but to mimic a 'smart' range, we can just filter by exact rank for now,
      // or fetch and filter in Dart if ranges are needed.
      query = query.where('gameRank', isEqualTo: rank);

      // If hardware matters (e.g. PC only)
      if (requiredHardware != null && requiredHardware.isNotEmpty) {
        query = query.where('hardware', arrayContains: requiredHardware);
      }

      final snapshot = await query.limit(50).get();

      final List<UserModel> matches = [];

      for (var doc in snapshot.docs) {
        if (doc.id == myUid) continue; // Skip self
        final data = doc.data() as Map<String, dynamic>;
        matches.add(UserModel.fromMap(doc.id, data));
      }

      return matches;
    } catch (e) {
      print('Error finding matches: $e');
      return [];
    }
  }

  /// Suggest squads based on the user's favorite game
  Future<List<Map<String, dynamic>>> suggestSquads(String favoriteGame) async {
    try {
      final snapshot = await _db
          .collection('squads')
          .where('game', isEqualTo: favoriteGame)
          .limit(20)
          .get();

      return snapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList();
    } catch (e) {
      print('Error suggesting squads: $e');
      return [];
    }
  }
}
