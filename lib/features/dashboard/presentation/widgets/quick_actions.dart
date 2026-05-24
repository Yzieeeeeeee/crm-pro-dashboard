import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:crm_dashboard_app/core/constants/app_colors.dart';
import 'package:crm_dashboard_app/core/constants/app_radius.dart';
import 'package:crm_dashboard_app/core/constants/app_spacing.dart';
import 'package:go_router/go_router.dart';
import 'package:crm_dashboard_app/routes/app_router.dart';

/// Highly interactive quick actions widget supporting horizontal scroll on mobile and a vertical list flow for desktop dashboards.
class QuickActions extends StatelessWidget {
  final bool isVertical;

  const QuickActions({
    super.key,
    this.isVertical = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final actions = [
      _QuickActionData(
        icon: Icons.add_business_rounded,
        label: 'Add Company',
        subtitle: 'Register new client',
        gradient: AppColors.avatarGradients[0],
        onTap: () => context.go(AppRoutes.companies),
      ),
      _QuickActionData(
        icon: Icons.calendar_month_rounded,
        label: 'Schedule Meeting',
        subtitle: 'Book a video call',
        gradient: AppColors.avatarGradients[4],
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Simulating Schedule Meeting workflow...'),
              backgroundColor: AppColors.primary,
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
      ),
      _QuickActionData(
        icon: Icons.assessment_rounded,
        label: 'Generate Report',
        subtitle: 'Export pipeline data',
        gradient: AppColors.avatarGradients[3],
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Report generated successfully!'),
              backgroundColor: AppColors.success,
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
      ),
      _QuickActionData(
        icon: Icons.analytics_rounded,
        label: 'View Analytics',
        subtitle: 'Open growth charts',
        gradient: AppColors.avatarGradients[1],
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Navigating to full Revenue Analytics...'),
              backgroundColor: AppColors.primary,
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
      ),
    ];

    if (isVertical) {
      return Column(
        children: actions.map((act) {
          return Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: _QuickActionRowTile(
              icon: act.icon,
              label: act.label,
              subtitle: act.subtitle,
              gradient: act.gradient,
              onTap: act.onTap,
              isDark: isDark,
            ),
          );
        }).toList(),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
        childAspectRatio: 1.35,
      ),
      itemCount: actions.length,
      itemBuilder: (context, index) {
        final act = actions[index];
        return _QuickActionCardTile(
          icon: act.icon,
          label: act.label,
          subtitle: act.subtitle,
          gradient: act.gradient,
          onTap: act.onTap,
          isDark: isDark,
        );
      },
    );
  }
}

class _QuickActionData {
  final IconData icon;
  final String label;
  final String subtitle;
  final LinearGradient gradient;
  final VoidCallback onTap;

  _QuickActionData({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.gradient,
    required this.onTap,
  });
}

/// Horizontal wide list row for Desktop
class _QuickActionRowTile extends StatefulWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final LinearGradient gradient;
  final VoidCallback onTap;
  final bool isDark;

  const _QuickActionRowTile({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.gradient,
    required this.onTap,
    required this.isDark,
  });

  @override
  State<_QuickActionRowTile> createState() => _QuickActionRowTileState();
}

class _QuickActionRowTileState extends State<_QuickActionRowTile> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        transform: _isHovered ? Matrix4.translationValues(4.0, 0.0, 0.0) : Matrix4.identity(),
        decoration: BoxDecoration(
          color: widget.isDark ? AppColors.darkCard : AppColors.white,
          borderRadius: AppRadius.borderRadiusMd,
          border: Border.all(
            color: _isHovered 
                ? AppColors.primary.withValues(alpha: 0.4)
                : (widget.isDark ? AppColors.darkBorder : AppColors.lightBorder),
          ),
          boxShadow: _isHovered 
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  )
                ]
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: AppRadius.borderRadiusMd,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: AppRadius.borderRadiusMd,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Row(
                children: [
                  Container(
                    padding: AppSpacing.paddingSm,
                    decoration: BoxDecoration(
                      gradient: widget.gradient,
                      borderRadius: AppRadius.borderRadiusSm,
                    ),
                    child: Icon(
                      widget.icon,
                      size: 20.w,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.label,
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.2,
                            color: widget.isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          widget.subtitle,
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: widget.isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 12.w,
                    color: _isHovered 
                        ? AppColors.primary 
                        : (widget.isDark ? AppColors.darkTextSecondary : AppColors.gray400),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Compact Square Card for Mobile
class _QuickActionCardTile extends StatefulWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final LinearGradient gradient;
  final VoidCallback onTap;
  final bool isDark;

  const _QuickActionCardTile({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.gradient,
    required this.onTap,
    required this.isDark,
  });

  @override
  State<_QuickActionCardTile> createState() => _QuickActionCardTileState();
}

class _QuickActionCardTileState extends State<_QuickActionCardTile> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        height: double.infinity,
        transform: _isHovered ? Matrix4.translationValues(0.0, -4.0, 0.0) : Matrix4.identity(),
        decoration: BoxDecoration(
          color: widget.isDark ? AppColors.darkCard : AppColors.white,
          borderRadius: AppRadius.borderRadiusLg,
          border: Border.all(
            color: _isHovered 
                ? AppColors.primary.withValues(alpha: 0.3)
                : (widget.isDark ? AppColors.darkBorder : AppColors.lightBorder),
          ),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  )
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: AppRadius.borderRadiusLg,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: AppRadius.borderRadiusLg,
            child: Padding(
              padding: AppSpacing.paddingBase,
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: AppSpacing.paddingSm,
                      decoration: BoxDecoration(
                        gradient: widget.gradient,
                        borderRadius: AppRadius.borderRadiusMd,
                      ),
                      child: Icon(
                        widget.icon,
                        size: 20.w,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.label,
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.2,
                            color: widget.isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          widget.subtitle,
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w400,
                            color: widget.isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
