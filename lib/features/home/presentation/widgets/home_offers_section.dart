import 'package:e_laundry/core/resources/colors/app_colors.dart';
import 'package:e_laundry/core/utils/screen_util.dart';
import 'package:e_laundry/core/widgets/custom_text.dart';
import 'package:e_laundry/core/widgets/spacing.dart';
import 'package:e_laundry/features/home/domain/entities/home_entity.dart';
import 'package:flutter/material.dart';

class HomeOffersSection extends StatelessWidget {
  final List<HomeOfferEntity> offers;

  const HomeOffersSection({super.key, required this.offers});

  @override
  Widget build(BuildContext context) {
    if (offers.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: CustomText(
            text: 'Offers & Discounts',
            textType: TextType.headlineMedium,
            color: AppColors.onSurface,
          ),
        ),
        const VerticalSpace(12),
        ...offers.map((offer) => _OfferCard(offer: offer)),
      ],
    );
  }
}

class _OfferCard extends StatelessWidget {
  final HomeOfferEntity offer;

  const _OfferCard({required this.offer});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 24.h),
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
                  text: offer.title,
                  textType: TextType.headlineMedium,
                  color: AppColors.onSurface,
                ),
                const VerticalSpace(4),
                CustomText(
                  text: offer.description,
                  textType: TextType.bodySmall,
                  color: AppColors.onSurfaceVariant,
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(100.r),
            ),
            child: CustomText(
              text: offer.discountBadge,
              textType: TextType.labelSmall,
              color: AppColors.primary,
              fontWeight: FontWeight.w500,
            ),
          )
        ],
      ),
    );
  }
}

