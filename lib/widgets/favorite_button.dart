import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/favorite_provider.dart';
import '../utils/app_colors.dart';

class FavoriteButton extends StatelessWidget {
  final String venueId;
  final double size;
  final Color? activeColor;

  const FavoriteButton({
    super.key,
    required this.venueId,
    this.size = 20,
    this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    final favoriteProvider = Provider.of<FavoriteProvider>(context);
    final isFav = favoriteProvider.isFavorite(venueId);

    return GestureDetector(
      onTap: () {
        favoriteProvider.toggleFavorite(venueId);
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.4),
          shape: BoxShape.circle,
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: Icon(
            isFav ? Icons.favorite : Icons.favorite_border,
            key: ValueKey(isFav),
            color: isFav ? (activeColor ?? AppColors.error) : Colors.white,
            size: size,
          ),
        ),
      ),
    );
  }
}
