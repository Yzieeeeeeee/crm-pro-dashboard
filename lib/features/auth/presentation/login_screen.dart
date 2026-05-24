import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:crm_dashboard_app/core/constants/app_colors.dart';
import 'package:crm_dashboard_app/core/localization/app_localizations.dart';
import 'package:crm_dashboard_app/core/utils/validators.dart';
import 'package:crm_dashboard_app/features/auth/provider/auth_provider.dart';

/// Redesigned Login Screen combining Instagram's latest minimalist UI with CRM app branding.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  String? _emailWarning;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      ref.read(authProvider.notifier).login(
            _emailController.text,
            _passwordController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.tr(ref);
    final authState = ref.watch(authProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    ref.listen<AuthState>(authProvider, (prev, next) {
      if (next.isAuthenticated) {
        context.go('/dashboard');
      }
      if (next.errorMessage != null && next.errorMessage != prev?.errorMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              next.errorMessage!,
              style: TextStyle(fontSize: 13.sp),
            ),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF000000) : const Color(0xFFFFFFFF),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Container(
                    constraints: BoxConstraints(maxWidth: 360.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // CRM App Logo
                        Center(
                          child: Container(
                            width: 60.w,
                            height: 60.w,
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppColors.primarySurfaceDark
                                  : AppColors.primarySurface,
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            child: Icon(
                              Icons.hub_rounded,
                              size: 32.w,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        SizedBox(height: 24.h),
                        // CRM App Title
                        Text(
                          locale.translate('crm_app'),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.5,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                        SizedBox(height: 32.h),
                        Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _buildCrmField(
                                controller: _emailController,
                                hint: locale.translate('email'),
                                isDark: isDark,
                                validator: Validators.email,
                                onChanged: (val) {
                                  setState(() {
                                    if (val.length > 23) {
                                      _emailWarning = locale.translate('email_char_limit');
                                    } else {
                                      _emailWarning = null;
                                    }
                                  });
                                },
                              ),
                              if (_emailWarning != null) ...[
                                SizedBox(height: 6.h),
                                Padding(
                                  padding: EdgeInsets.only(left: 4.w),
                                  child: Text(
                                    _emailWarning!,
                                    style: TextStyle(color: Colors.orange, fontSize: 11.sp),
                                  ),
                                ),
                                SizedBox(height: 6.h),
                              ] else ...[
                                SizedBox(height: 12.h),
                              ],
                              _buildCrmField(
                                controller: _passwordController,
                                hint: locale.translate('password'),
                                isDark: isDark,
                                obscureText: _obscurePassword,
                                validator: Validators.password,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                    size: 18.w,
                                    color: isDark ? Colors.white54 : Colors.black54,
                                  ),
                                  onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                                ),
                              ),
                              SizedBox(height: 16.h),
                              // Forgot Password (Aligned Right like modern IG/apps)
                              Align(
                                alignment: Alignment.centerRight,
                                child: GestureDetector(
                                  onTap: () => context.push('/forgot-password'),
                                  child: Text(
                                    locale.translate('forgot_password'),
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600,
                                      color: isDark ? const Color(0xFFE0E0E0) : const Color(0xFF00376B),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 24.h),
                              // Login Button
                              SizedBox(
                                height: 48.h,
                                child: ElevatedButton(
                                  onPressed: authState.isLoading ? null : _submit,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF0064E0), // Latest Meta Blue
                                    disabledBackgroundColor: const Color(0xFF0064E0).withValues(alpha: 0.5),
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(24.r), // More rounded modern feel
                                    ),
                                  ),
                                  child: authState.isLoading
                                      ? SizedBox(
                                          width: 20.w,
                                          height: 20.w,
                                          child: const CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2.5,
                                          ),
                                        )
                                      : Text(
                                          locale.translate('login'),
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 0.2,
                                          ),
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Bottom Divider and Sign Up section
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: isDark ? Colors.white24 : Colors.black12,
                    width: 0.5,
                  ),
                ),
              ),
              padding: EdgeInsets.symmetric(vertical: 24.h),
              child: GestureDetector(
                onTap: () => context.push('/register'),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      locale.translate('dont_have_account'),
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: isDark ? Colors.white54 : Colors.black54,
                      ),
                    ),
                    Text(
                      locale.translate('signup'),
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: isDark ? const Color(0xFFE0E0E0) : const Color(0xFF0064E0),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCrmField({
    required TextEditingController controller,
    required String hint,
    required bool isDark,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
    ValueChanged<String>? onChanged,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      onChanged: onChanged,
      style: TextStyle(
        fontSize: 14.sp,
        color: isDark ? Colors.white : Colors.black,
      ),
      decoration: InputDecoration(
        errorMaxLines: 2,
        hintText: hint,
        hintStyle: TextStyle(
          fontSize: 14.sp,
          color: isDark ? Colors.white54 : Colors.black38,
        ),
        filled: true,
        fillColor: isDark ? const Color(0xFF121212) : const Color(0xFFFAFAFA),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            color: isDark ? Colors.white24 : Colors.black12,
            width: 0.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            color: isDark ? Colors.white24 : Colors.black12,
            width: 0.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            color: isDark ? Colors.white54 : Colors.black38,
            width: 1.0,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: Colors.red, width: 0.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: Colors.red, width: 1.0),
        ),
      ),
    );
  }
}
