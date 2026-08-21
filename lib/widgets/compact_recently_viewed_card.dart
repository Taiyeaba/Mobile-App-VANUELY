import 'package:flutter/material.dart';
import '../models/venue.dart';
import '../utils/app_colors.dart';
import '../screens/venue_details_screen.dart';

class CompactRecentlyViewedCard extends StatelessWidget {
  final Venue venue;

  const CompactRecentlyViewedCard({
    super.key,
    required this.venue,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => VenueDetailsScreen(venue: venue)),
        );
      },
      child: Container(
        width: 190,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.lightCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Compact Image Thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                children: [
                  Image.network(
                    venue.imageUrls.first,
                    height: 95,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    top: 6,
                    right: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.star_rounded, color: AppColors.gold, size: 12),
                          const SizedBox(width: 2),
                          Text(
                            '${venue.rating}',
                            style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            Text(
              venue.name,
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: textPrimary),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),

            Row(
              children: [
                const Icon(Icons.location_on_outlined, color: AppColors.gold, size: 12),
                const SizedBox(width: 2),
                Expanded(
                  child: Text(
                    venue.location,
                    style: TextStyle(fontSize: 11, color: textSecondary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),

            Text(
              '৳${venue.pricePerDay.toStringAsFixed(0)}/day',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.gold),
            ),
          ],
        ),
      ),
    );
  }
}
