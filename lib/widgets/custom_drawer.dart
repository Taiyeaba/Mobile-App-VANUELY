import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../utils/app_colors.dart';
import '../screens/venue_comparison_screen.dart';

class CustomDrawer extends StatelessWidget {
  final String currentRoute;

  const CustomDrawer({
    super.key,
    required this.currentRoute,
  });

  void _navigateTo(BuildContext context, String routeName) {
    Navigator.pop(context); // Auto-close drawer
    if (routeName != currentRoute) {
      if (routeName == 'home') {
        Navigator.pushNamedAndRemoveUntil(context, 'home', (route) => false);
      } else {
        Navigator.pushNamed(context, routeName);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeProvider = Provider.of<ThemeProvider>(context);

    final bg = isDark ? AppColors.darkCard : AppColors.lightCard;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return Drawer(
      width: 300,
      backgroundColor: bg,
      elevation: 16,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(28)),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Drawer Header
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.gold.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.gold, width: 1.5),
                    ),
                    child: const Center(
                      child: Icon(Icons.diamond_outlined, color: AppColors.gold, size: 24),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'VENUELY',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2.0,
                          color: AppColors.gold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Premium Venue Booking',
                        style: TextStyle(
                          fontSize: 12,
                          color: textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

            // Navigation Items
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                children: [
                  _buildNavItem(
                    context: context,
                    icon: Icons.explore_outlined,
                    activeIcon: Icons.explore,
                    label: 'Discover',
                    isSelected: currentRoute == 'home',
                    onTap: () => _navigateTo(context, 'home'),
                  ),
                  _buildNavItem(
                    context: context,
                    icon: Icons.compare_arrows_rounded,
                    activeIcon: Icons.compare_arrows,
                    label: 'Compare Venues',
                    isSelected: currentRoute == 'compare',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const VenueComparisonScreen()),
                      );
                    },
                  ),
                  _buildNavItem(
                    context: context,
                    icon: Icons.favorite_outline,
                    activeIcon: Icons.favorite,
                    label: 'Saved Favorites',
                    isSelected: currentRoute == 'favorites',
                    onTap: () => _navigateTo(context, 'favorites'),
                  ),
                  _buildNavItem(
                    context: context,
                    icon: Icons.confirmation_number_outlined,
                    activeIcon: Icons.confirmation_number,
                    label: 'My Bookings',
                    isSelected: currentRoute == 'bookings',
                    onTap: () => _navigateTo(context, 'bookings'),
                  ),
                  _buildNavItem(
                    context: context,
                    icon: Icons.person_outline,
                    activeIcon: Icons.person,
                    label: 'Profile',
                    isSelected: currentRoute == 'profile',
                    onTap: () => _navigateTo(context, 'profile'),
                  ),
                  _buildNavItem(
                    context: context,
                    icon: Icons.settings_outlined,
                    activeIcon: Icons.settings,
                    label: 'Settings',
                    isSelected: currentRoute == 'settings',
                    onTap: () => _navigateTo(context, 'settings'),
                  ),

                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Divider(height: 1),
                  ),

                  // Appearance Toggle Item
                  ListTile(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    leading: Icon(
                      themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                      color: AppColors.gold,
                      size: 22,
                    ),
                    title: Text(
                      'Appearance',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: textPrimary,
                      ),
                    ),
                    trailing: Switch.adaptive(
                      value: themeProvider.isDarkMode,
                      activeTrackColor: AppColors.gold,
                      onChanged: (val) {
                        themeProvider.toggleTheme(val);
                      },
                    ),
                  ),

                  _buildNavItem(
                    context: context,
                    icon: Icons.help_outline,
                    activeIcon: Icons.help,
                    label: 'Help & Support',
                    isSelected: currentRoute == 'help',
                    onTap: () => _navigateTo(context, 'help'),
                  ),

                  _buildNavItem(
                    context: context,
                    icon: Icons.info_outline,
                    activeIcon: Icons.info,
                    label: 'About Venuely',
                    isSelected: currentRoute == 'about',
                    onTap: () => _navigateTo(context, 'about'),
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

            // Logout Footer
            Padding(
              padding: const EdgeInsets.all(14),
              child: ListTile(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                leading: const Icon(Icons.logout, color: AppColors.error, size: 22),
                title: const Text(
                  'Logout',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.error,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamedAndRemoveUntil(context, 'login', (route) => false);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeBg = AppColors.gold.withValues(alpha: 0.15);
    const activeColor = AppColors.gold;
    final inactiveColor = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        tileColor: isSelected ? activeBg : Colors.transparent,
        leading: Icon(
          isSelected ? activeIcon : icon,
          color: isSelected ? activeColor : inactiveColor,
          size: 22,
        ),
        title: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? activeColor : inactiveColor,
          ),
        ),
        trailing: isSelected
            ? Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: AppColors.gold,
                  shape: BoxShape.circle,
                ),
              )
            : null,
        onTap: onTap,
      ),
    );
  }
}
