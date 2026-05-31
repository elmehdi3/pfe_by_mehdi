import 'api_service.dart';

class FriendService extends BaseApiService {
  // Search
  Future<List<Map<String, dynamic>>> searchUsers(String query) async {
    try {
      final response = await dio.get(
        '/profiles/search',
        queryParameters: {'pseudo': query},
      );
      if (response.statusCode == 200 && response.data['success'] == true) {
        return List<Map<String, dynamic>>.from(
          response.data['data']['content'] ?? [],
        );
      }
      return [];
    } catch (e) {
      print('Search error: $e');
      return [];
    }
  }

  // Friend Requests
  Future<void> sendFriendRequest(int fromUid, int toUid) async {
    try {
      await dio.post('/friends/request/$toUid');
    } catch (e) {
      print('Send friend request error: $e');
      rethrow;
    }
  }

  Future<void> acceptFriendRequest(int requestId) async {
    try {
      await dio.post('/friends/accept/$requestId');
    } catch (e) {
      print('Accept friend request error: $e');
      rethrow;
    }
  }

  Future<void> declineFriendRequest(int requestId) async {
    try {
      await dio.post('/friends/decline/$requestId');
    } catch (e) {
      print('Decline friend request error: $e');
      rethrow;
    }
  }

  // Fetching
  Future<List<Map<String, dynamic>>> getIncomingRequests(int uid) async {
    try {
      final response = await dio.get('/friends/requests/$uid');
      if (response.data['success'] == true) {
        return List<Map<String, dynamic>>.from(response.data['data'] ?? []);
      }
      return [];
    } catch (e) {
      print('Get requests error: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getFriends(int uid) async {
    try {
      final response = await dio.get('/friends/$uid');
      if (response.data['success'] == true) {
        return List<Map<String, dynamic>>.from(response.data['data'] ?? []);
      }
      return [];
    } catch (e) {
      print('Get friends error: $e');
      return [];
    }
  }

  Future<void> removeFriend(int uid, int friendId) async {
    try {
      await dio.delete('/friends/$friendId');
    } catch (e) {
      print('Remove friend error: $e');
      rethrow;
    }
  }
}
