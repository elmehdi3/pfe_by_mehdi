import 'dart:async';
import 'package:flutter/material.dart';
import '../services/friend_service.dart';

class FriendProvider extends ChangeNotifier {
  final FriendService _friendService = FriendService();

  List<Map<String, dynamic>> _friends = [];
  List<Map<String, dynamic>> _incomingRequests = [];
  bool _isLoading = false;
  String? _error;

  List<Map<String, dynamic>> get friends => _friends;
  List<Map<String, dynamic>> get incomingRequests => _incomingRequests;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get pendingCount => _incomingRequests.length;

  /// Fetch initial data (Replaces startListening)
  Future<void> loadData(int uid) async {
    _setLoading(true);
    try {
      final friendsData = await _friendService.getFriends(uid);
      final requestsData = await _friendService.getIncomingRequests(uid);
      _friends = friendsData;
      _incomingRequests = requestsData;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<List<Map<String, dynamic>>> searchUsers(String query) async {
    if (query.trim().isEmpty) return [];
    return await _friendService.searchUsers(query.trim());
  }

  Future<void> sendRequest(int fromUid, int toUid) async {
    _setLoading(true);
    try {
      await _friendService.sendFriendRequest(fromUid, toUid);
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> acceptRequest(int requestId) async {
    _setLoading(true);
    try {
      await _friendService.acceptFriendRequest(requestId);
      // Wait a bit or reload
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> declineRequest(int requestId) async {
    await _friendService.declineFriendRequest(requestId);
  }

  Future<void> removeFriend(int uid, int friendId) async {
    await _friendService.removeFriend(uid, friendId);
  }

  void _setLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }
}
