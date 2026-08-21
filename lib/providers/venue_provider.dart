import 'package:flutter/material.dart';
import '../models/venue.dart';
import '../data/venue_data.dart';
import '../services/storage_service.dart';

class VenueProvider extends ChangeNotifier {
  final List<Venue> _allVenues = [...dummyVenues, ...exclusiveVenues];
  List<String> _recentlyViewedIds = [];
  final List<String> _comparisonIds = [];

  String _searchQuery = '';
  String _selectedCategory = 'All';
  String _selectedLocation = 'All Locations';
  double _maxPrice = 350000.0;
  int _minCapacity = 0;
  double _minRating = 0.0;
  String _sortBy = 'Recommended';

  VenueProvider() {
    _loadRecentlyViewed();
  }

  Future<void> _loadRecentlyViewed() async {
    _recentlyViewedIds = await StorageService.getRecentlyViewedIds();
    notifyListeners();
  }

  List<Venue> get venues => _allVenues;
  List<String> get comparisonIds => _comparisonIds;
  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;
  String get selectedLocation => _selectedLocation;
  double get maxPrice => _maxPrice;
  int get minCapacity => _minCapacity;
  double get minRating => _minRating;
  String get sortBy => _sortBy;

  List<Venue> get featuredVenues {
    return dummyVenues.where((v) => v.isFeatured).toList();
  }

  List<Venue> get exclusiveVenuesList {
    return exclusiveVenues;
  }

  List<Venue> get popularVenues {
    return _allVenues.where((v) => v.isPopular || v.rating >= 4.9).toList();
  }

  List<Venue> get recommendedVenues {
    return _allVenues.where((v) => v.rating >= 4.85).take(4).toList();
  }

  List<Venue> get recentlyViewedVenues {
    // Only return venues that the user has actually opened
    final list = <Venue>[];
    for (final id in _recentlyViewedIds) {
      final v = getVenueById(id);
      if (v != null && !list.contains(v)) {
        list.add(v);
      }
    }
    return list;
  }

  List<Venue> get comparisonVenues {
    return _allVenues.where((v) => _comparisonIds.contains(v.id)).toList();
  }

  Future<void> addToRecentlyViewed(String venueId) async {
    _recentlyViewedIds.remove(venueId);
    _recentlyViewedIds.insert(0, venueId);
    if (_recentlyViewedIds.length > 10) {
      _recentlyViewedIds.removeLast();
    }
    await StorageService.setRecentlyViewedIds(_recentlyViewedIds);
    notifyListeners();
  }

  bool toggleComparison(String venueId) {
    if (_comparisonIds.contains(venueId)) {
      _comparisonIds.remove(venueId);
      notifyListeners();
      return false;
    } else {
      if (_comparisonIds.length >= 3) {
        return false;
      }
      _comparisonIds.add(venueId);
      notifyListeners();
      return true;
    }
  }

  void clearComparison() {
    _comparisonIds.clear();
    notifyListeners();
  }

  Venue? getVenueById(String id) {
    try {
      return _allVenues.firstWhere((v) => v.id == id);
    } catch (_) {
      return null;
    }
  }

  List<Venue> get filteredVenues {
    List<Venue> result = _allVenues.where((venue) {
      final matchesSearch = _searchQuery.isEmpty ||
          venue.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          venue.location.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          venue.category.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesCategory = _selectedCategory == 'All' ||
          venue.category.toLowerCase() == _selectedCategory.toLowerCase();

      final matchesLocation = _selectedLocation == 'All Locations' ||
          venue.location.toLowerCase().contains(_selectedLocation.split(',').first.toLowerCase());

      final matchesPrice = venue.pricePerDay <= _maxPrice;
      final matchesCapacity = venue.guestCapacity >= _minCapacity;
      final matchesRating = venue.rating >= _minRating;

      return matchesSearch &&
          matchesCategory &&
          matchesLocation &&
          matchesPrice &&
          matchesCapacity &&
          matchesRating;
    }).toList();

    if (_sortBy == 'Price: Low to High') {
      result.sort((a, b) => a.pricePerDay.compareTo(b.pricePerDay));
    } else if (_sortBy == 'Price: High to Low') {
      result.sort((a, b) => b.pricePerDay.compareTo(a.pricePerDay));
    } else if (_sortBy == 'Highest Rated') {
      result.sort((a, b) => b.rating.compareTo(a.rating));
    }

    return result;
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setSelectedCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setSelectedLocation(String location) {
    _selectedLocation = location;
    notifyListeners();
  }

  void setMaxPrice(double price) {
    _maxPrice = price;
    notifyListeners();
  }

  void setMinCapacity(int capacity) {
    _minCapacity = capacity;
    notifyListeners();
  }

  void setMinRating(double rating) {
    _minRating = rating;
    notifyListeners();
  }

  void setSortBy(String sort) {
    _sortBy = sort;
    notifyListeners();
  }

  void resetFilters() {
    _searchQuery = '';
    _selectedCategory = 'All';
    _selectedLocation = 'All Locations';
    _maxPrice = 350000.0;
    _minCapacity = 0;
    _minRating = 0.0;
    _sortBy = 'Recommended';
    notifyListeners();
  }
}
