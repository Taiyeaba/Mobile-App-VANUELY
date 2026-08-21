import 'package:flutter/material.dart';

class FacilityBadge extends StatelessWidget {
  final String name;

  const FacilityBadge({super.key, required this.name});

  IconData _getIcon(String facility) {
    switch (facility.toLowerCase()) {
      case 'wifi':
        return Icons.wifi;
      case 'ac':
        return Icons.ac_unit;
      case 'catering':
        return Icons.restaurant;
      case 'parking':
        return Icons.local_parking;
      case 'sound system':
        return Icons.speaker;
      case 'stage':
        return Icons.theater_comedy;
      case 'pool':
        return Icons.pool;
      case 'bar counter':
        return Icons.local_bar;
      case 'projector':
        return Icons.videocam;
      case 'vip suite':
        return Icons.king_bed;
      default:
        return Icons.check_circle_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF7C3AED).withValues(alpha: 0.2) : const Color(0xFF7C3AED).withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFF7C3AED).withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getIcon(name),
            size: 16,
            color: const Color(0xFF7C3AED),
          ),
          const SizedBox(width: 6),
          Text(
            name,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color(0xFF7C3AED),
            ),
          ),
        ],
      ),
    );
  }
}
