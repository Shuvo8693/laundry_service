import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:e_laundry/core/utils/screen_util.dart';

class SplashLogo extends StatelessWidget {
  const SplashLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Accent glow effect (behind main logo)
        Container(
          width: 120.r,
          height: 120.r,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32.r),
            color: Colors.white.withValues(alpha: 0.10),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withValues(alpha: 0.15),
                blurRadius: 20.r,
                spreadRadius: 2.r,
              ),
            ],
          ),
        ),
        // Main logo container with gradient
        Container(
          width: 100.r,
          height: 100.r,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 32.r,
                offset: Offset(0, 8.r),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24.r),
            child: SvgPicture.asset(
              'assets/app_logo/Laundry-logo 1.svg',
              width: 100.r,
              height: 100.r,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ],
    );
  }
}
