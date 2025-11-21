/// Food detail screen for QuickBite application
/// Shows detailed food information with customization options
library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../domain/entities/restaurant_entity.dart';
import '../../domain/entities/menu_item_entity.dart';
import '../../domain/entities/cart_entity.dart';
import '../providers/cart_provider.dart';
import 'cart_screen_v2.dart';

class FoodDetailScreen extends StatefulWidget {
  final MenuItemEntity menuItem;
  final RestaurantEntity restaurant;

  const FoodDetailScreen({
    super.key,
    required this.menuItem,
    required this.restaurant,
  });

  @override
  State<FoodDetailScreen> createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends State<FoodDetailScreen> {
  int _quantity = 1;
  final Map<String, List<CustomizationChoice>> _selectedCustomizations = {};

  @override
  void initState() {
    super.initState();
    AppLogger.lifecycle('FoodDetailScreen', 'initState');
    // Initialize required customizations
    for (var option in widget.menuItem.customizations) {
      if (option.isRequired && option.choices.isNotEmpty) {
        _selectedCustomizations[option.id] = [option.choices.first];
      }
    }
  }

  double get _basePrice => widget.menuItem.price;

  double get _customizationPrice {
    double total = 0;
    for (var choices in _selectedCustomizations.values) {
      for (var choice in choices) {
        total += choice.additionalPrice;
      }
    }
    return total;
  }

  double get _totalPrice => (_basePrice + _customizationPrice) * _quantity;

  bool get _canAddToCart {
    for (var option in widget.menuItem.customizations) {
      if (option.isRequired) {
        if (!_selectedCustomizations.containsKey(option.id) ||
            _selectedCustomizations[option.id]!.isEmpty) {
          return false;
        }
      }
    }
    return true;
  }

  void _addToCart() {
    if (!_canAddToCart) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select all required options'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final selectedCustomizations = _selectedCustomizations.entries
        .map((entry) {
          final option = widget.menuItem.customizations
              .firstWhere((opt) => opt.id == entry.key);
          return SelectedCustomization(
            optionId: option.id,
            optionName: option.name,
            selectedChoices: entry.value,
          );
        })
        .toList();

    for (int i = 0; i < _quantity; i++) {
      cartProvider.addItem(
        menuItem: widget.menuItem,
        customizations: selectedCustomizations,
      );
    }

    // Save context before navigation
    if (!mounted) return;
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    // Close the food detail screen first
    navigator.pop();

    // Show success message with option to view cart
    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Text('Added ${widget.menuItem.name} to cart'),
        backgroundColor: AppColors.success,
        action: SnackBarAction(
          label: 'VIEW CART',
          textColor: Colors.white,
          onPressed: () {
            // Navigate to cart screen
            navigator.push(
              MaterialPageRoute(
                builder: (context) => const CartScreenV2(),
              ),
            );
          },
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          // App Bar with Image
          SliverAppBar(
            expandedHeight: 300,
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
                child: IconButton(
                  icon: const Icon(Icons.favorite_border, color: Colors.black),
                  onPressed: () {},
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    widget.menuItem.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: isDarkMode
                            ? AppColors.darkImagePlaceholder
                            : AppColors.imagePlaceholder,
                        child: const Icon(
                          Icons.fastfood,
                          size: 64,
                          color: Colors.white,
                        ),
                      );
                    },
                  ),
                  if (widget.menuItem.isPopular)
                    Positioned(
                      top: 60,
                      right: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          children: [
                            Text(
                              '🔥 Popular',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name and Price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.menuItem.name,
                          style:
                              Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    fontWeight: AppConstants.fontWeightBold,
                                  ),
                        ),
                      ),
                      Text(
                        CurrencyFormatter.format(_basePrice),
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: AppColors.primary,
                              fontWeight: AppConstants.fontWeightBold,
                            ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Rating and Reviews
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        size: 20,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        widget.menuItem.rating.toStringAsFixed(1),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '(${widget.menuItem.reviewCount} reviews)',
                        style: TextStyle(
                          color: isDarkMode
                              ? AppColors.darkTextSecondary
                              : AppColors.textSecondary,
                        ),
                      ),
                      if (widget.menuItem.isVegetarian) ...[
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.success.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.eco,
                                size: 14,
                                color: AppColors.success,
                              ),
                              SizedBox(width: 4),
                              Text(
                                'Vegetarian',
                                style: TextStyle(
                                  color: AppColors.success,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Description
                  Text(
                    widget.menuItem.description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: isDarkMode
                              ? AppColors.darkTextSecondary
                              : AppColors.textSecondary,
                          height: 1.5,
                        ),
                  ),

                  const SizedBox(height: 24),

                  // Ingredients
                  if (widget.menuItem.ingredients.isNotEmpty) ...[
                    Text(
                      'Ingredients',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: AppConstants.fontWeightBold,
                          ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: widget.menuItem.ingredients.map((ingredient) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isDarkMode
                                ? AppColors.darkCardBackground
                                : AppColors.cardBackground,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            ingredient,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Customizations
                  if (widget.menuItem.customizations.isNotEmpty) ...[
                    for (var option in widget.menuItem.customizations) ...[
                      _buildCustomizationSection(option, isDarkMode),
                      const SizedBox(height: 20),
                    ],
                  ],

                  // Quantity Selector
                  Text(
                    'Quantity',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: AppConstants.fontWeightBold,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildQuantityButton(
                        icon: Icons.remove,
                        onPressed: () {
                          if (_quantity > 1) {
                            setState(() {
                              _quantity--;
                            });
                          }
                        },
                      ),
                      const SizedBox(width: 16),
                      Text(
                        '$_quantity',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: AppConstants.fontWeightBold,
                            ),
                      ),
                      const SizedBox(width: 16),
                      _buildQuantityButton(
                        icon: Icons.add,
                        onPressed: () {
                          setState(() {
                            _quantity++;
                          });
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 100), // Space for bottom button
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: CustomButton(
          text: 'ADD TO CART - ${CurrencyFormatter.format(_totalPrice)}',
          onPressed: _canAddToCart ? _addToCart : null,
          isFullWidth: true,
        ),
      ),
    );
  }

  Widget _buildCustomizationSection(
    CustomizationOption option,
    bool isDarkMode,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              option.name,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: AppConstants.fontWeightBold,
                  ),
            ),
            if (option.isRequired) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Required',
                  style: TextStyle(
                    color: AppColors.error,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 12),
        ...option.choices.map((choice) {
          final isSelected = _selectedCustomizations[option.id]
                  ?.any((c) => c.id == choice.id) ??
              false;
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  if (option.maxSelections == 1) {
                    _selectedCustomizations[option.id] = [choice];
                  } else {
                    final current = _selectedCustomizations[option.id] ?? [];
                    if (isSelected) {
                      _selectedCustomizations[option.id] =
                          current.where((c) => c.id != choice.id).toList();
                    } else {
                      if (current.length < option.maxSelections) {
                        _selectedCustomizations[option.id] = [...current, choice];
                      }
                    }
                  }
                });
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary.withOpacity(0.1)
                      : isDarkMode
                          ? AppColors.darkCardBackground
                          : AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary
                        : isDarkMode
                            ? AppColors.darkBorder
                            : AppColors.lightBorder,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      choice.name,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                    ),
                    Row(
                      children: [
                        if (choice.additionalPrice > 0)
                          Text(
                            '+\$${choice.additionalPrice.toStringAsFixed(2)}',
                            style:
                                Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                        const SizedBox(width: 8),
                        Icon(
                          isSelected
                              ? Icons.check_circle
                              : Icons.circle_outlined,
                          color: isSelected
                              ? AppColors.primary
                              : isDarkMode
                                  ? AppColors.darkTextSecondary
                                  : AppColors.textSecondary,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white),
        onPressed: onPressed,
      ),
    );
  }
}

