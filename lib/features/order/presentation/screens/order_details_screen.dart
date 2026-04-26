import 'package:e_laundry/core/utils/screen_util.dart';
import 'package:e_laundry/core/resources/colors/app_colors.dart';
import 'package:e_laundry/features/order/presentation/cubit/order_state.dart';
import 'package:e_laundry/features/order/presentation/widgets/tracking_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_laundry/core/widgets/widgets.dart';
import 'package:e_laundry/features/order/presentation/cubit/order_cubit.dart';
import 'package:intl/intl.dart';

class OrderDetailsScreen extends StatelessWidget {
  const OrderDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Order Details', showBackButton: true),
      body: BlocBuilder<OrderCubit, OrderState>(
        builder: (context, state) {
          if (state is OrderLoading) {
            return const Center(child: CustomCircularProgressIndicator());
          } else if (state is OrderDetailsLoaded) {
            final order = state.order;
            return SingleChildScrollView(
              padding: EdgeInsets.all(20.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status Card
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: CustomText.labelLarge(
                      'Status: ${order.status.name.toUpperCase()}',
                      color: Colors.white,
                    ),
                  ),
                  const VerticalSpace(24),
                  // Tracking Stepper
                  TrackingStepper(steps: order.steps),
                  const VerticalSpace(32),

                  // Order Summary
                  const CustomText.headlineMedium('Order Summary'),
                  const VerticalSpace(16),
                  Container(
                    padding: EdgeInsets.all(16.r),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: AppColors.surfaceContainerHigh),
                    ),
                    child: Column(
                      children: [
                        ...order.items.map(
                          (item) => Padding(
                            padding: EdgeInsets.only(bottom: 12.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomText.bodyMedium(
                                  '${item.name} x${item.quantity}',
                                  color: AppColors.onSurfaceVariant,
                                ),
                                CustomText.bodyMedium(
                                  '\$${item.price.toStringAsFixed(2)}',
                                  color: AppColors.onSurface,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Divider(height: 24.h),
                        _SummaryRow(
                          label: 'Pickup Cost',
                          value: '\$${order.pickupCost.toStringAsFixed(2)}',
                        ),
                        const VerticalSpace(8),
                        _SummaryRow(
                          label: 'Delivery Cost',
                          value: '\$${order.deliveryCost.toStringAsFixed(2)}',
                        ),
                        const Divider(height: 24),
                        _SummaryRow(
                          label: 'Total',
                          value: '\$${order.totalPrice.toStringAsFixed(2)}',
                          isBold: true,
                          color: AppColors.primary,
                        ),
                      ],
                    ),
                  ),
                  const VerticalSpace(32),

                  // Service Details
                  const CustomText.headlineMedium('Service Details'),
                  const VerticalSpace(16),
                  Container(
                    padding: EdgeInsets.all(16.r),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: AppColors.surfaceContainerHigh),
                    ),
                    child: Column(
                      children: [
                        _DetailRow(
                          label: 'Service Type',
                          value: order.serviceName,
                        ),
                        const VerticalSpace(12),
                        _DetailRow(
                          label: 'Pickup Date',
                          value: DateFormat('dd/MM/yyyy').format(order.date),
                        ),
                        const VerticalSpace(12),
                        _DetailRow(
                          label: 'Pickup Time',
                          value: order.pickupTime,
                        ),
                        const VerticalSpace(12),
                        _DetailRow(
                          label: 'Delivery Address',
                          value: order.deliveryAddress,
                        ),
                      ],
                    ),
                  ),
                  if (order.itemSummary != null) ...[
                    const VerticalSpace(24),
                    const CustomText.headlineMedium('Items'),
                    const VerticalSpace(16),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16.r),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: AppColors.surfaceContainerHigh,
                        ),
                      ),
                      child: CustomText.bodyMedium(
                        order.itemSummary!,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                  const VerticalSpace(32),

                  // Rate Experience
                  const CustomText.headlineMedium('Rate Your Experience'),
                  const VerticalSpace(16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      5,
                      (index) => Icon(
                        Icons.star_border,
                        size: 32.r,
                        color: Colors.amber,
                      ),
                    ),
                  ),
                  const VerticalSpace(16),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Excellent Service',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: const BorderSide(
                          color: AppColors.surfaceContainerHigh,
                        ),
                      ),
                    ),
                    maxLines: 3,
                  ),
                  const VerticalSpace(24),
                  AppButton(onPressed: () {}, text: 'Submit Review'),
                ],
              ),
            );
          } else if (state is OrderError) {
            return Center(child: CustomText.bodyMedium(state.message));
          }
          return const SizedBox();
        },
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;
  final Color? color;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.isBold = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText.bodyMedium(
          label,
          color: AppColors.onSurfaceVariant,
          fontWeight: isBold ? FontWeight.w600 : null,
        ),
        CustomText.bodyMedium(
          value,
          color: color ?? AppColors.onSurface,
          fontWeight: isBold ? FontWeight.w700 : null,
        ),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 120.w,
          child: CustomText.bodyMedium(
            label,
            color: AppColors.onSurfaceVariant,
          ),
        ),
        Expanded(
          child: CustomText.bodyMedium(
            value,
            color: AppColors.onSurface,
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}
