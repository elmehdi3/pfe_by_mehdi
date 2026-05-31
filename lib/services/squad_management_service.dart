import 'api_service.dart';

class SquadManagementService extends BaseApiService {
  // Create a new squad
  Future<String?> createSquad({
    required String name,
    required int gameId,
    required int creatorUid,
    String? logoUrl,
  }) async {
    try {
      final response = await dio.post(
        '/teams',
        data: {
          'name': name,
          'gameId': gameId,
          'ownerId': creatorUid,
          'description': 'Squad members ensemble',
        },
      );
      return response.data['data']['id'].toString();
    } catch (e) {
      print('Error creating squad: $e');
      return null;
    }
  }

  // Get user's squads
  Future<List<Map<String, dynamic>>> getUserSquads(int userId) async {
    try {
      final response = await dio.get('/teams/user/$userId');
      if (response.statusCode == 200) {
        final List<dynamic> squads = response.data['data'];
        return squads.cast<Map<String, dynamic>>();
      }
      return [];
    } catch (e) {
      print('Error fetching user squads: $e');
      return [];
    }
  }

  // Get a specific squad's details
  Future<Map<String, dynamic>?> getSquadDetails(int squadId) async {
    try {
      final response = await dio.get('/teams/$squadId');
      if (response.statusCode == 200) {
        return response.data['data'] as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      print('Error fetching squad details: $e');
      return null;
    }
  }

  // Add a member to a squad
  Future<bool> addMember(int squadId, int newMemberUid) async {
    try {
      final response = await dio.post(
        '/teams/$squadId/members',
        queryParameters: {'userId': newMemberUid},
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('Error adding member: $e');
      return false;
    }
  }

  // Remove a member from a squad
  Future<bool> removeMember(int squadId, int memberUid) async {
    try {
      final response = await dio.delete('/teams/$squadId/members/$memberUid');
      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      print('Error removing member: $e');
      return false;
    }
  }

  // Send a squad invitation (Uses Invitations API)
  Future<bool> sendSquadInvite(int squadId, int fromUid, int toUid) async {
    try {
      final response = await dio.post(
        '/invitations/send',
        queryParameters: {
          'senderId': fromUid,
          'receiverId': toUid,
          'type': 'TEAM_INVITE',
          'targetId': squadId,
        },
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('Error sending squad invite: $e');
      return false;
    }
  }
}
