import 'package:e_laundry/core/utils/screen_util.dart';
import 'package:e_laundry/core/resources/colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:e_laundry/core/widgets/widgets.dart';
import 'package:e_laundry/features/order/domain/entities/order_entity.dart';
import 'package:intl/intl.dart';

class TrackingStepper extends StatelessWidget {
  final List<OrderStep> steps;

  const TrackingStepper({super.key, required this.steps});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(steps.length, (index) {
        final step = steps[index];
        final isLast = index == steps.length - 1;

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    width: 24.r,
                    height: 24.r,
                    decoration: BoxDecoration(
                      color: step.isCompleted
                          ? AppColors.primary
                          : Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: step.isCompleted
                            ? AppColors.primary
                            : AppColors.surfaceContainerHigh,
                        width: 2.r,
                      ),
                    ),
                    child: step.isCompleted
                        ? Icon(Icons.check, size: 14.r, color: Colors.white)
                        : null,
                  ),
                  if (!isLast)
                    Expanded(
                      child: Container(
                        width: 2.w,
                        color: step.isCompleted
                            ? AppColors.primary
                            : AppColors.surfaceContainerHigh,
                      ),
                    ),
                ],
              ),
              const HorizontalSpace(16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText.labelLarge(
                          step.title,
                          color: step.isCompleted
                              ? AppColors.onSurface
                              : AppColors.onSurfaceVariant,
                        ),
                        if (step.time != null)
                          CustomText.bodySmall(
                            DateFormat('HH:mm').format(step.time!),
                            color: AppColors.onSurfaceVariant,
                          ),
                      ],
                    ),
                    const VerticalSpace(24),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
