import 'package:e_laundry/core/resources/asset_resolver/image_resource_resolver.dart';
import 'package:e_laundry/core/resources/colors/app_colors.dart';
import 'package:e_laundry/core/utils/screen_util.dart';
import 'package:e_laundry/core/widgets/widgets.dart';
import 'package:e_laundry/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:e_laundry/features/settings/presentation/cubit/settings_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  String _selectedGender = 'Male';

  @override
  void initState() {
    super.initState();
    final state = context.read<SettingsCubit>().state;
    if (state is SettingsLoaded) {
      _nameController.text = state.user.name;
      _phoneController.text = state.user.phone;
      _selectedGender = state.user.gender;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SettingsCubit, SettingsState>(
      listener: (context, state) {
        if (state is SettingsUpdateSuccess) {
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
          title: 'Profile Details',
          showBackButton: true,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Image
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 32.r,
                      backgroundColor: const Color(0xFFE8E8E8),
                      backgroundImage:
                          ImageResourceResolver.userPlaceholder.assetImage,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.all(4.r),
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.camera_alt_outlined,
                          size: 16.r,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const VerticalSpace(24),

              // Name Field
              const CustomText.bodySmall('Name*', color: Color(0xFF333333)),
              const VerticalSpace(8),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 18.h,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: const BorderSide(color: Color(0xFFE8E8E8)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: const BorderSide(color: Color(0xFFE8E8E8)),
                  ),
                ),
              ),
              const VerticalSpace(16),

              // Phone Number Field
              const CustomText.bodySmall(
                'Phone Number',
                color: Color(0xFF333333),
              ),
              const VerticalSpace(8),
              Row(
                children: [
                  Container(
                    height: 56.h,
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: const Color(0xFFE8E8E8)),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.flag,
                          size: 16.r,
                        ), // Use real flag if available
                        const HorizontalSpace(4),
                        const CustomText.bodySmall(
                          '+27',
                          color: Color(0xFF333333),
                        ),
                        Icon(Icons.keyboard_arrow_down, size: 12.r),
                      ],
                    ),
                  ),
                  const HorizontalSpace(8),
                  Expanded(
                    child: TextField(
                      controller: _phoneController,
                      decoration: InputDecoration(
                        hintText: 'Enter Phone Number',
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 18.h,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: const BorderSide(
                            color: Color(0xFFE8E8E8),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: const BorderSide(
                            color: Color(0xFFE8E8E8),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const VerticalSpace(16),

              // Gender
              const CustomText.bodySmall('Gender', color: Color(0xFF333333)),
              const VerticalSpace(8),
              Row(
                children: [
                  _buildGenderOption('Male'),
                  const HorizontalSpace(32),
                  _buildGenderOption('Female'),
                  const HorizontalSpace(32),
                  _buildGenderOption('Others'),
                ],
              ),
              const VerticalSpace(40),

              // Update Button
              BlocBuilder<SettingsCubit, SettingsState>(
                builder: (context, state) {
                  return AppButton(
                    text: 'Update Profile',
                    isLoading: state is SettingsLoading,
                    onPressed: () {
                      context.read<SettingsCubit>().updateProfileDetails(
                        name: _nameController.text,
                        phone: _phoneController.text,
                        gender: _selectedGender,
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGenderOption(String gender) {
    final isSelected = _selectedGender == gender;
    return GestureDetector(
      onTap: () => setState(() => _selectedGender = gender),
      child: Row(
        children: [
          Container(
            width: 16.r,
            height: 16.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? AppColors.primary : const Color(0xFFE8E8E8),
              ),
            ),
            child: isSelected
                ? Center(
                    child: Container(
                      width: 8.r,
                      height: 8.r,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary,
                      ),
                    ),
                  )
                : null,
          ),
          const HorizontalSpace(4),
          CustomText.bodyMedium(gender, color: const Color(0xFF333333)),
        ],
      ),
    );
  }
}
