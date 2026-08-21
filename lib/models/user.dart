class UserProfile {
  final String name;
  final String email;
  final String phone;
  final String avatarUrl;
  final bool notificationBooking;
  final bool notificationPromo;
  final String currency;
  final String language;

  UserProfile({
    required this.name,
    required this.email,
    required this.phone,
    this.avatarUrl = 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=500&q=80',
    this.notificationBooking = true,
    this.notificationPromo = false,
    this.currency = 'BDT (৳)',
    this.language = 'English',
  });

  UserProfile copyWith({
    String? name,
    String? email,
    String? phone,
    String? avatarUrl,
    bool? notificationBooking,
    bool? notificationPromo,
    String? currency,
    String? language,
  }) {
    return UserProfile(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      notificationBooking: notificationBooking ?? this.notificationBooking,
      notificationPromo: notificationPromo ?? this.notificationPromo,
      currency: currency ?? this.currency,
      language: language ?? this.language,
    );
  }
}
