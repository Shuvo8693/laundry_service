import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:e_laundry/core/resources/colors/app_colors.dart';
import 'package:e_laundry/core/widgets/custom_text.dart';
import 'package:e_laundry/core/widgets/spacing.dart';

/// A reusable custom AppBar widget implementing PreferredSizeWidget
///
/// Usage:
///   CustomAppBar(title: 'My Title')
///   CustomAppBar(title: 'Title', showBackButton: true, actions: [...])
///   CustomAppBar.withSubtitle(title: 'Main', subtitle: 'Sub')
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final List<Widget>? actions;
  final Widget? leading;
  final bool showBackButton;
  final VoidCallback? onBack;
  final Color? backgroundColor;
  final double? elevation;
  final Widget? titleWidget;
  final bool centerTitle;

  const CustomAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.actions,
    this.leading,
    this.showBackButton = false,
    this.onBack,
    this.backgroundColor,
    this.elevation,
    this.titleWidget,
    this.centerTitle = false,
  });

  /// Constructor with custom title widget
  const CustomAppBar.custom({
    super.key,
    this.title = '',
    this.subtitle,
    this.actions,
    this.leading,
    this.showBackButton = false,
    this.onBack,
    this.backgroundColor,
    this.elevation,
    required this.titleWidget,
    this.centerTitle = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor ?? AppColors.surface,
      elevation: elevation ?? 0,
      automaticallyImplyLeading: false,
      leading: leading ?? _buildLeading(context),
      title: titleWidget ?? _buildTitle(),
      actions: actions,
      centerTitle: centerTitle,
    );
  }

  Widget? _buildLeading(BuildContext context) {
    if (showBackButton && Navigator.of(context).canPop()) {
      return IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColors.primary),
        onPressed: onBack ?? () => context.pop(),
      );
    }
    return null;
  }

  Widget _buildTitle() {
    if (subtitle != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomText.labelSmall(title, color: AppColors.primary),
          const VerticalSpace.small(),
          CustomText.headlineMedium(subtitle!, color: AppColors.primary),
        ],
      );
    }

    return CustomText.headlineMedium(title, color: AppColors.primary);
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
