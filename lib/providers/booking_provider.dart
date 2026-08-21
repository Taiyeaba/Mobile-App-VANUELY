import 'package:flutter/material.dart';
import '../models/booking.dart';

class BookingProvider extends ChangeNotifier {
  final List<Booking> _bookings = [
    Booking(
      id: 'VN-2026-001',
      venueId: 'v1',
      venueName: 'The Grand Garden',
      venueImage: 'https://images.unsplash.com/photo-1519167758481-83f550bb49b3?auto=format&fit=crop&w=1200&q=85',
      eventType: 'Wedding',
      date: '20 August 2026',
      timeSlot: '06:00 PM',
      guestCount: 250,
      clientName: 'Taiyeaba Shams',
      clientEmail: 'taiyeaba.shams@example.com',
      clientPhone: '+880 1700-000000',
      specialRequest: 'Red carpet stage entrance and LED ambient floral arch.',
      totalPrice: 185000.0,
      depositPaid: 27750.0,
      status: 'Confirmed',
    ),
    Booking(
      id: 'VN-2026-002',
      venueId: 'v3',
      venueName: 'Skyline Rooftop',
      venueImage: 'https://images.unsplash.com/photo-1533105079780-92b9be482077?auto=format&fit=crop&w=1200&q=85',
      eventType: 'Birthday',
      date: '05 July 2026',
      timeSlot: '08:00 PM',
      guestCount: 120,
      clientName: 'Taiyeaba Shams',
      clientEmail: 'taiyeaba.shams@example.com',
      clientPhone: '+880 1700-000000',
      totalPrice: 65000.0,
      depositPaid: 65000.0,
      status: 'Completed',
    ),
  ];

  List<Booking> get bookings => _bookings;

  List<Booking> get upcomingBookings {
    return _bookings.where((b) => b.status == 'Confirmed').toList();
  }

  List<Booking> get completedBookings {
    return _bookings.where((b) => b.status == 'Completed').toList();
  }

  List<Booking> get cancelledBookings {
    return _bookings.where((b) => b.status == 'Cancelled').toList();
  }

  Booking? getBookingById(String id) {
    try {
      return _bookings.firstWhere((b) => b.id == id);
    } catch (_) {
      return null;
    }
  }

  void addBooking(Booking booking) {
    _bookings.insert(0, booking);
    notifyListeners();
  }

  void cancelBooking(String bookingId) {
    final index = _bookings.indexWhere((b) => b.id == bookingId);
    if (index != -1) {
      _bookings[index] = _bookings[index].copyWith(status: 'Cancelled');
      notifyListeners();
    }
  }

  void completeBooking(String bookingId) {
    final index = _bookings.indexWhere((b) => b.id == bookingId);
    if (index != -1) {
      _bookings[index] = _bookings[index].copyWith(status: 'Completed');
      notifyListeners();
    }
  }
}
