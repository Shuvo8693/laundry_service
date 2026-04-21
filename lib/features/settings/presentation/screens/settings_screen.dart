import 'package:e_laundry/core/resources/asset_resolver/image_resource_resolver.dart';
import 'package:e_laundry/core/resources/colors/app_colors.dart';
import 'package:e_laundry/core/routes/route_names.dart';
import 'package:e_laundry/core/utils/screen_util.dart';
import 'package:e_laundry/core/widgets/widgets.dart';
import 'package:e_laundry/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:e_laundry/features/settings/presentation/cubit/settings_state.dart';
import 'package:e_laundry/features/settings/presentation/widgets/settings_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(title: 'Profile', showBackButton: false),
      body: BlocListener<SettingsCubit, SettingsState>(
        listener: (context, state) {
          if (state is SettingsLogoutSuccess) {
            context.go(RouteNames.login);
          }
        },
        child: BlocBuilder<SettingsCubit, SettingsState>(
          builder: (context, state) {
            if (state is SettingsLoading) {
              return const Center(child: CustomCircularProgressIndicator());
            }

            if (state is SettingsError) {
              return ErrorPlaceholder(
                message: state.message,
                onRetry: () => context.read<SettingsCubit>().fetchProfile(),
              );
            }

            final user = state is SettingsLoaded
                ? state.user
                : (state is SettingsUpdateSuccess ? state.user : null);

            if (user == null) return const SizedBox.shrink();

            return SingleChildScrollView(
              padding: EdgeInsets.all(16.r),
              child: Column(
                children: [
                  // Profile Section
                  Container(
                    padding: EdgeInsets.all(12.r),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: const Color(0xFFE8E8E8)),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 32.r,
                          backgroundImage: user.profileImage != null
                              ? NetworkImage(user.profileImage!)
                              : ImageResourceResolver
                                    .userPlaceholder
                                    .assetImage,
                        ),
                        const HorizontalSpace(12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText.bodyLarge(
                                user.name,
                                fontWeight: FontWeight.w400,
                                color: AppColors.primary,
                              ),
                              const VerticalSpace(4),
                              CustomText.bodySmall(
                                user.phone,
                                color: const Color(0xFF606060),
                              ),
                            ],
                          ),
                        ),
                        AppButton(
                          text: 'Edit',
                          width: 72,
                          height: 24,
                          padding: EdgeInsets.zero,
                          onPressed: () => context.push(RouteNames.profile),
                          isOutlined: true,
                        ),
                      ],
                    ),
                  ),
                  const VerticalSpace(16),

                  // Settings Options
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: const Color(0xFFE8E8E8)),
                    ),
                    child: Column(
                      children: [
                        SettingsTile(
                          icon: const Icon(
                            Icons.lock_outline,
                            color: Color(0xFF99A1AF),
                          ),
                          title: 'Change Password',
                          onTap: () => context.push(RouteNames.changePassword),
                        ),
                        SettingsTile(
                          icon: const Icon(
                            Icons.help_outline,
                            color: Color(0xFF99A1AF),
                          ),
                          title: 'Help & Support',
                          onTap: () => context.push(RouteNames.helpSupport),
                        ),
                        SettingsTile(
                          icon: const Icon(
                            Icons.description_outlined,
                            color: Color(0xFF99A1AF),
                          ),
                          title: 'Terms & Conditions',
                          onTap: () => context.push(RouteNames.termsConditions),
                        ),
                        SettingsTile(
                          icon: const Icon(
                            Icons.privacy_tip_outlined,
                            color: Color(0xFF99A1AF),
                          ),
                          title: 'Privacy Policy',
                          onTap: () => context.push(RouteNames.privacyPolicy),
                          showDivider: false,
                        ),
                      ],
                    ),
                  ),
                  const VerticalSpace(24),

                  // Logout Button
                  AppButton(
                    text: 'Log Out',
                    onPressed: () => _showLogoutDialog(context),
                    backgroundColor: const Color(0xFFD4183D),
                    icon: const Icon(Icons.logout, color: Colors.white),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const CustomText.headlineMedium('Log Out'),
        content: const CustomText.bodyMedium(
          'Are you sure you want to log out?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const CustomText.bodyMedium('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<SettingsCubit>().logout();
            },
            child: const CustomText.bodyMedium(
              'Log Out',
              color: Color(0xFFD4183D),
            ),
          ),
        ],
      ),
    );
  }
}
