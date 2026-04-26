import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_laundry/core/utils/screen_util.dart';
import 'package:go_router/go_router.dart';
import 'package:e_laundry/core/routes/route_names.dart';
import 'package:e_laundry/core/widgets/widgets.dart';
import 'package:e_laundry/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:e_laundry/features/auth/presentation/cubit/auth_state.dart';
import 'package:e_laundry/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:e_laundry/features/auth/presentation/widgets/auth_success_modal.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onReset() {
    final pass = _passwordController.text;
    final confirm = _confirmPasswordController.text;

    if (pass.isEmpty || confirm.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
      return;
    }

    if (pass != confirm) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Passwords do not match')));
      return;
    }

    final phone = context.read<AuthCubit>().pendingPhone ?? '';
    context.read<AuthCubit>().resetPassword(phone, pass);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: '', backgroundColor: Colors.white),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state is AuthAuthenticated) {
            // Assuming resetPassword logs us in or we just show success
            AuthSuccessModal.show(
              context,
              title: 'Password Update',
              description: 'You have Successfully Updated your password',
              onConfirm: () {
                context.goNamed(RouteNames.dashboard);
              },
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16.h),
                CustomText(
                  text: 'Enter New Password',
                  textType: TextType.headlineMedium,
                  fontWeight: FontWeight.w500,
                ),
                SizedBox(height: 48.h),
                CustomTextField(
                  hintText: '****************',
                  labelText: 'Enter New Password',
                  controller: _passwordController,
                  isPassword: true,
                ),
                SizedBox(height: 16.h),
                CustomTextField(
                  hintText: '****************',
                  labelText: 'Re-enter New Password',
                  controller: _confirmPasswordController,
                  isPassword: true,
                ),
                SizedBox(height: 32.h),
                AppButton.primary(
                  text: 'Reset Password',
                  onPressed: isLoading ? null : _onReset,
                  isLoading: isLoading,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
