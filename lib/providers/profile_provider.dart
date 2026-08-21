import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/storage_service.dart';

class ProfileProvider extends ChangeNotifier {
  UserProfile _user = UserProfile(
    name: 'Taiyeaba Shams',
    email: 'taiyeaba.shams@example.com',
    phone: '+880 1700-000000',
  );

  ProfileProvider() {
    _loadProfile();
  }

  UserProfile get user => _user;
  String get name => _user.name;
  String get email => _user.email;
  String get phone => _user.phone;
  String get avatarUrl => _user.avatarUrl;
  bool get notificationBooking => _user.notificationBooking;
  bool get notificationPromo => _user.notificationPromo;
  String get currency => _user.currency;
  String get language => _user.language;

  Future<void> _loadProfile() async {
    final data = await StorageService.getUserProfile();
    final notifPref = await StorageService.getNotificationPref();
    _user = _user.copyWith(
      name: data['name'],
      email: data['email'],
      phone: data['phone'],
      notificationBooking: notifPref,
    );
    notifyListeners();
  }

  Future<void> updateProfile({required String name, required String email, required String phone}) async {
    _user = _user.copyWith(name: name, email: email, phone: phone);
    await StorageService.saveUserProfile(name, email, phone);
    notifyListeners();
  }

  Future<void> setNotificationBooking(bool value) async {
    _user = _user.copyWith(notificationBooking: value);
    await StorageService.setNotificationPref(value);
    notifyListeners();
  }

  void setNotificationPromo(bool value) {
    _user = _user.copyWith(notificationPromo: value);
    notifyListeners();
  }

  void setCurrency(String curr) {
    _user = _user.copyWith(currency: curr);
    notifyListeners();
  }

  void setLanguage(String lang) {
    _user = _user.copyWith(language: lang);
    notifyListeners();
  }
}

// UserProvider alias / adapter for backward compatibility
typedef UserProvider = ProfileProvider;
