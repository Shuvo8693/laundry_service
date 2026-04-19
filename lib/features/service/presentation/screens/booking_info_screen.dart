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
import 'package:e_laundry/core/routes/route_names.dart';
import 'package:intl/intl.dart';

class BookingInfoScreen extends StatefulWidget {
  const BookingInfoScreen({super.key});

  @override
  State<BookingInfoScreen> createState() => _BookingInfoScreenState();
}

class _BookingInfoScreenState extends State<BookingInfoScreen> {
  final TextEditingController _addressController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    final details = context.read<ServiceCubit>().state.bookingDetails;
    _addressController.text = details.address ?? '';
    _selectedDate = details.pickupDate;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ServiceCubit, ServiceState>(
      listenWhen: (previous, current) =>
          previous is! SummaryInProgress && current is SummaryInProgress,
      listener: (context, state) {
        context.push(RouteNames.orderSummary);
      },
      builder: (context, state) {
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
                      const ServiceStepIndicator(currentStep: 2),
                      const VerticalSpace(32),
                      CustomText(
                        text: 'Schedule Pickup',
                        textType: TextType.bodyMedium,
                        color: AppColors.onSurface,
                      ),
                      const VerticalSpace(16),

                      _buildInfoTile(
                        label: 'Date',
                        value: _selectedDate == null
                            ? 'Select Date'
                            : DateFormat('yyyy-MM-dd').format(_selectedDate!),
                        icon: Icons.calendar_month,
                        onTap: () => _selectDate(context),
                      ),
                      const VerticalSpace(12),
                      _buildInfoTile(
                        label: 'Time',
                        value: _selectedTime == null
                            ? 'Select Time'
                            : _selectedTime!.format(context),
                        icon: Icons.access_time,
                        onTap: () => _selectTime(context),
                      ),
                      const VerticalSpace(12),
                      _buildAddressField(),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16.r),
                child: AppButton(
                  text: 'Next',
                  onPressed:
                      (_selectedDate != null &&
                          _selectedTime != null &&
                          _addressController.text.isNotEmpty)
                      ? () {
                          context.read<ServiceCubit>().updateBookingInfo(
                            date: _selectedDate,
                            time: _selectedTime?.format(context),
                            address: _addressController.text,
                          );
                          context.read<ServiceCubit>().proceedToSummary();
                        }
                      : null,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoTile({
    required String label,
    required String value,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 64.h,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.surfaceContainerHigh),
          color: AppColors.surfaceContainerLowest,
        ),
        child: Row(
          children: [
            CustomText(
              text: label,
              textType: TextType.bodyLarge,
              color: AppColors.onSurface,
            ),
            const Spacer(),
            CustomText(
              text: value,
              textType: TextType.bodyMedium,
              color: AppColors.onSurfaceVariant,
            ),
            const HorizontalSpace(8),
            Icon(icon, size: 24.sp, color: AppColors.onSurface),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressField() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.surfaceContainerHigh),
        color: AppColors.surfaceContainerLowest,
      ),
      child: TextField(
        controller: _addressController,
        decoration: InputDecoration(
          labelText: 'Delivery Address',
          border: InputBorder.none,
          suffixIcon: Icon(
            Icons.location_on,
            size: 24.sp,
            color: AppColors.onSurface,
          ),
        ),
        onChanged: (val) => setState(() {}),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) setState(() => _selectedTime = picked);
  }
}
