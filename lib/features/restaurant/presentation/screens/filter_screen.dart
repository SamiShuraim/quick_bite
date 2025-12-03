/// Filter screen for QuickBite application
/// Allows users to filter restaurants
library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';
import '../providers/restaurant_provider.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  late RangeValues _priceRange;
  late double _maxDistance;
  late Set<String> _selectedFilters;
  
  @override
  void initState() {
    super.initState();
    // Initialize with current filter values from provider
    final provider = Provider.of<RestaurantProvider>(context, listen: false);
    _priceRange = RangeValues(provider.minPrice, provider.maxPrice);
    _maxDistance = provider.maxDistance;
    _selectedFilters = Set.from(provider.selectedFilters);
  }

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
                _priceRange = const RangeValues(0, 100);
                _maxDistance = 20;
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
                '${_priceRange.start.round()} SAR',
                '${_priceRange.end.round()} SAR',
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
                  '${_priceRange.start.round()} SAR',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isDarkMode
                            ? AppColors.darkTextSecondary
                            : AppColors.textSecondary,
                      ),
                ),
                Text(
                  '${_priceRange.end.round()} SAR',
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

            // Filters
            Text(
              'Filters',
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
            // Apply filters to provider
            final provider = Provider.of<RestaurantProvider>(context, listen: false);
            provider.applyAdvancedFilters(
              minPrice: _priceRange.start,
              maxPrice: _priceRange.end,
              maxDistance: _maxDistance,
              paymentMethods: {}, // Empty set - all restaurants accept all payment methods
              filters: _selectedFilters,
            );
            
            // Go back
            Navigator.pop(context);
            
            // Show success message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Filters applied${_selectedFilters.isNotEmpty ? ": ${_selectedFilters.join(", ")}" : ""}',
                ),
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

