import 'package:e_laundry/core/resources/colors/app_colors.dart';
import 'package:e_laundry/core/utils/screen_util.dart';
import 'package:e_laundry/core/widgets/custom_text.dart';
import 'package:e_laundry/core/widgets/spacing.dart';
import 'package:flutter/material.dart';

class HomeBannerSection extends StatelessWidget {
  const HomeBannerSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: const Color(0xFFEDFDFE), // Light primary color based on design
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: 'Need Laundry?',
                  textType: TextType.headlineMedium,
                  color: AppColors.onSurface,
                ),
                const VerticalSpace(8),
                CustomText(
                  text: 'Schedule a pickup today and get it delivered in 48hrs.',
                  textType: TextType.bodyMedium,
                  color: AppColors.onSurfaceVariant,
                ),
                const VerticalSpace(16),
                InkWell(
                  onTap: () {},
                  borderRadius: BorderRadius.circular(30.r),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 10.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(30.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        )
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.date_range_outlined,
                          size: 16.sp,
                          color: AppColors.onPrimary,
                        ),
                        const HorizontalSpace(8),
                        CustomText(
                          text: 'Book Now',
                          textType: TextType.labelLarge,
                          color: AppColors.onPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const HorizontalSpace(16),
          Container(
            width: 96.w,
            height: 96.w,
            decoration: BoxDecoration(
              color: const Color(0xFFD1F7FC),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.local_laundry_service,
              size: 48.sp,
              color: AppColors.primaryContainer,
            ),
          ),
        ],
      ),
    );
  }
}

