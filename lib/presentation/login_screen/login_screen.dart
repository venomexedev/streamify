import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import '../../services/auth_service.dart';
import './widgets/login_form_widget.dart';
import './widgets/signup_link_widget.dart';
import './widgets/social_login_widget.dart';
import './widgets/streamify_logo_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;
  String? _errorMessage;
  final AuthService _authService = AuthService();

  Future<void> _handleLogin(String email, String password) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await _authService.signIn(
        email: email,
        password: password,
      );

      if (response.user != null) {
        // Haptic feedback for success
        HapticFeedback.lightImpact();

        // Check if user is admin
        final isAdmin = await _authService.isCurrentUserAdmin();

        // Navigate based on user type
        if (isAdmin) {
          Navigator.pushReplacementNamed(context, '/admin-dashboard-screen');
        } else {
          Navigator.pushReplacementNamed(context, '/home-screen');
        }
      }
    } catch (error) {
      setState(() {
        _errorMessage = error.toString().replaceAll('Exception: ', '');
        _isLoading = false;
      });

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_errorMessage!),
          backgroundColor: AppTheme.errorRed,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(4.w),
        ),
      );
    }
  }

  Future<void> _handleSignUp(
      String email, String password, String fullName) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await _authService.signUp(
        email: email,
        password: password,
        fullName: fullName,
      );

      setState(() {
        _isLoading = false;
      });

      if (response.user != null) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Account created successfully! Please sign in.'),
            backgroundColor: AppTheme.successGreen,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.all(4.w),
          ),
        );
      }
    } catch (error) {
      setState(() {
        _errorMessage = error.toString().replaceAll('Exception: ', '');
        _isLoading = false;
      });

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_errorMessage!),
          backgroundColor: AppTheme.errorRed,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(4.w),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
              ),
              child: IntrinsicHeight(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 8.h),

                      // Streamify Logo
                      const StreamifyLogoWidget(),
                      SizedBox(height: 6.h),

                      // Welcome Text
                      Text(
                        'Welcome Back!',
                        style: AppTheme.lightTheme.textTheme.headlineMedium
                            ?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onSurface,
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 1.h),

                      Text(
                        'Sign in to continue streaming',
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onSurface
                              .withValues(alpha: 0.7),
                          fontSize: 14.sp,
                        ),
                      ),
                      SizedBox(height: 5.h),

                      // Login Form
                      LoginFormWidget(
                        onLogin: _handleLogin,
                        onSignUp: _handleSignUp,
                        isLoading: _isLoading,
                      ),
                      SizedBox(height: 4.h),

                      // Social Login Options
                      SocialLoginWidget(
                        isLoading: _isLoading,
                      ),

                      const Spacer(),

                      // Sign Up Link
                      SignupLinkWidget(
                        isLoading: _isLoading,
                      ),
                      SizedBox(height: 2.h),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
