import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/theme_provider.dart';
import 'providers/venue_provider.dart';
import 'providers/booking_provider.dart';
import 'providers/favorite_provider.dart';
import 'providers/profile_provider.dart';
import 'providers/review_provider.dart';

import 'utils/app_theme.dart';
import 'screens/splash_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/favorites_screen.dart';
import 'screens/bookings_history_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/help/help_support_screen.dart';
import 'screens/help/about_screen.dart';

class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
        PointerDeviceKind.stylus,
      };
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => FavoriteProvider()),
        ChangeNotifierProvider(create: (_) => VenueProvider()),
        ChangeNotifierProvider(create: (_) => BookingProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => ReviewProvider()),
      ],
      child: const VenuelyApp(),
    ),
  );
}

class VenuelyApp extends StatelessWidget {
  const VenuelyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'VENUELY - Event Venue Booking',
      debugShowCheckedModeBanner: false,
      scrollBehavior: AppScrollBehavior(),
      themeMode: themeProvider.themeMode,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      builder: (context, child) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth > 550;
            final targetWidth = isDesktop ? 440.0 : constraints.maxWidth;
            final targetHeight = isDesktop ? constraints.maxHeight * 0.94 : constraints.maxHeight;

            final isDark = Theme.of(context).brightness == Brightness.dark;

            return Container(
              color: isDark ? const Color(0xFF000000) : const Color(0xFFD4D4D8),
              child: Center(
                child: Container(
                  width: targetWidth,
                  height: targetHeight,
                  decoration: isDesktop
                      ? BoxDecoration(
                          color: isDark ? const Color(0xFF09090B) : const Color(0xFFF7F7F5),
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(
                            color: isDark ? const Color(0xFF27272A) : const Color(0xFFE4E4E7),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.4),
                              blurRadius: 25,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        )
                      : null,
                  child: ClipRRect(
                    borderRadius: isDesktop ? BorderRadius.circular(26) : BorderRadius.zero,
                    child: MediaQuery(
                      data: MediaQuery.of(context).copyWith(
                        size: Size(targetWidth, targetHeight),
                      ),
                      child: child ?? const SizedBox.shrink(),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
      initialRoute: '/',
      routes: {
        '/': (_) => const SplashScreen(),
        'splash': (_) => const SplashScreen(),
        'onboarding': (_) => const OnboardingScreen(),
        'login': (_) => const LoginPage(),
        'home': (_) => const HomeScreen(),
        'favorites': (_) => const FavoritesScreen(),
        'bookings': (_) => const BookingsScreen(),
        'profile': (_) => const ProfileScreen(),
        'settings': (_) => const SettingsScreen(),
        'help': (_) => const HelpSupportScreen(),
        'about': (_) => const AboutScreen(),
      },
    );
  }
}
