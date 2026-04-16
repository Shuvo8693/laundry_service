import 'package:e_laundry/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:e_laundry/core/utils/screen_util.dart';
import 'package:e_laundry/core/resources/colors/app_colors.dart';
import 'package:e_laundry/core/resources/text/app_text_theme.dart';

class SocialLoginButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const SocialLoginButton({
    super.key,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50.h,
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(color: AppColors.outline), // Equivalent to Neutral-200
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Placeholder for Google Logo
            Icon(Icons.g_mobiledata, size: 28.sp, color: Colors.blue),
            SizedBox(width: 8.w),
            CustomText(
              text: text,
              textType: TextType.bodyMedium,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ],
        ),
      ),
    );
  }
}
