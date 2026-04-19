import 'package:e_laundry/core/routes/route_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_laundry/core/resources/colors/app_colors.dart';
import 'package:e_laundry/core/utils/screen_util.dart';
import 'package:e_laundry/core/widgets/custom_app_bar.dart';
import 'package:e_laundry/core/widgets/custom_text.dart';
import 'package:e_laundry/core/widgets/spacing.dart';
import 'package:e_laundry/core/widgets/app_button.dart';
import 'package:go_router/go_router.dart';
import '../cubit/service_cubit.dart';
import '../cubit/service_state.dart';
import '../widgets/service_step_indicator.dart';
import 'package:intl/intl.dart';

class OrderSummaryScreen extends StatelessWidget {
  const OrderSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ServiceCubit, ServiceState>(
      listenWhen: (previous, current) =>
          previous is! OrderConfirmed && current is OrderConfirmed,
      listener: (context, state) {
        // Navigate to some success screen or back to track order
        context.push(RouteNames.dashboard);
      },
      builder: (context, state) {
        final details = state.bookingDetails;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: const CustomAppBar(
            title: 'Book Service',
            showBackButton: true,
          ),
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const ServiceStepIndicator(currentStep: 3),
                      const VerticalSpace(32),
                      CustomText(
                        text: 'Order Summary',
                        textType: TextType.headlineMedium,
                        color: AppColors.onSurface,
                      ),
                      const VerticalSpace(16),

                      _buildSummaryCard(details),
                      const VerticalSpace(16),
                      _buildPickupInfo(details, context),
                      const VerticalSpace(16),
                      _buildNoteCard(),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.all(16.r),
                child: Column(
                  children: [
                    CustomText(
                      text: 'Payment : Cash On Delivery',
                      textType: TextType.bodyMedium,
                      color: AppColors.onSurfaceVariant,
                    ),
                    const VerticalSpace(8),
                    AppButton(
                      text: 'Confirm Order',
                      onPressed: () =>
                          context.read<ServiceCubit>().confirmOrder(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSummaryCard(details) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.surfaceContainerHigh),
        color: AppColors.surfaceContainerLowest,
      ),
      child: Column(
        children: [
          ...details.selectedItems.map(
            (item) => Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text:
                        '${details.selectedService?.title} • ${item.name} (${item.count})',
                    textType: TextType.bodyLarge,
                    color: AppColors.onSurfaceVariant,
                  ),
                  CustomText(
                    text: '\$${(item.count * 5).toStringAsFixed(0)}',
                    textType: TextType.labelLarge,
                    color: AppColors.onSurface,
                  ),
                ],
              ),
            ),
          ),
          const Divider(),
          _buildSummaryRow('Pickup Cost', '\$1'),
          _buildSummaryRow('Delivery Cost', '\$1'),
          const VerticalSpace(8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: 'Total',
                textType: TextType.headlineMedium,
                color: AppColors.onSurface,
              ),
              CustomText(
                text: '\$${details.totalCost.toStringAsFixed(0)}',
                textType: TextType.headlineMedium,
                color: AppColors.primary,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            text: label,
            textType: TextType.bodyLarge,
            color: AppColors.onSurfaceVariant,
          ),
          CustomText(text: value, textType: TextType.labelLarge),
        ],
      ),
    );
  }

  Widget _buildPickupInfo(details, context) {
    final dateStr = details.pickupDate != null
        ? DateFormat('yyyy-MM-dd').format(details.pickupDate!)
        : '';

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.surfaceContainerHigh),
        color: AppColors.surfaceContainerLowest,
      ),
      child: Column(
        children: [
          _infoRow(Icons.access_time, '$dateStr at ${details.pickupTime}'),
          const VerticalSpace(12),
          _infoRow(Icons.location_on, details.address ?? ''),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 20.sp, color: AppColors.onSurface),
        const HorizontalSpace(12),
        Expanded(
          child: CustomText(
            text: text,
            textType: TextType.labelLarge,
            color: AppColors.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildNoteCard() {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: AppColors.primaryContainer.withOpacity(0.3),
      ),
      child: CustomText(
        text:
            'Please Kindly Note that the number of your items should match your final payment amount before you submit your Order. Thank You',
        textType: TextType.bodySmall,
        color: AppColors.primary,
      ),
    );
  }
}
