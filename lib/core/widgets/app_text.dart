import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Semantic typographic scale variants for unified typography.
enum AppTextVariant {
  displayLarge,
  displayMedium,
  headlineLarge,
  headlineMedium,
  headlineSmall,
  titleLarge,
  titleMedium,
  titleSmall,
  bodyLarge,
  bodyMedium,
  bodySmall,
  labelLarge,
  labelMedium,
  labelSmall,
}

/// A unified, highly-reusable text widget wrapper to ensure Poppins font and typographic consistency.
class AppText extends StatelessWidget {
  final String text;
  final AppTextVariant variant;
  final Color? color;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;
  final double? fontSize;
  final TextStyle? style;

  const AppText(
    this.text, {
    super.key,
    this.variant = AppTextVariant.bodyMedium,
    this.color,
    this.fontWeight,
    this.textAlign,
    this.overflow,
    this.maxLines,
    this.fontSize,
    this.style,
  });

  // Display Variants
  factory AppText.displayLarge(
    String text, {
    Key? key,
    Color? color,
    FontWeight? fontWeight,
    TextAlign? textAlign,
    TextOverflow? overflow,
    int? maxLines,
    double? fontSize,
    TextStyle? style,
  }) =>
      AppText(
        text,
        key: key,
        variant: AppTextVariant.displayLarge,
        color: color,
        fontWeight: fontWeight,
        textAlign: textAlign,
        overflow: overflow,
        maxLines: maxLines,
        fontSize: fontSize,
        style: style,
      );

  factory AppText.displayMedium(
    String text, {
    Key? key,
    Color? color,
    FontWeight? fontWeight,
    TextAlign? textAlign,
    TextOverflow? overflow,
    int? maxLines,
    double? fontSize,
    TextStyle? style,
  }) =>
      AppText(
        text,
        key: key,
        variant: AppTextVariant.displayMedium,
        color: color,
        fontWeight: fontWeight,
        textAlign: textAlign,
        overflow: overflow,
        maxLines: maxLines,
        fontSize: fontSize,
        style: style,
      );

  // Headline Variants
  factory AppText.headlineLarge(
    String text, {
    Key? key,
    Color? color,
    FontWeight? fontWeight,
    TextAlign? textAlign,
    TextOverflow? overflow,
    int? maxLines,
    double? fontSize,
    TextStyle? style,
  }) =>
      AppText(
        text,
        key: key,
        variant: AppTextVariant.headlineLarge,
        color: color,
        fontWeight: fontWeight,
        textAlign: textAlign,
        overflow: overflow,
        maxLines: maxLines,
        fontSize: fontSize,
        style: style,
      );

  factory AppText.headlineMedium(
    String text, {
    Key? key,
    Color? color,
    FontWeight? fontWeight,
    TextAlign? textAlign,
    TextOverflow? overflow,
    int? maxLines,
    double? fontSize,
    TextStyle? style,
  }) =>
      AppText(
        text,
        key: key,
        variant: AppTextVariant.headlineMedium,
        color: color,
        fontWeight: fontWeight,
        textAlign: textAlign,
        overflow: overflow,
        maxLines: maxLines,
        fontSize: fontSize,
        style: style,
      );

  factory AppText.headlineSmall(
    String text, {
    Key? key,
    Color? color,
    FontWeight? fontWeight,
    TextAlign? textAlign,
    TextOverflow? overflow,
    int? maxLines,
    double? fontSize,
    TextStyle? style,
  }) =>
      AppText(
        text,
        key: key,
        variant: AppTextVariant.headlineSmall,
        color: color,
        fontWeight: fontWeight,
        textAlign: textAlign,
        overflow: overflow,
        maxLines: maxLines,
        fontSize: fontSize,
        style: style,
      );

  // Title Variants
  factory AppText.titleLarge(
    String text, {
    Key? key,
    Color? color,
    FontWeight? fontWeight,
    TextAlign? textAlign,
    TextOverflow? overflow,
    int? maxLines,
    double? fontSize,
    TextStyle? style,
  }) =>
      AppText(
        text,
        key: key,
        variant: AppTextVariant.titleLarge,
        color: color,
        fontWeight: fontWeight,
        textAlign: textAlign,
        overflow: overflow,
        maxLines: maxLines,
        fontSize: fontSize,
        style: style,
      );

  factory AppText.titleMedium(
    String text, {
    Key? key,
    Color? color,
    FontWeight? fontWeight,
    TextAlign? textAlign,
    TextOverflow? overflow,
    int? maxLines,
    double? fontSize,
    TextStyle? style,
  }) =>
      AppText(
        text,
        key: key,
        variant: AppTextVariant.titleMedium,
        color: color,
        fontWeight: fontWeight,
        textAlign: textAlign,
        overflow: overflow,
        maxLines: maxLines,
        fontSize: fontSize,
        style: style,
      );

  factory AppText.titleSmall(
    String text, {
    Key? key,
    Color? color,
    FontWeight? fontWeight,
    TextAlign? textAlign,
    TextOverflow? overflow,
    int? maxLines,
    double? fontSize,
    TextStyle? style,
  }) =>
      AppText(
        text,
        key: key,
        variant: AppTextVariant.titleSmall,
        color: color,
        fontWeight: fontWeight,
        textAlign: textAlign,
        overflow: overflow,
        maxLines: maxLines,
        fontSize: fontSize,
        style: style,
      );

