import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:crm_dashboard_app/core/constants/app_colors.dart';
import 'package:crm_dashboard_app/core/localization/app_localizations.dart';
import 'package:crm_dashboard_app/core/utils/responsive_helper.dart';
import 'package:crm_dashboard_app/core/widgets/global_search_dialog.dart';
import 'package:crm_dashboard_app/features/auth/provider/auth_provider.dart';

/// Upgraded enterprise AppBar that adapts between a sleek mobile bar and an advanced desktop utility header.
class CustomAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final List<Widget>? actions;
  final bool showBack;
  final VoidCallback? onBack;
  final Widget? leading;
  final PreferredSizeWidget? bottom;
  final bool showSearch;
  final bool showNotifications;

  const CustomAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.actions,
    this.showBack = false,
    this.onBack,
    this.leading,
    this.bottom,
    this.showSearch = true,
    this.showNotifications = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = context.tr(ref);
    final isMobile = ResponsiveHelper.isMobile(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final user = ref.watch(authProvider).user;
    final initials = user?.initials ?? 'AJ';

    return isMobile
        ? _buildMobileBar(context, isDark, initials, locale)
        : _buildDesktopBar(context, isDark, initials, ref, locale);
  }

  /// Mobile App Bar layout
  PreferredSizeWidget _buildMobileBar(BuildContext context, bool isDark, String initials, AppLocalizations locale) {
    return AppBar(
      scrolledUnderElevation: 0,
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: showBack
          ? IconButton(
              icon: Icon(Icons.arrow_back_ios_new_rounded, size: 18.w),
              onPressed: onBack ?? () => Navigator.of(context).pop(),
            )
          : leading,
      title: subtitle != null
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.3,
                  ),
                ),
                Text(
                  subtitle!,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.gray500,
                  ),
                ),
              ],
            )
          : Text(
              title,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.3,
              ),
            ),
      actions: actions ??
          [
            if (showSearch)
              IconButton(
                icon: Icon(Icons.search_rounded, size: 20.w),
                onPressed: () => GlobalSearchDialog.show(context),
              ),
            if (showNotifications)
              IconButton(
                icon: Icon(Icons.notifications_none_rounded, size: 20.w),
                onPressed: () => _showNotifications(context, locale),
              ),
            GestureDetector(
              onTap: () => context.push('/profile'),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Container(
                  margin: EdgeInsets.only(right: 16.w, left: 4.w),
                  alignment: Alignment.center,
                  child: Container(
                    width: 28.w,
                    height: 28.w,
                    decoration: BoxDecoration(
                      gradient: AppColors.avatarGradients[0],
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.15),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        initials,
                        style: TextStyle(
                          fontSize: 9.5.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
      bottom: bottom,
    );
  }

  /// Tablet/Desktop Bar layout
  Widget _buildDesktopBar(BuildContext context, bool isDark, String initials, WidgetRef ref, AppLocalizations locale) {
    final user = ref.watch(authProvider).user;
    final headingStyle = TextStyle(
      fontSize: 18.sp,
      fontWeight: FontWeight.w800,
      letterSpacing: -0.4,
      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
    );

    return Container(
      height: preferredSize.height,
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.transparent,
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.gray100,
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Stack(
          children: [
            // ── Left: Title / Back Controls ──────────────────────
            Align(
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (showBack) ...[
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios_new_rounded, size: 16.w),
                      onPressed: onBack ?? () => Navigator.of(context).pop(),
                    ),
                    SizedBox(width: 8.w),
                  ],
                  Flexible(
                    child: Text(
                      title, 
                      style: headingStyle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),

            // ── Center: Centered Search Button ───────────────────
            if (showSearch)
              Align(
                alignment: Alignment.center,
                child: _buildSearchButton(context, isDark, locale),
              ),

            // ── Right: Notifications & Profile Dropdown ──────────
            Align(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Notification Bell
                  if (showNotifications) ...[
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.notifications_outlined,
                            size: 20.w,
                            color: isDark ? AppColors.darkTextSecondary : AppColors.gray600,
                          ),
                          onPressed: () => _showNotifications(context, locale),
                        ),
                        Positioned(
                          top: 8.h,
                          right: 8.w,
                          child: Container(
                            width: 8.w,
                            height: 8.w,
                            decoration: const BoxDecoration(
                              color: AppColors.error,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 12.w),
                  ],

                  // Profile Dropdown Button
                  PopupMenuButton<String>(
                    onSelected: (val) {
                      if (val == 'profile') {
                        context.push('/profile');
                      } else if (val == 'logout') {
                        ref.read(authProvider.notifier).logout();
                        context.go('/login');
                      }
                    },
                    offset: Offset(0, 48.h),
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Row(
                        children: [
                          Container(
                            width: 32.w,
                            height: 32.w,
                            decoration: BoxDecoration(
                              gradient: AppColors.avatarGradients[0],
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withValues(alpha: 0.15),
                                  blurRadius: 6,
                                )
                              ],
                            ),
                            child: Center(
                              child: Text(
                                initials,
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Icon(
                            Icons.keyboard_arrow_down_rounded,
                            size: 14.w,
                            color: isDark ? AppColors.darkTextSecondary : AppColors.gray500,
                          ),
                        ],
                      ),
                    ),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        enabled: false,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user?.name ?? 'User',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.sp),
                            ),
                            Text(
                              user?.role ?? 'Admin',
                              style: TextStyle(fontSize: 11.sp, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      const PopupMenuDivider(),
                      PopupMenuItem(
                        value: 'profile',
                        child: Row(
                          children: [
                            const Icon(Icons.person_outline_rounded, size: 16),
                            const SizedBox(width: 8),
                            Text(locale.translate('profile_settings')),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'logout',
                        child: Row(
                          children: [
                            const Icon(Icons.logout_rounded, size: 16, color: AppColors.error),
                            const SizedBox(width: 8),
                            Text(locale.translate('sign_out'), style: const TextStyle(color: AppColors.error)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildSearchButton(BuildContext context, bool isDark, AppLocalizations locale) {
    final width = MediaQuery.sizeOf(context).width;
    // Scale search bar width dynamically based on screen width
    final double searchWidth = width > 1400 
        ? 400.w 
        : (width > 1000 ? 300.w : 220.w);

    return GestureDetector(
      onTap: () => GlobalSearchDialog.show(context),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: searchWidth,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1E1E) : const Color(0xFFFAFAFA),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: isDark ? Colors.white10 : Colors.black12,
              width: 1.0,
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.search_rounded,
                size: 18.w,
                color: isDark ? Colors.white38 : Colors.black38,
              ),
              SizedBox(width: 10.w),
              Flexible(
                child: Text(
                  locale.translate('search_hint'),
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13.sp,
                    color: isDark ? Colors.white54 : Colors.black54,
                    fontWeight: FontWeight.w400,
                  ),
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showNotifications(BuildContext context, AppLocalizations locale) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? AppColors.darkCard : Colors.white,
        title: Text(locale.translate('notifications')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildNotificationItem(locale.translate('new_lead_title'), locale.translate('new_lead_desc'), locale.translate('time_10_min'), isDark),
            const Divider(),
            _buildNotificationItem(locale.translate('meeting_title'), locale.translate('meeting_desc'), locale.translate('time_1_hour'), isDark),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(locale.translate('close')),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(String title, String desc, String time, bool isDark) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(time, style: TextStyle(fontSize: 10.sp, color: Colors.grey)),
            ],
          ),
          SizedBox(height: 2.h),
          Text(desc, style: TextStyle(fontSize: 12.sp, color: isDark ? AppColors.darkTextSecondary : AppColors.gray600)),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(64.h);
}
