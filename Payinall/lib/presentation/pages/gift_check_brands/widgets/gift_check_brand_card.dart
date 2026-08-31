import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:payinall/core/generated/locale_keys.g.dart';
import 'package:payinall/domain/entities/gift_check_brand.dart';
import 'package:payinall/presentation/shared/components/image_network_component.dart';
import 'package:payinall/presentation/shared/extensions/string_extension.dart';
import 'package:payinall/presentation/shared/extensions/theme_extension.dart';
import 'package:payinall/presentation/widgets/integration_components.dart';

final class GiftCheckBrandCard extends StatelessWidget {
  const GiftCheckBrandCard({
    required this.brand,
    required this.onTap,
    super.key,
  });

  final GiftCheckBrand brand;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final displayName = integrationBrandDisplayName(brand.name);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final cashback = NumberFormat.decimalPattern(
      locale,
    ).format(brand.cashbackRate * 100);

    return IntegrationSurface(
      onTap: onTap,
      showBorder: false,
      backgroundColor: const Color(0xFFF1F0F3),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Expanded(
            flex: 6,
            child: Semantics(
              label: displayName,
              image: true,
              child: SizedBox(
                height: 58,
                child: ImageNetworkComponent(
                  imageUrl: brand.logo,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    '%$cashback',
                    maxLines: 1,
                    style: context.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: AlisverislioColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  LocaleKeys.gift_check_cashback_short.translate,
                  maxLines: 1,
                  style: context.textTheme.labelSmall?.copyWith(
                    color: AlisverislioColors.textPrimary,
                    fontWeight: FontWeight.w600,
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
