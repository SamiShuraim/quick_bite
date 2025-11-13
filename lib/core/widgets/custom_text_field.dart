/// Custom Text Field
/// Reusable text input field component
library;

import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final String placeholder;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextInputType keyboardType;
  final IconData? prefixIcon;
  final bool enabled;
  final int maxLines;

  const CustomTextField({
    super.key,
    required this.label,
    required this.placeholder,
    required this.controller,
    this.validator,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.enabled = true,
    this.maxLines = 1,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          widget.label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: AppConstants.fontWeightMedium,
              ),
        ),
        const SizedBox(height: AppConstants.smallPadding / 2),

        // Text Field
        TextFormField(
          controller: widget.controller,
          obscureText: _obscureText,
          keyboardType: widget.keyboardType,
          enabled: widget.enabled,
          maxLines: _obscureText ? 1 : widget.maxLines,
          style: Theme.of(context).textTheme.bodyMedium,
          validator: widget.validator,
          decoration: InputDecoration(
            hintText: widget.placeholder,
            hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isDarkMode
                      ? AppColors.darkTextSecondary
                      : AppColors.textSecondary,
                ),
            prefixIcon: widget.prefixIcon != null
                ? Icon(
                    widget.prefixIcon,
                    color: AppColors.primary,
                  )
                : null,
            suffixIcon: widget.obscureText
                ? IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      color: isDarkMode
                          ? AppColors.darkTextSecondary
                          : AppColors.textSecondary,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  )
                : null,
            filled: true,
            fillColor: isDarkMode
                ? AppColors.darkSurface
                : AppColors.lightBackground,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppConstants.mediumPadding,
              vertical: AppConstants.mediumPadding,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                AppConstants.buttonBorderRadius,
              ),
              borderSide: BorderSide(
                color: isDarkMode
                    ? AppColors.darkBorder
                    : AppColors.lightBorder,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                AppConstants.buttonBorderRadius,
              ),
              borderSide: BorderSide(
                color: isDarkMode
                    ? AppColors.darkBorder
                    : AppColors.lightBorder,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                AppConstants.buttonBorderRadius,
              ),
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 2.0,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                AppConstants.buttonBorderRadius,
              ),
              borderSide: const BorderSide(
                color: AppColors.error,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                AppConstants.buttonBorderRadius,
              ),
              borderSide: const BorderSide(
                color: AppColors.error,
                width: 2.0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

