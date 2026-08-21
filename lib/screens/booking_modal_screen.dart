import 'package:flutter/material.dart';
import '../models/venue.dart';
import 'booking/booking_flow_screen.dart';

class BookingModalScreen extends StatelessWidget {
  final Venue venue;

  const BookingModalScreen({
    super.key,
    required this.venue,
  });

  @override
  Widget build(BuildContext context) {
    return BookingFlowScreen(venue: venue);
  }
}
