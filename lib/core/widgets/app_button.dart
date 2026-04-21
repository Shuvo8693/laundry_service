import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:e_laundry/core/resources/colors/app_colors.dart';
import 'package:e_laundry/core/utils/screen_util.dart';

/// Custom button widget following the design system.
/// All new parameters are nullable — existing call-sites are unaffected.
class AppButton extends StatelessWidget {
  // ── Required ──────────────────────────────────────────────────────────────
  final String text;
  final VoidCallback? onPressed;

  // ── Sizing ────────────────────────────────────────────────────────────────
  final double? width;

  /// Explicit button height. When null the height is driven by [padding].
  final double? height;

  // ── Padding ───────────────────────────────────────────────────────────────
  /// Full [EdgeInsets] override. When set, [horizontalPadding] and
  /// [verticalPadding] are ignored.
  final EdgeInsets? padding;
  final double horizontalPadding;
  final double verticalPadding;

  // ── Shape ─────────────────────────────────────────────────────────────────
  /// Border radius in logical pixels. Defaults to 9999 (pill shape).
  final double? borderRadius;

  // ── Color / Gradient ──────────────────────────────────────────────────────
  final List<Color>? gradientColors;
  final Color? backgroundColor;
  final Color? textColor;

  // ── Outline style ─────────────────────────────────────────────────────────
  /// When true, renders a transparent background with a visible border.
  final bool isOutlined;

  /// Border colour used when [isOutlined] is true or when set explicitly.
  final Color? borderColor;

  /// Border stroke width. Defaults to 1 when [isOutlined] is true.
  final double? borderWidth;

  // ── Shadow ────────────────────────────────────────────────────────────────
  /// Pass 0 to remove the drop shadow entirely.
  final double? elevation;

  // ── Typography ────────────────────────────────────────────────────────────
  final double fontSize;
  final FontWeight fontWeight;

  /// Overrides the full text [TextStyle]. When set, [fontSize], [fontWeight],
  /// [textColor], and [letterSpacing] are ignored.
  final TextStyle? textStyle;
  final double? letterSpacing;

  // ── State ─────────────────────────────────────────────────────────────────
  final bool isLoading;

  // ── Icon ──────────────────────────────────────────────────────────────────
  final Widget? icon;

