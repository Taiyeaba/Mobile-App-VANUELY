import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/venue_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/constants.dart';
import '../../widgets/search_bar_widget.dart';
import '../../widgets/venue_card.dart';
import '../../widgets/empty_state_widget.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _categoryScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<VenueProvider>(context, listen: false);
    _searchController.text = provider.searchQuery;
  }

  @override
  void dispose() {
    _searchController.dispose();
    _categoryScrollController.dispose();
    super.dispose();
  }

  void _scrollRight(ScrollController controller) {
    controller.animateTo(
      controller.offset + 200,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _scrollLeft(ScrollController controller) {
    controller.animateTo(
      controller.offset - 200,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _showFilterModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Consumer<VenueProvider>(
          builder: (context, provider, child) {
            final isDark = Theme.of(context).brightness == Brightness.dark;
            final bg = isDark ? AppColors.darkCard : AppColors.lightCard;
            final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;

            return Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: bg,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Filter Venues',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: textPrimary,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            provider.resetFilters();
                            _searchController.clear();
                          },
                          child: const Text('Reset All', style: TextStyle(color: AppColors.gold)),
                        ),
                      ],
                    ),
                    const Divider(),
                    const SizedBox(height: 12),

                    // Location Filter Dropdown
                    Text('Location', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textPrimary)),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      initialValue: provider.selectedLocation,
                      items: AppConstants.locations
                          .map((loc) => DropdownMenuItem(value: loc, child: Text(loc)))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) provider.setSelectedLocation(val);
                      },
                    ),

                    const SizedBox(height: 16),

                    // Sort By Dropdown
                    Text('Sort By', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textPrimary)),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      initialValue: provider.sortBy,
                      items: AppConstants.sortOptions
                          .map((opt) => DropdownMenuItem(value: opt, child: Text(opt)))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) provider.setSortBy(val);
                      },
                    ),

                    const SizedBox(height: 16),

                    // Max Price Slider
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Max Price per Day', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textPrimary)),
                        Text('৳${provider.maxPrice.toStringAsFixed(0)}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.gold)),
                      ],
                    ),
                    Slider(
                      value: provider.maxPrice,
                      min: 30000,
                      max: 350000,
                      divisions: 32,
                      activeColor: AppColors.gold,
                      onChanged: (val) => provider.setMaxPrice(val),
                    ),

                    const SizedBox(height: 20),

                    // Apply Button
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.gold,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          'Apply Filters',
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final venueProvider = Provider.of<VenueProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final filtered = venueProvider.filteredVenues;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Discover & Search'),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Top Search Input with Filter Button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SearchBarWidget(
                controller: _searchController,
                hintText: 'Search by venue, location, category...',
                onChanged: (val) => venueProvider.setSearchQuery(val),
                onFilterTap: () => _showFilterModal(context),
              ),
            ),

            // Category Chips Row with Left (<) and Right (>) Arrow Buttons & No Yellow Scrollbar
            Row(
              children: [
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(Icons.arrow_back_ios_rounded, color: AppColors.gold, size: 16),
                  tooltip: 'Scroll Left',
                  onPressed: () => _scrollLeft(_categoryScrollController),
                ),
                Expanded(
                  child: SizedBox(
                    height: 44,
                    child: ListView.builder(
                      controller: _categoryScrollController,
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                      itemCount: AppConstants.categories.length,
                      itemBuilder: (context, index) {
                        final cat = AppConstants.categories[index];
                        final isSelected = venueProvider.selectedCategory == cat;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(cat),
                            selected: isSelected,
                            selectedColor: AppColors.gold,
                            backgroundColor: isDark ? AppColors.darkCard : AppColors.lightCard,
                            labelStyle: TextStyle(
                              color: isSelected ? Colors.black : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              fontSize: 12,
                            ),
                            onSelected: (_) {
                              venueProvider.setSelectedCategory(cat);
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(Icons.arrow_forward_ios_rounded, color: AppColors.gold, size: 16),
                  tooltip: 'Scroll Right',
                  onPressed: () => _scrollRight(_categoryScrollController),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Search Results List
            Expanded(
              child: filtered.isEmpty
                  ? EmptyStateWidget(
                      icon: Icons.search_off_rounded,
                      title: 'No Venues Found',
                      description: 'Try adjusting your search query or filter options.',
                      buttonText: 'Reset Filters',
                      onButtonPressed: () {
                        venueProvider.resetFilters();
                        _searchController.clear();
                      },
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: filtered.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        return VenueCard(venue: filtered[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
