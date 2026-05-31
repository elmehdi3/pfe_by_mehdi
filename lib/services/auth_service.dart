import 'api_service.dart';
import 'token_service.dart';
import 'package:dio/dio.dart';

class AuthService {
  final BaseApiService _api = BaseApiService();

  // Sign Up
  Future<bool> signUp(String email, String password, String fullName) async {
    try {
      final response = await _api.dio.post(
        '/auth/signup',
        data: {
          'email': email,
          'password': password,
          'pseudo': fullName, // Backend uses 'pseudo' for username
        },
      );

      // Backend returns ApiResponse<MessageResponse>
      if (response.data['success'] == true) {
        return true;
      }
      return false;
    } on DioException catch (e) {
      print('Sign up API Error: ${e.response?.data['message'] ?? e.message}');
      rethrow;
    } catch (e) {
      print('General sign up error: $e');
      return false;
    }
  }

  // Login
  Future<Map<String, dynamic>?> login(String email, String password) async {
    try {
      final response = await _api.dio.post(
        '/auth/signin',
        data: {
          'pseudo': email, // Backend login uses 'pseudo' as identifier
          'password': password,
        },
      );

      if (response.data['success'] == true) {
        final data = response.data['data'];
        final token = data['token'];
        final refreshToken = data['refreshToken'];

        await TokenService.saveTokens(token, refreshToken);
        return data; // returns user info (id, pseudo, email, etc.)
      }
      return null;
    } on DioException catch (e) {
      print('Login API Error: ${e.response?.data['message'] ?? e.message}');
      rethrow;
    } catch (e) {
      print('General login error: $e');
      return null;
    }
  }

  // Logout
  Future<void> logout() async {
    await TokenService.clearTokens();
  }

  // Sign in with Google (Skeleton for future integration)
  Future<Map<String, dynamic>?> signInWithGoogle() async {
    print('Google Sign-In needs backend integration endpoints');
    return null;
  }

  // Sign in with Discord (Skeleton for future integration)
  Future<Map<String, dynamic>?> signInWithDiscord() async {
    print('Discord Sign-In needs backend integration endpoints');
    return null;
  }

  // Password Reset
  Future<bool> resetPassword(String email) async {
    try {
      final response = await _api.dio.post(
        '/auth/forgot-password',
        data: {'email': email},
      );
      return response.data['success'] == true;
    } catch (e) {
      print('Password reset error: $e');
      return false;
    }
  }

  // Dummy getters for compatibility with existing UI
  String? get currentUserId => null;
  dynamic get currentUser => null;
}
