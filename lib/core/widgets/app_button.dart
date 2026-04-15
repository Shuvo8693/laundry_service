import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:e_laundry/core/resources/colors/app_colors.dart';

/// Custom button widget following the design system from home_design.html
/// Based on the "Start" button design with gradient and rounded-full style
class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final List<Color>? gradientColors;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double horizontalPadding;
  final double verticalPadding;
  final double fontSize;
  final FontWeight fontWeight;
  final bool isLoading;
  final Widget? icon;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.gradientColors,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.horizontalPadding = 32,
    this.verticalPadding = 14,
    this.fontSize = 14,
    this.fontWeight = FontWeight.bold,
    this.isLoading = false,
    this.icon,
  });

  /// Default primary gradient (teal)
  factory AppButton.primary({
    required String text,
    required VoidCallback? onPressed,
    double? width,
    double? horizontalPadding,
    bool isLoading = false,
    Widget? icon,
  }) {
    return AppButton(
      key: UniqueKey(),
      text: text,
      horizontalPadding: horizontalPadding ?? 32,
      onPressed: onPressed,
      gradientColors: const [AppColors.primary, AppColors.primaryContainer],
      textColor: AppColors.onPrimary,
      width: width,
      isLoading: isLoading,
      icon: icon,
    );
  }

  /// Secondary gradient (blue)
  factory AppButton.secondary({
    required String text,
    required VoidCallback? onPressed,
    double? width,
    bool isLoading = false,
    Widget? icon,
  }) {
    return AppButton(
      key: UniqueKey(),
      text: text,
      onPressed: onPressed,
      gradientColors: const [AppColors.secondary, AppColors.secondaryContainer],
      textColor: AppColors.onSecondary,
      width: width,
      isLoading: isLoading,
      icon: icon,
    );
  }

  /// Outlined/secondary button style
  factory AppButton.outlined({
    required String text,
    required VoidCallback? onPressed,
    double? width,
    double? horizontalPadding,
    Color? backgroundColor,
    Color? textColor,
  }) {
    return AppButton(
      key: UniqueKey(),
      text: text,
      horizontalPadding: horizontalPadding ?? 32,
      onPressed: onPressed,
      backgroundColor: backgroundColor ?? AppColors.surfaceContainerHigh,
      textColor: textColor ?? AppColors.onSurfaceVariant,
      width: width,
    );
  }

  /// White button (for dark backgrounds)
  factory AppButton.white({
    required String text,
    required VoidCallback? onPressed,
    double? width,
    Color? textColor,
  }) {
    return AppButton(
      key: UniqueKey(),
      text: text,
      onPressed: onPressed,
      backgroundColor: Colors.white,
      textColor: textColor ?? AppColors.primary,
      width: width,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      child: Container(
        decoration: BoxDecoration(
          gradient: gradientColors != null
              ? LinearGradient(colors: gradientColors!)
              : null,
          color: gradientColors == null
              ? (backgroundColor ?? AppColors.primary)
              : null,
          borderRadius: BorderRadius.circular(9999),
          boxShadow: [
            BoxShadow(
              color:
                  (gradientColors != null
                          ? gradientColors!.first
                          : backgroundColor ?? AppColors.primary)
                      .withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isLoading ? null : onPressed,
            borderRadius: BorderRadius.circular(9999),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalPadding,
              ),
              child: Center(
                child: isLoading
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            textColor ?? Colors.white,
                          ),
                        ),
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (icon != null) ...[
                            icon!,
                            const SizedBox(width: 8),
                          ],
                          Text(
                            text,
                            style: GoogleFonts.inter(
                              fontSize: fontSize,
                              fontWeight: fontWeight,
                              color: textColor ?? Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
