import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:crm_dashboard_app/core/constants/app_colors.dart';
import 'package:crm_dashboard_app/core/constants/app_radius.dart';
import 'package:crm_dashboard_app/core/constants/app_shadows.dart';
import 'package:crm_dashboard_app/core/constants/app_spacing.dart';
import 'package:crm_dashboard_app/features/dashboard/data/dashboard_model.dart';

/// Bar chart widget using CustomPainter with animated bar growth.
class RevenueChart extends StatefulWidget {
  final List<ChartDataPoint> data;

  const RevenueChart({super.key, required this.data});

  @override
  State<RevenueChart> createState() => _RevenueChartState();
}

class _RevenueChartState extends State<RevenueChart>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _animation;
  String _selectedPeriod = '1M';

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _animation = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic);
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: AppSpacing.paddingBase,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: AppRadius.borderRadiusLg,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
        boxShadow: isDark ? null : AppShadows.subtle,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Revenue Analytics',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Flexible(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              '\$64,250',
                              style: TextStyle(
                                fontSize: 26.sp,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.6,
                                color: isDark
                                    ? AppColors.darkTextPrimary
                                    : AppColors.lightTextPrimary,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 6.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            color: AppColors.successLight,
                            borderRadius: AppRadius.borderRadiusSm,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.arrow_upward_rounded,
                                size: 10.w,
                                color: AppColors.success,
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                '12.4%',
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.success,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : AppColors.gray100,
                  borderRadius: AppRadius.borderRadiusFull,
                ),
                child: Row(
                  children: ['1W', '1M', '6M', '1Y'].map((p) {
                    final isSel = _selectedPeriod == p;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedPeriod = p),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: isSel
                              ? (isDark ? AppColors.darkCard : AppColors.white)
                              : Colors.transparent,
                          borderRadius: AppRadius.borderRadiusFull,
                        ),
                        child: Text(
                          p,
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight:
                                isSel ? FontWeight.w700 : FontWeight.w500,
                            color: isSel
                                ? (isDark
                                    ? AppColors.primaryLight
                                    : AppColors.primary)
                                : (isDark
                                    ? AppColors.darkTextSecondary
                                    : AppColors.gray500),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md),
          // Legend indicator
          Row(
            children: [
              Container(
                width: 8.w,
                height: 8.w,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              SizedBox(width: 6.w),
              Flexible(
                child: Text(
                  'Active Pipeline Revenue',
                  style: TextStyle(
                    fontSize: 11.sp,
                    color:
                        isDark ? AppColors.darkTextSecondary : AppColors.gray500,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.sm),
          SizedBox(
            height: 300,
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, _) {
                return CustomPaint(
                  size: const Size(double.infinity, 300),
                  painter: _BarChartPainter(
                    data: widget.data,
                    progress: _animation.value,
                    isDark: isDark,
                    primaryColor: AppColors.primary,
                    primaryLightColor: AppColors.primaryLight,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _BarChartPainter extends CustomPainter {
  final List<ChartDataPoint> data;
  final double progress;
  final bool isDark;
  final Color primaryColor;
  final Color primaryLightColor;

  _BarChartPainter({
    required this.data,
    required this.progress,
    required this.isDark,
    required this.primaryColor,
    required this.primaryLightColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    const leftPadding = 36.0;
    const bottomPadding = 28.0;
    const topPadding = 8.0;

    final chartWidth = size.width - leftPadding;
    final chartHeight = size.height - bottomPadding - topPadding;

    final maxVal = data.map((e) => e.value).reduce(math.max);
    final yStep = 20.0;
    final yMax = (maxVal / yStep).ceil() * yStep;

    // Grid paint
    final gridPaint = Paint()
      ..color = (isDark ? AppColors.darkBorder : AppColors.gray200)
          .withValues(alpha: 0.5)
      ..strokeWidth = 0.5;

    final labelStyle = TextStyle(
      fontSize: 10,
      color: isDark ? AppColors.darkTextSecondary : AppColors.gray400,
    );

    // Y-axis labels & grid lines
    for (var v = 0.0; v <= yMax; v += yStep) {
      final y = topPadding + chartHeight - (v / yMax * chartHeight);
      canvas.drawLine(
        Offset(leftPadding, y),
        Offset(size.width, y),
        gridPaint,
      );
      final tp = TextPainter(
        text: TextSpan(text: v.toInt().toString(), style: labelStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(leftPadding - tp.width - 6, y - tp.height / 2));
    }

    // Bars
    final barCount = data.length;
    final barGap = 8.0;
    final totalGaps = (barCount + 1) * barGap;
    final barWidth = (chartWidth - totalGaps) / barCount;

    for (var i = 0; i < barCount; i++) {
      final dp = data[i];
      final barHeight = (dp.value / yMax) * chartHeight * progress;
      final x = leftPadding + barGap + i * (barWidth + barGap);
      final y = topPadding + chartHeight - barHeight;

      final barRect = RRect.fromLTRBR(
        x,
        y,
        x + barWidth,
        topPadding + chartHeight,
        const Radius.circular(4),
      );

      final gradient = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [primaryColor, primaryLightColor],
      );

      final paint = Paint()
        ..shader = gradient.createShader(
          Rect.fromLTWH(x, y, barWidth, barHeight),
        );
      canvas.drawRRect(barRect, paint);

      // X-axis label
      final tp = TextPainter(
        text: TextSpan(text: dp.label, style: labelStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(
        canvas,
        Offset(
          x + barWidth / 2 - tp.width / 2,
          topPadding + chartHeight + 8,
        ),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _BarChartPainter old) =>
      old.progress != progress || old.isDark != isDark;
}
