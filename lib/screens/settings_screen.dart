import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/profile_provider.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';
import '../widgets/custom_drawer.dart';
import 'help/help_support_screen.dart';
import 'help/about_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final profileProvider = Provider.of<ProfileProvider>(context);
    final canPop = Navigator.canPop(context);

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final cardBg = isDark ? AppColors.darkCard : AppColors.lightCard;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return Scaffold(
      drawer: const CustomDrawer(currentRoute: 'settings'),
      appBar: AppBar(
        title: const Text('Settings'),
        leading: canPop
            ? IconButton(
                icon: const Icon(Icons.arrow_back, size: 22),
                tooltip: 'Back',
                onPressed: () => Navigator.pop(context),
              )
            : IconButton(
                icon: const Icon(Icons.menu),
                tooltip: 'Open Menu',
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
        actions: [
          if (canPop)
            Builder(
              builder: (ctx) => IconButton(
                icon: const Icon(Icons.menu),
                tooltip: 'Menu',
                onPressed: () => Scaffold.of(ctx).openDrawer(),
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Appearance Section
              Text('APPEARANCE', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.0, color: textSecondary)),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: border),
                ),
                child: Column(
                  children: [
                    ListTile(
                      title: Text('Dark Theme', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textPrimary)),
                      trailing: themeProvider.themeMode == ThemeMode.dark
                          ? const Icon(Icons.check_circle, color: AppColors.gold)
                          : null,
                      onTap: () => themeProvider.setThemeMode(ThemeMode.dark),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      title: Text('Light Theme', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textPrimary)),
                      trailing: themeProvider.themeMode == ThemeMode.light
                          ? const Icon(Icons.check_circle, color: AppColors.gold)
                          : null,
                      onTap: () => themeProvider.setThemeMode(ThemeMode.light),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      title: Text('System Default', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textPrimary)),
                      trailing: themeProvider.themeMode == ThemeMode.system
                          ? const Icon(Icons.check_circle, color: AppColors.gold)
                          : null,
                      onTap: () => themeProvider.setThemeMode(ThemeMode.system),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Notifications Section
              Text('NOTIFICATIONS', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.0, color: textSecondary)),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: border),
                ),
                child: Column(
                  children: [
                    SwitchListTile.adaptive(
                      title: Text('Booking Reminders', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textPrimary)),
                      subtitle: Text('Receive notifications for upcoming event dates', style: TextStyle(fontSize: 12, color: textSecondary)),
                      value: profileProvider.notificationBooking,
                      activeTrackColor: AppColors.gold,
                      onChanged: (val) => profileProvider.setNotificationBooking(val),
                    ),
                    const Divider(height: 1),
                    SwitchListTile.adaptive(
                      title: Text('Promotional Offers', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textPrimary)),
                      subtitle: Text('Receive alerts for weekend venue discounts', style: TextStyle(fontSize: 12, color: textSecondary)),
                      value: profileProvider.notificationPromo,
                      activeTrackColor: AppColors.gold,
                      onChanged: (val) => profileProvider.setNotificationPromo(val),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Preferences Section
              Text('PREFERENCES', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.0, color: textSecondary)),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: border),
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.currency_exchange_rounded, color: AppColors.gold, size: 20),
                      title: Text('Currency', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textPrimary)),
                      trailing: Text(profileProvider.currency, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.gold)),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.language_rounded, color: AppColors.gold, size: 20),
                      title: Text('Language', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textPrimary)),
                      trailing: Text(profileProvider.language, style: TextStyle(color: textSecondary, fontSize: 13)),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Support Section
              Text('SUPPORT & ABOUT', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.0, color: textSecondary)),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: border),
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.help_outline, color: AppColors.gold, size: 20),
                      title: Text('Help & FAQ', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textPrimary)),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.gold),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const HelpSupportScreen()),
                        );
                      },
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.info_outline, color: AppColors.gold, size: 20),
                      title: Text('About Venuely', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textPrimary)),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.gold),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const AboutScreen()),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Version
              Center(
                child: Text(
                  AppConstants.appVersion,
                  style: TextStyle(fontSize: 12, color: textSecondary),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
