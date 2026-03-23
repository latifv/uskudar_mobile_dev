import 'package:flutter/material.dart';
import 'package:payinall/domain/entities/metropol_user_detail.dart';
import 'package:payinall/presentation/shared/extensions/border_radius_extension.dart';
import 'package:payinall/presentation/shared/extensions/padding_extension.dart';
import 'package:payinall/presentation/shared/extensions/spacing_extension.dart';
import 'package:payinall/presentation/shared/extensions/theme_extension.dart';

final class MetropolUserInfoCard extends StatelessWidget {
  const MetropolUserInfoCard({
    required this.userDetail,
    super.key,
  });

  final MetropolUserDetail userDetail;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: context.colorScheme.primary.withAlpha(15),
      shape: RoundedRectangleBorder(
        borderRadius: context.borderRadiusNormalAll,
      ),
      child: Padding(
        padding: context.paddingNormalAll,
        child: Row(
          children: [
            Icon(
              Icons.credit_card_rounded,
              color: context.colorScheme.primary,
            ),
            context.spacingNormalWidth,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Kart No',
                    style: context.textTheme.labelSmall?.copyWith(
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    userDetail.cardNo,
                    style: context.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
