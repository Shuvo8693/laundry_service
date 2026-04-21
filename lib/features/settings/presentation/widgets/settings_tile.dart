import 'package:flutter/material.dart';
import 'package:e_laundry/core/resources/colors/app_colors.dart';
import 'package:e_laundry/core/utils/screen_util.dart';
import 'package:e_laundry/core/widgets/widgets.dart';

class SettingsTile extends StatelessWidget {
  final Widget icon;
  final String title;
  final VoidCallback onTap;
  final bool showDivider;

  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: Row(
              children: [
                icon,
                const HorizontalSpace(12),
                Expanded(
                  child: CustomText.bodyLarge(
                    title,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16.r,
                  color: const Color(0xFF99A1AF),
                ),
              ],
            ),
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            indent: 16.w,
            endIndent: 16.w,
            color: Color(0x1A000000),
          ),
      ],
    );
  }
}
