import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class FacilityCard extends StatelessWidget {
  final String facilityName;

  const FacilityCard({
    super.key,
    required this.facilityName,
  });

  IconData _getIcon(String name) {
    switch (name.toLowerCase()) {
      case 'parking':
        return Icons.local_parking_rounded;
      case 'wi-fi':
      case 'wifi':
        return Icons.wifi_rounded;
      case 'catering':
        return Icons.restaurant_rounded;
      case 'sound system':
        return Icons.speaker_group_rounded;
      case 'lighting':
        return Icons.lightbulb_outline_rounded;
      case 'tables & chairs':
        return Icons.chair_rounded;
      case 'air conditioning':
      case 'ac':
        return Icons.ac_unit_rounded;
      case 'restrooms':
        return Icons.wc_rounded;
      case 'stage':
        return Icons.theater_comedy_rounded;
      default:
        return Icons.check_circle_outline_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkCard : AppColors.lightCard;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_getIcon(facilityName), size: 18, color: AppColors.gold),
          const SizedBox(width: 8),
          Text(
            facilityName,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
