import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:crm_dashboard_app/core/constants/app_colors.dart';
import 'package:crm_dashboard_app/core/constants/app_radius.dart';
import 'package:crm_dashboard_app/core/constants/app_spacing.dart';

/// Shimmer loading placeholder widgets.
class ShimmerLoading extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const ShimmerLoading({
    super.key,
    this.width = double.infinity,
    required this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Shimmer.fromColors(
      baseColor: isDark ? AppColors.darkCard : AppColors.gray200,
      highlightColor: isDark ? AppColors.darkBorder : AppColors.gray100,
      period: const Duration(milliseconds: 3000),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.gray200,
          borderRadius: borderRadius ?? AppRadius.borderRadiusMd,
        ),
      ),
    );
  }
}

/// Shimmer placeholder for a company list tile.
class CompanyTileShimmer extends StatelessWidget {
  const CompanyTileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
      child: Row(
        children: [
          ShimmerLoading(
            width: 48.w,
            height: 48.w,
            borderRadius: AppRadius.borderRadiusFull,
          ),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerLoading(height: 14.h, width: 140.w),
                SizedBox(height: 6.h),
                ShimmerLoading(height: 12.h, width: 200.w),
                SizedBox(height: 4.h),
                ShimmerLoading(height: 12.h, width: 100.w),
              ],
            ),
          ),
          ShimmerLoading(
              width: 60.w,
              height: 24.h,
              borderRadius: AppRadius.borderRadiusFull),
        ],
      ),
    );
  }
}

/// Shimmer placeholder for the dashboard screen.
class DashboardShimmer extends StatelessWidget {
  const DashboardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.screenPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Greeting
          ShimmerLoading(height: 28.h, width: 200.w),
          SizedBox(height: 4.h),
          ShimmerLoading(height: 16.h, width: 280.w),
          SizedBox(height: AppSpacing.xl),
          // KPI Cards
          Row(
            children: List.generate(
              2,
              (i) => Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: i == 0 ? AppSpacing.md : 0),
                  child: ShimmerLoading(
                    height: 100.h,
                    borderRadius: AppRadius.borderRadiusLg,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: AppSpacing.md),
          Row(
            children: List.generate(
              2,
              (i) => Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: i == 0 ? AppSpacing.md : 0),
                  child: ShimmerLoading(
                    height: 100.h,
                    borderRadius: AppRadius.borderRadiusLg,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: AppSpacing.xl),
          // Chart
          ShimmerLoading(
            height: 220.h,
            borderRadius: AppRadius.borderRadiusLg,
          ),
        ],
      ),
    );
  }
}

/// Shimmer placeholder for the company details screen.
class CompanyDetailsShimmer extends StatelessWidget {
  const CompanyDetailsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.screenPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: ShimmerLoading(
              width: 80.w,
              height: 80.w,
              borderRadius: AppRadius.borderRadiusFull,
            ),
          ),
          SizedBox(height: AppSpacing.base),
          Center(child: ShimmerLoading(height: 22.h, width: 180.w)),
          SizedBox(height: 8.h),
          Center(child: ShimmerLoading(height: 14.h, width: 240.w)),
          SizedBox(height: AppSpacing.xl),
          ShimmerLoading(height: 140.h, borderRadius: AppRadius.borderRadiusLg),
          SizedBox(height: AppSpacing.base),
          ShimmerLoading(height: 140.h, borderRadius: AppRadius.borderRadiusLg),
          SizedBox(height: AppSpacing.base),
          ShimmerLoading(height: 100.h, borderRadius: AppRadius.borderRadiusLg),
        ],
      ),
    );
  }
}

/// Shimmer placeholder for the activity timeline.
class TimelineShimmer extends StatelessWidget {
  const TimelineShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        3,
        (index) => Padding(
          padding: EdgeInsets.only(bottom: AppSpacing.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShimmerLoading(
                width: 28.w,
                height: 28.w,
                borderRadius: AppRadius.borderRadiusFull,
              ),
              SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerLoading(height: 14.h, width: 120.w),
                    SizedBox(height: 6.h),
                    ShimmerLoading(height: 12.h, width: 220.w),
                    SizedBox(height: 8.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ShimmerLoading(height: 10.h, width: 70.w),
                        ShimmerLoading(height: 10.h, width: 50.w),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Shimmer placeholder for the meetings list.
class MeetingsShimmer extends StatelessWidget {
  const MeetingsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        3,
        (index) => Container(
          margin: EdgeInsets.only(bottom: AppSpacing.sm),
          padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
          child: Row(
            children: [
              ShimmerLoading(
                width: 40.w,
                height: 40.w,
                borderRadius: AppRadius.borderRadiusFull,
              ),
              SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerLoading(height: 14.h, width: 100.w),
                    SizedBox(height: 4.h),
                    ShimmerLoading(height: 12.h, width: 140.w),
                    SizedBox(height: 6.h),
                    Row(
                      children: [
                        ShimmerLoading(height: 10.h, width: 50.w),
                        SizedBox(width: 8.w),
                        ShimmerLoading(height: 12.h, width: 60.w, borderRadius: AppRadius.borderRadiusFull),
                      ],
                    ),
                  ],
                ),
              ),
              ShimmerLoading(width: 16.w, height: 16.w, borderRadius: AppRadius.borderRadiusFull),
            ],
          ),
        ),
      ),
    );
  }
}
