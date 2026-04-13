import 'package:e_laundry/core/resources/asset_resolver/png_image_resource.dart';
import 'package:e_laundry/core/resources/asset_resolver/svg_image_resource.dart';

const String assetBasePath = 'assets';
const String imageBasePath = '$assetBasePath/images';

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

  // Bottom Navigation Icons - Outlined
  static PNGImageResource get homeOutlined =>
      const PNGImageResource('$imageBasePath/home_outlined.png');

  static PNGImageResource get searchOutlined =>
      const PNGImageResource('$imageBasePath/search_outlined.png');

  static PNGImageResource get profileOutlined =>
      const PNGImageResource('$imageBasePath/profile_outlined.png');

  static PNGImageResource get settingsOutlined =>
      const PNGImageResource('$imageBasePath/settings_outlined.png');

  // Bottom Navigation Icons - Filled
  static PNGImageResource get homeFilled =>
      const PNGImageResource('$imageBasePath/home_filled.png');

  static PNGImageResource get searchFilled =>
      const PNGImageResource('$imageBasePath/search_filled.png');

  static PNGImageResource get profileFilled =>
      const PNGImageResource('$imageBasePath/profile_filled.png');

  static PNGImageResource get settingsFilled =>
      const PNGImageResource('$imageBasePath/settings_filled.png');

  // Common Icons
  static PNGImageResource get notificationIcon =>
      const PNGImageResource('$imageBasePath/notification.png');

  static PNGImageResource get menuIcon =>
      const PNGImageResource('$imageBasePath/menu.png');

  static PNGImageResource get backIcon =>
      const PNGImageResource('$imageBasePath/back.png');

  // Placeholder Images
  static PNGImageResource get userPlaceholder =>
      const PNGImageResource('$imageBasePath/user_placeholder.png');

  static PNGImageResource get imagePlaceholder =>
      const PNGImageResource('$imageBasePath/image_placeholder.png');
}
