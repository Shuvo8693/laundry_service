import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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

/// Font family options
enum FontFamily { plusJakartaSans, inter }

/// A reusable Text widget with predefined styles from AppTextTheme
///
/// Usage:
///   CustomText('Hello World', textType: TextType.headlineLarge)
///   CustomText('Body text', textType: TextType.bodyMedium, color: AppColors.primary)
class CustomText extends StatelessWidget {
  final String text;
  final TextType textType;
  final FontFamily? fontFamily;
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

  const CustomText(
    this.text, {
    super.key,
    this.textType = TextType.bodyMedium,
    this.fontFamily,
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

  /// Display Large - 32px, ExtraBold, Plus Jakarta Sans
  const CustomText.displayLarge(
    this.text, {
    super.key,
    this.color,
    this.overflow,
    this.maxLines,
    this.textAlign,
  }) : textType = TextType.displayLarge,
       fontFamily = null,
       fontWeight = null,
       fontSize = null,
       height = null,
       letterSpacing = null,
       shadows = null,
       decoration = null,
       decorationColor = null,
       decorationStyle = null;

  /// Display Medium - 28px, Bold, Plus Jakarta Sans
  const CustomText.displayMedium(
    this.text, {
    super.key,
    this.color,
    this.overflow,
    this.maxLines,
    this.textAlign,
  }) : textType = TextType.displayMedium,
       fontFamily = null,
       fontWeight = null,
       fontSize = null,
       height = null,
       letterSpacing = null,
       shadows = null,
       decoration = null,
       decorationColor = null,
       decorationStyle = null;

  /// Headline Large - 24px, Bold, Plus Jakarta Sans
  const CustomText.headlineLarge(
    this.text, {
    super.key,
    this.color,
    this.overflow,
    this.maxLines,
    this.textAlign,
  }) : textType = TextType.headlineLarge,
       fontFamily = null,
       fontWeight = null,
       fontSize = null,
       height = null,
       letterSpacing = null,
       shadows = null,
       decoration = null,
       decorationColor = null,
       decorationStyle = null;

  /// Headline Medium - 20px, SemiBold, Plus Jakarta Sans
  const CustomText.headlineMedium(
    this.text, {
    super.key,
    this.color,
    this.overflow,
    this.maxLines,
    this.textAlign,
  }) : textType = TextType.headlineMedium,
       fontFamily = null,
       fontWeight = null,
       fontSize = null,
       height = null,
       letterSpacing = null,
       shadows = null,
       decoration = null,
       decorationColor = null,
       decorationStyle = null;

  /// Body Large - 16px, Regular, Inter
  const CustomText.bodyLarge(
    this.text, {
    super.key,
    this.color,
    this.overflow,
    this.maxLines,
    this.textAlign,
  }) : textType = TextType.bodyLarge,
       fontFamily = null,
       fontWeight = null,
       fontSize = null,
       height = null,
       letterSpacing = null,
       shadows = null,
       decoration = null,
       decorationColor = null,
       decorationStyle = null;

  /// Body Medium - 14px, Regular, Inter
  const CustomText.bodyMedium(
    this.text, {
    super.key,
    this.color,
    this.overflow,
    this.maxLines,
    this.textAlign,
  }) : textType = TextType.bodyMedium,
       fontFamily = null,
       fontWeight = null,
       fontSize = null,
       height = null,
       letterSpacing = null,
       shadows = null,
       decoration = null,
       decorationColor = null,
       decorationStyle = null;

  /// Body Small - 12px, Regular, Inter
  const CustomText.bodySmall(
    this.text, {
    super.key,
    this.color,
    this.overflow,
    this.maxLines,
    this.textAlign,
  }) : textType = TextType.bodySmall,
       fontFamily = null,
       fontWeight = null,
       fontSize = null,
       height = null,
       letterSpacing = null,
       shadows = null,
       decoration = null,
       decorationColor = null,
       decorationStyle = null;

  /// Label Large - 14px, SemiBold, Plus Jakarta Sans
  const CustomText.labelLarge(
    this.text, {
    super.key,
    this.color,
    this.overflow,
    this.maxLines,
    this.textAlign,
  }) : textType = TextType.labelLarge,
       fontFamily = null,
       fontWeight = null,
       fontSize = null,
       height = null,
       letterSpacing = null,
       shadows = null,
       decoration = null,
       decorationColor = null,
       decorationStyle = null;

  /// Label Small - 10px, Bold, Plus Jakarta Sans
  const CustomText.labelSmall(
    this.text, {
    super.key,
    this.color,
    this.overflow,
    this.maxLines,
    this.textAlign,
  }) : textType = TextType.labelSmall,
       fontFamily = null,
       fontWeight = null,
       fontSize = null,
       height = null,
       letterSpacing = null,
       shadows = null,
       decoration = null,
       decorationColor = null,
       decorationStyle = null;

  TextStyle _getTextStyle() {
    // Default colors based on text type
    Color defaultColor;
    switch (textType) {
      case TextType.bodySmall:
      case TextType.labelSmall:
        defaultColor = AppColors.onSurfaceVariant;
        break;
      default:
        defaultColor = AppColors.onSurface;
    }

    // Get font family
    FontFamily effectiveFontFamily =
        fontFamily ??
        ((textType == TextType.bodyLarge ||
                textType == TextType.bodyMedium ||
                textType == TextType.bodySmall)
            ? FontFamily.inter
            : FontFamily.plusJakartaSans);

    // Get font size, weight, and other properties based on textType
    double effectiveFontSize;
    FontWeight effectiveFontWeight;
    double? effectiveHeight;
    double? effectiveLetterSpacing;

    switch (textType) {
      case TextType.displayLarge:
        effectiveFontSize = 32;
        effectiveFontWeight = FontWeight.w800;
        effectiveLetterSpacing = -0.5;
        break;
      case TextType.displayMedium:
        effectiveFontSize = 28;
        effectiveFontWeight = FontWeight.w700;
        break;
      case TextType.headlineLarge:
        effectiveFontSize = 24;
        effectiveFontWeight = FontWeight.w700;
        break;
      case TextType.headlineMedium:
        effectiveFontSize = 20;
        effectiveFontWeight = FontWeight.w600;
        break;
      case TextType.bodyLarge:
        effectiveFontSize = 16;
        effectiveFontWeight = FontWeight.w400;
        effectiveHeight = 1.5;
        break;
      case TextType.bodyMedium:
        effectiveFontSize = 14;
        effectiveFontWeight = FontWeight.w400;
        break;
      case TextType.bodySmall:
        effectiveFontSize = 12;
        effectiveFontWeight = FontWeight.w400;
        break;
      case TextType.labelLarge:
        effectiveFontSize = 14;
        effectiveFontWeight = FontWeight.w600;
        break;
      case TextType.labelSmall:
        effectiveFontSize = 10;
        effectiveFontWeight = FontWeight.w700;
        effectiveLetterSpacing = 0.2;
        break;
    }

    // Apply Google Fonts
    TextStyle baseStyle;
    switch (effectiveFontFamily) {
      case FontFamily.plusJakartaSans:
        baseStyle = GoogleFonts.plusJakartaSans();
        break;
      case FontFamily.inter:
        baseStyle = GoogleFonts.inter();
        break;
    }

    // Apply custom overrides
    return baseStyle.copyWith(
      fontSize: fontSize ?? effectiveFontSize,
      fontWeight: fontWeight ?? effectiveFontWeight,
      color: color ?? defaultColor,
      height: height ?? effectiveHeight,
      letterSpacing: letterSpacing ?? effectiveLetterSpacing,
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
      style: _getTextStyle(),
      maxLines: maxLines,
      textAlign: textAlign,
      overflow: overflow,
    );
  }
}
