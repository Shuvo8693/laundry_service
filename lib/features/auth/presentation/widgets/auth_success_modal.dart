import 'package:flutter/material.dart';
import 'package:e_laundry/core/utils/screen_util.dart';
import 'package:e_laundry/core/resources/colors/app_colors.dart';
import 'package:e_laundry/core/widgets/widgets.dart';

class AuthSuccessModal extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback onConfirm;

  const AuthSuccessModal({
    super.key,
    required this.title,
    required this.description,
    required this.onConfirm,
  });

  static void show(
    BuildContext context, {
    required String title,
    required String description,
    required VoidCallback onConfirm,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (_) => AuthSuccessModal(
        title: title,
        description: description,
        onConfirm: onConfirm,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 24.h,
        left: 24.w,
        right: 24.w,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24.h,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: AppColors.outlineVariant,
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
          SizedBox(height: 32.h),

          // Success Icon Representation
          Container(
            width: 120.w,
            height: 120.w,
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            padding: EdgeInsets.all(10.w),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              padding: EdgeInsets.all(18.w),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.check, color: Colors.white, size: 32.sp),
              ),
            ),
          ),

          SizedBox(height: 24.h),
          CustomText(
            text: title,
            textType: TextType.headlineMedium,
            fontWeight: FontWeight.w500,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.h),
          CustomText(
            text: description,
            textType: TextType.bodyMedium,
            color: AppColors.onSurfaceVariant,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 32.h),
          AppButton.primary(text: 'Confirm', onPressed: onConfirm),
        ],
      ),
    );
  }
}
