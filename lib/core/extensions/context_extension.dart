import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:e_laundry/l10n/app_localizations.dart';

extension ContextExtension on BuildContext {
  // Localization helper
  AppLocalizations get l10n => AppLocalizations.of(this)!;

  // Navigation helpers
  void go(String location) => GoRouter.of(this).go(location);
  void push(String location) => GoRouter.of(this).push(location);
  void pop() => GoRouter.of(this).pop();

  // Theme helpers
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  // MediaQuery helpers
  Size get screenSize => MediaQuery.of(this).size;
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
  EdgeInsets get padding => MediaQuery.of(this).padding;
  EdgeInsets get viewInsets => MediaQuery.of(this).viewInsets;

  // Show snackbar helper
  void showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // Show dialog helper
  Future<T?> showAppDialog<T>({
    required Widget child,
    bool barrierDismissible = true,
  }) {
    return showDialog<T>(
      context: this,
      barrierDismissible: barrierDismissible,
      builder: (context) => child,
    );
  }
}
