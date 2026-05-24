import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:crm_dashboard_app/core/constants/app_colors.dart';
import 'package:crm_dashboard_app/core/localization/app_localizations.dart';
import 'package:crm_dashboard_app/core/utils/responsive_helper.dart';
import 'package:crm_dashboard_app/shared/side_navigation.dart';
import 'package:crm_dashboard_app/core/widgets/offline_simulator_banner.dart';

/// Adaptive app shell with floating pill nav for mobile and sidebar for tablet/desktop.
class AppShell extends ConsumerStatefulWidget {
  final StatefulNavigationShell navigationShell;

  const AppShell({super.key, required this.navigationShell});

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  bool? _userSidebarExpanded;

  bool _getIsSidebarExpanded(BuildContext context) {
    if (_userSidebarExpanded != null) return _userSidebarExpanded!;
    return ResponsiveHelper.isDesktop(context);
  }

  void _onDestinationSelected(int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.tr(ref);
    final isMobile = ResponsiveHelper.isMobile(context);
    final theme = Theme.of(context);
    final isExpanded = _getIsSidebarExpanded(context);

    final mainLayout = isMobile
        ? Scaffold(
            extendBody: true, // Content flows under the floating nav
            body: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              switchInCurve: Curves.easeIn,
              switchOutCurve: Curves.easeOut,
              child: KeyedSubtree(
                key: ValueKey<int>(widget.navigationShell.currentIndex),
                child: widget.navigationShell,
              ),
            ),
            bottomNavigationBar: _buildFloatingBottomNav(context, locale),
          )
        : Scaffold(
            body: Row(
              children: [
                SideNavigation(
                  selectedIndex: widget.navigationShell.currentIndex,
                  onDestinationSelected: _onDestinationSelected,
                  isExpanded: isExpanded,
                  onToggleCollapse: () {
                    setState(() {
                      _userSidebarExpanded = !isExpanded;
                    });
                  },
                ),
                const VerticalDivider(width: 1, thickness: 1),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    switchInCurve: Curves.easeIn,
                    switchOutCurve: Curves.easeOut,
                    child: KeyedSubtree(
                      key: ValueKey<int>(widget.navigationShell.currentIndex),
                      child: widget.navigationShell,
                    ),
                  ),
                ),
              ],
            ),
          );

    final content = Column(
      children: [
        const OfflineSimulatorBanner(),
        Expanded(child: mainLayout),
      ],
    );

    return AnimatedTheme(
      data: theme,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      child: content,
    );
  }

  Widget _buildFloatingBottomNav(BuildContext context, AppLocalizations locale) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentIndex = widget.navigationShell.currentIndex;

    return Padding(
      padding: EdgeInsets.only(
        bottom: 24.h,
        left: 32.w,
        right: 32.w,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32.r),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            height: 68.h,
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.darkSurface.withValues(alpha: 0.75)
                  : AppColors.white.withValues(alpha: 0.85),
              borderRadius: BorderRadius.circular(32.r),
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.1)
                    : AppColors.primary.withValues(alpha: 0.15),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.1),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, Icons.dashboard_rounded, locale.translate('dashboard'), isDark,
                    currentIndex),
                _buildNavItem(1, Icons.business_rounded, locale.translate('companies'), isDark,
                    currentIndex),
                _buildNavItem(2, Icons.settings_rounded, locale.translate('settings'), isDark,
                    currentIndex),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
      int index, IconData icon, String label, bool isDark, int currentIndex) {
    final isSelected = index == currentIndex;

    return GestureDetector(
      onTap: () => _onDestinationSelected(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 16.w : 12.w,
          vertical: 10.h,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark
                  ? AppColors.primaryLight.withValues(alpha: 0.2)
                  : AppColors.primary.withValues(alpha: 0.1))
              : Colors.transparent,
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, anim) =>
                  ScaleTransition(scale: anim, child: child),
              child: Icon(
                icon,
                key: ValueKey<bool>(isSelected),
                size: 24.w,
                color: isSelected
                    ? (isDark ? AppColors.primaryLight : AppColors.primary)
                    : (isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.gray500),
              ),
            ),
            if (isSelected) ...[
              SizedBox(width: 6.w),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.2,
                  color: isDark ? AppColors.primaryLight : AppColors.primary,
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
