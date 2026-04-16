import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:e_laundry/core/utils/screen_util.dart';

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
        ClipRRect(
          borderRadius: BorderRadius.circular(24.r),
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: _useSvg
                ? SvgPicture.asset(_logoAsset, fit: BoxFit.contain)
                : Image.asset(_logoAsset, fit: BoxFit.contain),
          ),
        ),
      ],
    );
  }
}
