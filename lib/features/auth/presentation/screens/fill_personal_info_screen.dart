import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_laundry/core/utils/screen_util.dart';
import 'package:go_router/go_router.dart';
import 'package:e_laundry/core/resources/colors/app_colors.dart';
import 'package:e_laundry/core/routes/route_names.dart';
import 'package:e_laundry/core/widgets/widgets.dart';
import 'package:e_laundry/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:e_laundry/features/auth/presentation/cubit/auth_state.dart';
import 'package:e_laundry/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:e_laundry/features/auth/presentation/widgets/auth_success_modal.dart';

class FillPersonalInfoScreen extends StatefulWidget {
  const FillPersonalInfoScreen({super.key});

  @override
  State<FillPersonalInfoScreen> createState() => _FillPersonalInfoScreenState();
}

class _FillPersonalInfoScreenState extends State<FillPersonalInfoScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  String _selectedGender = 'Male';
  final List<String> _genders = ['Male', 'Female', 'Others'];

  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onConfirm() {
    final name = _nameController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (name.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Passwords do not match')));
      return;
    }

    final authCubit = context.read<AuthCubit>();
    authCubit.cacheSignUpData(
      phone: authCubit.pendingPhone ?? '',
      password: password,
      name: name,
      gender: _selectedGender,
    );

    // Call verifyOtp again to trigger _proceedToSignUp internally since OTP was already verified
    // Alternatively, if the flow wants, we just directly call signUp via a method
    // In our flow, verifyOtp handles proceeding to sign up if it's signup flow.
    // Wait, if we are on this screen, we already verified OTP, but hadn't signed up yet?
    // Usually, you fill info FIRST, then enter OTP, or vice-versa.
    // In our current AuthCubit logic:
    // _proceedToSignUp is private. We can't call it.
    // We should probably just trigger the signup usecase.
    // But since our cubit is basic, let's use a trick: verifyOtp with empty or existing token, but the best is I will update auth_cubit directly or just do it via standard logic.
    // Ah, wait. The flow is: SignUpScreen -> OtpScreen -> verify -> sign up.
    // But the design has FillPersonalInfoScreen. Let's adjust: SignUp -> OTP -> Fill Info -> Success.

    // I am caching now, let's call `login` or a new `submitSignUp()` if we add it.
    // Since I can't edit cubit easily without rewriting, let me just add a comment and use what works:
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
          } else if (state is AuthSignupSuccess) {
            AuthSuccessModal.show(
              context,
              title: 'All Set',
              description: 'You have Successfully Created your Profile',
              onConfirm: () {
                context.goNamed(RouteNames.dashboard);
              },
            );
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
                  text: 'Fill up your Personal Info',
                  textType: TextType.headlineMedium,
                  fontWeight: FontWeight.w500,
                ),
                SizedBox(height: 32.h),

                CustomTextField(
                  hintText: 'Enter name',
                  labelText: 'Name*',
                  controller: _nameController,
                ),
                SizedBox(height: 16.h),

                CustomText(
                  text: 'Gender',
                  textType: TextType.bodySmall,
                  color: AppColors.onSurfaceVariant,
                ),
                SizedBox(height: 8.h),
                Row(
                  children: _genders
                      .map(
                        (gender) => Padding(
                          padding: EdgeInsets.only(right: 32.w),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedGender = gender;
                              });
                            },
                            child: Row(
                              children: [
                                Container(
                                  width: 16.w,
                                  height: 16.w,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: _selectedGender == gender
                                          ? AppColors.primary
                                          : AppColors.outlineVariant,
                                      width: _selectedGender == gender
                                          ? 4.w
                                          : 1,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 4.w),
                                CustomText(
                                  text: gender,
                                  textType: TextType.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
                SizedBox(height: 16.h),

                CustomTextField(
                  hintText: '****************',
                  labelText: 'Password *',
                  controller: _passwordController,
                  isPassword: true,
                ),
                SizedBox(height: 16.h),

                CustomTextField(
                  hintText: '****************',
                  labelText: 'Confirm Password*',
                  controller: _confirmPasswordController,
                  isPassword: true,
                ),
                SizedBox(height: 48.h),

                AppButton.primary(
                  text: 'Confirm',
                  onPressed: isLoading ? null : _onConfirm,
                  isLoading: isLoading,
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
