import 'package:e_laundry/core/resources/asset_resolver/png_image_resource.dart';
import 'package:e_laundry/core/resources/asset_resolver/svg_image_resource.dart';

const String assetBasePath = 'assets';
const String imageBasePath = '$assetBasePath/app_image';
const String iconBasePath = '$assetBasePath/app_icon';
const String logoBasePath = '$assetBasePath/app_logo';

class ImageResourceResolver {
  // App Logo
  static SVGImageResource get appLogo =>
      const SVGImageResource('$logoBasePath/laundry-logo.svg');

  // Background Images
  static PNGImageResource get homeBgPNG =>
      const PNGImageResource('$imageBasePath/home_bg.png');

  static SVGImageResource get homeBgSVG =>
      const SVGImageResource('$imageBasePath/home_bg.svg');

  // Bottom Navigation Icons - Filled/Outlined (Currently matching assets)
  static SVGImageResource get home =>
      const SVGImageResource('$iconBasePath/laundry_home.svg');

  static SVGImageResource get order =>
      const SVGImageResource('$iconBasePath/laundry_order.svg');

  static SVGImageResource get profile =>
      const SVGImageResource('$iconBasePath/laundry_profile.svg');

  static SVGImageResource get service =>
      const SVGImageResource('$iconBasePath/laundry_service.svg');

  // Onboarding
  static SVGImageResource get onboarding1 =>
      const SVGImageResource('$imageBasePath/laundry_onboarding_1.svg');

  static SVGImageResource get onboarding2 =>
      const SVGImageResource('$imageBasePath/laundry_onboarding_2.svg');

  static SVGImageResource get onboarding3 =>
      const SVGImageResource('$imageBasePath/laundry_onboarding_3.svg');

  // Common Icons
  static PNGImageResource get notificationIcon =>
      const PNGImageResource('$iconBasePath/notification.png');

  // Placeholder Images
  static PNGImageResource get userPlaceholder =>
      const PNGImageResource('$imageBasePath/user_placeholder.png');

  static PNGImageResource get imagePlaceholder =>
      const PNGImageResource('$imageBasePath/image_placeholder.png');
}
