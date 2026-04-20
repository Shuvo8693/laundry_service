import 'package:e_laundry/core/utils/screen_util.dart';
import 'package:e_laundry/core/resources/colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:e_laundry/core/widgets/widgets.dart';
import 'package:e_laundry/features/order/domain/entities/order_entity.dart';
import 'package:intl/intl.dart';

class OrderCard extends StatelessWidget {
  final OrderEntity order;
  final VoidCallback onTap;

  const OrderCard({super.key, required this.order, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.surfaceContainerHigh),
        ),
        child: Row(
          children: [
            // Order Icon Placeholder
            Container(
              width: 48.r,
              height: 48.r,
              decoration: BoxDecoration(
                // ignore: deprecated_member_use
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(24.r),
              ),
              child: Icon(
                Icons.shopping_bag_outlined,
                color: AppColors.primary,
                size: 24.r,
              ),
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
                        'Order #${order.id}',
                        color: AppColors.onSurface,
                      ),
                      _StatusBadge(status: order.status),
                    ],
                  ),
                  const VerticalSpace(4),
                  CustomText.bodyMedium(
                    order.serviceName,
                    color: AppColors.onSurfaceVariant,
                  ),
                  const VerticalSpace(8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText.labelLarge(
                        '\$${order.totalPrice.toStringAsFixed(2)}',
                        color: AppColors.primary,
                      ),
                      CustomText.bodySmall(
                        DateFormat('dd/MM/yyyy').format(order.date),
                        color: AppColors.onSurfaceVariant,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const HorizontalSpace(8),
            Icon(
              Icons.chevron_right,
              color: AppColors.onSurfaceVariant,
              size: 24.r,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final OrderStatus status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;
    String label;

    switch (status) {
      case OrderStatus.pending:
        bgColor = const Color(0xFFFFF9E6);
        textColor = const Color(0xFFD97706);
        label = 'Pending';
        break;
      case OrderStatus.completed:
      case OrderStatus.delivered:
        bgColor = const Color(0xFFE6F9F0);
        textColor = const Color(0xFF059669);
        label = 'Completed';
        break;
      default:
        bgColor = AppColors.surfaceContainerHigh;
        textColor = AppColors.onSurfaceVariant;
        label = status.name;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: CustomText.labelSmall(label, color: textColor),
    );
  }
}
