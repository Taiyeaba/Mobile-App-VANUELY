class VenuePackage {
  final String name;
  final double price;
  final List<String> features;

  const VenuePackage({
    required this.name,
    required this.price,
    required this.features,
  });
}

class Venue {
  final String id;
  final String name;
  final String category; // Wedding, Birthday, Corporate, Party, Conference, Outdoor
  final String location;
  final double pricePerDay;
  final int guestCapacity;
  final double rating;
  final int reviewsCount;
  final List<String> imageUrls;
  final String description;
  final List<String> facilities;
  final List<String> suitableFor;
  final List<String> availableSlots;
  final List<VenuePackage> packages;
  final String tagline;
  final bool isFeatured;
  final bool isPopular;

  const Venue({
    required this.id,
    required this.name,
    required this.category,
    required this.location,
    required this.pricePerDay,
    required this.guestCapacity,
    required this.rating,
    required this.reviewsCount,
    required this.imageUrls,
    required this.description,
    required this.facilities,
    required this.suitableFor,
    required this.availableSlots,
    required this.packages,
    this.tagline = 'Luxury Event Space',
    this.isFeatured = false,
    this.isPopular = false,
  });
}
