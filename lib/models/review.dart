class Review {
  final String id;
  final String venueId;
  final String reviewerName;
  final String reviewerRole;
  final double rating;
  final String date;
  final String comment;
  final String avatarUrl;
  final bool isVerified;

  const Review({
    required this.id,
    required this.venueId,
    required this.reviewerName,
    this.reviewerRole = 'Verified Guest',
    required this.rating,
    required this.date,
    required this.comment,
    required this.avatarUrl,
    this.isVerified = true,
  });

  String get userName => reviewerName;
  String get userAvatar => avatarUrl;

  Map<String, dynamic> toJson() => {
        'id': id,
        'venueId': venueId,
        'reviewerName': reviewerName,
        'reviewerRole': reviewerRole,
        'rating': rating,
        'date': date,
        'comment': comment,
        'avatarUrl': avatarUrl,
        'isVerified': isVerified,
      };

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        id: json['id'],
        venueId: json['venueId'],
        reviewerName: json['reviewerName'],
        reviewerRole: json['reviewerRole'] ?? 'Verified Guest',
        rating: (json['rating'] as num).toDouble(),
        date: json['date'],
        comment: json['comment'],
        avatarUrl: json['avatarUrl'],
        isVerified: json['isVerified'] ?? true,
      );
}

typedef ReviewModel = Review;
