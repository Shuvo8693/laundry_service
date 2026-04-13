import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:e_laundry/core/routes/route_names.dart';
import 'package:e_laundry/features/splash/presentation/screens/splash_screen.dart';
import 'package:e_laundry/features/splash/presentation/cubit/splash/splash_cubit.dart';
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
    // GoRoute(
    //   path: RouteNames.dashboard,
    //   builder: (context, state) => BlocProvider(
    //     create: (context) => di<NavigationCubit>(),
    //     child: const MainScreen(),
    //   ),
    // ),
    GoRoute(
      path: RouteNames.login,
      builder: (context, state) =>
          const Scaffold(body: Center(child: Text('Login Screen'))),
    ),
  ],
);
