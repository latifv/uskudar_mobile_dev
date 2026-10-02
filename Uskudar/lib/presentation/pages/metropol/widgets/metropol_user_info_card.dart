import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uskudar_mobile/core/generated/locale_keys.g.dart';
import 'package:uskudar_mobile/domain/entities/metropol_user_detail.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/string_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/theme_extension.dart';
import 'package:uskudar_mobile/presentation/widgets/integration_components.dart';

final class MetropolUserInfoCard extends StatelessWidget {
  const MetropolUserInfoCard({
    required this.userDetail,
    super.key,
  });

  final MetropolUserDetail userDetail;

  @override
  Widget build(BuildContext context) {
    return IntegrationSurface(
      backgroundColor: AlisverislioColors.lilac,
      showBorder: false,
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
                  LocaleKeys.clothing_card.translate,
                  style: context.textTheme.labelSmall?.copyWith(
                    color: AlisverislioColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  userDetail.cardNo,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: AlisverislioColors.textPrimary,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.4,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: LocaleKeys.copy_card_number.translate,
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: userDetail.cardNo));
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(LocaleKeys.card_number_copied.translate),
                ),
              );
            },
            icon: const Icon(
              Icons.copy_rounded,
              size: 20,
              color: AlisverislioColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
