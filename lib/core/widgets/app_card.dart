import 'package:flutter/material.dart';
import 'package:crm_dashboard_app/core/constants/app_colors.dart';
import 'package:crm_dashboard_app/core/constants/app_radius.dart';
import 'package:crm_dashboard_app/core/constants/app_shadows.dart';
import 'package:crm_dashboard_app/core/constants/app_spacing.dart';

/// Reusable card with theme-aware styling, optional border, and hover effect.
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;
  final Color? color;
  final bool showBorder;
  final List<BoxShadow>? boxShadow;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius,
    this.onTap,
    this.color,
    this.showBorder = true,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: padding ?? AppSpacing.paddingBase,
        decoration: BoxDecoration(
          color: color ?? (isDark ? AppColors.darkCard : AppColors.lightCard),
          borderRadius: borderRadius ?? AppRadius.borderRadiusLg,
          border: showBorder
              ? Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                )
              : null,
          boxShadow: boxShadow ?? (isDark ? null : AppShadows.subtle),
        ),
        child: child,
      ),
    );
  }
}
