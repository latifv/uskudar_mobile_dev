import 'package:flutter/material.dart';
import 'package:payinall/domain/entities/point_of_sale_location.dart';
import 'package:payinall/presentation/shared/extensions/border_radius_extension.dart';
import 'package:payinall/presentation/shared/extensions/padding_extension.dart';
import 'package:payinall/presentation/shared/extensions/spacing_extension.dart';
import 'package:payinall/presentation/shared/extensions/theme_extension.dart';

final class LocationCard extends StatelessWidget {
  const LocationCard({required this.location, super.key});

  final PointOfSaleLocation location;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: context.borderRadiusNormalAll,
        side: BorderSide(color: context.colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: context.paddingNormalAll,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor:
                      context.colorScheme.primary.withAlpha(25),
                  child: Icon(
                    Icons.store_rounded,
                    color: context.colorScheme.primary,
                  ),
                ),
                context.spacingNormalWidth,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        location.signboardName,
                        style: context.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${location.sector} - ${location.subSector}',
                        style: context.textTheme.bodySmall?.copyWith(
                          color: context.colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            context.spacingLowHeight,
            _buildInfoRow(
              context,
              icon: Icons.location_on_outlined,
              text:
                  '${location.saleAddress}, ${location.district}/${location.city}',
            ),
            if (location.telNo.isNotEmpty) ...[
              context.spacingLowHeight,
              _buildInfoRow(
                context,
                icon: Icons.phone_outlined,
                text: location.telNo,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String text,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: context.colorScheme.onSurfaceVariant,
        ),
        context.spacingLowWidth,
        Expanded(
          child: Text(
            text,
            style: context.textTheme.bodySmall?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
