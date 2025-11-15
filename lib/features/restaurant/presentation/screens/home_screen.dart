/// Home screen for QuickBite application
/// Displays restaurant listings and categories
library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_logger.dart';
import '../providers/restaurant_provider.dart';
import '../providers/cart_provider.dart';
import '../widgets/restaurant_card.dart';
import '../widgets/category_chip.dart';
import 'restaurant_detail_screen.dart';
import 'filter_screen.dart';
import 'cart_screen_v2.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    AppLogger.lifecycle('HomeScreen', 'initState');
  }

  @override
  void dispose() {
    AppLogger.lifecycle('HomeScreen', 'dispose');
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final restaurantProvider = Provider.of<RestaurantProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: restaurantProvider.refreshRestaurants,
          child: CustomScrollView(
            slivers: [
              // App Bar
              SliverAppBar(
                floating: true,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                elevation: 0,
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'DELIVER TO',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.primary,
                            fontWeight: AppConstants.fontWeightBold,
                            letterSpacing: 1.2,
                          ),
                    ),
                    Row(
                      children: [
                        Text(
                          'Current Location',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: AppConstants.fontWeightBold,
                                  ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: isDarkMode
                              ? AppColors.darkTextPrimary
                              : AppColors.textPrimary,
                        ),
                      ],
                    ),
                  ],
                ),
                actions: [
                  // Cart Icon
                  Stack(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.shopping_bag_outlined),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CartScreenV2(),
                            ),
                          );
                        },
                      ),
                      if (cartProvider.itemCount > 0)
                        Positioned(
                          right: 8,
                          top: 8,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 18,
                              minHeight: 18,
                            ),
                            child: Text(
                              '${cartProvider.itemCount}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),

              // Search Bar and Filter
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(AppConstants.defaultPadding),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: isDarkMode
                                ? AppColors.darkCardBackground
                                : AppColors.cardBackground,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: TextField(
                            controller: _searchController,
                            onChanged: (value) {
                              restaurantProvider.setSearchQuery(value);
                            },
                            decoration: InputDecoration(
                              hintText: 'Search dishes, restaurants',
                              prefixIcon: Icon(
                                Icons.search,
                                color: isDarkMode
                                    ? AppColors.darkTextSecondary
                                    : AppColors.textSecondary,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.tune, color: Colors.white),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const FilterScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Categories
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.defaultPadding,
                    ),
                    itemCount: restaurantProvider.categories.length,
                    itemBuilder: (context, index) {
                      final category = restaurantProvider.categories[index];
                      final isSelected =
                          category == restaurantProvider.selectedCategory;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: CategoryChip(
                          label: category,
                          isSelected: isSelected,
                          onTap: () {
                            restaurantProvider.setCategory(category);
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),

              const SliverToBoxAdapter(
                child: SizedBox(height: AppConstants.mediumPadding),
              ),

              // Section Header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.defaultPadding,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Open Restaurants',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: AppConstants.fontWeightBold,
                            ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'See All',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: AppConstants.fontWeightMedium,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Restaurant List
              if (restaurantProvider.isLoading)
                const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (restaurantProvider.restaurants.isEmpty)
                SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.restaurant_outlined,
                          size: 64,
                          color: isDarkMode
                              ? AppColors.darkTextSecondary
                              : AppColors.textSecondary,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No restaurants found',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: isDarkMode
                                        ? AppColors.darkTextSecondary
                                        : AppColors.textSecondary,
                                  ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.defaultPadding,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final restaurant =
                            restaurantProvider.restaurants[index];
                        return Padding(
                          padding: const EdgeInsets.only(
                            bottom: AppConstants.mediumPadding,
                          ),
                          child: RestaurantCard(
                            restaurant: restaurant,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RestaurantDetailScreen(
                                    restaurant: restaurant,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                      childCount: restaurantProvider.restaurants.length,
                    ),
                  ),
                ),

              const SliverToBoxAdapter(
                child: SizedBox(height: AppConstants.defaultPadding),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