  /// When true, the icon appears after the label instead of before it.
  final bool iconAfterText;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    // Sizing
    this.width,
    this.height,
    // Padding
    this.padding,
    this.horizontalPadding = 32,
    this.verticalPadding = 14,
    // Shape
    this.borderRadius,
    // Color
    this.gradientColors,
    this.backgroundColor,
    this.textColor,
    // Outline
    this.isOutlined = false,
    this.borderColor,
    this.borderWidth,
    // Shadow
    this.elevation,
    // Typography
    this.fontSize = 14,
    this.fontWeight = FontWeight.bold,
    this.textStyle,
    this.letterSpacing,
    // State
    this.isLoading = false,
    // Icon
    this.icon,
    this.iconAfterText = false,
  });

  // ── Factory constructors (unchanged API) ─────────────────────────────────

  /// Default primary gradient (teal)
  factory AppButton.primary({
    required String text,
    required VoidCallback? onPressed,
    double? width,
    double? height,
    double? horizontalPadding,
    bool isLoading = false,
    Widget? icon,
    bool iconAfterText = false,
  }) {
    return AppButton(
      key: UniqueKey(),
      text: text,
      onPressed: onPressed,
      gradientColors: const [AppColors.primary, AppColors.primaryContainer],
      textColor: AppColors.onPrimary,
      width: width,
      height: height,
      horizontalPadding: horizontalPadding ?? 32,
      isLoading: isLoading,
      icon: icon,
      iconAfterText: iconAfterText,
    );
  }

  /// Secondary gradient (blue)
  factory AppButton.secondary({
    required String text,
    required VoidCallback? onPressed,
    double? width,
    double? height,
    bool isLoading = false,
    Widget? icon,
    bool iconAfterText = false,
  }) {
    return AppButton(
      key: UniqueKey(),
      text: text,
      onPressed: onPressed,
      gradientColors: const [AppColors.secondary, AppColors.secondaryContainer],
      textColor: AppColors.onSecondary,
      width: width,
      height: height,
      isLoading: isLoading,
      icon: icon,
      iconAfterText: iconAfterText,
    );
  }

  /// Outlined style — transparent fill, visible border
  factory AppButton.outlined({
    required String text,
    required VoidCallback? onPressed,
    double? width,
    double? height,
    double? horizontalPadding,
    Color? backgroundColor,
    Color? textColor,
    Color? borderColor,
    double? borderWidth,
    double? borderRadius,
    Widget? icon,
    bool iconAfterText = false,
    bool isLoading = false,
  }) {
    return AppButton(
      key: UniqueKey(),
      text: text,
      onPressed: onPressed,
      isOutlined: true,
      backgroundColor: backgroundColor ?? Colors.transparent,
      textColor: textColor ?? AppColors.primary,
      borderColor: borderColor ?? AppColors.primary,
      borderWidth: borderWidth,
      borderRadius: borderRadius,
      width: width,
      height: height,
      horizontalPadding: horizontalPadding ?? 32,
      icon: icon,
      iconAfterText: iconAfterText,
      isLoading: isLoading,
    );
  }

  /// White button (for dark backgrounds)
  factory AppButton.white({
    required String text,
    required VoidCallback? onPressed,
    double? width,
    double? height,
    Color? textColor,
    Widget? icon,
  }) {
    return AppButton(
      key: UniqueKey(),
      text: text,
      onPressed: onPressed,
      backgroundColor: Colors.white,
      textColor: textColor ?? AppColors.primary,
      width: width,
      height: height,
      icon: icon,
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  double get _resolvedRadius => borderRadius ?? 9999;

  EdgeInsets get _resolvedPadding =>
      padding ??
      EdgeInsets.symmetric(
        horizontal: horizontalPadding.w,
        vertical: verticalPadding.h,
      );

  Color get _primaryColor =>
      gradientColors?.first ?? backgroundColor ?? AppColors.primary;

  double get _resolvedElevation => elevation ?? 8;

  BoxBorder? get _border {
    if (isOutlined) {
      return Border.all(
        color: borderColor ?? AppColors.primary,
        width: borderWidth ?? 1,
      );
    }
    if (borderColor != null) {
      return Border.all(color: borderColor!, width: borderWidth ?? 1);
    }
    return null;
  }

  List<BoxShadow> get _shadows {
    if (_resolvedElevation <= 0) return [];
    return [
      BoxShadow(
        color: _primaryColor.withValues(alpha: 0.3),
        blurRadius: _resolvedElevation,
        offset: const Offset(0, 4),
      ),
    ];
  }

  TextStyle get _labelStyle =>
      textStyle ??
      GoogleFonts.inter(
        fontSize: fontSize.sp,
        fontWeight: fontWeight,
        color: textColor ?? Colors.white,
        letterSpacing: letterSpacing ?? 0.5,
      );

  Widget _buildLabel() {
    final label = Text(text, style: _labelStyle);

    if (icon == null) return label;

    final iconWidget = icon!;
    final gap = SizedBox(width: 8.w);

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: iconAfterText
          ? [label, gap, iconWidget]
          : [iconWidget, gap, label],
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width != null ? width!.w : double.infinity,
      height: height?.h,
      child: Container(
        decoration: BoxDecoration(
          gradient: (!isOutlined && gradientColors != null)
              ? LinearGradient(colors: gradientColors!)
              : null,
          color: (!isOutlined && gradientColors == null)
              ? (backgroundColor ?? AppColors.primary)
              : isOutlined
                  ? (backgroundColor ?? Colors.transparent)
                  : null,
          borderRadius: BorderRadius.circular(_resolvedRadius.r),
          border: _border,
          boxShadow: _shadows,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isLoading ? null : onPressed,
            borderRadius: BorderRadius.circular(_resolvedRadius.r),
            child: Padding(
              padding: _resolvedPadding,
              child: Center(
                child: isLoading
                    ? SizedBox(
                        width: 20.r,
                        height: 20.r,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            textColor ?? Colors.white,
                          ),
                        ),
                      )
                    : _buildLabel(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
