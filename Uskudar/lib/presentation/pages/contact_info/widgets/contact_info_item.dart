import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:uskudar_mobile/domain/entities/contact_info.dart';
import 'package:uskudar_mobile/presentation/shared/constants/icon_size_constants.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/media_query_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/padding_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/spacing_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/theme_extension.dart';

final class ContactInfoItem extends StatelessWidget {
  const ContactInfoItem({required this.info, required this.onTap, super.key});

  final ContactInfoModel info;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: context.paddingLowVertical * 1.5,
        child: Row(
          children: [
            _buildIcon(context),
            context.spacingMediumWidth,
            Expanded(child: _buildContent(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon(BuildContext context) {
    return Container(
      width: context.dynamicHeight(.05),
      height: context.dynamicHeight(.05),
      decoration: BoxDecoration(
        color: context.colorScheme.primary.withAlpha(25),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: FaIcon(
          info.iconData,
          size: IconSizeConstants.m,
          color: context.colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          info.title,
          style: context.textTheme.bodyMedium?.copyWith(
            color: context.colorScheme.onSurface.withAlpha(130),
            fontWeight: FontWeight.w400,
          ),
        ),
        context.spacingLowHeight,
        Text(
          info.content,
          style: context.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: context.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}
