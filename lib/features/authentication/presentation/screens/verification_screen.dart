/// Email Verification screen for QuickBite application
/// Handles email verification with 4-digit code
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../../core/widgets/custom_button.dart';

class VerificationScreen extends StatefulWidget {
  final String email;

  const VerificationScreen({
    super.key,
    required this.email,
  });

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final List<TextEditingController> _controllers = List.generate(
    4,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(
    4,
    (index) => FocusNode(),
  );
  bool _isLoading = false;
  bool _canResend = false;
  int _resendTimer = 60;

  @override
  void initState() {
    super.initState();
    AppLogger.lifecycle('VerificationScreen', 'initState');
    _startResendTimer();
  }

  @override
  void dispose() {
    AppLogger.lifecycle('VerificationScreen', 'dispose');
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _startResendTimer() {
    setState(() {
      _canResend = false;
      _resendTimer = 60;
    });

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted && _resendTimer > 0) {
        setState(() {
          _resendTimer--;
        });
        _startResendTimer();
      } else if (mounted) {
        setState(() {
          _canResend = true;
        });
      }
    });
  }

  String _getVerificationCode() {
    return _controllers.map((c) => c.text).join();
  }

  bool _isCodeComplete() {
    return _getVerificationCode().length == 4;
  }

  Future<void> _handleVerify() async {
    if (!_isCodeComplete()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter the complete verification code'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final code = _getVerificationCode();
      AppLogger.info('Verifying code: $code');

      // TODO: Call verification API
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call

      if (!mounted) return;

      // Show success and navigate to home
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email verified successfully!'),
          backgroundColor: AppColors.success,
        ),
      );

      // TODO: Navigate to home screen
      AppLogger.info('Verification successful');
    } catch (e) {
      AppLogger.error('Verification error', error: e);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid verification code. Please try again.'),
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

  Future<void> _handleResend() async {
    if (!_canResend) return;

    setState(() {
      _isLoading = true;
    });

    try {
      AppLogger.info('Resending verification code to: ${widget.email}');

      // TODO: Call resend verification API
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Verification code sent!'),
          backgroundColor: AppColors.success,
        ),
      );

      _startResendTimer();
    } catch (e) {
      AppLogger.error('Resend error', error: e);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to resend code. Please try again.'),
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: AppConstants.largePadding),

              // Logo
              Container(
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

              const SizedBox(height: AppConstants.defaultPadding),

              // Title
              Text(
                'Verification',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: AppConstants.fontWeightBold,
                    ),
              ),

              const SizedBox(height: AppConstants.smallPadding / 2),

              // Subtitle
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.defaultPadding,
                ),
                child: Text(
                  'We have sent a code to your email\n${widget.email}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isDarkMode
                            ? AppColors.darkTextSecondary
                            : AppColors.textSecondary,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: AppConstants.largePadding * 2),

              // Code input fields
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (index) {
                  return Container(
                    margin: EdgeInsets.only(
                      right: index < 3 ? AppConstants.mediumPadding : 0,
                    ),
                    child: _buildCodeInput(index),
                  );
                }),
              ),

              const SizedBox(height: AppConstants.largePadding),

              // Verify button
              CustomButton(
                text: _isLoading ? 'Verifying...' : 'VERIFY',
                onPressed: _isLoading ? null : _handleVerify,
                isFullWidth: true,
              ),

              const SizedBox(height: AppConstants.defaultPadding),

              // Resend code
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Didn't receive code? ",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  if (_canResend)
                    TextButton(
                      onPressed: _isLoading ? null : _handleResend,
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(0, 0),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        'Resend',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.primary,
                              fontWeight: AppConstants.fontWeightBold,
                            ),
                      ),
                    )
                  else
                    Text(
                      'Resend in ${_resendTimer}s',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: isDarkMode
                                ? AppColors.darkTextSecondary
                                : AppColors.textSecondary,
                          ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCodeInput(int index) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkSurface : AppColors.lightBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _focusNodes[index].hasFocus
              ? AppColors.primary
              : (isDarkMode ? AppColors.darkBorder : AppColors.lightBorder),
          width: _focusNodes[index].hasFocus ? 2 : 1,
        ),
      ),
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        enabled: !_isLoading,
        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: AppConstants.fontWeightBold,
            ),
        decoration: const InputDecoration(
          counterText: '',
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
        ),
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        onChanged: (value) {
          if (value.isNotEmpty && index < 3) {
            // Move to next field
            _focusNodes[index + 1].requestFocus();
          } else if (value.isEmpty && index > 0) {
            // Move to previous field
            _focusNodes[index - 1].requestFocus();
          }

          // Auto-verify when all fields are filled
          if (_isCodeComplete()) {
            FocusScope.of(context).unfocus();
          }
        },
      ),
    );
  }
}

