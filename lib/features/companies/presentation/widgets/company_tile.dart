import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:crm_dashboard_app/core/constants/app_colors.dart';
import 'package:crm_dashboard_app/core/constants/app_spacing.dart';
import 'package:crm_dashboard_app/core/widgets/status_badge.dart';
import 'package:crm_dashboard_app/features/companies/data/company_model.dart';

class CompanyTile extends StatelessWidget {
  final CompanyModel company;
  final StatusType status;
  final VoidCallback onTap;

  const CompanyTile({
    super.key,
    required this.company,
    required this.status,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // Assign a consistent gradient based on ID
    final gradient = AppColors
        .avatarGradients[company.id % AppColors.avatarGradients.length];

    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            child: Row(
              children: [
                Hero(
                  tag: 'company-avatar-${company.id}',
                  child: Container(
                    width: 48.w,
                    height: 48.w,
                    decoration: BoxDecoration(
                      gradient: gradient,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        company.initials,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        company.companyName,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: -0.2,
                                ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        children: [
                          Icon(
                            Icons.person_outline_rounded,
                            size: 13.sp,
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary,
                          ),
                          SizedBox(width: 4.w),
                          Expanded(
                            child: Text(
                              '${company.contactName} • ${company.email.length > 23 ? '${company.email.substring(0, 20)}...' : company.email}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: isDark
                                        ? AppColors.darkTextSecondary
                                        : AppColors.lightTextSecondary,
                                    fontSize: 12.sp,
                                  ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        company.address.city,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.lightTextSecondary,
                              fontSize: 11.sp,
                            ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: AppSpacing.sm),
                StatusBadge(
                  label: _getStatusLabel(status),
                  type: status,
                ),
                SizedBox(width: AppSpacing.sm),
                Icon(
                  Icons.chevron_right_rounded,
                  color:
                      isDark ? AppColors.darkTextSecondary : AppColors.gray400,
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
            color: isDark
                ? AppColors.darkBorder.withValues(alpha: 0.5)
                : AppColors.gray200,
            indent: 80.w,
          ),
        ],
      ),
    );
  }

  String _getStatusLabel(StatusType type) {
    switch (type) {
      case StatusType.active:
        return 'Active';
      case StatusType.inactive:
        return 'Inactive';
      case StatusType.pending:
        return 'Pending';
      case StatusType.priority:
        return 'Priority';
      case StatusType.info:
        return 'Info';
    }
  }
}
