import '../models/user_model.dart';
import 'api_service.dart';

/// Fetches ranked player data from the backend for the leaderboard.
class LeaderboardService extends BaseApiService {
  /// Returns top players sorted by [sortField] descending.
  Future<List<UserModel>> getTopPlayers({
    String sortField = 'reputationScore',
    int limit = 50,
  }) async {
    try {
      final response = await dio.get(
        '/profiles/search',
        queryParameters: {'size': limit, 'sort': '$sortField,desc'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> profiles = response.data['data']['content'];
        return profiles
            .map((p) => UserModel.fromMap(p['id'].toString(), p))
            .toList();
      }
      return [];
    } catch (e) {
      print('Error fetching leaderboard: $e');
      return [];
    }
  }

  /// Optional: Real-time stream (simulated via polling or WebSocket)
  Stream<List<UserModel>> topPlayersStream({
    String sortField = 'reputationScore',
    int limit = 50,
  }) async* {
    final players = await getTopPlayers(sortField: sortField, limit: limit);
    yield players;
  }
}
