import '../models/user_model.dart';
import 'api_service.dart';

class DatabaseService extends BaseApiService {
  // Update user profile
  Future<void> updateUserProfile(int userId, Map<String, dynamic> data) async {
    try {
      await dio.put('/profiles/$userId', data: data);
    } catch (e) {
      print('Update profile error: $e');
      rethrow;
    }
  }

  // Get user profile
  Future<UserModel?> getUserProfile(int userId) async {
    try {
      final response = await dio.get('/profiles/$userId');
      if (response.data['success'] == true) {
        final data = response.data['data'];
        return UserModel.fromMap(userId, data);
      }
      return null;
    } catch (e) {
      print('Get profile error: $e');
      return null;
    }
  }

  // Squad operations (REST)
  Future<void> createSquad(Map<String, dynamic> squadData) async {
    try {
      await dio.post('/teams', data: squadData);
    } catch (e) {
      print('Create squad error: $e');
      rethrow;
    }
  }
}
