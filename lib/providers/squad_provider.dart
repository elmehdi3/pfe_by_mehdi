import 'package:flutter/material.dart';
import '../services/database_service.dart';

class SquadProvider with ChangeNotifier {
  List<Map<String, dynamic>> _squads = [];
  Map<String, dynamic>? _activeSquad;
  bool _isLoading = false;

  List<Map<String, dynamic>> get squads => _squads;
  Map<String, dynamic>? get activeSquad => _activeSquad;
  bool get isLoading => _isLoading;

  Future<void> fetchSquads() async {
    _isLoading = true;
    notifyListeners();

    try {
      // For now, DatabaseService.getSquads returns an empty stream placeholder.
      // We should eventually implement a proper List return in DatabaseService.
    } catch (e) {
      debugPrint('Error fetching squads: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setActiveSquad(Map<String, dynamic> squad) {
    _activeSquad = squad;
    notifyListeners();
  }
}
