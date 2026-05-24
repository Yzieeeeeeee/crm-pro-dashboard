import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Spacing system based on a 4px grid.
class AppSpacing {
  AppSpacing._();

  // ── Raw Values ──────────────────────────────────────────
  static double get xxs => 2.w;
  static double get xs => 4.w;
  static double get sm => 8.w;
  static double get md => 12.w;
  static double get base => 16.w;
  static double get lg => 20.w;
  static double get xl => 24.w;
  static double get xxl => 32.w;
  static double get xxxl => 40.w;
  static double get huge => 48.w;
  static double get massive => 64.w;

  // ── Vertical Gaps ───────────────────────────────────────
  static SizedBox get gapXs => SizedBox(height: xs);
  static SizedBox get gapSm => SizedBox(height: sm);
  static SizedBox get gapMd => SizedBox(height: md);
  static SizedBox get gapBase => SizedBox(height: base);
  static SizedBox get gapLg => SizedBox(height: lg);
  static SizedBox get gapXl => SizedBox(height: xl);
  static SizedBox get gapXxl => SizedBox(height: xxl);
  static SizedBox get gapXxxl => SizedBox(height: xxxl);

  // ── Horizontal Gaps ─────────────────────────────────────
  static SizedBox get hGapXs => SizedBox(width: xs);
  static SizedBox get hGapSm => SizedBox(width: sm);
  static SizedBox get hGapMd => SizedBox(width: md);
  static SizedBox get hGapBase => SizedBox(width: base);
  static SizedBox get hGapLg => SizedBox(width: lg);
  static SizedBox get hGapXl => SizedBox(width: xl);

  // ── Padding Presets ─────────────────────────────────────
  static EdgeInsets get paddingSm => EdgeInsets.all(sm);
  static EdgeInsets get paddingMd => EdgeInsets.all(md);
  static EdgeInsets get paddingBase => EdgeInsets.all(base);
  static EdgeInsets get paddingLg => EdgeInsets.all(lg);
  static EdgeInsets get paddingXl => EdgeInsets.all(xl);

  static EdgeInsets get paddingHorizontalBase =>
      EdgeInsets.symmetric(horizontal: base);
  static EdgeInsets get paddingHorizontalLg =>
      EdgeInsets.symmetric(horizontal: lg);
  static EdgeInsets get paddingHorizontalXl =>
      EdgeInsets.symmetric(horizontal: xl);

  static EdgeInsets get paddingVerticalSm => EdgeInsets.symmetric(vertical: sm);
  static EdgeInsets get paddingVerticalBase =>
      EdgeInsets.symmetric(vertical: base);

  // ── Screen Padding ──────────────────────────────────────
  static EdgeInsets get screenPadding =>
      EdgeInsets.symmetric(horizontal: lg, vertical: base);
  static EdgeInsets get screenPaddingHorizontal =>
      EdgeInsets.symmetric(horizontal: lg);
}
