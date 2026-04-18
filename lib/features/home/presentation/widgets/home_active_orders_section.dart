import 'package:e_laundry/core/resources/colors/app_colors.dart';
import 'package:e_laundry/core/utils/screen_util.dart';
import 'package:e_laundry/core/widgets/custom_text.dart';
import 'package:e_laundry/core/widgets/spacing.dart';
import 'package:e_laundry/features/home/domain/entities/home_entity.dart';
import 'package:flutter/material.dart';

class HomeActiveOrdersSection extends StatelessWidget {
  final List<HomeActiveOrderEntity> activeOrders;

  const HomeActiveOrdersSection({super.key, required this.activeOrders});

  @override
  Widget build(BuildContext context) {
    if (activeOrders.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: CustomText(
            text: 'Active orders',
            textType: TextType.headlineMedium,
            color: AppColors.onSurface,
          ),
        ),
        const VerticalSpace(12),
        ...activeOrders.map((order) => _OrderCard(order: order)),
      ],
    );
  }
}

class _OrderCard extends StatelessWidget {
  final HomeActiveOrderEntity order;

  const _OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 8.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.surfaceContainerHigh),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: order.orderId,
                  textType: TextType.headlineMedium,
                  color: AppColors.onSurface,
                ),
                const VerticalSpace(4),
                CustomText(
                  text: order.services,
                  textType: TextType.bodySmall,
                  color: AppColors.onSurfaceVariant,
                ),
                const VerticalSpace(4),
                CustomText(
                  text: order.date,
                  textType: TextType.bodySmall,
                  color: AppColors.onSurfaceVariant,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.tertiary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(100.r),
                ),
                child: CustomText(
                  text: order.status,
                  textType: TextType.labelSmall,
                  color: AppColors.tertiary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const VerticalSpace(12),
              CustomText(
                text: '\$${order.price.toStringAsFixed(0)}',
                textType: TextType.displayLarge,
                color: AppColors.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ],
          )
        ],
      ),
    );
  }
}

