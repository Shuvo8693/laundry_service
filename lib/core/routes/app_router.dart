import 'package:e_laundry/core/navigation/cubit/navigation_cubit.dart';
import 'package:e_laundry/features/main/presentation/screens/main_screen.dart';
import 'package:e_laundry/features/onboarding/onboarding_screen.dart';
import 'package:e_laundry/features/onboarding/presentation/cubit/onboarding/onboarding_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:e_laundry/core/routes/route_names.dart';
import 'package:e_laundry/features/splash/presentation/screens/splash_screen.dart';
import 'package:e_laundry/features/splash/presentation/cubit/splash/splash_cubit.dart';
import 'package:e_laundry/features/auth/presentation/screens/login_screen.dart';
import 'package:e_laundry/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:e_laundry/features/auth/presentation/screens/otp_screen.dart';
import 'package:e_laundry/features/auth/presentation/screens/fill_personal_info_screen.dart';
import 'package:e_laundry/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:e_laundry/features/auth/presentation/screens/reset_password_screen.dart';
import 'package:e_laundry/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:e_laundry/features/service/presentation/cubit/service_cubit.dart';
import 'package:e_laundry/features/service/presentation/screens/service_list_screen.dart';
import 'package:e_laundry/features/service/presentation/screens/select_service_screen.dart';
import 'package:e_laundry/features/service/presentation/screens/booking_info_screen.dart';
import 'package:e_laundry/features/service/presentation/screens/order_summary_screen.dart';
import 'package:e_laundry/injection_container.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: RouteNames.splash,
  routes: [
    GoRoute(
      path: RouteNames.splash,
      builder: (context, state) => BlocProvider(
        create: (context) => di<SplashCubit>()..initializeData(),
        child: const SplashScreen(),
      ),
    ),
    GoRoute(
      path: RouteNames.dashboard,
      builder: (context, state) => BlocProvider.value(
        value: di<NavigationCubit>(),
        child: const MainScreen(),
      ),
    ),
    GoRoute(
      path: RouteNames.login,
      builder: (context, state) => BlocProvider(
        create: (context) => di<AuthCubit>(),
        child: const LoginScreen(),
      ),
    ),
    GoRoute(
      path: RouteNames.signup,
      builder: (context, state) => BlocProvider(
        create: (context) => di<AuthCubit>(),
        child: const SignUpScreen(),
      ),
    ),
    GoRoute(
      path: RouteNames.otp,
      builder: (context, state) => BlocProvider(
        create: (context) => di<AuthCubit>(),
        child: const OtpScreen(),
      ),
    ),
    GoRoute(
      path: RouteNames.fillInfo,
      builder: (context, state) => BlocProvider(
        create: (context) => di<AuthCubit>(),
        child: const FillPersonalInfoScreen(),
      ),
    ),
    GoRoute(
      path: RouteNames.forgotPassword,
      builder: (context, state) => BlocProvider(
        create: (context) => di<AuthCubit>(),
        child: const ForgotPasswordScreen(),
      ),
    ),
    GoRoute(
      path: RouteNames.resetPassword,
      builder: (context, state) => BlocProvider(
        create: (context) => di<AuthCubit>(),
        child: const ResetPasswordScreen(),
      ),
    ),
    GoRoute(
      path: RouteNames.onboarding,
      builder: (context, state) => BlocProvider(
        create: (context) => di<OnboardingCubit>(),
        child: const OnboardingScreen(),
      ),
    ),

    // Service Feature
    GoRoute(
      path: RouteNames.laundryServices,
      builder: (context, state) => BlocProvider.value(
        value: di<ServiceCubit>()..fetchServices(),
        child: const ServiceListScreen(),
      ),
    ),
    GoRoute(
      path: RouteNames.selectService,
      builder: (context, state) => BlocProvider.value(
        value: di<ServiceCubit>(),
        child: const SelectServiceScreen(),
      ),
    ),
    GoRoute(
      path: RouteNames.bookingInfo,
      builder: (context, state) => BlocProvider.value(
        value: di<ServiceCubit>(),
        child: const BookingInfoScreen(),
      ),
    ),
    GoRoute(
      path: RouteNames.orderSummary,
      builder: (context, state) => BlocProvider.value(
        value: di<ServiceCubit>(),
        child: const OrderSummaryScreen(),
      ),
    ),
  ],
);
