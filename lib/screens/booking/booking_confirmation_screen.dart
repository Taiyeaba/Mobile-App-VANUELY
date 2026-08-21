import 'package:flutter/material.dart';
import '../../models/booking.dart';
import '../../utils/app_colors.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/secondary_button.dart';
import '../bookings/booking_details_screen.dart';

class BookingConfirmationScreen extends StatelessWidget {
  final Booking booking;

  const BookingConfirmationScreen({
    super.key,
    required this.booking,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final cardBg = isDark ? AppColors.darkCard : AppColors.lightCard;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated Checkmark Circle
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.success, width: 2),
                  ),
                  child: const Center(
                    child: Icon(Icons.check_rounded, color: AppColors.success, size: 54),
                  ),
                ),
                const SizedBox(height: 24),

                Text(
                  'Booking Confirmed!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                    color: textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Your venue reservation has been placed successfully.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: textSecondary),
                ),

                const SizedBox(height: 28),

                // Booking Summary Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                  ),
                  child: Column(
                    children: [
                      Text(
                        booking.venueName,
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: textPrimary),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      const Divider(),
                      const SizedBox(height: 12),
                      _detailRow(context, 'Booking ID', booking.id, isGold: true),
                      _detailRow(context, 'Event Type', booking.eventType),
                      _detailRow(context, 'Date', booking.date),
                      _detailRow(context, 'Time Slot', booking.timeSlot),
                      _detailRow(context, 'Guests', '${booking.guestCount} Person(s)'),
                      _detailRow(context, 'Total Rate', '৳${booking.totalPrice.toStringAsFixed(0)}'),
                      _detailRow(context, '15% Deposit Paid', '৳${booking.depositPaid.toStringAsFixed(0)}', isBold: true, isGold: true),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Action Buttons
                PrimaryButton(
                  label: 'View Booking Details',
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => BookingDetailsScreen(booking: booking)),
                    );
                  },
                ),
                const SizedBox(height: 12),
                SecondaryButton(
                  label: 'Back to Home',
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(context, 'home', (route) => false);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _detailRow(BuildContext context, String label, String value, {bool isGold = false, bool isBold = false}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final labelColor = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final valueColor = isGold
        ? AppColors.gold
        : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 13, color: labelColor)),
          Text(
            value,
            style: TextStyle(
              fontSize: isBold ? 14 : 13,
              fontWeight: isBold || isGold ? FontWeight.bold : FontWeight.w600,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}
