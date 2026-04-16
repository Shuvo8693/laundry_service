import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_laundry/core/utils/screen_util.dart';
import 'package:go_router/go_router.dart';
import 'package:e_laundry/core/resources/colors/app_colors.dart';
import 'package:e_laundry/core/resources/text/app_text_theme.dart';
import 'package:e_laundry/core/routes/route_names.dart';
import 'package:e_laundry/core/widgets/widgets.dart';
import 'package:e_laundry/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:e_laundry/features/auth/presentation/cubit/auth_state.dart';
import 'package:e_laundry/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:e_laundry/features/auth/presentation/widgets/social_login_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLogin() {
    final phone = _phoneController.text.trim();
    final password = _passwordController.text;
    if (phone.isNotEmpty && password.isNotEmpty) {
      context.read<AuthCubit>().login(phone, password);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: '', backgroundColor: Colors.white),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            context.push(RouteNames.dashboard);
          } else if (state is AuthError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16.h),
                // Header
                CustomText(
                  text: 'Log in',
                  textType: TextType.headlineMedium,
                  fontWeight: FontWeight.w500,
                ),
                SizedBox(height: 12.h),
                CustomText(
                  text: 'Create an account or Log in to explore our app',
                  textType: TextType.bodySmall,
                  color: AppColors.onSurfaceVariant, // Neutral-800
                ),
                SizedBox(height: 32.h),

                // Form
                CustomTextField(
                  hintText: 'Enter Phone Number',
                  controller: _phoneController,
                  isPhone: true,
                ),
                SizedBox(height: 16.h),
                CustomTextField(
                  hintText: '****************',
                  labelText: 'Password *',
                  controller: _passwordController,
                  isPassword: true,
                ),
                SizedBox(height: 12.h),

                // Forgot password
                Row(
                  children: [
                    CustomText(
                      text: 'Forgot password?',
                      textType: TextType.bodyMedium,
                      color: AppColors.onSurfaceVariant,
                    ),
                    SizedBox(width: 4.w),
                    GestureDetector(
                      onTap: () => context.push(RouteNames.forgotPassword),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        child: CustomText(
                          text: 'Reset Now',
                          textType: TextType.bodyMedium,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),

                // Login Button
                AppButton.primary(
                  text: 'Log in',
                  onPressed: isLoading ? null : _onLogin,
                  isLoading: isLoading,
                ),
                SizedBox(height: 32.h),

                // Or Sign in with
                Row(
                  children: [
                    Expanded(child: Divider(color: AppColors.onSurfaceVariant)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 13.w),
                      child: CustomText(
                        text: 'Or Sign in with',
                        textType: TextType.bodyMedium,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    Expanded(child: Divider(color: AppColors.onSurfaceVariant)),
                  ],
                ),
                SizedBox(height: 18.h),

                // Social Login
                SocialLoginButton(
                  text: 'Sign in with Google',
                  onTap: () {
                    // TODO: Implement Google Sign In
                  },
                ),
                SizedBox(height: 32.h),

                // Sign Up link
                Center(
                  child: RichText(
                    text: TextSpan(
                      text: 'Don’t have an account? ',
                      style: AppTextTheme.textTheme.bodyMedium!.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                      children: [
                        TextSpan(
                          text: 'Sign Up',
                          style: AppTextTheme.textTheme.bodyMedium!.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w500,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => context.push(RouteNames.signup),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
              ],
            ),
          );
        },
      ),
    );
  }
}
