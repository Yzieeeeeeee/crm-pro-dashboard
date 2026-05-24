import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:crm_dashboard_app/core/constants/app_colors.dart';
import 'package:crm_dashboard_app/core/constants/app_radius.dart';
import 'package:crm_dashboard_app/core/constants/app_spacing.dart';
import 'package:crm_dashboard_app/core/utils/extensions.dart';
import 'package:crm_dashboard_app/core/widgets/status_badge.dart';
import 'package:crm_dashboard_app/features/dashboard/data/dashboard_model.dart';

/// Upcoming meetings list with avatar, contact info, and type badge.
class MeetingsList extends StatelessWidget {
  final List<Meeting> meetings;

  const MeetingsList({super.key, required this.meetings});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: meetings.map((m) => MeetingTile(meeting: m)).toList(),
    );
  }
}

class MeetingTile extends StatelessWidget {
  const MeetingTile({super.key, required this.meeting});
  final Meeting meeting;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final gradientIndex =
        meeting.id.hashCode % AppColors.avatarGradients.length;

    return Container(
      margin: EdgeInsets.only(bottom: AppSpacing.sm),
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: AppRadius.borderRadiusMd,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              gradient: AppColors.avatarGradients[gradientIndex],
              borderRadius: AppRadius.borderRadiusFull,
            ),
            child: Center(
              child: Text(
                meeting.avatarInitials,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(width: AppSpacing.md),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  meeting.contactName,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  meeting.title,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
                SizedBox(height: 4.h),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: AppSpacing.sm,
                  runSpacing: 4.h,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.access_time_rounded,
                          size: 12.w,
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.gray400,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          meeting.time.formattedTime,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.gray400,
                          ),
                        ),
                      ],
                    ),
                    StatusBadge(
                      label: meeting.type,
                      type: StatusType.info,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Chevron
          Icon(
            Icons.chevron_right_rounded,
            size: 20.w,
            color: isDark ? AppColors.darkTextSecondary : AppColors.gray400,
          ),
        ],
      ),
    );
  }
}
