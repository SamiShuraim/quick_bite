/// Payment Method Screen for QuickBite application
/// Follows new design mockup
library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_logger.dart';
import '../providers/cart_provider.dart';
import '../providers/payment_provider.dart';
import '../providers/order_provider.dart';
import '../providers/restaurant_provider.dart';
import '../../domain/entities/saved_card_entity.dart';
import 'add_card_screen.dart';
import 'payment_success_screen.dart';

class PaymentMethodScreen extends StatefulWidget {
  const PaymentMethodScreen({super.key});

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  String _selectedPaymentMethod = 'cash';
  bool _isLoading = false;
  SavedCardEntity? _selectedCard;

  @override
  void initState() {
    super.initState();
    // Fetch saved cards on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PaymentProvider>().fetchSavedCards();
    });
  }
  
  final List<Map<String, dynamic>> _paymentMethods = [
    {
      'id': 'cash',
      'name': 'Cash',
      'icon': Icons.payments_outlined,
      'color': const Color(0xFF4CAF50),
    },
    {
      'id': 'visa',
      'name': 'Visa',
      'logo': 'assets/visa.png',
      'color': const Color(0xFF1A1F71),
    },
    {
      'id': 'mastercard',
      'name': 'Mastercard',
      'logo': 'assets/mastercard.png',
      'color': const Color(0xFFEB001B),
    },
    {
      'id': 'paypal',
      'name': 'Paypal',
      'logo': 'assets/paypal.png',
      'color': const Color(0xFF003087),
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF1E1E2E) : const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: isDarkMode ? const Color(0xFF1E1E2E) : const Color(0xFFF5F5F5),
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: isDarkMode ? Colors.white : Colors.black,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Payment',
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Payment Methods
                  Row(
                    children: _paymentMethods.map((method) {
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: _buildPaymentMethodCard(
                            method: method,
                            isSelected: _selectedPaymentMethod == method['id'],
                            isDarkMode: isDarkMode,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Card Section
                  _buildCardSection(isDarkMode),
                  
                  const SizedBox(height: 24),
                  
                  // Add Card Button
                  InkWell(
                    onTap: () async {
                      final navigator = Navigator.of(context);
                      final paymentProvider = context.read<PaymentProvider>();
                      
                      final result = await navigator.push(
                        MaterialPageRoute(
                          builder: (context) => const AddCardScreen(),
                        ),
                      );
                      
                      // Refresh cards if card was added
                      if (result == true && mounted) {
                        await paymentProvider.fetchSavedCards();
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.3),
                          width: 2,
                          style: BorderStyle.solid,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add,
                            color: AppColors.primary,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'ADD CARD',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
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
          
          // Bottom Section
          _buildBottomSection(context, isDarkMode, cartProvider),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodCard({
    required Map<String, dynamic> method,
    required bool isSelected,
    required bool isDarkMode,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPaymentMethod = method['id'];
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: isDarkMode ? const Color(0xFF2A2A3E) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected 
                ? AppColors.primary 
                : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: AppColors.primary.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Column(
          children: [
            if (method['icon'] != null)
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: method['color'].withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  method['icon'],
                  color: method['color'],
                  size: 24,
                ),
              )
            else
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.grey[300]!,
                  ),
                ),
                child: Center(
                  child: Text(
                    method['name'][0],
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: method['color'],
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 8),
            Text(
              method['name'],
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardSection(bool isDarkMode) {
    if (_selectedPaymentMethod == 'cash') {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF4CAF50), Color(0xFF45A049)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF4CAF50).withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Cash Payment',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(
                  Icons.payments,
                  color: Colors.white.withOpacity(0.8),
                  size: 32,
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Pay with cash when your order arrives',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }
    
    // Card display - use saved cards
    final paymentProvider = context.watch<PaymentProvider>();
    SavedCardEntity? card;
    
    try {
      card = paymentProvider.savedCards.firstWhere(
        (c) => c.cardBrand == _selectedPaymentMethod,
      );
    } catch (e) {
      // If no card matches the selected method, use default or first available
      card = paymentProvider.defaultCard ?? 
             (paymentProvider.savedCards.isNotEmpty ? paymentProvider.savedCards.first : null);
    }
    
    _selectedCard = card;
    
    if (card == null) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDarkMode ? const Color(0xFF2A2A3E) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.primary.withOpacity(0.3),
            width: 2,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          children: [
            Icon(
              Icons.credit_card_outlined,
              size: 48,
              color: isDarkMode ? Colors.grey[600] : Colors.grey[400],
            ),
            const SizedBox(height: 12),
            Text(
              'No saved ${_selectedPaymentMethod.toUpperCase()} cards',
              style: TextStyle(
                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add a card to continue',
              style: TextStyle(
                color: isDarkMode ? Colors.grey[600] : Colors.grey[400],
                fontSize: 12,
              ),
            ),
          ],
        ),
      );
    }
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF7622), Color(0xFFFF9D5C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                card.cardBrand.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (card.isDefault)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: Colors.white,
                        size: 16,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Default',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            '•••• •••• •••• ${card.cardLast4}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w600,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Card Holder',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 10,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    card.cardHolderName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Expiry',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 10,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${card.expiryMonth}/${card.expiryYear.substring(2)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSection(
    BuildContext context,
    bool isDarkMode,
    CartProvider cartProvider,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF2A2A3E) : Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Total Price
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total:',
                  style: TextStyle(
                    fontSize: 16,
                    color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
                Row(
                  children: [
                    Text(
                      '\$${cartProvider.total.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // PAY & CONFIRM Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isLoading ? null : () => _showOrderConfirmation(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  disabledBackgroundColor: AppColors.primary.withOpacity(0.6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'PAY & CONFIRM',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showOrderConfirmation(BuildContext context) async {
    if (_isLoading) return;
    
    final cartProvider = context.read<CartProvider>();
    final orderProvider = context.read<OrderProvider>();
    final restaurantProvider = context.read<RestaurantProvider>();
    
    // Validate cart is not empty
    if (cartProvider.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Your cart is empty'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    // Validate restaurant is selected
    final currentRestaurant = restaurantProvider.selectedRestaurant;
    if (currentRestaurant == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No restaurant selected'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    // Validate payment method for cards
    if (_selectedPaymentMethod != 'cash' && _selectedCard == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add a card or select cash payment'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    setState(() => _isLoading = true);
    
    try {
      // Prepare order items
      final items = cartProvider.items.map((cartItem) {
        return {
          'menuItemId': cartItem.menuItem.id,
          'name': cartItem.menuItem.name,
          'price': cartItem.menuItem.price,
          'quantity': cartItem.quantity,
          'imageUrl': cartItem.menuItem.imageUrl,
          'customizations': cartItem.customizations.map((c) => {
            'optionName': c.optionName,
            'choices': c.selectedChoices.map((choice) => choice.name).toList(),
          }).toList(),
          'subtotal': cartItem.totalPrice,
        };
      }).toList();
      
      // Prepare delivery address (using mock data - in real app, get from user profile or input)
      final deliveryAddress = {
        'street': '123 Main Street',
        'city': 'San Francisco',
        'state': 'CA',
        'zipCode': '94102',
        'country': 'USA',
        'fullAddress': '123 Main Street, San Francisco, CA 94102',
        'latitude': 37.7749,
        'longitude': -122.4194,
      };
      
      // Prepare payment details
      final paymentDetails = {
        'method': _selectedPaymentMethod == 'cash' ? 'cash' : 'card',
        if (_selectedCard != null) 'cardLast4': _selectedCard!.cardLast4,
        if (_selectedCard != null) 'cardBrand': _selectedCard!.cardBrand,
      };
      
      // Create order
      final order = await orderProvider.createOrder(
        restaurantId: currentRestaurant.id,
        items: items,
        deliveryAddress: deliveryAddress,
        paymentDetails: paymentDetails,
        subtotal: cartProvider.subtotal,
        deliveryFee: cartProvider.deliveryFee,
        tax: cartProvider.tax,
        total: cartProvider.total,
      );
      
      AppLogger.userAction('Order Placed', details: {
        'orderNumber': order.orderNumber,
        'paymentMethod': _selectedPaymentMethod,
        'total': order.total,
      });
      
      // Clear cart after successful order
      cartProvider.clearCart();
      
      if (mounted) {
        // Store navigator before async gap
        final navigator = Navigator.of(context);
        
        // Navigate to success screen
        navigator.pushReplacement(
          MaterialPageRoute(
            builder: (context) => PaymentSuccessScreen(order: order),
          ),
        );
      }
    } catch (e) {
      AppLogger.error('Error creating order', error: e);
      if (mounted) {
        // Store messenger before async gap
        final messenger = ScaffoldMessenger.of(context);
        
        messenger.showSnackBar(
          SnackBar(
            content: Text('Failed to place order: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}

