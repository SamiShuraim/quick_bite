/// Add Card Screen for QuickBite application
/// Follows new design mockup
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_logger.dart';
import '../providers/payment_provider.dart';

class AddCardScreen extends StatefulWidget {
  const AddCardScreen({super.key});

  @override
  State<AddCardScreen> createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _cardHolderController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _cardNumberController.dispose();
    _cardHolderController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  String _detectCardBrand(String cardNumber) {
    final cleaned = cardNumber.replaceAll(' ', '');
    if (cleaned.isEmpty) return 'visa';
    
    // Visa: starts with 4
    if (cleaned.startsWith('4')) return 'visa';
    
    // Mastercard: starts with 51-55 or 2221-2720
    if (cleaned.startsWith(RegExp(r'^5[1-5]'))) return 'mastercard';
    if (int.tryParse(cleaned.substring(0, 4)) case final num when num != null && num >= 2221 && num <= 2720) {
      return 'mastercard';
    }
    
    // American Express: starts with 34 or 37
    if (cleaned.startsWith(RegExp(r'^3[47]'))) return 'amex';
    
    // Discover: starts with 6011, 622126-622925, 644-649, 65
    if (cleaned.startsWith('6011') || cleaned.startsWith('65')) return 'discover';
    
    return 'visa'; // default
  }

  Future<void> _handleAddCard() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final paymentProvider = context.read<PaymentProvider>();
      
      final cardBrand = _detectCardBrand(_cardNumberController.text);
      
      await paymentProvider.addSavedCard(
        cardNumber: _cardNumberController.text,
        cardBrand: cardBrand,
        cardHolderName: _cardHolderController.text,
        expiryDate: _expiryController.text,
        cvv: _cvvController.text,
        isDefault: false,
      );

      if (mounted) {
        Navigator.pop(context, true); // Return true to indicate success
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Card added successfully!'),
            backgroundColor: AppColors.success,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      AppLogger.error('Error adding card', error: e);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add card: ${e.toString()}'),
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

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF0A0A0F) : Colors.white,
      appBar: AppBar(
        backgroundColor: isDarkMode ? const Color(0xFF0A0A0F) : Colors.white,
        elevation: 0,
        leading: Row(
          children: [
            const SizedBox(width: 16),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(
                  Icons.close,
                  color: Colors.black,
                  size: 18,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
        leadingWidth: 56,
        title: const Text(
          'Add Card',
          style: TextStyle(
            color: AppColors.primary,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'CARD HOLDER NAME',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 8),
              
              // Card Holder Name
              TextFormField(
                controller: _cardHolderController,
                keyboardType: TextInputType.name,
                onChanged: (value) => setState(() {}),
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                  fontSize: 16,
                ),
                decoration: InputDecoration(
                  hintText: 'Vipul Khadse',
                  hintStyle: TextStyle(
                    color: isDarkMode ? Colors.grey[600] : Colors.grey[400],
                  ),
                  filled: true,
                  fillColor: isDarkMode ? const Color(0xFF1E1E2E) : const Color(0xFFF5F5F5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'This field is required';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 20),
              
              // Card Number
              Text(
                'CARD NUMBER',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _cardNumberController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(16),
                  _CardNumberFormatter(),
                ],
                onChanged: (value) => setState(() {}),
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                  fontSize: 16,
                ),
                decoration: InputDecoration(
                  hintText: '2134 ____ ____ ____',
                  hintStyle: TextStyle(
                    color: isDarkMode ? Colors.grey[600] : Colors.grey[400],
                  ),
                  filled: true,
                  fillColor: isDarkMode ? const Color(0xFF1E1E2E) : const Color(0xFFF5F5F5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'This field is required';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 20),
              
              // Expiry and CVV Row
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'EXPIRY DATE',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _expiryController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(4),
                            _ExpiryDateFormatter(),
                          ],
                          onChanged: (value) => setState(() {}),
                          style: TextStyle(
                            color: isDarkMode ? Colors.white : Colors.black,
                            fontSize: 16,
                          ),
                          decoration: InputDecoration(
                            hintText: '12/2027',
                            hintStyle: TextStyle(
                              color: isDarkMode ? Colors.grey[600] : Colors.grey[400],
                            ),
                            filled: true,
                            fillColor: isDarkMode ? const Color(0xFF1E1E2E) : const Color(0xFFF5F5F5),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'CVV',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _cvvController,
                          keyboardType: TextInputType.number,
                          obscureText: true,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(3),
                          ],
                          onChanged: (value) => setState(() {}),
                          style: TextStyle(
                            color: isDarkMode ? Colors.white : Colors.black,
                            fontSize: 16,
                          ),
                          decoration: InputDecoration(
                            hintText: '•••',
                            hintStyle: TextStyle(
                              color: isDarkMode ? Colors.grey[600] : Colors.grey[400],
                            ),
                            filled: true,
                            fillColor: isDarkMode ? const Color(0xFF1E1E2E) : const Color(0xFFF5F5F5),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 120),
              
              // Add & Make Payment Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleAddCard,
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
                          'ADD & MAKE PAYMENT',
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
      ),
    );
  }

}

// Card Number Formatter
class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll(' ', '');
    final buffer = StringBuffer();
    
    for (int i = 0; i < text.length; i++) {
      if (i > 0 && i % 4 == 0) {
        buffer.write(' ');
      }
      buffer.write(text[i]);
    }
    
    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}

// Expiry Date Formatter
class _ExpiryDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll('/', '');
    final buffer = StringBuffer();
    
    for (int i = 0; i < text.length && i < 4; i++) {
      if (i == 2) {
        buffer.write('/');
      }
      buffer.write(text[i]);
    }
    
    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}

