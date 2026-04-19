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
import '../widgets/cloth_item_tile.dart';
import 'package:e_laundry/core/routes/route_names.dart';

class SelectServiceScreen extends StatelessWidget {
  const SelectServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ServiceCubit, ServiceState>(
      listenWhen: (previous, current) =>
          previous is! BookingInfoInProgress && current is BookingInfoInProgress,
      listener: (context, state) {
        context.push(RouteNames.bookingInfo);
      },
      child: Scaffold(
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
                    const ServiceStepIndicator(currentStep: 1),
                    const VerticalSpace(32),

                    // Service Selection Row
                    BlocBuilder<ServiceCubit, ServiceState>(
                      buildWhen: (previous, current) =>
                          previous.bookingDetails.selectedService !=
                          current.bookingDetails.selectedService,
                      builder: (context, state) =>
                          _buildServiceSelection(context, state),
                    ),

                    const VerticalSpace(32),
                    CustomText(
                      text: 'Choose Cloth items',
                      textType: TextType.headlineMedium,
                      color: AppColors.onSurface,
                    ),
                    const VerticalSpace(16),

                    // Cloth Items List
                    BlocBuilder<ServiceCubit, ServiceState>(
                      buildWhen: (previous, current) =>
                          current is ClothSelectionLoaded,
                      builder: (context, state) {
                        if (state is! ClothSelectionLoaded)
                          return const SizedBox.shrink();
                        return Column(
                          children: state.items
                              .map(
                                (item) => Padding(
                                  padding: EdgeInsets.only(bottom: 12.h),
                                  child: ClothItemTile(
                                    item: item,
                                    onCountChanged: (count) => context
                                        .read<ServiceCubit>()
                                        .updateClothItemCount(item.id, count),
                                  ),
                                ),
                              )
                              .toList(),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Button
            BlocBuilder<ServiceCubit, ServiceState>(
              builder: (context, state) {
                final details = state.bookingDetails;
                return Padding(
                  padding: EdgeInsets.all(16.r),
                  child: AppButton(
                    text: 'Next',
                    onPressed: details.selectedItems.isNotEmpty
                        ? () =>
                            context.read<ServiceCubit>().proceedToBookingInfo()
                        : null,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceSelection(BuildContext context, ServiceState state) {
    // Ideally we'd have the list of services here too.
    // For the selection step, we show the 3 choices from design.
    final selectedId = state.bookingDetails.selectedService?.id;

    // This is simplified; in a full app we'd fetch these or get from state
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Reusing the 3 services for display in step 1
        // (Assuming they were loaded in the previous screen)
        // For brevity in mock, I'll assume they exist or show placeholders
      ],
    );
  }
}
