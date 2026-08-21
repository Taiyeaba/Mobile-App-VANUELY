import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/venue.dart';
import '../models/review.dart';
import '../providers/venue_provider.dart';
import '../providers/review_provider.dart';
import '../providers/profile_provider.dart';
import '../utils/app_colors.dart';
import '../widgets/favorite_button.dart';
import '../widgets/rating_widget.dart';
import '../widgets/facility_card.dart';
import '../widgets/package_card.dart';
import '../widgets/primary_button.dart';
import 'booking/booking_flow_screen.dart';
import 'fullscreen_gallery_screen.dart';
import 'venue_comparison_screen.dart';

class VenueDetailsScreen extends StatefulWidget {
  final Venue venue;

  const VenueDetailsScreen({
    super.key,
    required this.venue,
  });

  @override
  State<VenueDetailsScreen> createState() => _VenueDetailsScreenState();
}

class _VenueDetailsScreenState extends State<VenueDetailsScreen> {
  int _currentImageIndex = 0;
  int _selectedPackageIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<VenueProvider>(context, listen: false).addToRecentlyViewed(widget.venue.id);
    });
  }

  void _showVirtualTourModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return AlertDialog(
          backgroundColor: isDark ? AppColors.darkCard : AppColors.lightCard,
          title: const Row(
            children: [
              Icon(Icons.threed_rotation, color: AppColors.gold),
              SizedBox(width: 8),
              Text('360° Virtual Tour', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  widget.venue.imageUrls.first,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Interactive 360° Virtual Panorama Viewer initialized in 4K high resolution.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close Tour', style: TextStyle(color: AppColors.gold, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  void _showLocationMapModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return AlertDialog(
          backgroundColor: isDark ? AppColors.darkCard : AppColors.lightCard,
          title: const Row(
            children: [
              Icon(Icons.map_outlined, color: AppColors.gold),
              SizedBox(width: 8),
              Text('Location & Travel Distance', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '📍 ${widget.venue.location}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 12),
              const Text('Est. Distances from Key Dhaka Hubs:'),
              const SizedBox(height: 6),
              const Text('• Gulshan-2 Circle: ~ 3.2 km (8 mins)'),
              const Text('• Uttara Sector 3: ~ 8.5 km (18 mins)'),
              const Text('• Dhanmondi 32: ~ 7.0 km (15 mins)'),
              const Text('• Hazrat Shahjalal Airport: ~ 10.2 km'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close Map', style: TextStyle(color: AppColors.gold, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  void _showWriteReviewModal(BuildContext context) {
    double selectedRating = 5.0;
    final commentController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final isDark = Theme.of(context).brightness == Brightness.dark;
            final bg = isDark ? AppColors.darkCard : AppColors.lightCard;
            final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
            final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

            return Container(
              padding: EdgeInsets.only(
                top: 24,
                left: 24,
                right: 24,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              decoration: BoxDecoration(
                color: bg,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.rate_review_rounded, color: AppColors.gold, size: 22),
                              SizedBox(width: 8),
                              Text('Write a Review', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, size: 20),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                      Text(
                        widget.venue.name,
                        style: TextStyle(fontSize: 13, color: textSecondary),
                      ),
                      const SizedBox(height: 14),
                      const Divider(),
                      const SizedBox(height: 14),

                      // Interactive Star Rating Selector
                      Text('Select Your Rating:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: textPrimary)),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(5, (index) {
                          final starValue = (index + 1).toDouble();
                          final isFilled = starValue <= selectedRating;
                          return IconButton(
                            iconSize: 32,
                            icon: Icon(
                              isFilled ? Icons.star_rounded : Icons.star_border_rounded,
                              color: AppColors.gold,
                            ),
                            onPressed: () {
                              setModalState(() {
                                selectedRating = starValue;
                              });
                            },
                          );
                        }),
                      ),
                      Center(
                        child: Text(
                          '${selectedRating.toInt()} Out of 5 Stars',
                          style: const TextStyle(color: AppColors.gold, fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Review Text Field
                      Text('Your Review:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: textPrimary)),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: commentController,
                        maxLines: 3,
                        maxLength: 250,
                        decoration: InputDecoration(
                          hintText: 'Share your experience with this venue...',
                          hintStyle: TextStyle(fontSize: 13, color: textSecondary),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'Please enter a review text';
                          }
                          if (val.trim().length < 10) {
                            return 'Review must be at least 10 characters long';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      // Submit Review Button
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.gold,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              final profile = Provider.of<ProfileProvider>(context, listen: false);
                              final newReview = Review(
                                id: 'rev-${DateTime.now().millisecondsSinceEpoch}',
                                venueId: widget.venue.id,
                                reviewerName: profile.name,
                                reviewerRole: 'Verified Guest',
                                rating: selectedRating,
                                date: 'Just now',
                                comment: commentController.text.trim(),
                                avatarUrl: profile.avatarUrl,
                                isVerified: true,
                              );

                              Provider.of<ReviewProvider>(context, listen: false).addReview(newReview);
                              Navigator.pop(context);

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('✓ Review submitted successfully!'),
                                  backgroundColor: AppColors.gold,
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            }
                          },
                          icon: const Icon(Icons.send_rounded, color: Colors.black, size: 18),
                          label: const Text(
                            'Submit Review',
                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final venue = widget.venue;
    final venueProvider = Provider.of<VenueProvider>(context);
    final reviewProvider = Provider.of<ReviewProvider>(context);

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    final venueReviews = reviewProvider.getReviewsForVenue(venue.id);
    final avgRating = reviewProvider.getAverageRating(venue.id, venue.rating);
    final totalCount = reviewProvider.getTotalReviewsCount(venue.id, venue.reviewsCount);
    final breakdown = reviewProvider.getRatingBreakdown(venue.id);

    final isInComparison = venueProvider.comparisonIds.contains(venue.id);

    return Scaffold(
      body: Stack(
        children: [
          // Main Scroll Content
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 90),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Image Carousel Stack
                Stack(
                  children: [
                    SizedBox(
                      height: 320,
                      child: PageView.builder(
                        itemCount: venue.imageUrls.length,
                        onPageChanged: (index) {
                          setState(() {
                            _currentImageIndex = index;
                          });
                        },
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => FullscreenGalleryScreen(
                                    imageUrls: venue.imageUrls,
                                    initialIndex: index,
                                  ),
                                ),
                              );
                            },
                            child: Image.network(
                              venue.imageUrls[index],
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                                child: const Icon(Icons.location_city, size: 60, color: AppColors.gold),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    // Top Bar overlay with Back button & Favorite Button
                    Positioned(
                      top: 40,
                      left: 16,
                      right: 16,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.5),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                            ),
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  final added = venueProvider.toggleComparison(venue.id);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        added
                                            ? 'Added to Venue Comparison (${venueProvider.comparisonIds.length}/3)'
                                            : 'Removed from Comparison',
                                      ),
                                      duration: const Duration(seconds: 2),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: isInComparison ? AppColors.gold : Colors.black.withValues(alpha: 0.5),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.compare_arrows_rounded,
                                    color: isInComparison ? Colors.black : Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              FavoriteButton(venueId: venue.id, size: 20),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Page Indicator Chip (1/8)
                    Positioned(
                      bottom: 16,
                      right: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${_currentImageIndex + 1}/${venue.imageUrls.length}',
                          style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),

                    // 360° Virtual Tour & Distance Badges
                    Positioned(
                      bottom: 16,
                      left: 16,
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () => _showVirtualTourModal(context),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppColors.gold,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Row(
                                children: [
                                  Icon(Icons.threed_rotation, color: Colors.black, size: 14),
                                  SizedBox(width: 4),
                                  Text(
                                    '360° Tour',
                                    style: TextStyle(color: Colors.black, fontSize: 11, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // Content Container
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category Tag
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.gold.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppColors.gold, width: 1),
                            ),
                            child: Text(
                              venue.category.toUpperCase(),
                              style: const TextStyle(color: AppColors.gold, fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                          ),

                          if (venueProvider.comparisonIds.isNotEmpty)
                            OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: AppColors.gold),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => const VenueComparisonScreen()),
                                );
                              },
                              icon: const Icon(Icons.compare_arrows_rounded, color: AppColors.gold, size: 16),
                              label: Text(
                                'Compare (${venueProvider.comparisonIds.length})',
                                style: const TextStyle(color: AppColors.gold, fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Name
                      Text(
                        venue.name,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5,
                          color: textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),

                      // Location & Rating
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined, color: AppColors.gold, size: 16),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              venue.location,
                              style: TextStyle(fontSize: 13, color: textSecondary),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          RatingWidget(rating: avgRating, reviewsCount: totalCount),
                        ],
                      ),

                      const SizedBox(height: 20),
                      const Divider(),
                      const SizedBox(height: 16),

                      // Venue Highlights
                      Text(
                        'VENUE HIGHLIGHTS',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 0.5, color: textSecondary),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildHighlightItem(context, Icons.groups_outlined, '${venue.guestCapacity}', 'Guests'),
                          _buildHighlightItem(context, Icons.local_parking_rounded, 'Valet', 'Parking'),
                          _buildHighlightItem(context, Icons.ac_unit_rounded, 'Central AC', 'Climate'),
                          _buildHighlightItem(context, Icons.wifi_rounded, 'Wi-Fi 6', 'High Speed'),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // About Description
                      Text(
                        'ABOUT VENUE',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 0.5, color: textSecondary),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        venue.description,
                        style: TextStyle(fontSize: 14, height: 1.5, color: textPrimary),
                      ),

                      const SizedBox(height: 24),

                      // Facilities
                      Text(
                        'FACILITIES & AMENITIES',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 0.5, color: textSecondary),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: venue.facilities.map((f) => FacilityCard(facilityName: f)).toList(),
                      ),

                      const SizedBox(height: 24),

                      // Suitable For
                      Text(
                        'SUITABLE FOR',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 0.5, color: textSecondary),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: venue.suitableFor.map(
                          (tag) => Chip(
                            label: Text(tag, style: TextStyle(fontSize: 12, color: textPrimary)),
                            backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                            side: const BorderSide(color: AppColors.darkBorder),
                          ),
                        ).toList(),
                      ),

                      const SizedBox(height: 24),

                      // Pricing & Packages
                      Text(
                        'PACKAGES & PRICING',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 0.5, color: textSecondary),
                      ),
                      const SizedBox(height: 12),
                      ...List.generate(
                        venue.packages.length,
                        (index) => PackageCard(
                          package: venue.packages[index],
                          isSelected: _selectedPackageIndex == index,
                          onTap: () {
                            setState(() {
                              _selectedPackageIndex = index;
                            });
                          },
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Gallery Grid Preview
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'GALLERY PREVIEW',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 0.5, color: textSecondary),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => FullscreenGalleryScreen(
                                    imageUrls: venue.imageUrls,
                                    initialIndex: 0,
                                  ),
                                ),
                              );
                            },
                            child: const Text('Fullscreen HD', style: TextStyle(color: AppColors.gold, fontSize: 12)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                        itemCount: venue.imageUrls.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => FullscreenGalleryScreen(
                                    imageUrls: venue.imageUrls,
                                    initialIndex: index,
                                  ),
                                ),
                              );
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                venue.imageUrls[index],
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 28),

                      // ==========================================
                      // REVIEWS & RATINGS SECTION
                      // ==========================================
                      Text(
                        'REVIEWS & RATINGS',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 0.5, color: textSecondary),
                      ),
                      const SizedBox(height: 12),

                      // Rating Summary & Breakdown Card
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkCard : AppColors.lightCard,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                        ),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Left Big Rating Number
                                Column(
                                  children: [
                                    Text(
                                      '$avgRating',
                                      style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: textPrimary),
                                    ),
                                    Row(
                                      children: List.generate(
                                        5,
                                        (i) => Icon(
                                          i < avgRating.floor() ? Icons.star_rounded : Icons.star_half_rounded,
                                          color: AppColors.gold,
                                          size: 16,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '$totalCount Reviews',
                                      style: TextStyle(fontSize: 11, color: textSecondary),
                                    ),
                                  ],
                                ),

                                const SizedBox(width: 16),
                                Container(height: 60, width: 1, color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                                const SizedBox(width: 16),

                                // Right Breakdown Progress Bars
                                Expanded(
                                  child: Column(
                                    children: [5, 4, 3, 2, 1].map((star) {
                                      final percent = breakdown[star] ?? 0.0;
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 2),
                                        child: Row(
                                          children: [
                                            Text('$star★', style: TextStyle(fontSize: 10, color: textSecondary)),
                                            const SizedBox(width: 6),
                                            Expanded(
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(4),
                                                child: LinearProgressIndicator(
                                                  value: percent,
                                                  backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                                                  color: AppColors.gold,
                                                  minHeight: 6,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Text('${(percent * 100).toInt()}%', style: TextStyle(fontSize: 10, color: textSecondary)),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),
                            const Divider(),
                            const SizedBox(height: 12),

                            // Write a Review Button
                            SizedBox(
                              width: double.infinity,
                              height: 44,
                              child: OutlinedButton.icon(
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: AppColors.gold, width: 1.5),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                ),
                                onPressed: () => _showWriteReviewModal(context),
                                icon: const Icon(Icons.edit_note_rounded, color: AppColors.gold, size: 20),
                                label: const Text(
                                  'Write a Review',
                                  style: TextStyle(color: AppColors.gold, fontWeight: FontWeight.bold, fontSize: 13),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // User Reviews List for this Venue
                      if (venueReviews.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Text(
                            'No reviews yet for this venue. Be the first to share your experience!',
                            style: TextStyle(fontSize: 13, color: textSecondary, fontStyle: FontStyle.italic),
                          ),
                        )
                      else
                        ...venueReviews.map((rev) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.darkCard : AppColors.lightCard,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 18,
                                      backgroundImage: NetworkImage(rev.userAvatar),
                                      backgroundColor: AppColors.gold.withValues(alpha: 0.2),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                rev.userName,
                                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textPrimary),
                                              ),
                                              if (rev.isVerified) ...[
                                                const SizedBox(width: 6),
                                                Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                  decoration: BoxDecoration(
                                                    color: AppColors.success.withValues(alpha: 0.15),
                                                    borderRadius: BorderRadius.circular(6),
                                                  ),
                                                  child: const Row(
                                                    children: [
                                                      Icon(Icons.verified_rounded, color: AppColors.success, size: 10),
                                                      SizedBox(width: 2),
                                                      Text('Verified', style: TextStyle(color: AppColors.success, fontSize: 9, fontWeight: FontWeight.bold)),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ],
                                          ),
                                          const SizedBox(height: 2),
                                          Row(
                                            children: [
                                              Row(
                                                children: List.generate(
                                                  5,
                                                  (i) => Icon(
                                                    i < rev.rating ? Icons.star_rounded : Icons.star_border_rounded,
                                                    color: AppColors.gold,
                                                    size: 12,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Text(rev.date, style: TextStyle(fontSize: 10, color: textSecondary)),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  rev.comment,
                                  style: TextStyle(fontSize: 13, height: 1.4, color: textPrimary),
                                ),
                              ],
                            ),
                          );
                        }),

                      const SizedBox(height: 24),

                      // Location Card Action
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkCard : AppColors.lightCard,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.map, color: AppColors.gold, size: 28),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Location & Travel Map', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: textPrimary)),
                                  Text(venue.location, style: TextStyle(fontSize: 12, color: textSecondary)),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.navigation_outlined, color: AppColors.gold),
                              onPressed: () => _showLocationMapModal(context),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Sticky Mobile Bottom Action Bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : AppColors.lightCard,
                border: Border(top: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 10,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Starting Rate', style: TextStyle(fontSize: 11, color: textSecondary)),
                      Text(
                        '৳${venue.pricePerDay.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.gold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: PrimaryButton(
                      label: 'Book Now',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => BookingFlowScreen(venue: venue)),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHighlightItem(BuildContext context, IconData icon, String title, String subtitle) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkCard : AppColors.lightCard;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return Container(
      width: 75,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.gold, size: 20),
          const SizedBox(height: 6),
          Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: textPrimary), maxLines: 1),
          Text(subtitle, style: TextStyle(fontSize: 10, color: textSecondary)),
        ],
      ),
    );
  }
}
