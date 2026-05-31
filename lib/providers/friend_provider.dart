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

  StreamSubscription? _friendsSub;
  StreamSubscription? _requestsSub;

  /// Start listening to friend & request streams for [uid].
  void startListening(String uid) {
    _friendsSub?.cancel();
    _requestsSub?.cancel();

    _friendsSub = _friendService.friendsStream(uid).listen((data) {
      _friends = data;
      notifyListeners();
    });

    _requestsSub = _friendService.incomingRequestsStream(uid).listen((data) {
      _incomingRequests = data;
      notifyListeners();
    });
  }

  void stopListening() {
    _friendsSub?.cancel();
    _requestsSub?.cancel();
  }

  Future<List<Map<String, dynamic>>> searchUsers(String query) async {
    if (query.trim().isEmpty) return [];
    return await _friendService.searchUsers(query.trim());
  }

  Future<void> sendRequest(String fromUid, String toUid) async {
    _setLoading(true);
    try {
      await _friendService.sendFriendRequest(fromUid, toUid);
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> acceptRequest(String requestId) async {
    _setLoading(true);
    try {
      await _friendService.acceptFriendRequest(requestId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> declineRequest(String requestId) async {
    await _friendService.declineFriendRequest(requestId);
  }

  Future<void> removeFriend(String uid, String friendId) async {
    await _friendService.removeFriend(uid, friendId);
  }

  void _setLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  @override
  void dispose() {
    stopListening();
    super.dispose();
  }
}
