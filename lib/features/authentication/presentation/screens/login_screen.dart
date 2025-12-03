/// Login screen for QuickBite application
/// Handles user authentication with email and password
library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../providers/auth_provider.dart';
import 'signup_screen.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    AppLogger.lifecycle('LoginScreen', 'initState');
    
    // Show test account dialog and prepopulate fields after frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showTestAccountDialog();
    });
  }
  
  void _showTestAccountDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.info_outline,
                  color: AppColors.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Test Account',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          content: const Text(
            'For testing simplicity, an account we used throughout the whole development journey is provided. However, if you want to create your own account, you are free to do so.',
            style: TextStyle(fontSize: 15, height: 1.5),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Prepopulate the fields after dialog is dismissed
                _emailController.text = 'sam.shuraim@gmail.com';
                _passwordController.text = '12345678*&Ss';
              },
              style: TextButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'OK',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    AppLogger.lifecycle('LoginScreen', 'dispose');
    _emailController.dispose();
    _passwordController.dispose();
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

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final success = await authProvider.login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (!mounted) return;

      if (success) {
        // Navigate to home screen
        AppLogger.info('Login successful, navigating to home');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login successful!'),
            backgroundColor: AppColors.success,
            duration: Duration(seconds: 1),
          ),
        );
        
        // Navigate to home and remove all previous routes
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            Navigator.pushReplacementNamed(context, '/home');
          }
        });
      } else {
        // Show error message
        final errorMessage = authProvider.errorMessage ?? 'Login failed';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } catch (e) {
      AppLogger.error('Login error', error: e);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('An error occurred. Please try again.'),
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

  void _navigateToSignUp() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SignUpScreen()),
    );
  }

  void _navigateToForgotPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                    'Log In',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          fontWeight: AppConstants.fontWeightBold,
                        ),
                  ),
                ),

                const SizedBox(height: AppConstants.smallPadding / 2),

                // Subtitle
                Center(
                  child: Text(
                    'Please sign in to your existing account',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: isDarkMode
                              ? AppColors.darkTextSecondary
                              : AppColors.textSecondary,
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

                const SizedBox(height: AppConstants.mediumPadding),

                // Password field
                CustomTextField(
                  label: 'PASSWORD',
                  placeholder: '••••••••',
                  controller: _passwordController,
                  obscureText: true,
                  prefixIcon: Icons.lock_outline,
                  validator: _validatePassword,
                  enabled: !_isLoading,
                ),

                const SizedBox(height: AppConstants.smallPadding),

                // Forgot Password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _isLoading ? null : _navigateToForgotPassword,
                    child: Text(
                      'Forgot Password?',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.primary,
                            fontWeight: AppConstants.fontWeightMedium,
                          ),
                    ),
                  ),
                ),

                const SizedBox(height: AppConstants.mediumPadding),

                // Login Button
                CustomButton(
                  text: _isLoading ? 'Logging in...' : 'LOG IN',
                  onPressed: _isLoading ? null : _handleLogin,
                  isFullWidth: true,
                ),

                const SizedBox(height: AppConstants.defaultPadding),

                // Sign up link
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      TextButton(
                        onPressed: _isLoading ? null : _navigateToSignUp,
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(0, 0),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'SIGN UP',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: AppConstants.fontWeightBold,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppConstants.mediumPadding),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
