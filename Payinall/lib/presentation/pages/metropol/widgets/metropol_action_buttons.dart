import 'package:flutter/material.dart';
import 'package:payinall/core/generated/locale_keys.g.dart';
import 'package:payinall/presentation/shared/extensions/string_extension.dart';
import 'package:payinall/presentation/shared/extensions/border_radius_extension.dart';
import 'package:payinall/presentation/shared/extensions/media_query_extension.dart';
import 'package:payinall/presentation/shared/extensions/padding_extension.dart';
import 'package:payinall/presentation/shared/extensions/spacing_extension.dart';
import 'package:payinall/presentation/shared/extensions/theme_extension.dart';

final class MetropolActionButtons extends StatelessWidget {
  const MetropolActionButtons({
    required this.onMarketTransferPressed,
    required this.onGiftTransferPressed,
    required this.onLocationsPressed,
    required this.onTransactionsPressed,
    super.key,
  });

  final VoidCallback onMarketTransferPressed;
  final VoidCallback onGiftTransferPressed;
  final VoidCallback onLocationsPressed;
  final VoidCallback onTransactionsPressed;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: context.lowWidth,
      mainAxisSpacing: context.lowHeight,
      childAspectRatio: 2.2,
      children: [
        _ActionButton(
          icon: Icons.qr_code_scanner_rounded,
          label: LocaleKeys.market_balance_top_up.translate,
          color: context.colorScheme.primary,
          onTap: onMarketTransferPressed,
        ),
        _ActionButton(
          icon: Icons.checkroom_rounded,
          label: LocaleKeys.clothing_balance_top_up.translate,
          color: context.colorScheme.tertiary,
          onTap: onGiftTransferPressed,
        ),
        _ActionButton(
          icon: Icons.location_on_rounded,
          label: LocaleKeys.point_of_sale_locations.translate,
          color: context.colorScheme.secondary,
          onTap: onLocationsPressed,
        ),
        _ActionButton(
          icon: Icons.receipt_long_rounded,
          label: LocaleKeys.transaction_history.translate,
          color: context.colorScheme.error,
          onTap: onTransactionsPressed,
        ),
      ],
    );
  }
}

final class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: context.borderRadiusNormalAll,
        side: BorderSide(color: context.colorScheme.outlineVariant),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: context.borderRadiusNormalAll,
        child: Padding(
          padding: context.paddingLowAll,
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: color.withAlpha(25),
                radius: 18,
                child: Icon(icon, color: color, size: 20),
              ),
              context.spacingLowWidth,
              Expanded(
                child: Text(
                  label,
                  style: context.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
