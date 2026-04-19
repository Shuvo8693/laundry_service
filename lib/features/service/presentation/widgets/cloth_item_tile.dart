import 'package:flutter/material.dart';
import 'package:e_laundry/core/resources/colors/app_colors.dart';
import 'package:e_laundry/core/utils/screen_util.dart';
import 'package:e_laundry/core/widgets/custom_text.dart';
import 'package:e_laundry/core/widgets/spacing.dart';
import '../../domain/entities/cloth_item_entity.dart';

class ClothItemTile extends StatelessWidget {
  final ClothItemEntity item;
  final ValueChanged<int> onCountChanged;

  const ClothItemTile({
    super.key,
    required this.item,
    required this.onCountChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.surfaceContainerHigh),
        color: AppColors.surfaceContainerLowest,
      ),
      child: Row(
        children: [
          Icon(item.icon, color: AppColors.onSurfaceVariant, size: 24.sp),
          const HorizontalSpace(12),
          Expanded(
            child: CustomText(
              text: item.name,
              textType: TextType.bodyLarge,
              color: AppColors.onSurface,
            ),
          ),
          _buildCounter(),
        ],
      ),
    );
  }

  Widget _buildCounter() {
    return Row(
      children: [
        _CounterButton(
          icon: Icons.remove,
          onPressed: item.count > 0 ? () => onCountChanged(item.count - 1) : null,
          color: AppColors.surfaceContainerHigh,
          iconColor: AppColors.onSurface,
        ),
        SizedBox(
          width: 32.w,
          child: CustomText(
            text: item.count.toString(),
            textType: TextType.labelLarge,
            color: AppColors.onSurface,
            textAlign: TextAlign.center,
          ),
        ),
        _CounterButton(
          icon: Icons.add,
          onPressed: () => onCountChanged(item.count + 1),
          color: AppColors.primary,
          iconColor: AppColors.onPrimary,
        ),
      ],
    );
  }
}

class _CounterButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Color color;
  final Color iconColor;

  const _CounterButton({
    required this.icon,
    required this.onPressed,
    required this.color,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 32.r,
        height: 32.r,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 16.sp, color: iconColor),
      ),
    );
  }
}
