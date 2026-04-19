import 'package:flutter/material.dart';
import 'package:e_laundry/core/resources/colors/app_colors.dart';
import 'package:e_laundry/core/utils/screen_util.dart';
import 'package:e_laundry/core/widgets/custom_text.dart';

class ServiceStepIndicator extends StatelessWidget {
  final int currentStep;

  const ServiceStepIndicator({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildStep(1, currentStep >= 1),
        _buildDivider(currentStep >= 2),
        _buildStep(2, currentStep >= 2),
        _buildDivider(currentStep >= 3),
        _buildStep(3, currentStep >= 3),
      ],
    );
  }

  Widget _buildStep(int step, bool isActive) {
    return Container(
      width: 24.r,
      height: 24.r,
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary : AppColors.surfaceContainerHigh,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: CustomText(
        text: step.toString(),
        textType: TextType.labelSmall,
        color: isActive ? AppColors.onPrimary : AppColors.onSurface,
      ),
    );
  }

  Widget _buildDivider(bool isActive) {
    return Expanded(
      child: Container(
        height: 1.h,
        margin: EdgeInsets.symmetric(horizontal: 4.w),
        color: isActive ? AppColors.primary : AppColors.surfaceContainerHigh,
      ),
    );
  }
}
