import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'image_resource.dart';

class SVGImageResource implements ImageResource {
  final String name;

  const SVGImageResource(this.name);

  @override
  Widget getImageWidget({
    double? width,
    double? height,
    BoxFit? boxFit,
    Color? color,
  }) {
    return SvgPicture.asset(
      name,
      height: height,
      width: width,
      fit: boxFit ?? BoxFit.contain,
      colorFilter: color != null
          ? ColorFilter.mode(color, BlendMode.srcIn)
          : null,
    );
  }

  @override
  String get getPath {
    return name;
  }
}
