import 'package:flutter/material.dart';
import '../services/database_service.dart';

class SquadProvider with ChangeNotifier {
  final _dbService = DatabaseService();

  List<Map<String, dynamic>> _squads = [];
  Map<String, dynamic>? _activeSquad;
  bool _isLoading = false;

  List<Map<String, dynamic>> get squads => _squads;
  Map<String, dynamic>? get activeSquad => _activeSquad;
  bool get isLoading => _isLoading;

  void fetchSquads() {
    _isLoading = true;
    notifyListeners();

    _dbService.getSquads().listen((event) {
      _squads = event;
      _isLoading = false;
      notifyListeners();
    });
  }

  void setActiveSquad(Map<String, dynamic> squad) {
    _activeSquad = squad;
    notifyListeners();
  }
}
