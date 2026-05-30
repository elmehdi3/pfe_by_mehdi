import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';

class UserProvider with ChangeNotifier {
  UserModel? _user;
  bool _isLoading = false;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;

  final _authService = AuthService();
  final _dbService = DatabaseService();

  UserProvider() {
    _listenToAuthChanges();
  }

  void _listenToAuthChanges() {
    _authService.user.listen((firebaseUser) async {
      if (firebaseUser != null) {
        await fetchUserProfile(firebaseUser.uid);
      } else {
        _user = null;
        notifyListeners();
      }
    });
  }

  Future<void> fetchUserProfile(String uid) async {
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
