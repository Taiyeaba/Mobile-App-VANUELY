import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _keyOnboardingCompleted = 'onboarding_completed';
  static const String _keyThemeMode = 'theme_mode';
  static const String _keyFavoriteIds = 'favorite_venue_ids';
  static const String _keyRecentlyViewedIds = 'recently_viewed_venue_ids';
  static const String _keyUserReviews = 'user_submitted_reviews';
  static const String _keyUserName = 'user_name';
  static const String _keyUserEmail = 'user_email';
  static const String _keyUserPhone = 'user_phone';
  static const String _keyNotificationPref = 'notification_pref';

  // Onboarding
  static Future<bool> isOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyOnboardingCompleted) ?? false;
  }

  static Future<void> setOnboardingCompleted(bool completed) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyOnboardingCompleted, completed);
  }

  // Theme Mode ('light', 'dark', 'system')
  static Future<String> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyThemeMode) ?? 'dark';
  }

  static Future<void> setThemeMode(String mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyThemeMode, mode);
  }

  // Favorites
  static Future<List<String>> getFavoriteIds() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_keyFavoriteIds) ?? [];
  }

  static Future<void> setFavoriteIds(List<String> ids) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_keyFavoriteIds, ids);
  }

  // Recently Viewed
  static Future<List<String>> getRecentlyViewedIds() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_keyRecentlyViewedIds) ?? [];
  }

  static Future<void> setRecentlyViewedIds(List<String> ids) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_keyRecentlyViewedIds, ids);
  }

  // Custom User Reviews Persistence
  static Future<List<String>> getCustomReviewsJson() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_keyUserReviews) ?? [];
  }

  static Future<void> saveCustomReviewsJson(List<String> jsonList) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_keyUserReviews, jsonList);
  }

  // User Profile
  static Future<Map<String, String>> getUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'name': prefs.getString(_keyUserName) ?? 'Taiyeaba Shams',
      'email': prefs.getString(_keyUserEmail) ?? 'taiyeaba.shams@example.com',
      'phone': prefs.getString(_keyUserPhone) ?? '+880 1700-000000',
    };
  }

  static Future<void> saveUserProfile(String name, String email, String phone) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserName, name);
    await prefs.setString(_keyUserEmail, email);
    await prefs.setString(_keyUserPhone, phone);
  }

  // Notifications
  static Future<bool> getNotificationPref() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyNotificationPref) ?? true;
  }

  static Future<void> setNotificationPref(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyNotificationPref, enabled);
  }
}
