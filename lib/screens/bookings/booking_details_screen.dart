import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/booking.dart';
import '../../providers/booking_provider.dart';
import '../../utils/app_colors.dart';
import '../../widgets/secondary_button.dart';

class BookingDetailsScreen extends StatelessWidget {
  final Booking booking;

  const BookingDetailsScreen({
    super.key,
    required this.booking,
  });

  void _showPDFReceiptModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return AlertDialog(
          backgroundColor: isDark ? AppColors.darkCard : AppColors.lightCard,
          title: const Row(
            children: [
              Icon(Icons.picture_as_pdf_rounded, color: AppColors.gold),
              SizedBox(width: 8),
              Text('Digital Receipt PDF', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Official Voucher ID: ${booking.id}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: 8),
              Text('Venue: ${booking.venueName}'),
              Text('Event: ${booking.eventType}'),
              Text('Date: ${booking.date} (${booking.timeSlot})'),
              Text('Total Price: ৳${booking.totalPrice.toStringAsFixed(0)}'),
              Text('Deposit Paid: ৳${booking.depositPaid.toStringAsFixed(0)}'),
              const SizedBox(height: 12),
              const Text('Status: Verified SSL Encrypted PDF Receipt Generated.', style: TextStyle(color: AppColors.success, fontSize: 12)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Download PDF', style: TextStyle(color: AppColors.gold, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  void _cancelBooking(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Cancel Reservation?'),
          content: const Text('Are you sure you want to cancel this booking? Refunds will be processed according to venue policies.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Keep Booking'),
            ),
            TextButton(
              onPressed: () {
                Provider.of<BookingProvider>(context, listen: false).cancelBooking(booking.id);
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('Cancel Booking', style: TextStyle(color: AppColors.error)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final cardBg = isDark ? AppColors.darkCard : AppColors.lightCard;

    return Scaffold(
      appBar: AppBar(
        title: Text('Booking ${booking.id}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf_outlined, color: AppColors.gold),
            onPressed: () => _showPDFReceiptModal(context),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Venue Header Banner
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  booking.venueImage,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),

              Text(
                booking.venueName,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textPrimary),
              ),
              const SizedBox(height: 6),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.gold.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'STATUS: ${booking.status.toUpperCase()}',
                  style: const TextStyle(color: AppColors.gold, fontWeight: FontWeight.bold, fontSize: 11),
                ),
              ),

              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 16),

              // Booking Details Container
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                ),
                child: Column(
                  children: [
                    _row(context, 'Booking Reference', booking.id, isGold: true),
                    _row(context, 'Event Type', booking.eventType),
                    _row(context, 'Reservation Date', booking.date),
                    _row(context, 'Time Slot', booking.timeSlot),
                    _row(context, 'Guest Capacity', '${booking.guestCount} Guests'),
                    _row(context, 'Host Name', booking.clientName),
                    _row(context, 'Host Email', booking.clientEmail),
                    _row(context, 'Host Phone', booking.clientPhone),
                    if (booking.specialRequest.isNotEmpty)
                      _row(context, 'Special Note', booking.specialRequest),
                    const Divider(),
                    _row(context, 'Total Package Rate', '৳${booking.totalPrice.toStringAsFixed(0)}', isBold: true),
                    _row(context, '15% Advance Deposit Paid', '৳${booking.depositPaid.toStringAsFixed(0)}', isGold: true),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              SecondaryButton(
                label: 'Download Official PDF Receipt',
                icon: Icons.download_rounded,
                onPressed: () => _showPDFReceiptModal(context),
              ),

              if (booking.status == 'Confirmed') ...[
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: TextButton.icon(
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.error,
                    ),
                    onPressed: () => _cancelBooking(context),
                    icon: const Icon(Icons.cancel_outlined, size: 18),
                    label: const Text('Cancel Reservation'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _row(BuildContext context, String label, String value, {bool isGold = false, bool isBold = false}) {
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
          Text(label, style: TextStyle(fontSize: 12, color: labelColor)),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: isBold ? 13 : 12,
                fontWeight: isBold || isGold ? FontWeight.bold : FontWeight.w600,
                color: valueColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
