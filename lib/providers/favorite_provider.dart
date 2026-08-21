import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class FavoriteProvider extends ChangeNotifier {
  List<String> _favoriteIds = [];

  FavoriteProvider() {
    _loadFavorites();
  }

  List<String> get favoriteIds => _favoriteIds;

  Future<void> _loadFavorites() async {
    _favoriteIds = await StorageService.getFavoriteIds();
    notifyListeners();
  }

  bool isFavorite(String venueId) {
    return _favoriteIds.contains(venueId);
  }

  Future<void> toggleFavorite(String venueId) async {
    if (_favoriteIds.contains(venueId)) {
      _favoriteIds.remove(venueId);
    } else {
      _favoriteIds.add(venueId);
    }
    await StorageService.setFavoriteIds(_favoriteIds);
    notifyListeners();
  }

  Future<void> clearFavorites() async {
    _favoriteIds.clear();
    await StorageService.setFavoriteIds(_favoriteIds);
    notifyListeners();
  }
}
