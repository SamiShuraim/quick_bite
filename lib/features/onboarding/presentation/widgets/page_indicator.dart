/// Reusable page indicator widget for onboarding and carousels
library;

import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';

class PageIndicator extends StatelessWidget {
  final int currentPage;
  final int pageCount;
  final Color? activeColor;
  final Color? inactiveColor;
  final double? size;
  final double? spacing;

  const PageIndicator({
    super.key,
    required this.currentPage,
    required this.pageCount,
    this.activeColor,
    this.inactiveColor,
    this.size,
    this.spacing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        pageCount,
        (index) => _buildIndicatorDot(index),
      ),
    );
  }

  Widget _buildIndicatorDot(int index) {
    final isActive = index == currentPage;
    final dotSize = size ?? AppConstants.pageIndicatorSize;
    final dotSpacing = spacing ?? AppConstants.pageIndicatorSpacing;

    return AnimatedContainer(
      duration: const Duration(
        milliseconds: AppConstants.indicatorAnimationMilliseconds,
      ),
      margin: EdgeInsets.symmetric(horizontal: dotSpacing),
      width: dotSize,
      height: dotSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive
            ? (activeColor ?? AppColors.indicatorActive)
            : (inactiveColor ?? AppColors.indicatorInactive),
      ),
    );
  }
}

