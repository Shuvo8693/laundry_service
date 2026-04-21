import 'package:e_laundry/core/resources/colors/app_colors.dart';
import 'package:e_laundry/core/utils/screen_util.dart';
import 'package:e_laundry/core/widgets/widgets.dart';
import 'package:e_laundry/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:e_laundry/features/settings/presentation/cubit/settings_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscureOld = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SettingsCubit, SettingsState>(
      listener: (context, state) {
        if (state is SettingsPasswordChangeSuccess) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
          Navigator.pop(context);
        } else if (state is SettingsError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: const CustomAppBar(
          title: 'Change Password',
          showBackButton: true,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16.r),
          child: Column(
            children: [
              _buildPasswordField(
                controller: _oldPasswordController,
                hint: 'Enter Your Old Password',
                obscureText: _obscureOld,
                onToggle: () => setState(() => _obscureOld = !_obscureOld),
              ),
              const VerticalSpace(16),
              _buildPasswordField(
                controller: _newPasswordController,
                hint: 'Enter Your New Password',
                obscureText: _obscureNew,
                onToggle: () => setState(() => _obscureNew = !_obscureNew),
              ),
              const VerticalSpace(16),
              _buildPasswordField(
                controller: _confirmPasswordController,
                hint: 'Re-type Your New Password',
                obscureText: _obscureConfirm,
                onToggle: () =>
                    setState(() => _obscureConfirm = !_obscureConfirm),
              ),
              const VerticalSpace(32),
              BlocBuilder<SettingsCubit, SettingsState>(
                builder: (context, state) {
                  return AppButton(
                    text: 'Change Password',
                    isLoading: state is SettingsLoading,
                    onPressed: _onChangePassword,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onChangePassword() {
    if (_newPasswordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Passwords do not match'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    context.read<SettingsCubit>().updatePassword(
      oldPassword: _oldPasswordController.text,
      newPassword: _newPasswordController.text,
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hint,
    required bool obscureText,
    required VoidCallback onToggle,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFDADADB)),
      ),
      child: Row(
        children: [
          Icon(Icons.lock_outline, color: const Color(0xFF606060), size: 16.r),
          const HorizontalSpace(12),
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: obscureText,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(
                  color: const Color(0xFF606060),
                  fontSize: 14.sp,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 18.h),
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              obscureText
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: const Color(0xFF333333),
              size: 16.r,
            ),
            onPressed: onToggle,
          ),
        ],
      ),
    );
  }
}
