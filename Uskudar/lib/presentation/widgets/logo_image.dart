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
        child: imagePath == null
            ? FittedBox(
                fit: fit,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipOval(
                      child: Image.asset(
                        IconAssetsConstants.municipalitySeal,
                        width: 72,
                        height: 72,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'ÜSKÜDAR',
                          style: TextStyle(
                            color: Color(0xFF0E4269),
                            fontSize: 35,
                            fontWeight: FontWeight.w800,
                            height: 1,
                            letterSpacing: -1.1,
                          ),
                        ),
                        Text(
                          'BELEDİYESİ',
                          style: TextStyle(
                            color: Color(0xFF0E4269),
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            height: 1.05,
                            letterSpacing: 0.1,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            : Image.asset(imagePath!, fit: fit),
      ),
    );
  }
}
