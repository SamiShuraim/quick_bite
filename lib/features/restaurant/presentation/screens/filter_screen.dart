/// Filter screen for QuickBite application
/// Allows users to filter restaurants
library;

import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  RangeValues _priceRange = const RangeValues(0, 50);
  double _maxDistance = 10;
  final Set<String> _selectedPaymentMethods = {'Credit Card'};
  final Set<String> _selectedFilters = {};

  final List<String> _paymentMethods = [
    'Credit Card',
    'Debit Card',
    'Online Payment',
    'Cash on Delivery',
  ];

  final List<String> _filters = [
    'Free Delivery',
    'Popular',
    'Open Now',
    'Top Rated',
    'Vegetarian',
    'Fast Delivery',
  ];

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Filter'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _priceRange = const RangeValues(0, 50);
                _maxDistance = 10;
                _selectedPaymentMethods.clear();
                _selectedPaymentMethods.add('Credit Card');
                _selectedFilters.clear();
              });
            },
            child: const Text(
              'Reset',
              style: TextStyle(color: AppColors.primary),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Price Range
            Text(
              'Price Range',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: AppConstants.fontWeightBold,
                  ),
            ),
            const SizedBox(height: 12),
            RangeSlider(
              values: _priceRange,
              min: 0,
              max: 100,
              divisions: 20,
              activeColor: AppColors.primary,
              labels: RangeLabels(
                '\$${_priceRange.start.round()}',
                '\$${_priceRange.end.round()}',
              ),
              onChanged: (values) {
                setState(() {
                  _priceRange = values;
                });
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '\$${_priceRange.start.round()}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isDarkMode
                            ? AppColors.darkTextSecondary
                            : AppColors.textSecondary,
                      ),
                ),
                Text(
                  '\$${_priceRange.end.round()}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isDarkMode
                            ? AppColors.darkTextSecondary
                            : AppColors.textSecondary,
                      ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Distance
            Text(
              'Distance',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: AppConstants.fontWeightBold,
                  ),
            ),
            const SizedBox(height: 12),
            Slider(
              value: _maxDistance,
              min: 1,
              max: 20,
              divisions: 19,
              activeColor: AppColors.primary,
              label: '${_maxDistance.round()} km',
              onChanged: (value) {
                setState(() {
                  _maxDistance = value;
                });
              },
            ),
            Text(
              'Up to ${_maxDistance.round()} km',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isDarkMode
                        ? AppColors.darkTextSecondary
                        : AppColors.textSecondary,
                  ),
            ),

            const SizedBox(height: 32),

            // Payment Methods
            Text(
              'Payment Methods',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: AppConstants.fontWeightBold,
                  ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _paymentMethods.map((method) {
                final isSelected = _selectedPaymentMethods.contains(method);
                return FilterChip(
                  label: Text(method),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedPaymentMethods.add(method);
                      } else {
                        _selectedPaymentMethods.remove(method);
                      }
                    });
                  },
                  selectedColor: AppColors.primary.withOpacity(0.2),
                  checkmarkColor: AppColors.primary,
                  backgroundColor: isDarkMode
                      ? AppColors.darkCardBackground
                      : AppColors.cardBackground,
                  labelStyle: TextStyle(
                    color: isSelected
                        ? AppColors.primary
                        : (isDarkMode
                            ? AppColors.darkTextPrimary
                            : AppColors.textPrimary),
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 32),

            // Additional Filters
            Text(
              'Additional Filters',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: AppConstants.fontWeightBold,
                  ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _filters.map((filter) {
                final isSelected = _selectedFilters.contains(filter);
                return FilterChip(
                  label: Text(filter),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedFilters.add(filter);
                      } else {
                        _selectedFilters.remove(filter);
                      }
                    });
                  },
                  selectedColor: AppColors.primary.withOpacity(0.2),
                  checkmarkColor: AppColors.primary,
                  backgroundColor: isDarkMode
                      ? AppColors.darkCardBackground
                      : AppColors.cardBackground,
                  labelStyle: TextStyle(
                    color: isSelected
                        ? AppColors.primary
                        : (isDarkMode
                            ? AppColors.darkTextPrimary
                            : AppColors.textPrimary),
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 32),
          ],
        ),
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
          text: 'APPLY FILTERS',
          onPressed: () {
            // Apply filters and go back
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Filters applied successfully'),
                backgroundColor: AppColors.success,
              ),
            );
          },
          isFullWidth: true,
        ),
      ),
    );
  }
}

