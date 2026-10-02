import 'package:flutter/material.dart';
import 'package:payinall/core/generated/locale_keys.g.dart';
import 'package:payinall/domain/entities/fuel_provider.dart';
import 'package:payinall/presentation/shared/extensions/string_extension.dart';
import 'package:payinall/presentation/shared/extensions/theme_extension.dart';
import 'package:payinall/presentation/widgets/integration_components.dart';

final class FuelProviderCard extends StatelessWidget {
  const FuelProviderCard({
    required this.provider,
    required this.onTap,
    super.key,
  });

  final FuelProvider provider;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return IntegrationSurface(
      onTap: onTap,
      showBorder: false,
      backgroundColor: context.colorScheme.surfaceContainerLow,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Expanded(
            flex: 6,
            child: Text(
              provider.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: context.textTheme.titleMedium?.copyWith(
                color: provider.brandColor,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Icon(
                  Icons.add_card_rounded,
                  color: context.colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(height: 4),
                Text(
                  LocaleKeys.fuel_link_card.translate,
                  maxLines: 2,
                  textAlign: TextAlign.end,
                  style: context.textTheme.labelSmall?.copyWith(
                    color: context.colorScheme.primary,
                    fontWeight: FontWeight.w700,
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
