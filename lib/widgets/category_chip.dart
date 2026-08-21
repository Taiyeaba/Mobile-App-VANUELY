import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class CategoryChip extends StatelessWidget {
  final String category;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryChip({
    super.key,
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  String _getEmoji(String cat) {
    switch (cat.toLowerCase()) {
      case 'wedding':
        return '💍';
      case 'birthday':
        return '🎂';
      case 'corporate':
        return '💼';
      case 'party':
        return '🎉';
      case 'conference':
        return '🎤';
      case 'engagement':
        return '💎';
      case 'outdoor':
        return '🌿';
      default:
        return '✨';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final emoji = _getEmoji(category);

    final bg = isSelected
        ? AppColors.gold
        : (isDark ? AppColors.darkCard : AppColors.lightCard);

    final textColor = isSelected
        ? Colors.black
        : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary);

    final borderColor = isSelected
        ? AppColors.gold
        : (isDark ? AppColors.darkBorder : AppColors.lightBorder);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: borderColor, width: 1),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.gold.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 14)),
            const SizedBox(width: 6),
            Text(
              category,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
