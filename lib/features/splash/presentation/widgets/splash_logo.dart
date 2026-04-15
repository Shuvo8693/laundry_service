import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:e_laundry/core/utils/screen_util.dart';
import 'package:e_laundry/core/resources/colors/app_colors.dart';

class SplashLogo extends StatelessWidget {
  const SplashLogo({super.key});

  // Set to true to use SVG, false to use PNG/any image asset
  static const bool _useSvg = true;
  static const String _logoAsset = 'assets/app_logo/laundry-logo.svg';

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Logo card with shadow
        Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceLowest,
            borderRadius: BorderRadius.circular(28.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.onSurface.withValues(alpha: 0.08),
                blurRadius: 40.r,
                offset: Offset(0, 12.r),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28.r),
            child: Padding(
              padding: EdgeInsets.all(16.r),
              child: _useSvg
                  ? SvgPicture.asset(_logoAsset, fit: BoxFit.contain)
                  : Image.asset(_logoAsset, fit: BoxFit.contain),
            ),
          ),
        ),
      ],
    );
  }
}
