import 'package:e_laundry/core/resources/colors/app_colors.dart';
import 'package:e_laundry/core/widgets/error_placeholder.dart';
import 'package:e_laundry/features/home/presentation/cubit/home_cubit.dart';
import 'package:e_laundry/features/home/presentation/cubit/home_state.dart';
import 'package:e_laundry/features/home/presentation/widgets/home_active_orders_section.dart';
import 'package:e_laundry/features/home/presentation/widgets/home_app_bar_section.dart';
import 'package:e_laundry/features/home/presentation/widgets/home_banner_section.dart';
import 'package:e_laundry/features/home/presentation/widgets/home_offers_section.dart';
import 'package:e_laundry/features/home/presentation/widgets/home_services_section.dart';
import 'package:e_laundry/features/home/presentation/widgets/home_shimmer.dart';
import 'package:e_laundry/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di<HomeCubit>()..fetchHomeData(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              return switch (state) {
                HomeInitial() => const SizedBox.shrink(),
                HomeLoading() => const HomeShimmer(),
                HomeLoaded() => SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        HomeAppBarSection(
                          userName: state.homeData.userName,
                          location: state.homeData.location,
                        ),
                        const HomeBannerSection(),
                        HomeServicesSection(services: state.homeData.services),
                        HomeActiveOrdersSection(
                          activeOrders: state.homeData.activeOrders,
                        ),
                        HomeOffersSection(offers: state.homeData.offers),
                      ],
                    ),
                  ),
                HomeError() => ErrorPlaceholder(
                    message: state.message,
                    onRetry: () => context.read<HomeCubit>().fetchHomeData(),
                  ),
              };
            },
          ),
        ),
      ),
    );
  }
}
