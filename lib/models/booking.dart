class Booking {
  final String id;
  final String venueId;
  final String venueName;
  final String venueImage;
  final String eventType;
  final String date;
  final String timeSlot;
  final int guestCount;
  final String clientName;
  final String clientEmail;
  final String clientPhone;
  final String specialRequest;
  final double totalPrice;
  final double depositPaid;
  final String status; // 'Confirmed', 'Completed', 'Cancelled'
  final DateTime createdAt;

  Booking({
    required this.id,
    required this.venueId,
    required this.venueName,
    required this.venueImage,
    required this.eventType,
    required this.date,
    required this.timeSlot,
    required this.guestCount,
    required this.clientName,
    required this.clientEmail,
    required this.clientPhone,
    this.specialRequest = '',
    required this.totalPrice,
    this.depositPaid = 0.0,
    this.status = 'Confirmed',
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Booking copyWith({
    String? status,
  }) {
    return Booking(
      id: id,
      venueId: venueId,
      venueName: venueName,
      venueImage: venueImage,
      eventType: eventType,
      date: date,
      timeSlot: timeSlot,
      guestCount: guestCount,
      clientName: clientName,
      clientEmail: clientEmail,
      clientPhone: clientPhone,
      specialRequest: specialRequest,
      totalPrice: totalPrice,
      depositPaid: depositPaid,
      status: status ?? this.status,
      createdAt: createdAt,
    );
  }
}
