/// Forgot Password screen for QuickBite application
/// Handles password reset request
library;

import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    AppLogger.lifecycle('ForgotPasswordScreen', 'initState');
  }

  @override
  void dispose() {
    AppLogger.lifecycle('ForgotPasswordScreen', 'dispose');
    _emailController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  Future<void> _handleSendCode() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final email = _emailController.text.trim();
      AppLogger.info('Sending password reset code to: $email');

      // TODO: Call forgot password API
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call

      if (!mounted) return;

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password reset code sent to your email!'),
          backgroundColor: AppColors.success,
        ),
      );

      // Navigate back after success
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          Navigator.pop(context);
        }
      });
    } catch (e) {
      AppLogger.error('Forgot password error', error: e);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to send reset code. Please try again.'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDarkMode ? AppColors.darkTextPrimary : AppColors.textPrimary,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppConstants.largePadding),

                // Logo
                Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Center(
                      child: Text(
                        '🍔',
                        style: TextStyle(fontSize: 40),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: AppConstants.defaultPadding),

                // Title
                Center(
                  child: Text(
                    'Forgot Password',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          fontWeight: AppConstants.fontWeightBold,
                        ),
                  ),
                ),

                const SizedBox(height: AppConstants.smallPadding / 2),

                // Subtitle
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.defaultPadding,
                    ),
                    child: Text(
                      'Please sign in to your existing account',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: isDarkMode
                                ? AppColors.darkTextSecondary
                                : AppColors.textSecondary,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),

                const SizedBox(height: AppConstants.largePadding * 1.5),

                // Email field
                CustomTextField(
                  label: 'EMAIL',
                  placeholder: 'example@gmail.com',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icons.email_outlined,
                  validator: _validateEmail,
                  enabled: !_isLoading,
                ),

                const SizedBox(height: AppConstants.largePadding),

                // Send Code Button
                CustomButton(
                  text: _isLoading ? 'Sending...' : 'SEND CODE',
                  onPressed: _isLoading ? null : _handleSendCode,
                  isFullWidth: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

