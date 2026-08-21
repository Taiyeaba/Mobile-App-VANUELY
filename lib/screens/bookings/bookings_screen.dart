import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/booking_provider.dart';
import '../../utils/app_colors.dart';
import '../../widgets/custom_drawer.dart';
import '../../widgets/booking_card.dart';
import '../../widgets/empty_state_widget.dart';

class BookingsScreen extends StatelessWidget {
  const BookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bookingProvider = Provider.of<BookingProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final canPop = Navigator.canPop(context);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        drawer: const CustomDrawer(currentRoute: 'bookings'),
        appBar: AppBar(
          title: const Text('My Bookings'),
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
          bottom: TabBar(
            indicatorColor: AppColors.gold,
            labelColor: AppColors.gold,
            unselectedLabelColor: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            tabs: const [
              Tab(text: 'Upcoming'),
              Tab(text: 'Completed'),
              Tab(text: 'Cancelled'),
            ],
          ),
        ),
        body: SafeArea(
          child: TabBarView(
            children: [
              // Upcoming Tab
              _buildBookingsList(
                context,
                bookingProvider.upcomingBookings,
                'No Upcoming Bookings',
                'You have no active venue reservations at the moment.',
              ),

              // Completed Tab
              _buildBookingsList(
                context,
                bookingProvider.completedBookings,
                'No Completed Events',
                'Your past completed venue reservations will appear here.',
              ),

              // Cancelled Tab
              _buildBookingsList(
                context,
                bookingProvider.cancelledBookings,
                'No Cancelled Bookings',
                'You have no cancelled bookings.',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBookingsList(BuildContext context, List bookings, String emptyTitle, String emptyDesc) {
    if (bookings.isEmpty) {
      return EmptyStateWidget(
        icon: Icons.confirmation_number_outlined,
        title: emptyTitle,
        description: emptyDesc,
        buttonText: 'Explore Venues',
        onButtonPressed: () {
          Navigator.pushNamed(context, 'home');
        },
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        return BookingCard(booking: bookings[index]);
      },
    );
  }
}

// Backward compatibility alias
typedef BookingsHistoryScreen = BookingsScreen;
