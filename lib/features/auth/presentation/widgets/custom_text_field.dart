import 'package:e_laundry/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:e_laundry/core/utils/screen_util.dart';
import 'package:e_laundry/core/resources/colors/app_colors.dart';
import 'package:e_laundry/core/resources/text/app_text_theme.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final String labelText;
  final bool isPassword;
  final bool isPhone;
  final TextEditingController? controller;

  const CustomTextField({
    super.key,
    required this.hintText,
    this.labelText = '',
    this.isPassword = false,
    this.isPhone = false,
    this.controller,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelText.isNotEmpty) ...[
          CustomText(
            text: widget.labelText,
            textType: TextType.bodySmall,
            color: AppColors.onSurfaceVariant,
          ),
          SizedBox(height: 8.h),
        ],
        Container(
          height: 56.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: AppColors.outlineVariant),
          ),
          child: Row(
            children: [
              if (widget.isPhone) ...[
                // Country Code simple representation
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border(right: BorderSide(color: AppColors.outlineVariant)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomText(
                        text: '+27',
                        textType: TextType.bodyMedium,
                      ),
                      Icon(Icons.arrow_drop_down, color: AppColors.onSurface),
                    ],
                  ),
                ),
              ],
              Expanded(
                child: TextField(
                  controller: widget.controller,
                  obscureText: widget.isPassword && _obscureText,
                  keyboardType: widget.isPhone ? TextInputType.phone : TextInputType.text,
                  style: AppTextTheme.textTheme.bodyMedium,
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    hintStyle: AppTextTheme.textTheme.bodyMedium!.copyWith(color: AppColors.onSurfaceVariant),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                    border: InputBorder.none,
                    isDense: true,
                  ),
                ),
              ),
              if (widget.isPassword)
                IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                    color: AppColors.onSurfaceVariant,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                ),
            ],
          ),
        ),
      ],
    );
  }
}
