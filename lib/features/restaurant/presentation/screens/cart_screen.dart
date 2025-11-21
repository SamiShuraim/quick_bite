/// Cart screen for QuickBite application
/// Shows cart items and checkout
library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/custom_button.dart';
import '../providers/cart_provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('My Cart'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        actions: [
          if (cartProvider.items.isNotEmpty)
            TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Clear Cart'),
                    content: const Text(
                      'Are you sure you want to remove all items from your cart?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          cartProvider.clearCart();
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Clear',
                          style: TextStyle(color: AppColors.error),
                        ),
                      ),
                    ],
                  ),
                );
              },
              child: const Text(
                'Clear',
                style: TextStyle(color: AppColors.error),
              ),
            ),
        ],
      ),
      body: cartProvider.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_bag_outlined,
                    size: 100,
                    color: isDarkMode
                        ? AppColors.darkTextSecondary
                        : AppColors.textSecondary,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Your cart is empty',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: isDarkMode
                              ? AppColors.darkTextSecondary
                              : AppColors.textSecondary,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Add items to get started',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: isDarkMode
                              ? AppColors.darkTextSecondary
                              : AppColors.textSecondary,
                        ),
                  ),
                  const SizedBox(height: 32),
                  CustomButton(
                    text: 'Browse Restaurants',
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(AppConstants.defaultPadding),
                    itemCount: cartProvider.items.length,
                    itemBuilder: (context, index) {
                      final item = cartProvider.items[index];
                      return Padding(
                        padding: const EdgeInsets.only(
                          bottom: AppConstants.mediumPadding,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: isDarkMode
                                ? AppColors.darkCardBackground
                                : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.shadow,
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              // Image
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(16),
                                  bottomLeft: Radius.circular(16),
                                ),
                                child: Image.network(
                                  item.menuItem.imageUrl,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: 100,
                                      height: 100,
                                      color: isDarkMode
                                          ? AppColors.darkImagePlaceholder
                                          : AppColors.imagePlaceholder,
                                      child: const Icon(
                                        Icons.fastfood,
                                        color: Colors.white,
                                      ),
                                    );
                                  },
                                ),
                              ),

                              // Info
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(
                                    AppConstants.mediumPadding,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Name
                                      Text(
                                        item.menuItem.name,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(
                                              fontWeight:
                                                  AppConstants.fontWeightBold,
                                            ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),

                                      const SizedBox(height: 4),

                                      // Customizations
                                      if (item.customizations.isNotEmpty)
                                        ...item.customizations.map((custom) {
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                              top: 2,
                                            ),
                                            child: Text(
                                              '${custom.optionName}: ${custom.selectedChoices.map((c) => c.name).join(", ")}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall
                                                  ?.copyWith(
                                                    color: isDarkMode
                                                        ? AppColors
                                                            .darkTextSecondary
                                                        : AppColors
                                                            .textSecondary,
                                                  ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          );
                                        }),

                                      const SizedBox(height: 8),

                                      // Price and Quantity
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            CurrencyFormatter.format(item.totalPrice),
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium
                                                ?.copyWith(
                                                  color: AppColors.primary,
                                                  fontWeight: AppConstants
                                                      .fontWeightBold,
                                                ),
                                          ),
                                          Row(
                                            children: [
                                              _buildQuantityButton(
                                                context,
                                                Icons.remove,
                                                () {
                                                  cartProvider.updateQuantity(
                                                    index,
                                                    item.quantity - 1,
                                                  );
                                                },
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 12,
                                                ),
                                                child: Text(
                                                  '${item.quantity}',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleMedium
                                                      ?.copyWith(
                                                        fontWeight: AppConstants
                                                            .fontWeightBold,
                                                      ),
                                                ),
                                              ),
                                              _buildQuantityButton(
                                                context,
                                                Icons.add,
                                                () {
                                                  cartProvider.updateQuantity(
                                                    index,
                                                    item.quantity + 1,
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Summary
                Container(
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
                  child: Column(
                    children: [
                      _buildSummaryRow(
                        context,
                        'Subtotal',
                        CurrencyFormatter.format(cartProvider.subtotal),
                        isDarkMode,
                      ),
                      const SizedBox(height: 8),
                      _buildSummaryRow(
                        context,
                        'Delivery Fee',
                        cartProvider.deliveryFee == 0
                            ? 'FREE'
                            : CurrencyFormatter.format(cartProvider.deliveryFee),
                        isDarkMode,
                      ),
                      const SizedBox(height: 8),
                      _buildSummaryRow(
                        context,
                        'VAT (15%)',
                        CurrencyFormatter.format(cartProvider.tax),
                        isDarkMode,
                      ),
                      const Divider(height: 24),
                      _buildSummaryRow(
                        context,
                        'Total',
                        CurrencyFormatter.format(cartProvider.total),
                        isDarkMode,
                        isTotal: true,
                      ),
                      const SizedBox(height: 16),
                      CustomButton(
                        text: 'PROCEED TO CHECKOUT',
                        onPressed: () {
                          AppLogger.userAction('Checkout Initiated');
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Checkout feature coming soon!'),
                              backgroundColor: AppColors.info,
                            ),
                          );
                        },
                        isFullWidth: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildQuantityButton(
    BuildContext context,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(icon, color: Colors.white, size: 18),
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildSummaryRow(
    BuildContext context,
    String label,
    String value,
    bool isDarkMode, {
    bool isTotal = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isTotal
                    ? (isDarkMode
                        ? AppColors.darkTextPrimary
                        : AppColors.textPrimary)
                    : (isDarkMode
                        ? AppColors.darkTextSecondary
                        : AppColors.textSecondary),
                fontWeight:
                    isTotal ? AppConstants.fontWeightBold : FontWeight.normal,
                fontSize: isTotal ? 18 : 14,
              ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isTotal ? AppColors.primary : null,
                fontWeight: AppConstants.fontWeightBold,
                fontSize: isTotal ? 20 : 14,
              ),
        ),
      ],
    );
  }
}

