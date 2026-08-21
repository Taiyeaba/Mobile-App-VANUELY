import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../utils/app_colors.dart';
import '../screens/notifications_screen.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showHamburger;
  final bool showThemeToggle;
  final List<Widget>? actions;

  const CustomAppBar({
    super.key,
    this.title = 'VENUELY',
    this.showHamburger = true,
    this.showThemeToggle = true,
    this.actions,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final canPop = Navigator.canPop(context);

    Widget? leadingWidget;
    if (canPop) {
      leadingWidget = IconButton(
        icon: const Icon(Icons.arrow_back, size: 22),
        tooltip: 'Back',
        onPressed: () => Navigator.pop(context),
      );
    } else if (showHamburger) {
      leadingWidget = IconButton(
        icon: const Icon(Icons.menu, size: 24),
        tooltip: 'Open Menu',
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
      );
    }

    return AppBar(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      leading: leadingWidget,
      title: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          letterSpacing: title == 'VENUELY' ? 2.0 : -0.5,
          color: title == 'VENUELY' ? AppColors.gold : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
        ),
      ),
      actions: [
        if (actions != null) ...actions!,

        // Notification Bell Icon with Badge
        Stack(
          alignment: Alignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.notifications_none_rounded, size: 22, color: AppColors.gold),
              tooltip: 'Notifications',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const NotificationsScreen()),
                );
              },
            ),
            Positioned(
              top: 12,
              right: 12,
              child: Container(
                width: 7,
                height: 7,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),

        if (showThemeToggle)
          IconButton(
            icon: Icon(
              themeProvider.isDarkMode ? Icons.wb_sunny_outlined : Icons.nightlight_round_outlined,
              size: 20,
              color: AppColors.gold,
            ),
            tooltip: 'Toggle Theme',
            onPressed: () {
              themeProvider.toggleTheme(!themeProvider.isDarkMode);
            },
          ),
        const SizedBox(width: 8),
      ],
    );
  }
}
