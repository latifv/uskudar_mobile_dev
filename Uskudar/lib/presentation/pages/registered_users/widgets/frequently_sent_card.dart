import 'package:flutter/material.dart';
import 'package:uskudar_mobile/domain/entities/frequently_sent.dart';
import 'package:uskudar_mobile/presentation/shared/constants/icon_size_constants.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/border_radius_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/padding_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/spacing_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/theme_extension.dart';

final class FrequentlySentCard extends StatelessWidget {
  const FrequentlySentCard({
    required this.user,
    this.onDelete,
    this.onTap,
    this.showDelete = true,
    super.key,
  });

  final FrequentlySent user;
  final VoidCallback? onDelete;
  final VoidCallback? onTap;
  final bool showDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: context.borderRadiusLowAll,
        boxShadow: [
          BoxShadow(
            color: context.colorScheme.onSurface.withAlpha(52),
            blurRadius: 4,
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: context.borderRadiusLowAll,
        child: Padding(
          padding: context.paddingNormalAll,
          child: Row(
            children: [
              Container(
                padding: context.paddingNormalAll,
                decoration: BoxDecoration(
                  color: context.colorScheme.primary.withAlpha(26),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.person_outline,
                  color: context.colorScheme.primary,
                  size: IconSizeConstants.n,
                ),
              ),
              context.spacingNormalWidth,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.fullName,
                      style: context.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    context.spacingLowHeight,
                    Text(
                      user.customerNumber,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.colorScheme.onSurface.withAlpha(153),
                      ),
                    ),
                  ],
                ),
              ),
              if (showDelete)
                IconButton(
                  onPressed: onDelete,
                  icon: Icon(
                    Icons.delete_outline,
                    color: context.colorScheme.error,
                    size: IconSizeConstants.n,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
