import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:crm_dashboard_app/core/constants/app_colors.dart';
import 'package:crm_dashboard_app/core/constants/app_spacing.dart';
import 'package:crm_dashboard_app/core/constants/app_radius.dart';
import 'package:crm_dashboard_app/core/localization/app_localizations.dart';
import 'package:crm_dashboard_app/core/theme/theme_provider.dart';

/// Sidebar navigation for tablet and desktop layouts.
class SideNavigation extends ConsumerWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final bool isExpanded;
  final VoidCallback? onToggleCollapse;

  const SideNavigation({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    this.isExpanded = true,
    this.onToggleCollapse,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = context.tr(ref);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeMode = ref.watch(themeProvider);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: isExpanded ? 240.w : 72.w,
      constraints: BoxConstraints(
        maxWidth: isExpanded ? 260 : 80,
        minWidth: isExpanded ? 220 : 64,
      ),
      color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    // ── Logo Section ──────────────────────────────────
                    _buildLogo(isDark),
                    const Divider(height: 1),
                    AppSpacing.gapSm,

                    // ── Navigation Items ──────────────────────────────
                    ..._buildNavItems(context, isDark, locale),

                    const Spacer(),

                    // ── Bottom Controls ───────────────────────────────
                    _buildBottomControls(context, ref, isDark, themeMode, locale),
                    AppSpacing.gapBase,
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLogo(bool isDark) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.base,
        vertical: AppSpacing.lg,
      ),
      child: Row(
        children: [
          Container(
            width: 36.w,
            height: 36.w,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: AppRadius.borderRadiusMd,
            ),
            child: Icon(
              Icons.hub_rounded,
              color: Colors.white,
              size: 20.w,
            ),
          ),
          if (isExpanded) ...[
            AppSpacing.hGapMd,
            Flexible(
              child: Text(
                'CRM',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                ),
                softWrap: false,
                overflow: TextOverflow.fade,
              ),
            ),
          ],
        ],
      ),
    );
  }

  List<Widget> _buildNavItems(BuildContext context, bool isDark, AppLocalizations locale) {
    final items = [
      _NavItem(Icons.dashboard_rounded, locale.translate('dashboard'), 0),
      _NavItem(Icons.business_rounded, locale.translate('companies'), 1),
      _NavItem(Icons.settings_rounded, locale.translate('settings'), 2),
    ];

    return items.map((item) {
      final isSelected = selectedIndex == item.index;
      final navTile = Material(
        color: Colors.transparent,
        borderRadius: AppRadius.borderRadiusMd,
        child: InkWell(
          borderRadius: AppRadius.borderRadiusMd,
          onTap: () => onDestinationSelected(item.index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: 10.h,
            ),
            decoration: BoxDecoration(
              color: isSelected
                  ? (isDark
                      ? AppColors.primarySurfaceDark
                      : AppColors.primarySurface)
                  : Colors.transparent,
              borderRadius: AppRadius.borderRadiusMd,
            ),
            child: Row(
              mainAxisAlignment:
                  isExpanded ? MainAxisAlignment.start : MainAxisAlignment.center,
              children: [
                Icon(
                  item.icon,
                  size: 20.w,
                  color: isSelected
                      ? (isDark ? AppColors.primaryLight : AppColors.primary)
                      : (isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.gray500),
                ),
                if (isExpanded) ...[
                  AppSpacing.hGapMd,
                  Flexible(
                    child: Text(
                      item.label,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                        color: isSelected
                            ? (isDark
                                ? AppColors.primaryLight
                                : AppColors.primary)
                            : (isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.gray600),
                      ),
                      softWrap: false,
                      overflow: TextOverflow.fade,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      );

      return Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: 2.h,
        ),
        child: isExpanded
            ? navTile
            : Tooltip(
                message: item.label,
                preferBelow: false,
                child: navTile,
              ),
      );
    }).toList();
  }

  Widget _buildBottomControls(
    BuildContext context,
    WidgetRef ref,
    bool isDark,
    ThemeMode themeMode,
    AppLocalizations locale,
  ) {
    if (isExpanded) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(
                Icons.chevron_left_rounded,
                color: isDark ? AppColors.darkTextSecondary : AppColors.gray500,
                size: 20.w,
              ),
              onPressed: onToggleCollapse,
              tooltip: locale.translate('collapse_sidebar'),
            ),
            IconButton(
              icon: Icon(
                isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                color: isDark ? AppColors.darkTextSecondary : AppColors.gray500,
                size: 20.w,
              ),
              onPressed: () => ref.read(themeProvider.notifier).toggleTheme(),
              tooltip: isDark ? locale.translate('switch_to_light') : locale.translate('switch_to_dark'),
            ),
          ],
        ),
      );
    } else {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Tooltip(
            message: locale.translate('expand_sidebar'),
            preferBelow: false,
            child: IconButton(
              icon: Icon(
                Icons.chevron_right_rounded,
                color: isDark ? AppColors.darkTextSecondary : AppColors.gray500,
                size: 20.w,
              ),
              onPressed: onToggleCollapse,
            ),
          ),
          AppSpacing.gapSm,
          Tooltip(
            message: isDark ? locale.translate('switch_to_light') : locale.translate('switch_to_dark'),
            preferBelow: false,
            child: IconButton(
              icon: Icon(
                isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                color: isDark ? AppColors.darkTextSecondary : AppColors.gray500,
                size: 20.w,
              ),
              onPressed: () => ref.read(themeProvider.notifier).toggleTheme(),
            ),
          ),
        ],
      );
    }
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  final int index;
  const _NavItem(this.icon, this.label, this.index);
}
