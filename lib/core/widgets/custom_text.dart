import 'package:flutter/material.dart';
import 'package:e_laundry/core/resources/colors/app_colors.dart';

/// Text style types available in the design system
enum TextType {
  displayLarge,
  displayMedium,
  headlineLarge,
  headlineMedium,
  bodyLarge,
  bodyMedium,
  bodySmall,
  labelLarge,
  labelSmall,
}

/// A reusable Text widget that resolves styles directly from [AppTextTheme]
/// via [Theme.of(context).textTheme] — so any update to [AppTextTheme] is
/// automatically reflected here.
///
/// Usage:
///   CustomText('Hello', textType: TextType.headlineLarge)
///   CustomText.headlineLarge('Hello', color: AppColors.primary)
class CustomText extends StatelessWidget {
  final String text;
  final TextType textType;
  final Color? color;
  final FontWeight? fontWeight;
  final double? fontSize;
  final double? height;
  final double? letterSpacing;
  final TextOverflow? overflow;
  final int? maxLines;
  final TextAlign? textAlign;
  final List<Shadow>? shadows;
  final TextDecoration? decoration;
  final Color? decorationColor;
  final TextDecorationStyle? decorationStyle;

  const CustomText({
    super.key,
    required this.text,
    this.textType = TextType.bodyMedium,
    this.color,
    this.fontWeight,
    this.fontSize,
    this.height,
    this.letterSpacing,
    this.overflow,
    this.maxLines,
    this.textAlign,
    this.shadows,
    this.decoration,
    this.decorationColor,
    this.decorationStyle,
  });

  // ── Named constructors ───────────────────────────────────────────────────

  /// Display Large — 32px, ExtraBold, Plus Jakarta Sans
  const CustomText.displayLarge(
    this.text, {
    super.key,
    this.color,
    this.overflow,
    this.fontWeight,
    this.maxLines,
    this.textAlign,
  }) : textType = TextType.displayLarge,
       fontSize = null,
       height = null,
       letterSpacing = null,
       shadows = null,
       decoration = null,
       decorationColor = null,
       decorationStyle = null;

  /// Display Medium — 28px, Bold, Plus Jakarta Sans
  const CustomText.displayMedium(
    this.text, {
    super.key,
    this.color,
    this.overflow,
    this.fontWeight,
    this.maxLines,
    this.textAlign,
  }) : textType = TextType.displayMedium,
       fontSize = null,
       height = null,
       letterSpacing = null,
       shadows = null,
       decoration = null,
       decorationColor = null,
       decorationStyle = null;

  /// Headline Large — 24px, Bold, Plus Jakarta Sans
  const CustomText.headlineLarge(
    this.text, {
    super.key,
    this.color,
    this.overflow,
    this.fontWeight,
    this.maxLines,
    this.textAlign,
  }) : textType = TextType.headlineLarge,
       fontSize = null,
       height = null,
       letterSpacing = null,
       shadows = null,
       decoration = null,
       decorationColor = null,
       decorationStyle = null;

  /// Headline Medium — 20px, SemiBold, Plus Jakarta Sans
  const CustomText.headlineMedium(
    this.text, {
    super.key,
    this.color,
    this.overflow,
    this.fontWeight,
    this.maxLines,
    this.textAlign,
  }) : textType = TextType.headlineMedium,
       fontSize = null,
       height = null,
       letterSpacing = null,
       shadows = null,
       decoration = null,
       decorationColor = null,
       decorationStyle = null;

  /// Body Large — 16px, Regular, Inter, height 1.5
  const CustomText.bodyLarge(
    this.text, {
    super.key,
    this.color,
    this.overflow,
    this.fontWeight,
    this.maxLines,
    this.textAlign,
  }) : textType = TextType.bodyLarge,
       fontSize = null,
       height = null,
       letterSpacing = null,
       shadows = null,
       decoration = null,
       decorationColor = null,
       decorationStyle = null;

  /// Body Medium — 14px, Regular, Inter
  const CustomText.bodyMedium(
    this.text, {
    super.key,
    this.color,
    this.overflow,
    this.fontWeight,
    this.maxLines,
    this.textAlign,
  }) : textType = TextType.bodyMedium,
       fontSize = null,
       height = null,
       letterSpacing = null,
       shadows = null,
       decoration = null,
       decorationColor = null,
       decorationStyle = null;

  /// Body Small — 12px, Regular, Inter, onSurfaceVariant
  const CustomText.bodySmall(
    this.text, {
    super.key,
    this.color,
    this.overflow,
    this.fontWeight,
    this.maxLines,
    this.textAlign,
  }) : textType = TextType.bodySmall,
       fontSize = null,
       height = null,
       letterSpacing = null,
       shadows = null,
       decoration = null,
       decorationColor = null,
       decorationStyle = null;

  /// Label Large — 14px, SemiBold, Plus Jakarta Sans
  const CustomText.labelLarge(
    this.text, {
    super.key,
    this.color,
    this.overflow,
    this.maxLines,
    this.fontWeight,
    this.textAlign,
  }) : textType = TextType.labelLarge,
       fontSize = null,
       height = null,
       letterSpacing = null,
       shadows = null,
       decoration = null,
       decorationColor = null,
       decorationStyle = null;

  /// Label Small — 10px, Bold, Plus Jakarta Sans, onSurfaceVariant
  const CustomText.labelSmall(
    this.text, {
    super.key,
    this.color,
    this.overflow,
    this.maxLines,
    this.fontWeight,
    this.textAlign,
  }) : textType = TextType.labelSmall,
       fontSize = null,
       height = null,
       letterSpacing = null,
       shadows = null,
       decoration = null,
       decorationColor = null,
       decorationStyle = null;

  // ── Style resolution ─────────────────────────────────────────────────────

  /// Picks the matching [TextStyle] from [ThemeData.textTheme], then applies
  /// any caller-supplied overrides on top. This means [AppTextTheme] is always
  /// the single source of truth — no values are duplicated here.
  TextStyle _resolveStyle(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    // Map TextType → textTheme slot
    final TextStyle? base = switch (textType) {
      TextType.displayLarge => tt.displayLarge,
      TextType.displayMedium => tt.displayMedium,
      TextType.headlineLarge => tt.headlineLarge,
      TextType.headlineMedium => tt.headlineMedium,
      TextType.bodyLarge => tt.bodyLarge,
      TextType.bodyMedium => tt.bodyMedium,
      TextType.bodySmall => tt.bodySmall,
      TextType.labelLarge => tt.labelLarge,
      TextType.labelSmall => tt.labelSmall,
    };

    // Fallback colour for variants not set in AppTextTheme
    final Color fallbackColor = switch (textType) {
      TextType.bodySmall || TextType.labelSmall => AppColors.onSurfaceVariant,
      _ => AppColors.onSurface,
    };

    return (base ?? const TextStyle()).copyWith(
      color: color ?? base?.color ?? fallbackColor,
      fontWeight: fontWeight,
      fontSize: fontSize,
      height: height,
      letterSpacing: letterSpacing,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationStyle: decorationStyle,
      shadows: shadows,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: _resolveStyle(context),
      maxLines: maxLines,
      textAlign: textAlign,
      overflow: overflow,
    );
  }
}
