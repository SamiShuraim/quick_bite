/// My Orders screen for QuickBite application
/// Displays user's order history
library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../restaurant/presentation/providers/order_provider.dart';
import '../../../restaurant/presentation/providers/cart_provider.dart';
import '../../../restaurant/presentation/providers/restaurant_provider.dart';
import '../../../restaurant/domain/entities/order_entity.dart';
import '../../../restaurant/domain/entities/cart_entity.dart';
import '../../../restaurant/domain/entities/menu_item_entity.dart';
import '../../../restaurant/presentation/screens/cart_screen_v2.dart';
import 'package:intl/intl.dart';
import 'order_tracking_screen.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  String? _selectedStatus;
  
  @override
  void initState() {
    super.initState();
    AppLogger.lifecycle('MyOrdersScreen', 'initState');
    // Defer loading until after the first frame to avoid setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadOrders();
    });
  }
  
  Future<void> _loadOrders() async {
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    try {
      await orderProvider.fetchUserOrders(status: _selectedStatus);
    } catch (e) {
      // Error handling is done in provider
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final orderProvider = Provider.of<OrderProvider>(context);
    
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('My Orders'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Filter Tabs
            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: [
                  _buildFilterChip('All', null, isDarkMode),
                  const SizedBox(width: 8),
                  _buildFilterChip('Pending', 'pending', isDarkMode),
                  const SizedBox(width: 8),
                  _buildFilterChip('Preparing', 'confirmed', isDarkMode),
                  const SizedBox(width: 8),
                  _buildFilterChip('On the Way', 'on_the_way', isDarkMode),
                  const SizedBox(width: 8),
                  _buildFilterChip('Arriving Soon', 'arriving_soon', isDarkMode),
                  const SizedBox(width: 8),
                  _buildFilterChip('Delivered', 'delivered', isDarkMode),
                  const SizedBox(width: 8),
                  _buildFilterChip('Cancelled', 'cancelled', isDarkMode),
                ],
              ),
            ),
            
            // Orders List
            Expanded(
              child: RefreshIndicator(
                onRefresh: _loadOrders,
                child: orderProvider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : orderProvider.orders.isEmpty
                        ? _buildEmptyState(context, isDarkMode)
                        : ListView.builder(
                            padding: const EdgeInsets.all(24),
                            itemCount: orderProvider.orders.length,
                            itemBuilder: (context, index) {
                              final order = orderProvider.orders[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: _buildOrderCard(context, order, isDarkMode),
                              );
                            },
                          ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildFilterChip(String label, String? status, bool isDarkMode) {
    final isSelected = _selectedStatus == status;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedStatus = status;
        });
        _loadOrders();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : isDarkMode
                  ? AppColors.darkCardBackground
                  : AppColors.cardBackground,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : isDarkMode
                    ? AppColors.darkDivider
                    : AppColors.divider,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? Colors.white
                : isDarkMode
                    ? AppColors.darkTextPrimary
                    : AppColors.textPrimary,
            fontWeight: isSelected
                ? AppConstants.fontWeightSemiBold
                : AppConstants.fontWeightMedium,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
  
  Widget _buildOrderCard(BuildContext context, OrderEntity order, bool isDarkMode) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode
            ? AppColors.darkCardBackground
            : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            AppLogger.userAction('Order tapped', details: {'orderId': order.id});
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OrderTrackingScreen(order: order),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Order Number and Status
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      order.orderNumber,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: AppConstants.fontWeightBold,
                          ),
                    ),
                    _buildStatusChip(order.status, isDarkMode),
                  ],
                ),
                
                const SizedBox(height: 12),
                
                // Restaurant Name
                Row(
                  children: [
                    Icon(
                      Icons.restaurant,
                      size: 16,
                      color: isDarkMode
                          ? AppColors.darkTextSecondary
                          : AppColors.textSecondary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        order.restaurantName,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: isDarkMode
                                  ? AppColors.darkTextSecondary
                                  : AppColors.textSecondary,
                            ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 8),
                
                // Items Count
                Row(
                  children: [
                    Icon(
                      Icons.shopping_bag_outlined,
                      size: 16,
                      color: isDarkMode
                          ? AppColors.darkTextSecondary
                          : AppColors.textSecondary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${order.items.length} items',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: isDarkMode
                                ? AppColors.darkTextSecondary
                                : AppColors.textSecondary,
                          ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 12),
                
                const Divider(height: 1),
                
                const SizedBox(height: 12),
                
                // Total and Date
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      CurrencyFormatter.format(order.total),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: AppConstants.fontWeightBold,
                            color: AppColors.primary,
                          ),
                    ),
                    Text(
                      DateFormat('MMM dd, yyyy').format(order.createdAt),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: isDarkMode
                                ? AppColors.darkTextSecondary
                                : AppColors.textSecondary,
                          ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _handleReorder(context, order),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: AppColors.primary, width: 1.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        icon: const Icon(Icons.refresh, color: AppColors.primary, size: 18),
                        label: const Text(
                          'REORDER',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OrderTrackingScreen(order: order),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          elevation: 0,
                        ),
                        icon: const Icon(Icons.remove_red_eye_outlined, color: Colors.white, size: 18),
                        label: const Text(
                          'VIEW',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildStatusChip(String status, bool isDarkMode) {
    Color backgroundColor;
    Color textColor;
    String displayText;
    
    switch (status.toLowerCase()) {
      case 'pending':
        backgroundColor = Colors.orange.withValues(alpha: 0.1);
        textColor = Colors.orange;
        displayText = 'Pending';
        break;
      case 'confirmed':
        backgroundColor = Colors.blue.withValues(alpha: 0.1);
        textColor = Colors.blue;
        displayText = 'Preparing';
        break;
      case 'on_the_way':
        backgroundColor = AppColors.primary.withValues(alpha: 0.1);
        textColor = AppColors.primary;
        displayText = 'On the Way';
        break;
      case 'arriving_soon':
        backgroundColor = Colors.green.withValues(alpha: 0.1);
        textColor = Colors.green;
        displayText = 'Arriving Soon';
        break;
      case 'delivered':
        backgroundColor = AppColors.success.withValues(alpha: 0.1);
        textColor = AppColors.success;
        displayText = 'Delivered';
        break;
      case 'cancelled':
        backgroundColor = AppColors.error.withValues(alpha: 0.1);
        textColor = AppColors.error;
        displayText = 'Cancelled';
        break;
      default:
        backgroundColor = Colors.grey.withValues(alpha: 0.1);
        textColor = Colors.grey;
        displayText = status;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        displayText,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: AppConstants.fontWeightSemiBold,
        ),
      ),
    );
  }
  
  Widget _buildEmptyState(BuildContext context, bool isDarkMode) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 80,
            color: isDarkMode
                ? AppColors.darkTextSecondary
                : AppColors.textSecondary,
          ),
          const SizedBox(height: 24),
          Text(
            'No orders yet',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: AppConstants.fontWeightBold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your order history will appear here',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isDarkMode
                      ? AppColors.darkTextSecondary
                      : AppColors.textSecondary,
                ),
          ),
        ],
      ),
    );
  }
  
  Future<void> _handleReorder(BuildContext context, OrderEntity order) async {
    try {
      AppLogger.userAction('Reorder clicked', details: {'orderId': order.id});
      
      final cartProvider = context.read<CartProvider>();
      final restaurantProvider = context.read<RestaurantProvider>();
      
      // Show loading dialog
      if (!mounted) return;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );
      
      // Clear current cart
      cartProvider.clearCart();
      
      int successfulItems = 0;
      int failedItems = 0;
      final List<String> unavailableItems = [];
      
      // Fetch menu items for each order item to get full details
      for (final orderItem in order.items) {
        try {
          final menuItem = await restaurantProvider.getMenuItemById(orderItem.menuItemId);
          
          // Convert order customizations to cart customizations
          final customizations = <SelectedCustomization>[];
          if (orderItem.customizations != null) {
            for (final orderCustomization in orderItem.customizations!) {
              // Find matching customization option in menu item
              try {
                final customizationOption = menuItem.customizations.firstWhere(
                  (opt) => opt.name == orderCustomization.optionName,
                );
                
                // Convert choice names to CustomizationChoice objects
                final selectedChoices = <CustomizationChoice>[];
                for (final choiceName in orderCustomization.choices) {
                  try {
                    final choice = customizationOption.choices.firstWhere(
                      (c) => c.name == choiceName,
                    );
                    selectedChoices.add(choice);
                  } catch (e) {
                    AppLogger.warning('Choice $choiceName not found, skipping');
                  }
                }
                
                if (selectedChoices.isNotEmpty) {
                  customizations.add(SelectedCustomization(
                    optionId: customizationOption.id,
                    optionName: customizationOption.name,
                    selectedChoices: selectedChoices,
                  ));
                }
              } catch (e) {
                AppLogger.warning('Customization option ${orderCustomization.optionName} not found, skipping');
              }
            }
          }
          
          // Add item to cart with the correct quantity
          for (int i = 0; i < orderItem.quantity; i++) {
            cartProvider.addItem(
              menuItem: menuItem,
              customizations: customizations,
            );
          }
          
          successfulItems++;
          AppLogger.info('Added ${orderItem.name} to cart (x${orderItem.quantity})');
        } catch (e) {
          failedItems++;
          unavailableItems.add(orderItem.name);
          AppLogger.error('Error fetching menu item ${orderItem.menuItemId}: ${orderItem.name}', error: e);
          // Continue with other items even if one fails
        }
      }
      
      // Close loading dialog
      if (!mounted) return;
      Navigator.pop(context);
      
      // Check if any items were added successfully
      if (successfulItems == 0) {
        // No items could be added - show error and don't navigate
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Unable to reorder. All items from this order are no longer available.',
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
        return;
      }
      
      // Set the restaurant as selected
      try {
        final restaurant = restaurantProvider.restaurants.firstWhere(
          (r) => r.id == order.restaurantId,
        );
        restaurantProvider.selectRestaurant(restaurant);
      } catch (e) {
        AppLogger.warning('Could not find restaurant ${order.restaurantId}');
      }
      
      // Navigate to cart
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const CartScreenV2(),
        ),
      );
      
      // Show success/warning message
      if (failedItems > 0) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Added $successfulItems item(s) to cart. $failedItems item(s) are no longer available:\n${unavailableItems.join(", ")}',
            ),
            backgroundColor: Colors.orange,
            duration: const Duration(seconds: 5),
          ),
        );
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Successfully added all items to cart!'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
      
      AppLogger.info('Reorder completed: $successfulItems items added, $failedItems unavailable');
      
    } catch (e) {
      AppLogger.error('Error reordering', error: e);
      
      // Close loading dialog if still open
      if (mounted) {
        Navigator.pop(context);
        
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to reorder: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }
}

