import 'package:e_laundry/features/splash/presentation/widgets/splash_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:e_laundry/core/resources/colors/app_colors.dart';
import 'package:e_laundry/core/routes/route_names.dart';
import 'package:e_laundry/core/utils/screen_util.dart';
import 'package:e_laundry/features/splash/presentation/cubit/splash/splash_cubit.dart';
import 'package:e_laundry/features/splash/presentation/cubit/splash/splash_state.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashCubit, SplashState>(
      listener: (context, state) {
        if (state is SplashNavigateToHome) {
          context.go(RouteNames.dashboard);
        } else if (state is SplashNavigateToOnboarding) {
          context.go(RouteNames.onboarding);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.surface,
        body: SafeArea(
          child: Column(
            children: [
              // Top buffer for asymmetry (from HTML design)
              Spacer(),
              SplashLogo(),
              Spacer(),
              // Footer area with loading bar and metadata
              Padding(
                padding: EdgeInsets.only(bottom: 80.h, left: 24.w, right: 24.w),
                child: Column(
                  children: [
                    // Minimal loading indicator
                    Container(
                      width: double.infinity,
                      height: 3.h,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(9999.r),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.0, end: 0.6),
                        duration: const Duration(milliseconds: 1500),
                        curve: Curves.easeInOut,
                        builder: (context, value, child) {
                          return FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: value,
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.primaryContainer,
                                borderRadius: BorderRadius.circular(9999.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primaryContainer
                                        .withValues(alpha: 0.4),
                                    blurRadius: 12.r,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
