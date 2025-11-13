/// Reusable custom button widget for QuickBite application
library;

import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';
import '../utils/app_logger.dart';

enum ButtonType {
  primary,
  secondary,
  text,
}

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonType type;
  final bool isFullWidth;
  final double? width;
  final double? height;
  final IconData? icon;
  final bool isLoading;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = ButtonType.primary,
    this.isFullWidth = false,
    this.width,
    this.height,
    this.icon,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final buttonWidth = isFullWidth ? double.infinity : width;
    final buttonHeight = height ?? AppConstants.buttonHeight;

    Widget buttonChild = isLoading
        ? SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                type == ButtonType.primary
                    ? AppColors.textOnPrimary
                    : AppColors.primary,
              ),
            ),
          )
        : _buildButtonContent();

    return SizedBox(
      width: buttonWidth,
      height: buttonHeight,
      child: _buildButton(buttonChild),
    );
  }

  Widget _buildButtonContent() {
    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Text(text),
        ],
      );
    }
    return Text(text);
  }

  Widget _buildButton(Widget child) {
    switch (type) {
      case ButtonType.primary:
        return ElevatedButton(
          onPressed: isLoading ? null : _handlePressed,
          child: child,
        );
      case ButtonType.secondary:
        return OutlinedButton(
          onPressed: isLoading ? null : _handlePressed,
          child: child,
        );
      case ButtonType.text:
        return TextButton(
          onPressed: isLoading ? null : _handlePressed,
          child: child,
        );
    }
  }

  void _handlePressed() {
    AppLogger.userAction('Button Pressed', details: {'buttonText': text});
    onPressed?.call();
  }
}

