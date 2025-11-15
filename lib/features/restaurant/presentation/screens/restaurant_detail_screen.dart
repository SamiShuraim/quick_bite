/// Restaurant detail screen for QuickBite application
/// Shows restaurant info and menu items
library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_logger.dart';
import '../../domain/entities/restaurant_entity.dart';
import '../../domain/entities/menu_item_entity.dart';
import '../providers/restaurant_provider.dart';
import '../providers/cart_provider.dart';
import '../widgets/menu_item_card.dart';
import 'food_detail_screen.dart';
import 'cart_screen_v2.dart';

class RestaurantDetailScreen extends StatefulWidget {
  final RestaurantEntity restaurant;

  const RestaurantDetailScreen({
    super.key,
    required this.restaurant,
  });

  @override
  State<RestaurantDetailScreen> createState() => _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends State<RestaurantDetailScreen> {
  List<MenuItemEntity> _menuItems = [];
  String _selectedCategory = 'All';
  bool _isLoadingMenu = true;

  @override
  void initState() {
    super.initState();
    AppLogger.lifecycle('RestaurantDetailScreen', 'initState');
    _loadMenuItems();
  }

  Future<void> _loadMenuItems() async {
    setState(() {
      _isLoadingMenu = true;
    });

    try {
      final restaurantProvider =
          Provider.of<RestaurantProvider>(context, listen: false);
      final menuItems = await restaurantProvider.getMenuItemsForRestaurant(widget.restaurant.id);
      
      if (mounted) {
        setState(() {
          _menuItems = menuItems;
          _isLoadingMenu = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingMenu = false;
        });
      }
    }
  }

  List<String> get _categories {
    final categories = <String>{'All'};
    for (var item in _menuItems) {
      categories.add(item.category);
    }
    return categories.toList();
  }

  List<MenuItemEntity> get _filteredMenuItems {
    if (_selectedCategory == 'All') {
      return _menuItems;
    }
    return _menuItems
        .where((item) => item.category == _selectedCategory)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          // App Bar with Image
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.shopping_bag_outlined,
                          color: Colors.black),
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
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                widget.restaurant.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: isDarkMode
                        ? AppColors.darkImagePlaceholder
                        : AppColors.imagePlaceholder,
                    child: const Icon(
                      Icons.restaurant,
                      size: 64,
                      color: Colors.white,
                    ),
                  );
                },
              ),
            ),
          ),

          // Restaurant Info
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name and Rating
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.restaurant.name,
                          style:
                              Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    fontWeight: AppConstants.fontWeightBold,
                                  ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.star,
                              size: 16,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              widget.restaurant.rating.toStringAsFixed(1),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Description
                  Text(
                    widget.restaurant.description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: isDarkMode
                              ? AppColors.darkTextSecondary
                              : AppColors.textSecondary,
                        ),
                  ),

                  const SizedBox(height: 16),

                  // Info Row
                  Row(
                    children: [
                      _buildInfoChip(
                        context,
                        Icons.access_time,
                        '${widget.restaurant.deliveryTime} min',
                      ),
                      const SizedBox(width: 12),
                      _buildInfoChip(
                        context,
                        Icons.delivery_dining,
                        widget.restaurant.isFreeDelivery
                            ? 'Free'
                            : '\$${widget.restaurant.deliveryFee.toStringAsFixed(2)}',
                      ),
                      const SizedBox(width: 12),
                      _buildInfoChip(
                        context,
                        Icons.location_on_outlined,
                        '${widget.restaurant.distance} km',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Category Tabs
          SliverToBoxAdapter(
            child: SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.defaultPadding,
                ),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  final isSelected = category == _selectedCategory;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedCategory = category;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary
                              : isDarkMode
                                  ? AppColors.darkCardBackground
                                  : AppColors.cardBackground,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Text(
                          category,
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : isDarkMode
                                    ? AppColors.darkTextPrimary
                                    : AppColors.textPrimary,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          const SliverToBoxAdapter(
            child: SizedBox(height: AppConstants.mediumPadding),
          ),

          // Menu Items
          if (_isLoadingMenu)
            const SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          else if (_filteredMenuItems.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Text(
                  'No menu items available',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: isDarkMode
                            ? AppColors.darkTextSecondary
                            : AppColors.textSecondary,
                      ),
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
                    final menuItem = _filteredMenuItems[index];
                    return Padding(
                      padding: const EdgeInsets.only(
                        bottom: AppConstants.mediumPadding,
                      ),
                      child: MenuItemCard(
                        menuItem: menuItem,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FoodDetailScreen(
                                menuItem: menuItem,
                                restaurant: widget.restaurant,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                  childCount: _filteredMenuItems.length,
                ),
              ),
            ),

          const SliverToBoxAdapter(
            child: SizedBox(height: AppConstants.defaultPadding),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(BuildContext context, IconData icon, String label) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isDarkMode
            ? AppColors.darkCardBackground
            : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: AppColors.primary,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}

