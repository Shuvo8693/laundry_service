import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:e_laundry/core/resources/colors/app_colors.dart';
import 'package:e_laundry/core/routes/route_names.dart';
import 'package:e_laundry/core/utils/screen_util.dart';
import 'package:e_laundry/features/splash/presentation/cubit/splash/splash_cubit.dart';
import 'package:e_laundry/features/splash/presentation/cubit/splash/splash_state.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    final screenSize = MediaQuery.of(context).size;

    return BlocListener<SplashCubit, SplashState>(
      listener: (context, state) {
        if (state is SplashNavigateToHome) {
          context.go(RouteNames.dashboard);
        } else if (state is SplashNavigateToLogin) {
          context.go(RouteNames.login);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.surface,
        body: Stack(
          children: [
            // Background luminescence effects
            Positioned(
              top: -screenSize.height * 0.1,
              right: -screenSize.width * 0.1,
              child: Container(
                width: screenSize.width * 0.6,
                height: screenSize.height * 0.6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryContainer.withValues(alpha: 0.10),
                ),
              ),
            ),
            Positioned(
              bottom: -screenSize.height * 0.05,
              left: -screenSize.width * 0.05,
              child: Container(
                width: screenSize.width * 0.4,
                height: screenSize.height * 0.4,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.secondaryContainer.withValues(alpha: 0.10),
                ),
              ),
            ),

            // Main content
            SafeArea(
              child: Column(
                children: [
                  // Top buffer for asymmetry (from HTML design)
                  SizedBox(height: 96.h),

                  // Central identity cluster
                  Expanded(
                    child: BlocBuilder<SplashCubit, SplashState>(
                      builder: (context, state) {
                        if (state is SplashLoaded) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Tagline
                              Padding(
                                padding: EdgeInsets.only(top: 12.h),
                                child: Text(
                                  state.splashData.subTitle,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18.sp,
                                    letterSpacing: 0.5,
                                    color: AppColors.onSurfaceVariant,
                                  ),
                                ),
                              ),
                            ],
                          );
                        }

                        // Loading state
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              color: AppColors.primaryContainer,
                            ),
                          ],
                        );
                      },
                    ),
                  ),

                  // Footer area with loading bar and metadata
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: 80.h,
                      left: 24.w,
                      right: 24.w,
                    ),
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
                            tween: Tween(begin: 0.0, end: 0.4),
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

                        SizedBox(height: 32.h),

                        // Academic integrity badge
                        BlocBuilder<SplashCubit, SplashState>(
                          builder: (context, state) {
                            String integrityText = '';

                            if (state is SplashLoaded) {
                              integrityText = state
                                  .splashData
                                  .academicIntegrityText
                                  .toUpperCase();
                            }

                            return Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 6.h,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceContainerLow,
                                borderRadius: BorderRadius.circular(9999.r),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.school,
                                    color: AppColors.primaryContainer,
                                    size: 16.r,
                                  ),
                                  SizedBox(width: 8.w),
                                  Text(
                                    integrityText,
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 10.sp,
                                      letterSpacing: 2,
                                      color: AppColors.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Background brand pattern (subtle glassmorphism)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: screenSize.height * 0.33,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      AppColors.surfaceContainerLow.withValues(alpha: 0.50),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
