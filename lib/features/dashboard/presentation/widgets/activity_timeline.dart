import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:crm_dashboard_app/core/constants/app_colors.dart';
import 'package:crm_dashboard_app/core/constants/app_radius.dart';
import 'package:crm_dashboard_app/core/constants/app_spacing.dart';
import 'package:crm_dashboard_app/core/utils/extensions.dart';
import 'package:crm_dashboard_app/core/widgets/app_text.dart';
import 'package:crm_dashboard_app/features/dashboard/data/dashboard_model.dart';

/// Vertical timeline showing recent activities with colored type indicators.
class ActivityTimeline extends StatelessWidget {
  final List<Activity> activities;

  const ActivityTimeline({super.key, required this.activities});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: activities.length,
      itemBuilder: (context, i) {
        return ActivityTile(
          key: ValueKey(activities[i].id),
          activity: activities[i],
          isLast: i == activities.length - 1,
          index: i % 5, // Cap animation delay to page size
        );
      },
    );
  }
}

class ActivityTile extends StatefulWidget {
  const ActivityTile({
    super.key,
    required this.activity,
    required this.isLast,
    required this.index,
  });

  final Activity activity;
  final bool isLast;
  final int index;

  @override
  State<ActivityTile> createState() => ActivityTileState();
}

class ActivityTileState extends State<ActivityTile>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0.05, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));

    Future.delayed(Duration(milliseconds: widget.index * 80), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final a = widget.activity;
    final color = _typeColor(a.type);
    final icon = _typeIcon(a.type);

    return FadeTransition(
      opacity: _fadeAnim,
      child: SlideTransition(
        position: _slideAnim,
        child: Stack(
          children: [
            // 1. Timeline Track Line - Positioned perfectly behind the icon
            if (!widget.isLast)
              Positioned(
                left: 14.w, // Center of the 28.w circular icon
                top: 28.w,  // Start below the circular icon
                bottom: 0,
                child: Container(
                  width: 2.w,
                  color: isDark ? AppColors.darkBorder : AppColors.gray200,
                ),
              ),

            // 2. Timeline Type Icon
            Positioned(
              left: 0,
              top: 0,
              child: Container(
                width: 28.w,
                height: 28.w,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 14.w, color: color),
              ),
            ),

            // 3. Content Card - Padded left to make space for track/icon
            Padding(
              padding: EdgeInsets.only(left: 40.w),
              child: Container(
                margin: EdgeInsets.only(bottom: AppSpacing.md),
                padding: EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCard : AppColors.lightCard,
                  borderRadius: AppRadius.borderRadiusMd,
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText.bodyMedium(
                      a.title,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                    ),
                    SizedBox(height: 4.h),
                    AppText.bodySmall(
                      a.description,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: AppText.labelSmall(
                            a.userName,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        AppText.labelSmall(
                          a.timestamp.timeAgo,
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.gray400,
                        ),
                      ],
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

  Color _typeColor(ActivityType type) {
    switch (type) {
      case ActivityType.deal:
        return AppColors.success;
      case ActivityType.meeting:
        return AppColors.primary;
      case ActivityType.email:
        return AppColors.info;
      case ActivityType.task:
        return AppColors.warning;
    }
  }

  IconData _typeIcon(ActivityType type) {
    switch (type) {
      case ActivityType.deal:
        return Icons.handshake_rounded;
      case ActivityType.meeting:
        return Icons.videocam_rounded;
      case ActivityType.email:
        return Icons.email_rounded;
      case ActivityType.task:
        return Icons.task_alt_rounded;
    }
  }
}
