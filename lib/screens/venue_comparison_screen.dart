import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/venue_provider.dart';
import '../utils/app_colors.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/primary_button.dart';

class VenueComparisonScreen extends StatelessWidget {
  const VenueComparisonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final venueProvider = Provider.of<VenueProvider>(context);
    final comparisonVenues = venueProvider.comparisonVenues;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final cardBg = isDark ? AppColors.darkCard : AppColors.lightCard;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Compare Venues'),
        actions: [
          if (comparisonVenues.isNotEmpty)
            TextButton(
              onPressed: () => venueProvider.clearComparison(),
              child: const Text('Clear All', style: TextStyle(color: AppColors.gold)),
            ),
        ],
      ),
      body: SafeArea(
        child: comparisonVenues.isEmpty
            ? EmptyStateWidget(
                icon: Icons.compare_arrows_rounded,
                title: 'No Venues Selected',
                description: 'Add up to 3 venues to compare rates, capacity, facilities and ratings side-by-side.',
                buttonText: 'Browse Venues',
                onButtonPressed: () => Navigator.pop(context),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Comparing ${comparisonVenues.length} Venue(s)',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textPrimary),
                    ),
                    const SizedBox(height: 16),

                    // Side by side Comparison Cards Grid
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: comparisonVenues.map((venue) {
                          return Container(
                            width: 220,
                            margin: const EdgeInsets.only(right: 14),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: cardBg,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: border),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(14),
                                      child: Image.network(
                                        venue.imageUrls.first,
                                        height: 120,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Positioned(
                                      top: 4,
                                      right: 4,
                                      child: CircleAvatar(
                                        radius: 14,
                                        backgroundColor: Colors.black.withValues(alpha: 0.6),
                                        child: IconButton(
                                          padding: EdgeInsets.zero,
                                          icon: const Icon(Icons.close, color: Colors.white, size: 14),
                                          onPressed: () => venueProvider.toggleComparison(venue.id),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  venue.name,
                                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: textPrimary),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  venue.location,
                                  style: TextStyle(fontSize: 11, color: textSecondary),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 12),
                                const Divider(),

                                _compRow('Price per Day', '৳${venue.pricePerDay.toStringAsFixed(0)}', isGold: true, textPrimary: textPrimary, textSecondary: textSecondary),
                                _compRow('Guest Capacity', '${venue.guestCapacity} Guests', textPrimary: textPrimary, textSecondary: textSecondary),
                                _compRow('Rating', '★ ${venue.rating} (${venue.reviewsCount})', textPrimary: textPrimary, textSecondary: textSecondary),
                                _compRow('Category', venue.category, textPrimary: textPrimary, textSecondary: textSecondary),
                                _compRow('Valet Parking', venue.facilities.contains('Valet Parking') ? 'Available' : 'N/A', textPrimary: textPrimary, textSecondary: textSecondary),
                                _compRow('Aircon', venue.facilities.contains('Central AC') ? 'Central AC' : 'Standard', textPrimary: textPrimary, textSecondary: textSecondary),
                                const SizedBox(height: 12),

                                PrimaryButton(
                                  label: 'Book Venue',
                                  height: 38,
                                  onPressed: () {
                                    Navigator.pushNamed(context, 'home');
                                  },
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _compRow(String label, String value, {bool isGold = false, required Color textPrimary, required Color textSecondary}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 10, color: textSecondary)),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isGold ? AppColors.gold : textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
