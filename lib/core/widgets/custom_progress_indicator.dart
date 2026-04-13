import 'package:flutter/material.dart';
import 'package:e_laundry/core/resources/colors/app_colors.dart';

/// A reusable custom circular progress indicator with consistent styling
///
/// Usage:
///   CustomCircularProgressIndicator()
///   CustomCircularProgressIndicator(size: 30, strokeWidth: 3)
class CustomCircularProgressIndicator extends StatelessWidget {
  final double? size;
  final double? strokeWidth;
  final Color? color;
  final Animation<double>? value;

  const CustomCircularProgressIndicator({
    super.key,
    this.size,
    this.strokeWidth,
    this.color,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size ?? 24,
      height: size ?? 24,
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth ?? 2.5,
        value: value?.value,
        valueColor: AlwaysStoppedAnimation<Color>(
          color ?? AppColors.primaryContainer,
        ),
      ),
    );
  }
}
