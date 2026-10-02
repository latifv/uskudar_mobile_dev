import 'package:flutter/material.dart';
import 'package:uskudar_mobile/presentation/shared/constants/icon_asset_constants.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/border_radius_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/media_query_extension.dart';

final class LogoImage extends StatelessWidget {
  const LogoImage({
    this.heightFactor = .25,
    this.widthFactor = 1,
    this.borderRadius,
    this.fit = BoxFit.contain,
    super.key,
    this.imagePath,
  });

  final double heightFactor;
  final double widthFactor;
  final BorderRadiusGeometry? borderRadius;
  final BoxFit fit;
  final String? imagePath;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.dynamicHeight(heightFactor),
      width: context.dynamicWidth(widthFactor),
      child: ClipRRect(
        borderRadius: borderRadius ?? context.borderRadiusHighAll,
        child: Image.asset(
          imagePath ?? IconAssetsConstants.logo,
          fit: fit,
        ),
      ),
    );
  }
}
