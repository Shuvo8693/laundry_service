import 'package:e_laundry/core/widgets/shimmer_placeholder.dart';
import 'package:e_laundry/core/widgets/spacing.dart';
import 'package:flutter/material.dart';
import 'package:e_laundry/core/utils/screen_util.dart';

class HomeShimmer extends StatelessWidget {
  const HomeShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(vertical: 24.h),
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerPlaceholder.text(width: 150.w, height: 24.h),
                  const VerticalSpace(8),
                  ShimmerPlaceholder.text(width: 100.w, height: 16.h),
                ],
              ),
              ShimmerPlaceholder.circular(size: 40.w),
            ],
          ),
        ),
        const VerticalSpace(24),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: ShimmerPlaceholder.card(width: double.infinity, height: 160.h),
        ),
        const VerticalSpace(24),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: ShimmerPlaceholder.text(width: 120.w, height: 24.h),
        ),
        const VerticalSpace(12),
        SizedBox(
          height: 140.h,
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            itemBuilder: (_, _) => Padding(
              padding: EdgeInsets.only(right: 8.w),
              child: ShimmerPlaceholder.card(width: 114.w, height: 140.h),
            ),
          ),
        ),
        const VerticalSpace(24),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: ShimmerPlaceholder.text(width: 120.w, height: 24.h),
        ),
        const VerticalSpace(12),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: ShimmerPlaceholder.card(width: double.infinity, height: 100.h),
        ),
      ],
    );
  }
}
