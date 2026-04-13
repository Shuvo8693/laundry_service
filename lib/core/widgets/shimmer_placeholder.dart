import 'package:flutter/material.dart';
import 'package:e_laundry/core/resources/colors/app_colors.dart';
import 'package:shimmer/shimmer.dart';

/// A reusable shimmer loading effect for card/list placeholders
///
/// Usage:
///   ShimmerPlaceholder.card()
///   ShimmerPlaceholder.listItem()
///   ShimmerPlaceholder.circular(size: 50)
class ShimmerPlaceholder extends StatelessWidget {
  final Widget child;

  const ShimmerPlaceholder({super.key, required this.child});

  /// Shimmer for card layouts
  factory ShimmerPlaceholder.card({double? width, double? height}) {
    return ShimmerPlaceholder(
      child: Container(
        width: width ?? double.infinity,
        height: height ?? 120,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  /// Shimmer for list item rows
  factory ShimmerPlaceholder.listItem({double? height}) {
    return ShimmerPlaceholder(
      child: Container(
        width: double.infinity,
        height: height ?? 60,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  /// Shimmer for circular avatars/icons
  factory ShimmerPlaceholder.circular({double size = 40}) {
    return ShimmerPlaceholder(
      child: Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  /// Shimmer for text lines
  factory ShimmerPlaceholder.text({double? width, double? height}) {
    return ShimmerPlaceholder(
      child: Container(
        width: width ?? double.infinity,
        height: height ?? 14,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }

  /// Shimmer for detail screen content
  factory ShimmerPlaceholder.details() {
    return ShimmerPlaceholder(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: 150,
            height: 20,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            height: 14,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            height: 14,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.surfaceContainerHighest,
      highlightColor: AppColors.surfaceContainerLow,
      child: child,
    );
  }
}
