import 'package:e_laundry/core/utils/screen_util.dart';
import 'package:flutter/material.dart';

/// Reusable vertical and horizontal spacing widgets
/// Replaces SizedBox(height: x) and SizedBox(width: x) with semantic names

/// Vertical spacing widget
class VerticalSpace extends StatelessWidget {
  final double height;

  const VerticalSpace(this.height, {super.key});

  /// Small vertical space (8px)
  const VerticalSpace.small({super.key}) : height = 8;

  /// Medium vertical space (16px)
  const VerticalSpace.medium({super.key}) : height = 16;

  /// Large vertical space (24px)
  const VerticalSpace.large({super.key}) : height = 24;

  /// Extra large vertical space (32px)
  const VerticalSpace.xlarge({super.key}) : height = 32;

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: height.h);
  }
}

/// Horizontal spacing widget
class HorizontalSpace extends StatelessWidget {
  final double width;

  const HorizontalSpace(this.width, {super.key});

  /// Small horizontal space (8px)
  const HorizontalSpace.small({super.key}) : width = 8;

  /// Medium horizontal space (16px)
  const HorizontalSpace.medium({super.key}) : width = 16;

  /// Large horizontal space (24px)
  const HorizontalSpace.large({super.key}) : width = 24;

  /// Extra large horizontal space (32px)
  const HorizontalSpace.xlarge({super.key}) : width = 32;

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: width.w);
  }
}
