import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:e_laundry/core/routes/route_names.dart';

class AppNavigation {
  static void toLogin(BuildContext context) {
    context.go(RouteNames.login);
  }

  static void toDashboard(BuildContext context) {
    context.go(RouteNames.dashboard);
  }

  static void toProfile(BuildContext context) {
    context.push(RouteNames.profile);
  }

  static void back(BuildContext context) {
    context.pop();
  }

  static void toOnboarding(BuildContext context) {
    context.go(RouteNames.onboarding);
  }
}
