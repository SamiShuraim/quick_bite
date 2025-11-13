/// Reusable onboarding content widget
library;

import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';

class OnboardingContent extends StatelessWidget {
  final String title;
  final String description;
  final Widget? image;

  const OnboardingContent({
    super.key,
    required this.title,
    required this.description,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: AppConstants.largePadding),
        
        // Image/Illustration
        _buildImagePlaceholder(context),
        
        const SizedBox(height: AppConstants.largePadding),
        
        // Title
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: AppConstants.smallPadding),
        
        // Description
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.mediumPadding,
          ),
          child: Text(
            description,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
          ),
        ),
      ],
    );
  }

  Widget _buildImagePlaceholder(BuildContext context) {
    if (image != null) {
      return SizedBox(
        height: AppConstants.onboardingImageHeight,
        width: double.infinity,
        child: image,
      );
    }

    // Default placeholder with rounded corners
    return Container(
      height: AppConstants.onboardingImageHeight,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(
        horizontal: AppConstants.defaultPadding,
      ),
      decoration: BoxDecoration(
        color: AppColors.imagePlaceholder,
        borderRadius: BorderRadius.circular(AppConstants.buttonBorderRadius),
      ),
      child: const Center(
        child: Icon(
          Icons.restaurant_menu,
          size: 60,
          color: AppColors.textOnPrimary,
        ),
      ),
    );
  }
}

