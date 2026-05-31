import '../models/user_model.dart';
import 'api_service.dart';

class MatchmakingService extends BaseApiService {
  /// Find players matching specific criteria using smart matching
  Future<List<UserModel>> findMatches({
    required int myUid,
    required int gameId,
  }) async {
    try {
      final response = await dio.get(
        '/matching/smart/$gameId',
        queryParameters: {'userId': myUid},
      );

      if (response.statusCode == 200) {
        final List<dynamic> matches = response.data['data'];
        return matches
            .map((m) => UserModel.fromMap(m['matchedUserId'].toString(), m))
            .toList();
      }
      return [];
    } catch (e) {
      print('Error finding matches: $e');
      return [];
    }
  }

  /// Suggest squads based on the user's favorite game
  Future<List<Map<String, dynamic>>> suggestSquads(int gameId) async {
    try {
      final response = await dio.get(
        '/teams/search',
        queryParameters: {'gameId': gameId},
      );

      if (response.statusCode == 200) {
        final List<dynamic> squads = response.data['data']['content'];
        return squads.cast<Map<String, dynamic>>();
      }
      return [];
    } catch (e) {
      print('Error suggesting squads: $e');
      return [];
    }
  }

  /// Quick match logic
  Future<int?> quickMatch(int userId, int? gameId) async {
    try {
      final response = await dio.get(
        '/matching/random/quick',
        queryParameters: {
          'userId': userId,
          if (gameId != null) 'gameId': gameId,
        },
      );

      if (response.statusCode == 200 && response.data['data'] != null) {
        return response.data['data']['matchedUserId'];
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
