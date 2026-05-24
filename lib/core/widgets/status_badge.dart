import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:crm_dashboard_app/core/constants/app_colors.dart';
import 'package:crm_dashboard_app/core/constants/app_radius.dart';

/// Colored status indicator badge.
class StatusBadge extends StatelessWidget {
  final String label;
  final StatusType type;

  const StatusBadge({
    super.key,
    required this.label,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: AppRadius.borderRadiusFull,
        border: Border.all(color: _borderColor, width: 0.5),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeight.w600,
          color: _textColor,
          letterSpacing: 0.2,
        ),
      ),
    );
  }

  Color get _backgroundColor {
    switch (type) {
      case StatusType.active:
        return AppColors.successLight;
      case StatusType.inactive:
        return AppColors.gray100;
      case StatusType.pending:
        return AppColors.warningLight;
      case StatusType.priority:
        return AppColors.errorLight;
      case StatusType.info:
        return AppColors.infoLight;
    }
  }

  Color get _textColor {
    switch (type) {
      case StatusType.active:
        return AppColors.success;
      case StatusType.inactive:
        return AppColors.gray500;
      case StatusType.pending:
        return AppColors.warning;
      case StatusType.priority:
        return AppColors.error;
      case StatusType.info:
        return AppColors.info;
    }
  }

  Color get _borderColor {
    switch (type) {
      case StatusType.active:
        return AppColors.success.withValues(alpha: 0.2);
      case StatusType.inactive:
        return AppColors.gray300;
      case StatusType.pending:
        return AppColors.warning.withValues(alpha: 0.2);
      case StatusType.priority:
        return AppColors.error.withValues(alpha: 0.2);
      case StatusType.info:
        return AppColors.info.withValues(alpha: 0.2);
    }
  }
}

/// Status type for badge styling.
enum StatusType {
  active,
  inactive,
  pending,
  priority,
  info,
}
