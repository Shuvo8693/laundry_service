import 'package:e_laundry/core/resources/colors/app_colors.dart';
import 'package:e_laundry/core/utils/screen_util.dart';
import 'package:e_laundry/core/widgets/custom_text.dart';
import 'package:e_laundry/core/widgets/spacing.dart';
import 'package:flutter/material.dart';

class HomeAppBarSection extends StatelessWidget {
  final String userName;
  final String location;

  const HomeAppBarSection({
    super.key,
    required this.userName,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: 'Welcome, $userName',
                textType: TextType.headlineMedium,
                color: AppColors.onSurface,
              ),
              const VerticalSpace(4),
              Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 16.sp,
                    color: AppColors.onSurfaceVariant,
                  ),
                  const HorizontalSpace(4),
                  CustomText(
                    text: location,
                    textType: TextType.bodyMedium,
                    color: AppColors.onSurfaceVariant,
                  ),
                  const HorizontalSpace(4),
                  Icon(
                    Icons.keyboard_arrow_down,
                    size: 16.sp,
                    color: AppColors.onSurfaceVariant,
                  ),
                ],
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surfaceContainerHigh,
            ),
            child: Icon(
              Icons.notifications_none_outlined,
              size: 24.sp,
              color: AppColors.onSurface,
            ),
          )
        ],
      ),
    );
  }
}

