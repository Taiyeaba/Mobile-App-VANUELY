import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final cardBg = isDark ? AppColors.darkCard : AppColors.lightCard;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    final faqs = [
      {'q': 'How do I reserve an event space?', 'a': 'Select your desired venue from Discover, tap Book Now, choose your event type, date, time slot, guest count, and confirm.'},
      {'q': 'Is there a deposit fee required?', 'a': 'Yes, a standard 15% advance deposit secures your reservation date.'},
      {'q': 'Can I cancel or reschedule a booking?', 'a': 'Yes, you can cancel your booking directly from My Bookings screen or contact host support.'},
      {'q': 'Are all venues verified?', 'a': 'All listed palaces, hotels, and resorts are 100% verified for quality, safety, and acoustic standards.'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & FAQ'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('FREQUENTLY ASKED QUESTIONS', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.0, color: textSecondary)),
              const SizedBox(height: 12),
              ...faqs.map(
                (item) => Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item['q']!, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: textPrimary)),
                      const SizedBox(height: 6),
                      Text(item['a']!, style: TextStyle(fontSize: 13, color: textSecondary, height: 1.4)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
