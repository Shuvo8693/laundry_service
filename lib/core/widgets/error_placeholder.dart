import 'package:flutter/material.dart';
import 'package:e_laundry/core/resources/colors/app_colors.dart';
import 'package:e_laundry/core/widgets/custom_text.dart';
import 'package:e_laundry/core/widgets/app_button.dart';
import 'package:e_laundry/core/widgets/spacing.dart';

/// A reusable error placeholder widget for failed API/data loads.
///
/// Usage:
///   ErrorPlaceholder(
///     message: 'Failed to load data',
///     onRetry: () => context.read<MyCubit>().loadData(),
///   )
class ErrorPlaceholder extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  final String? retryText;
  final IconData? icon;
  final double? iconSize;
  final Color? iconColor;
  final EdgeInsets? padding;

  const ErrorPlaceholder({
    super.key,
    required this.message,
    this.onRetry,
    this.retryText,
    this.icon,
    this.iconSize,
    this.iconColor,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon ?? Icons.error_outline,
              size: iconSize ?? 64,
              color: iconColor ?? AppColors.error,
            ),
            const VerticalSpace.large(),
            CustomText.bodyMedium(
              message,
              textAlign: TextAlign.center,
              color: AppColors.onSurfaceVariant,
            ),
            if (onRetry != null) ...[
              const VerticalSpace.large(),
              AppButton.primary(
                text: retryText ?? 'Retry',
                onPressed: onRetry,
                width: 160,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
