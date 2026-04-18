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

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _phoneController = TextEditingController();
  bool _agreedToTerms = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _onGetOtp() {
    final phone = _phoneController.text.trim();
    if (phone.isNotEmpty && _agreedToTerms) {
      context.read<AuthCubit>().setIsSignUpFlow(true);
      context.read<AuthCubit>().sendOtp(phone);
    } else if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please agree to terms and privacy policy'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: '', backgroundColor: Colors.white),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthOtpSent) {
            context.pushNamed(RouteNames.otp);
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
                CustomText(
                  text: 'Create an account',
                  textType: TextType.headlineMedium,
                  fontWeight: FontWeight.w500,
                ),
                SizedBox(height: 12.h),
                CustomText(
                  text: 'Continue with Phone Number',
                  textType: TextType.bodySmall,
                  color: AppColors.onSurfaceVariant,
                ),
                SizedBox(height: 32.h),

                CustomTextField(
                  hintText: 'Enter Phone Number',
                  controller: _phoneController,
                  isPhone: true,
                ),
                SizedBox(height: 12.h),

                // Terms and conditions checkbox row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 24.w,
                      height: 24.w,
                      child: Checkbox(
                        value: _agreedToTerms,
                        onChanged: (value) {
                          setState(() {
                            _agreedToTerms = value ?? false;
                          });
                        },
                        activeColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: AppTextTheme.textTheme.bodyMedium!.copyWith(
                            color: AppColors.onSurface,
                          ),
                          children: [
                            const TextSpan(text: 'I agree to the '),
                            TextSpan(
                              text: 'Terms of Service',
                              style: const TextStyle(color: Colors.blue),
                              recognizer: TapGestureRecognizer()..onTap = () {},
                            ),
                            const TextSpan(text: ' and '),
                            TextSpan(
                              text: 'Privacy Policy',
                              style: const TextStyle(color: Colors.blue),
                              recognizer: TapGestureRecognizer()..onTap = () {},
                            ),
                            const TextSpan(text: ' *'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),

                AppButton.primary(
                  text: 'Get OTP',
                  onPressed: isLoading ? null : _onGetOtp,
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

                SocialLoginButton(
                  text: 'Sign in with Google',
                  onTap: () {
                    // TODO: Implement Google Sign In
                  },
                ),
                SizedBox(height: 32.h),

                // Login link
                Center(
                  child: RichText(
                    text: TextSpan(
                      text: 'Already have an account? ',
                      style: AppTextTheme.textTheme.bodyMedium!.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                      children: [
                        TextSpan(
                          text: 'Log in',
                          style: AppTextTheme.textTheme.bodyMedium!.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w500,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => context.push(RouteNames.login),
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
