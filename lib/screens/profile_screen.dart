import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/profile_provider.dart';
import '../utils/app_colors.dart';
import '../widgets/custom_drawer.dart';
import 'profile/edit_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);
    final user = profileProvider.user;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final canPop = Navigator.canPop(context);

    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final cardBg = isDark ? AppColors.darkCard : AppColors.lightCard;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return Scaffold(
      drawer: const CustomDrawer(currentRoute: 'profile'),
      appBar: AppBar(
        title: const Text('My Profile'),
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
            children: [
              // User Avatar Card Header
              Center(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 46,
                          backgroundImage: NetworkImage(user.avatarUrl),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: AppColors.gold,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.edit, color: Colors.black, size: 14),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      user.name,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      user.email,
                      style: TextStyle(fontSize: 13, color: textSecondary),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.gold.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        'VIP GOLD MEMBER',
                        style: TextStyle(color: AppColors.gold, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Menu Cards Options
              Container(
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: border),
                ),
                child: Column(
                  children: [
                    _buildOptionTile(
                      context,
                      icon: Icons.person_outline,
                      title: 'Edit Profile Information',
                      subtitle: 'Name, email, phone number',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const EditProfileScreen()),
                        );
                      },
                    ),
                    const Divider(height: 1),
                    _buildOptionTile(
                      context,
                      icon: Icons.confirmation_number_outlined,
                      title: 'My Bookings History',
                      subtitle: 'Upcoming & past reservations',
                      onTap: () {
                        Navigator.pushNamed(context, 'bookings');
                      },
                    ),
                    const Divider(height: 1),
                    _buildOptionTile(
                      context,
                      icon: Icons.favorite_outline,
                      title: 'Saved Favorites',
                      subtitle: 'View bookmarked venue spaces',
                      onTap: () {
                        Navigator.pushNamed(context, 'favorites');
                      },
                    ),
                    const Divider(height: 1),
                    _buildOptionTile(
                      context,
                      icon: Icons.settings_outlined,
                      title: 'App Settings',
                      subtitle: 'Preferences & notifications',
                      onTap: () {
                        Navigator.pushNamed(context, 'settings');
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return ListTile(
      leading: Icon(icon, color: AppColors.gold, size: 22),
      title: Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textPrimary)),
      subtitle: Text(subtitle, style: TextStyle(fontSize: 12, color: textSecondary)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.gold),
      onTap: onTap,
    );
  }
}
