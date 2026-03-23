import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:payinall/domain/entities/contact_info.dart';
import 'package:payinall/presentation/shared/constants/icon_size_constants.dart';
import 'package:payinall/presentation/shared/extensions/media_query_extension.dart';
import 'package:payinall/presentation/shared/extensions/padding_extension.dart';
import 'package:payinall/presentation/shared/extensions/theme_extension.dart';

final class SocialMediaIcon extends StatelessWidget {
  const SocialMediaIcon({
    required this.socialMedia,
    required this.onTap,
    super.key,
  });

  final SocialMediaModel socialMedia;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: context.dynamicHeight(.05),
        height: context.dynamicHeight(.05),
        margin: context.paddingMediumHorizontal,
        decoration: BoxDecoration(
          color: context.colorScheme.primary.withAlpha(40),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: FaIcon(
            socialMedia.iconData,
            size: IconSizeConstants.n,
            color: context.colorScheme.primary,
          ),
        ),
      ),
    );
  }
}
