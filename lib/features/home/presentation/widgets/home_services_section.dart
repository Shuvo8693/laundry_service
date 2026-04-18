import 'package:e_laundry/core/resources/colors/app_colors.dart';
import 'package:e_laundry/core/utils/screen_util.dart';
import 'package:e_laundry/core/widgets/custom_text.dart';
import 'package:e_laundry/core/widgets/spacing.dart';
import 'package:e_laundry/features/home/domain/entities/home_entity.dart';
import 'package:flutter/material.dart';

class HomeServicesSection extends StatelessWidget {
  final List<HomeServiceEntity> services;

  const HomeServicesSection({super.key, required this.services});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: CustomText(
            text: 'Our Services',
            textType: TextType.headlineMedium,
            color: AppColors.onSurface,
          ),
        ),
        const VerticalSpace(12),
        SizedBox(
          height: 140.h,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            scrollDirection: Axis.horizontal,
            itemCount: services.length,
            separatorBuilder: (context, index) => const HorizontalSpace(8),
            itemBuilder: (context, index) {
              final service = services[index];
              return _ServiceItem(service: service);
            },
          ),
        ),
      ],
    );
  }
}

class _ServiceItem extends StatelessWidget {
  final HomeServiceEntity service;

  const _ServiceItem({required this.service});

  @override
  Widget build(BuildContext context) {
    IconData getServiceIcon(String id) {
      if (id.contains('001')) return Icons.local_laundry_service;
      if (id.contains('002')) return Icons.iron;
      return Icons.dry_cleaning;
    }

    return SizedBox(
      width: 114.w,
      child: Column(
        children: [
          Container(
            height: 80.h,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: AppColors.surfaceContainerHigh),
              color: AppColors.surfaceContainerLowest,
            ),
            child: Icon(
              getServiceIcon(service.id),
              color: AppColors.primary,
              size: 32.sp,
            ),
          ),
          const VerticalSpace(8),
          CustomText(
            text: service.title,
            textType: TextType.bodyMedium,
            color: AppColors.onSurface,
            textAlign: TextAlign.center,
          ),
          const VerticalSpace(4),
          CustomText(
            text: service.priceStartingFrom,
            textType: TextType.labelSmall,
            color: AppColors.onSurfaceVariant,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

