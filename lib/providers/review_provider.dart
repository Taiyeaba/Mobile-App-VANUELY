import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/review.dart';
import '../data/venue_data.dart';
import '../services/storage_service.dart';

class ReviewProvider extends ChangeNotifier {
  List<Review> _customReviews = [];

  ReviewProvider() {
    _loadCustomReviews();
  }

  Future<void> _loadCustomReviews() async {
    final jsonList = await StorageService.getCustomReviewsJson();
    _customReviews = jsonList
        .map((item) => Review.fromJson(json.decode(item)))
        .toList();
    notifyListeners();
  }

  List<Review> getReviewsForVenue(String venueId) {
    final defaultReviews = dummyReviews.where((r) => r.venueId == venueId).toList();
    final customForVenue = _customReviews.where((r) => r.venueId == venueId).toList();
    return [...customForVenue, ...defaultReviews];
  }

  double getAverageRating(String venueId, double initialRating) {
    final allReviews = getReviewsForVenue(venueId);
    if (allReviews.isEmpty) return initialRating;

    double total = 0;
    for (var r in allReviews) {
      total += r.rating;
    }
    return double.parse((total / allReviews.length).toStringAsFixed(1));
  }

  int getTotalReviewsCount(String venueId, int initialCount) {
    final allReviews = getReviewsForVenue(venueId);
    return allReviews.length > initialCount ? allReviews.length : (initialCount + _customReviews.where((r) => r.venueId == venueId).length);
  }

  Map<int, double> getRatingBreakdown(String venueId) {
    final allReviews = getReviewsForVenue(venueId);
    if (allReviews.isEmpty) {
      return {5: 0.82, 4: 0.12, 3: 0.04, 2: 0.01, 1: 0.01};
    }

    final Map<int, int> counts = {5: 0, 4: 0, 3: 0, 2: 0, 1: 0};
    for (var r in allReviews) {
      final star = r.rating.round().clamp(1, 5);
      counts[star] = (counts[star] ?? 0) + 1;
    }

    final total = allReviews.length;
    return {
      5: (counts[5]! / total),
      4: (counts[4]! / total),
      3: (counts[3]! / total),
      2: (counts[2]! / total),
      1: (counts[1]! / total),
    };
  }

  Future<void> addReview(Review review) async {
    _customReviews.insert(0, review);
    final jsonList = _customReviews.map((r) => json.encode(r.toJson())).toList();
    await StorageService.saveCustomReviewsJson(jsonList);
    notifyListeners();
  }
}
