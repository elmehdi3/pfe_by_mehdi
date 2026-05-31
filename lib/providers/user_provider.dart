import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';
import '../services/token_service.dart';

class UserProvider with ChangeNotifier {
  UserModel? _user;
  bool _isLoading = false;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;

  final _authService = AuthService();
  final _dbService = DatabaseService();

  UserProvider() {
    _tryAutoLogin();
  }

  Future<void> _tryAutoLogin() async {
    final token = await TokenService.getToken();
    if (token != null) {
      // In a real app, we might decode the JWT to get the userId
      // For now, this is a placeholder.
      // If we had the userId stored, we could call fetchUserProfile.
    }
  }

  Future<void> fetchUserProfile(int uid) async {
    _isLoading = true;
    notifyListeners();

    try {
      final profile = await _dbService.getUserProfile(uid);
      _user = profile;
    } catch (e) {
      debugPrint('Error fetching user profile: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setUser(UserModel user) {
    _user = user;
    notifyListeners();
  }

  Future<void> logout() async {
    await _authService.logout();
    _user = null;
    notifyListeners();
  }

  Future<void> updateProfile(Map<String, dynamic> data) async {
    if (_user == null) return;

    try {
      await _dbService.updateUserProfile(_user!.id, data);
      await fetchUserProfile(_user!.id);
    } catch (e) {
      debugPrint('Error updating profile: $e');
    }
  }
}
