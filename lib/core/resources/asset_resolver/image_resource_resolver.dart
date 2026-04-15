import 'package:e_laundry/core/resources/asset_resolver/png_image_resource.dart';
import 'package:e_laundry/core/resources/asset_resolver/svg_image_resource.dart';

const String assetBasePath = 'assets';
const String imageBasePath = '$assetBasePath/app_images';
const String iconBasePath = '$assetBasePath/app_icons';

class ImageResourceResolver {
  // App Logo
  static PNGImageResource get appLogo =>
      const PNGImageResource('$imageBasePath/app_logo.png');

  static PNGImageResource get appIcon =>
      const PNGImageResource('$imageBasePath/app_icon.png');

  // Background Images
  static PNGImageResource get homeBgPNG =>
      const PNGImageResource('$imageBasePath/home_bg.png');

  static SVGImageResource get homeBgSVG =>
      const SVGImageResource('$imageBasePath/home_bg.svg');

  // Bottom Navigation Icons - Filled
  static PNGImageResource get homeOutlined =>
      const PNGImageResource('$imageBasePath/home_outlined.png');

  // Bottom Navigation Icons - Outlined
  static PNGImageResource get home =>
      const PNGImageResource('$iconBasePath/laundry_home.svg');

  static PNGImageResource get order =>
      const PNGImageResource('$iconBasePath/laundry_order.svg');

  static PNGImageResource get profile =>
      const PNGImageResource('$iconBasePath/laundry_profile.svg');

  static PNGImageResource get service =>
      const PNGImageResource('$iconBasePath/laundry_service.svg');

  // Common Icons
  static PNGImageResource get notificationIcon =>
      const PNGImageResource('$iconBasePath/notification.png');

  // Placeholder Images
  static PNGImageResource get userPlaceholder =>
      const PNGImageResource('$imageBasePath/user_placeholder.png');

  static PNGImageResource get imagePlaceholder =>
      const PNGImageResource('$imageBasePath/image_placeholder.png');
}
