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
import '../../../restaurant/domain/entities/order_entity.dart';
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
                  _buildFilterChip('Confirmed', 'confirmed', isDarkMode),
                  const SizedBox(width: 8),
                  _buildFilterChip('Preparing', 'preparing', isDarkMode),
                  const SizedBox(width: 8),
                  _buildFilterChip('Delivering', 'out_for_delivery', isDarkMode),
                  const SizedBox(width: 8),
                  _buildFilterChip('Completed', 'delivered', isDarkMode),
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
                        order.restaurantId, // Would be restaurant name in real app
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
}