  // Body Variants
  factory AppText.bodyLarge(
    String text, {
    Key? key,
    Color? color,
    FontWeight? fontWeight,
    TextAlign? textAlign,
    TextOverflow? overflow,
    int? maxLines,
    double? fontSize,
    TextStyle? style,
  }) =>
      AppText(
        text,
        key: key,
        variant: AppTextVariant.bodyLarge,
        color: color,
        fontWeight: fontWeight,
        textAlign: textAlign,
        overflow: overflow,
        maxLines: maxLines,
        fontSize: fontSize,
        style: style,
      );

  factory AppText.bodyMedium(
    String text, {
    Key? key,
    Color? color,
    FontWeight? fontWeight,
    TextAlign? textAlign,
    TextOverflow? overflow,
    int? maxLines,
    double? fontSize,
    TextStyle? style,
  }) =>
      AppText(
        text,
        key: key,
        variant: AppTextVariant.bodyMedium,
        color: color,
        fontWeight: fontWeight,
        textAlign: textAlign,
        overflow: overflow,
        maxLines: maxLines,
        fontSize: fontSize,
        style: style,
      );

  factory AppText.bodySmall(
    String text, {
    Key? key,
    Color? color,
    FontWeight? fontWeight,
    TextAlign? textAlign,
    TextOverflow? overflow,
    int? maxLines,
    double? fontSize,
    TextStyle? style,
  }) =>
      AppText(
        text,
        key: key,
        variant: AppTextVariant.bodySmall,
        color: color,
        fontWeight: fontWeight,
        textAlign: textAlign,
        overflow: overflow,
        maxLines: maxLines,
        fontSize: fontSize,
        style: style,
      );

  // Label Variants
  factory AppText.labelLarge(
    String text, {
    Key? key,
    Color? color,
    FontWeight? fontWeight,
    TextAlign? textAlign,
    TextOverflow? overflow,
    int? maxLines,
    double? fontSize,
    TextStyle? style,
  }) =>
      AppText(
        text,
        key: key,
        variant: AppTextVariant.labelLarge,
        color: color,
        fontWeight: fontWeight,
        textAlign: textAlign,
        overflow: overflow,
        maxLines: maxLines,
        fontSize: fontSize,
        style: style,
      );

  factory AppText.labelMedium(
    String text, {
    Key? key,
    Color? color,
    FontWeight? fontWeight,
    TextAlign? textAlign,
    TextOverflow? overflow,
    int? maxLines,
    double? fontSize,
    TextStyle? style,
  }) =>
      AppText(
        text,
        key: key,
        variant: AppTextVariant.labelMedium,
        color: color,
        fontWeight: fontWeight,
        textAlign: textAlign,
        overflow: overflow,
        maxLines: maxLines,
        fontSize: fontSize,
        style: style,
      );

  factory AppText.labelSmall(
    String text, {
    Key? key,
    Color? color,
    FontWeight? fontWeight,
    TextAlign? textAlign,
    TextOverflow? overflow,
    int? maxLines,
    double? fontSize,
    TextStyle? style,
  }) =>
      AppText(
        text,
        key: key,
        variant: AppTextVariant.labelSmall,
        color: color,
        fontWeight: fontWeight,
        textAlign: textAlign,
        overflow: overflow,
        maxLines: maxLines,
        fontSize: fontSize,
        style: style,
      );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    TextStyle baseStyle;

    switch (variant) {
      case AppTextVariant.displayLarge:
        baseStyle = theme.textTheme.displayLarge ?? const TextStyle();
        break;
      case AppTextVariant.displayMedium:
        baseStyle = theme.textTheme.displayMedium ?? const TextStyle();
        break;
      case AppTextVariant.headlineLarge:
        baseStyle = theme.textTheme.headlineLarge ?? const TextStyle();
        break;
      case AppTextVariant.headlineMedium:
        baseStyle = theme.textTheme.headlineMedium ?? const TextStyle();
        break;
      case AppTextVariant.headlineSmall:
        baseStyle = theme.textTheme.headlineSmall ?? const TextStyle();
        break;
      case AppTextVariant.titleLarge:
        baseStyle = theme.textTheme.titleLarge ?? const TextStyle();
        break;
      case AppTextVariant.titleMedium:
        baseStyle = theme.textTheme.titleMedium ?? const TextStyle();
        break;
      case AppTextVariant.titleSmall:
        baseStyle = theme.textTheme.titleSmall ?? const TextStyle();
        break;
      case AppTextVariant.bodyLarge:
        baseStyle = theme.textTheme.bodyLarge ?? const TextStyle();
        break;
      case AppTextVariant.bodyMedium:
        baseStyle = theme.textTheme.bodyMedium ?? const TextStyle();
        break;
      case AppTextVariant.bodySmall:
        baseStyle = theme.textTheme.bodySmall ?? const TextStyle();
        break;
      case AppTextVariant.labelLarge:
        baseStyle = theme.textTheme.labelLarge ?? const TextStyle();
        break;
      case AppTextVariant.labelMedium:
        baseStyle = theme.textTheme.labelMedium ?? const TextStyle();
        break;
      case AppTextVariant.labelSmall:
        baseStyle = theme.textTheme.labelSmall ?? const TextStyle();
        break;
    }

    final mergedStyle = GoogleFonts.poppins(
      textStyle: baseStyle.copyWith(
        color: color,
        fontWeight: fontWeight,
        fontSize: fontSize,
      ),
    );

    return Text(
      text,
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
      style: style != null ? mergedStyle.merge(style) : mergedStyle,
    );
  }
}
