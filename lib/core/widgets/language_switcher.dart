import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_laundry/core/localization/cubit/language_cubit.dart';
import 'package:e_laundry/core/localization/cubit/language_state.dart';
import 'package:e_laundry/core/resources/colors/app_colors.dart';
import 'package:e_laundry/core/widgets/custom_text.dart';

/// Language option data class
class LanguageOption {
  final String code;
  final String name;
  final String flag;

  const LanguageOption({
    required this.code,
    required this.name,
    required this.flag,
  });
}

/// Available languages
class Languages {
  static const List<LanguageOption> available = [
    LanguageOption(code: 'en', name: 'English', flag: '🇺🇸'),
    LanguageOption(code: 'bn', name: 'বাংলা', flag: '🇧🇩'),
    // LanguageOption(code: 'ar', name: 'العربية', flag: '🇸🇦'),
  ];

  static LanguageOption fromCode(String code) {
    return available.firstWhere(
      (lang) => lang.code == code,
      orElse: () =>
          const LanguageOption(code: 'en', name: 'English', flag: '🇺🇸'),
    );
  }
}

/// A reusable language switcher widget
/// Can be used as a dropdown, dialog, or bottom sheet
///
/// Usage:
///   LanguageSwitcherDropdown() - for inline dropdown
///   LanguageSwitcher.show(context) - for dialog
///   LanguageSwitcher.showBottomSheet(context) - for bottom sheet
class LanguageSwitcher extends StatelessWidget {
  const LanguageSwitcher({super.key});

  /// Show language selection dialog
  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => const _LanguageDialog(),
    );
  }

  /// Show language selection bottom sheet
  static Future<void> showBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (context) => const _LanguageBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}

/// Standalone dropdown language switcher for direct use in UI
class LanguageSwitcherDropdown extends StatelessWidget {
  final Color? backgroundColor;
  final Color? textColor;

  const LanguageSwitcherDropdown({
    super.key,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageCubit, LanguageState>(
      builder: (context, state) {
        final language = Languages.available.firstWhere(
          (lang) => lang.code == state.locale.languageCode,
        );

        return DropdownButton<LanguageOption>(
          value: language,
          underline: const SizedBox.shrink(),
          // icon: Icon(Icons.language, color: textColor ?? AppColors.primary),
          items: Languages.available.map((lang) {
            return DropdownMenuItem<LanguageOption>(
              value: lang,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(lang.flag, style: TextStyle(fontSize: 16)),
                  const SizedBox(width: 4),
                  Text(
                    lang.name,
                    style: TextStyle(
                      fontSize: 14,
                      color: textColor ?? AppColors.primary,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: (LanguageOption? newLang) {
            if (newLang != null) {
              context.read<LanguageCubit>().changeLanguage(newLang.code);
            }
          },
        );
      },
    );
  }
}

/// Internal dialog implementation
class _LanguageDialog extends StatelessWidget {
  const _LanguageDialog();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageCubit, LanguageState>(
      builder: (context, state) {
        return AlertDialog(
          title: const CustomText.headlineMedium('Select Language'),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: Languages.available.map((lang) {
                final isSelected = lang.code == state.locale.languageCode;
                return ListTile(
                  leading: CustomText.bodyLarge(lang.flag),
                  title: CustomText.bodyLarge(lang.name),
                  trailing: isSelected
                      ? const Icon(Icons.check, color: AppColors.primary)
                      : null,
                  onTap: () {
                    context.read<LanguageCubit>().changeLanguage(lang.code);
                    Navigator.of(context).pop();
                  },
                  tileColor: isSelected
                      ? AppColors.primary.withValues(alpha: 0.1)
                      : null,
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const CustomText.labelLarge('Cancel'),
            ),
          ],
        );
      },
    );
  }
}

/// Internal bottom sheet implementation
class _LanguageBottomSheet extends StatelessWidget {
  const _LanguageBottomSheet();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageCubit, LanguageState>(
      builder: (context, state) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.all(16),
                child: CustomText.headlineMedium('Select Language'),
              ),
              const Divider(height: 1),
              ...Languages.available.map((lang) {
                final isSelected = lang.code == state.locale.languageCode;
                return ListTile(
                  leading: CustomText.bodyLarge(lang.flag),
                  title: CustomText.bodyLarge(lang.name),
                  trailing: isSelected
                      ? const Icon(Icons.check, color: AppColors.primary)
                      : null,
                  onTap: () {
                    context.read<LanguageCubit>().changeLanguage(lang.code);
                    Navigator.of(context).pop();
                  },
                  tileColor: isSelected
                      ? AppColors.primary.withValues(alpha: 0.1)
                      : null,
                );
              }),
            ],
          ),
        );
      },
    );
  }
}
