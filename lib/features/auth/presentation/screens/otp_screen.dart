import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_laundry/core/utils/screen_util.dart';
import 'package:go_router/go_router.dart';
import 'package:e_laundry/core/resources/colors/app_colors.dart';
import 'package:e_laundry/core/resources/text/app_text_theme.dart';
import 'package:e_laundry/core/routes/route_names.dart';
import 'package:e_laundry/core/widgets/widgets.dart';
import 'package:e_laundry/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:e_laundry/features/auth/presentation/cubit/auth_state.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final List<TextEditingController> _controllers = List.generate(
    4,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _onVerify() {
    final otp = _controllers.map((c) => c.text).join();
    if (otp.length == 4) {
      final phone = context.read<AuthCubit>().pendingPhone ?? '';
      context.read<AuthCubit>().verifyOtp(phone, otp);
    }
  }

  void _onResend() {
    final phone = context.read<AuthCubit>().pendingPhone ?? '';
    if (phone.isNotEmpty) {
      context.read<AuthCubit>().sendOtp(phone);
    }
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
            context.goNamed(RouteNames.dashboard);
          } else if (state is AuthPasswordResetSuccess) {
            context.push(RouteNames.resetPassword);
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
                  text: 'Enter OTP',
                  textType: TextType.headlineMedium,
                  fontWeight: FontWeight.w500,
                ),
                SizedBox(height: 48.h),

                // OTP Input Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    4,
                    (index) => _buildOtpBox(index, context),
                  ),
                ),

                SizedBox(height: 32.h),

                AppButton.primary(
                  text: 'Verify Code',
                  onPressed: isLoading ? null : _onVerify,
                  isLoading: isLoading,
                ),
                SizedBox(height: 32.h),

                // Resend Link
                Center(
                  child: RichText(
                    text: TextSpan(
                      text: 'Hey, did you get the code? ',
                      style: AppTextTheme.textTheme.bodyMedium!.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                      children: [
                        TextSpan(
                          text: 'Resend',
                          style: AppTextTheme.textTheme.bodyMedium!.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w500,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = isLoading ? null : _onResend,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildOtpBox(int index, BuildContext context) {
    return Container(
      width: 44.w,
      height: 57.h,
      margin: EdgeInsets.symmetric(horizontal: 6.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color:
              _focusNodes[index].hasFocus || _controllers[index].text.isNotEmpty
              ? AppColors.primary
              : AppColors.outlineVariant,
        ),
      ),
      child: Center(
        child: TextField(
          controller: _controllers[index],
          focusNode: _focusNodes[index],
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          style: AppTextTheme.textTheme.bodyLarge!.copyWith(
            fontWeight: FontWeight.w500,
          ),
          maxLength: 1,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: const InputDecoration(
            counterText: "",
            border: InputBorder.none,
          ),
          onChanged: (value) {
            if (value.isNotEmpty && index < 3) {
              _focusNodes[index + 1].requestFocus();
            } else if (value.isEmpty && index > 0) {
              _focusNodes[index - 1].requestFocus();
            }
            setState(() {});
          },
          onTap: () => setState(() {}),
        ),
      ),
    );
  }
}
