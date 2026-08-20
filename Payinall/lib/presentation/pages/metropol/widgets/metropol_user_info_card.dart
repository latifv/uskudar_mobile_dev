import 'package:flutter/material.dart';
import 'package:payinall/domain/entities/metropol_user_detail.dart';
import 'package:payinall/presentation/shared/extensions/theme_extension.dart';
import 'package:payinall/presentation/widgets/integration_components.dart';

final class MetropolUserInfoCard extends StatelessWidget {
  const MetropolUserInfoCard({
    required this.userDetail,
    super.key,
  });

  final MetropolUserDetail userDetail;

  @override
  Widget build(BuildContext context) {
    return IntegrationSurface(
      backgroundColor: context.colorScheme.primary.withAlpha(12),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          const IntegrationIconBox(icon: Icons.credit_card_rounded),
          const SizedBox(width: 12),
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
                const SizedBox(height: 2),
                Text(
                  userDetail.cardNo,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
