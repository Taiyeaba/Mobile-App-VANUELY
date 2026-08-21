import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/favorite_provider.dart';
import '../providers/venue_provider.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/venue_card.dart';
import '../widgets/empty_state_widget.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favoriteProvider = Provider.of<FavoriteProvider>(context);
    final venueProvider = Provider.of<VenueProvider>(context);
    final canPop = Navigator.canPop(context);

    final favIds = favoriteProvider.favoriteIds;
    final favVenues = venueProvider.venues.where((v) => favIds.contains(v.id)).toList();

    return Scaffold(
      drawer: const CustomDrawer(currentRoute: 'favorites'),
      appBar: AppBar(
        title: const Text('Saved Favorites'),
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
        child: favVenues.isEmpty
            ? EmptyStateWidget(
                icon: Icons.favorite_border_rounded,
                title: 'No Saved Venues',
                description: 'Your saved venues will appear here. Tap the heart icon on any venue to save it.',
                buttonText: 'Discover Venues',
                onButtonPressed: () {
                  Navigator.pushNamed(context, 'home');
                },
              )
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: favVenues.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  return VenueCard(venue: favVenues[index]);
                },
              ),
      ),
    );
  }
}
