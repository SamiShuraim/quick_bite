/// Unified Payment Screen for QuickBite application
/// Can be used for both payment method management (profile) and checkout
library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../providers/cart_provider.dart';
import '../providers/payment_provider.dart';
import '../providers/order_provider.dart';
import '../providers/restaurant_provider.dart';
import '../../domain/entities/restaurant_entity.dart';
import '../../domain/entities/saved_card_entity.dart';
import 'add_card_screen.dart';
import 'payment_success_screen.dart';

class UnifiedPaymentScreen extends StatefulWidget {
  /// If amount is provided, this is checkout mode with bottom payment section
  /// If amount is null, this is management mode (from profile)
  final double? amount;
  
  const UnifiedPaymentScreen({
    super.key,
    this.amount,
  });

  @override
  State<UnifiedPaymentScreen> createState() => _UnifiedPaymentScreenState();
}

class _UnifiedPaymentScreenState extends State<UnifiedPaymentScreen> {
  String _selectedPaymentMethod = 'cash';
  SavedCardEntity? _selectedCard;
  bool _isLoading = false;

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
      'id': 'mada',
      'name': 'Mada',
      'logo': 'assets/mada.png',
      'color': const Color(0xFF1B5BA1),
    },
  ];

  bool get isCheckoutMode => widget.amount != null;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadPaymentMethods();
    });
  }

  String _getCardLogoUrl(String cardType) {
    switch (cardType.toLowerCase()) {
      case 'visa':
        return 'https://upload.wikimedia.org/wikipedia/commons/thumb/5/5e/Visa_Inc._logo.svg/2560px-Visa_Inc._logo.svg.png';
      case 'mada':
        // Using a reliable CDN URL for Mada logo
        return 'https://cdn.salla.network/images/logo/mada-logo.png';
      default:
        return '';
    }
  }

  Future<void> _loadPaymentMethods() async {
    final paymentProvider = Provider.of<PaymentProvider>(context, listen: false);
    try {
      await paymentProvider.fetchSavedCards();
    } catch (e) {
      AppLogger.error('Error loading payment methods', error: e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final paymentProvider = Provider.of<PaymentProvider>(context);
    
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
          isCheckoutMode ? 'Payment' : 'Payment Methods',
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
            child: RefreshIndicator(
              onRefresh: _loadPaymentMethods,
              child: paymentProvider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
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
                          _buildCardSection(isDarkMode, paymentProvider),
                          
                  const SizedBox(height: 24),
                  
                  // Add Card Button - only show for card payment methods
                  if (_selectedPaymentMethod != 'cash')
                    InkWell(
                      onTap: () async {
                        final navigator = Navigator.of(context);
                        
                        // Pass the selected card type
                        final result = await navigator.push(
                          MaterialPageRoute(
                            builder: (context) => AddCardScreen(
                              cardType: _selectedPaymentMethod,
                            ),
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
          ),
          
          // Bottom Section - only show in checkout mode
          if (isCheckoutMode)
            _buildBottomSection(context, isDarkMode),
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
            else if (method['logo'] != null)
              Container(
                width: 40,
                height: 40,
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: method['id'] == 'mada' 
                      ? const Color(0xFF1B5BA1) 
                      : Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.grey[300]!,
                  ),
                ),
                child: method['id'] == 'visa'
                    ? Image.network(
                        _getCardLogoUrl(method['id']),
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Center(
                            child: Text(
                              'V',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: method['color'],
                              ),
                            ),
                          );
                        },
                      )
                    : Center(
                        child: Text(
                          'mada',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
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

  Widget _buildCardSection(bool isDarkMode, PaymentProvider paymentProvider) {
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
    
    // Filter cards by selected payment method (case-insensitive)
    List<SavedCardEntity> matchingCards = paymentProvider.savedCards
        .where((c) {
          final cardBrandLower = c.cardBrand.toLowerCase().trim();
          final selectedMethodLower = _selectedPaymentMethod.toLowerCase().trim();
          AppLogger.debug('Comparing card brand: "$cardBrandLower" with selected: "$selectedMethodLower"');
          return cardBrandLower == selectedMethodLower;
        })
        .toList();
    
    AppLogger.debug('Found ${matchingCards.length} matching cards for $_selectedPaymentMethod');
    
    // If no matching cards, show empty state
    if (matchingCards.isEmpty) {
      _selectedCard = null;
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
    
    // Set the first card as selected if none is selected or current selection is not in matching cards
    if (_selectedCard == null || !matchingCards.any((c) => c.id == _selectedCard!.id)) {
      // Try to get default card of this type first
      try {
        _selectedCard = matchingCards.firstWhere((c) => c.isDefault);
      } catch (e) {
        // If no default, just use the first one
        _selectedCard = matchingCards.first;
      }
    }
    
    // Build card displays for all matching cards
    return Column(
      children: matchingCards.map((card) {
        final isSelected = _selectedCard?.id == card.id;
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildCardDisplay(card, isDarkMode, paymentProvider, isSelected),
        );
      }).toList(),
    );
  }

  Widget _buildCardDisplay(SavedCardEntity card, bool isDarkMode, PaymentProvider paymentProvider, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCard = card;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isSelected 
                ? [const Color(0xFFFF7622), const Color(0xFFFF9D5C)]
                : [Colors.grey[600]!, Colors.grey[500]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            if (isSelected)
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
              Row(
                children: [
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
                  // Only show menu in management mode (not checkout)
                  if (!isCheckoutMode) ...[
                    const SizedBox(width: 8),
                    PopupMenuButton<String>(
                      icon: const Icon(
                        Icons.more_vert,
                        color: Colors.white,
                      ),
                      onSelected: (value) async {
                        if (value == 'default') {
                          await _handleSetDefault(card.id, paymentProvider);
                        } else if (value == 'delete') {
                          await _handleDeleteCard(card.id, paymentProvider);
                        }
                      },
                      itemBuilder: (context) => [
                        if (!card.isDefault)
                          const PopupMenuItem(
                            value: 'default',
                            child: Row(
                              children: [
                                Icon(Icons.check_circle_outline),
                                SizedBox(width: 8),
                                Text('Set as Default'),
                              ],
                            ),
                          ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete_outline, color: Colors.red),
                              SizedBox(width: 8),
                              Text('Remove', style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
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
      ),
    );
  }

  Widget _buildBottomSection(BuildContext context, bool isDarkMode) {
    final cartProvider = Provider.of<CartProvider>(context);
    
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
                      CurrencyFormatter.format(widget.amount!),
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

  Future<void> _handleSetDefault(String cardId, PaymentProvider paymentProvider) async {
    try {
      await paymentProvider.setDefaultCard(cardId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Default card updated'),
            backgroundColor: Colors.green,
          ),
        );
        // Reload to update UI
        await _loadPaymentMethods();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update default card: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _handleDeleteCard(String cardId, PaymentProvider paymentProvider) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Card'),
        content: const Text('Are you sure you want to remove this card?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('REMOVE'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await paymentProvider.deleteSavedCard(cardId);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Card removed successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to remove card: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
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
    RestaurantEntity? currentRestaurant = restaurantProvider.selectedRestaurant;
    
    // Fallback: If no restaurant is selected but cart has items, 
    // try to get restaurant from cart items
    if (currentRestaurant == null && cartProvider.items.isNotEmpty) {
      final restaurantId = cartProvider.items.first.menuItem.restaurantId;
      
      // Try to find the restaurant in the list of restaurants
      try {
        currentRestaurant = restaurantProvider.restaurants.firstWhere(
          (r) => r.id == restaurantId,
        );
        
        // Set it as selected for future reference
        restaurantProvider.selectRestaurant(currentRestaurant);
      } catch (e) {
        AppLogger.error('Restaurant not found in list', error: e);
      }
    }
    
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
        'street': 'Building 24, Academic Belt Road',
        'city': 'Dhahran',
        'state': 'Eastern Province',
        'zipCode': '31261',
        'country': 'Saudi Arabia',
        'fullAddress': 'Building 24, Academic Belt Road, Dhahran 31261',
        'latitude': 26.3045,
        'longitude': 50.1437,
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

