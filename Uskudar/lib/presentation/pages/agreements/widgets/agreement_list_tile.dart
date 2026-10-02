import 'package:flutter/material.dart';
import 'package:payinall/presentation/shared/constants/icon_size_constants.dart';
import 'package:payinall/presentation/shared/extensions/border_radius_extension.dart';
import 'package:payinall/presentation/shared/extensions/padding_extension.dart';
import 'package:payinall/presentation/shared/extensions/spacing_extension.dart';
import 'package:payinall/presentation/shared/extensions/string_extension.dart';
import 'package:payinall/presentation/shared/extensions/theme_extension.dart';

final class AgreementListTile extends StatelessWidget {
  const AgreementListTile({
    required this.titleKey,
    required this.icon,
    required this.onTap,
    super.key,
  });

  final String titleKey;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Material(
      color: colorScheme.surface,
      borderRadius: context.borderRadiusNormalAll,
      child: InkWell(
        borderRadius: context.borderRadiusNormalAll,
        onTap: onTap,
        child: Container(
          padding: context.paddingNormalAll,
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: context.borderRadiusNormalAll,
          ),
          child: Row(
            children: [
              Container(
                padding: context.paddingLowAll,
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: IconSizeConstants.n,
                  color: colorScheme.primary,
                ),
              ),
              context.spacingNormalWidth,
              Expanded(
                child: Text(
                  titleKey.translate,
                  style: context.textTheme.displayLarge?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: IconSizeConstants.s,
                color: colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
