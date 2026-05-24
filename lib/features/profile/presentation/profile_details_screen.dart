import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:crm_dashboard_app/core/constants/app_colors.dart';
import 'package:crm_dashboard_app/core/constants/app_spacing.dart';
import 'package:crm_dashboard_app/core/localization/app_localizations.dart';
import 'package:crm_dashboard_app/core/utils/responsive_helper.dart';
import 'package:crm_dashboard_app/core/widgets/app_card.dart';
import 'package:crm_dashboard_app/core/widgets/app_text.dart';
import 'package:crm_dashboard_app/core/widgets/custom_app_bar.dart';
import 'package:crm_dashboard_app/features/auth/provider/auth_provider.dart';

/// A premium, highly polished profile overview screen.
class ProfileDetailsScreen extends ConsumerStatefulWidget {
  const ProfileDetailsScreen({super.key});

  @override
  ConsumerState<ProfileDetailsScreen> createState() => _ProfileDetailsScreenState();
}

class _ProfileDetailsScreenState extends ConsumerState<ProfileDetailsScreen> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.tr(ref);
    final authState = ref.watch(authProvider);
    final user = authState.user;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = ResponsiveHelper.isMobile(context);

    // Limit screen width on wide desktop monitors for premium look
    final contentWidth = isMobile ? double.infinity : 520.w;

    return Scaffold(
      appBar: CustomAppBar(
        title: locale.translate('profile_details'),
        showBack: true,
        showSearch: false,
        showNotifications: false,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: AppSpacing.screenPadding,
          child: Container(
            width: contentWidth,
            alignment: Alignment.topCenter,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── Header Profile Card ───────────────────────────────
                _buildHeaderCard(context, user, isDark),
                AppSpacing.gapXl,

                // ── Account Details Card ──────────────────────────────
                _buildSectionTitle(locale.translate('account_information'), context),
                AppSpacing.gapSm,
                _buildAccountInfoCard(user, isDark, locale),
                AppSpacing.gapXl,

                // ── Security & Security Log ───────────────────────────
                _buildSectionTitle(locale.translate('security'), context),
                AppSpacing.gapSm,
                _buildSecurityCard(isDark, locale),
                AppSpacing.gapXxl,

                // ── Actions Card ──────────────────────────────────────
                _buildSignOutButton(context, locale),
                AppSpacing.gapXxl,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCard(BuildContext context, dynamic user, bool isDark) {
    final initials = user?.initials ?? 'AJ';
    final name = user?.name ?? 'User Name';
    final role = user?.role ?? 'Administrator';

    return AppCard(
      child: Column(
        children: [
          SizedBox(height: 12.h),
          // Gradient Circle Avatar
          Container(
            width: 96.w,
            height: 96.w,
            decoration: BoxDecoration(
              gradient: AppColors.avatarGradients[0],
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.25),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Center(
              child: AppText(
                initials,
                variant: AppTextVariant.displayMedium,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                fontSize: 32.sp,
              ),
            ),
          ),
          SizedBox(height: 16.h),
          AppText.titleLarge(
            name,
            fontWeight: FontWeight.w700,
          ),
          SizedBox(height: 6.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 5.h),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.verified_user_rounded,
                  size: 14.w,
                  color: AppColors.primary,
                ),
                SizedBox(width: 6.w),
                AppText.labelSmall(
                  role.toUpperCase(),
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                  style: const TextStyle(letterSpacing: 0.5),
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),
        ],
      ),
    );
  }

  Widget _buildAccountInfoCard(dynamic user, bool isDark, AppLocalizations locale) {
    final email = user?.email ?? 'user@email.com';
    final id = user?.id ?? '1';

    return AppCard(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 8.h),
      child: Column(
        children: [
          _buildInfoRow(
            icon: Icons.person_outline_rounded,
            label: locale.translate('user_id'),
            value: 'CRM-00$id',
            isDark: isDark,
          ),
          const Divider(indent: 56, endIndent: 16, height: 1),
          _buildInfoRow(
            icon: Icons.mail_outline_rounded,
            label: locale.translate('email_address'),
            value: email,
            isDark: isDark,
          ),
          const Divider(indent: 56, endIndent: 16, height: 1),
          _buildInfoRow(
            icon: Icons.business_outlined,
            label: locale.translate('organization'),
            value: 'Muhammed Yasir Corp',
            isDark: isDark,
          ),
          const Divider(indent: 56, endIndent: 16, height: 1),
          _buildInfoRow(
            icon: Icons.calendar_month_outlined,
            label: locale.translate('member_since'),
            value: 'May 2026',
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    required bool isDark,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.03),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 20.w,
              color: isDark ? AppColors.darkTextSecondary : AppColors.gray600,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText.labelSmall(
                  label,
                  color: isDark ? Colors.white38 : Colors.black38,
                ),
                SizedBox(height: 2.h),
                AppText.bodyMedium(
                  value,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityCard(bool isDark, AppLocalizations locale) {
    return AppCard(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 8.h),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: ScaleTransition(
                    scale: Tween<double>(begin: 0.85, end: 1.0).animate(
                      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
                    ),
                    child: const Icon(
                      Icons.circle,
                      size: 12,
                      color: Colors.green,
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText.bodyMedium(
                        locale.translate('active_session'),
                        fontWeight: FontWeight.w600,
                      ),
                      AppText.bodySmall(
                        locale.translate('secure_device'),
                        color: isDark ? Colors.white54 : Colors.black54,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignOutButton(BuildContext context, AppLocalizations locale) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.error,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: EdgeInsets.symmetric(vertical: 14.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
      onPressed: () => _handleLogout(context),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.logout_rounded, size: 20.w),
          SizedBox(width: 8.w),
          AppText.bodyMedium(
            locale.translate('sign_out_btn'),
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  Future<void> _handleLogout(BuildContext context) async {
    final router = GoRouter.of(context);
    final locale = context.tr(ref);
    // Show smooth confirmation
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return AlertDialog(
          backgroundColor: isDark ? AppColors.darkCard : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
          title: AppText.titleLarge(locale.translate('confirm_logout_title'), fontWeight: FontWeight.bold),
          content: AppText.bodyMedium(locale.translate('confirm_logout_desc')),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: AppText.bodyMedium(locale.translate('cancel'), color: isDark ? Colors.white54 : Colors.black54),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
              ),
              onPressed: () => Navigator.of(context).pop(true),
              child: AppText.bodyMedium(locale.translate('sign_out'), fontWeight: FontWeight.w600, color: Colors.white),
            ),
          ],
        );
      },
    );

    if (confirm == true && mounted) {
      await ref.read(authProvider.notifier).logout();
      if (mounted) {
        router.go('/login');
      }
    }
  }

  Widget _buildSectionTitle(String title, BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 8.w),
      child: AppText.labelSmall(
        title,
        style: TextStyle(
          letterSpacing: 1.2,
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
        ),
      ),
    );
  }
}
