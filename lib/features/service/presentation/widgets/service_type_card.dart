import 'package:flutter/material.dart';
import 'package:e_laundry/core/resources/colors/app_colors.dart';
import 'package:e_laundry/core/utils/screen_util.dart';
import 'package:e_laundry/core/widgets/custom_text.dart';
import 'package:e_laundry/core/widgets/spacing.dart';
import '../../domain/entities/service_entity.dart';

class ServiceTypeCard extends StatelessWidget {
  final ServiceEntity service;
  final bool isSelected;
  final VoidCallback onTap;

  const ServiceTypeCard({
    super.key,
    required this.service,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 114.w,
        child: Column(
          children: [
            Container(
              height: 80.h,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.surfaceContainerHigh,
                  width: isSelected ? 2 : 1,
                ),
                color: isSelected ? AppColors.primaryContainer : AppColors.surfaceContainerLowest,
              ),
              child: Icon(
                service.icon,
                color: AppColors.primary,
                size: 32.sp,
              ),
            ),
            const VerticalSpace(8),
            CustomText(
              text: service.title,
              textType: TextType.bodyMedium,
              color: AppColors.onSurface,
              textAlign: TextAlign.center,
            ),
            const VerticalSpace(4),
            CustomText(
              text: service.priceInfo,
              textType: TextType.labelSmall,
              color: AppColors.onSurfaceVariant,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
