import 'package:flutter/material.dart';
import 'package:payinall/core/generated/locale_keys.g.dart';
import 'package:payinall/presentation/shared/extensions/string_extension.dart';
import 'package:payinall/presentation/widgets/integration_components.dart';

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
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 2.5,
      children: [
        IntegrationActionCard(
          icon: Icons.qr_code_scanner_rounded,
          label: LocaleKeys.qr_pay.translate,
          color: AlisverislioColors.primary,
          onTap: onMarketTransferPressed,
        ),
        IntegrationActionCard(
          icon: Icons.checkroom_rounded,
          label: LocaleKeys.clothing_balance_top_up.translate,
          color: AlisverislioColors.primary,
          onTap: onGiftTransferPressed,
        ),
        IntegrationActionCard(
          icon: Icons.location_on_rounded,
          label: LocaleKeys.point_of_sale_locations.translate,
          color: AlisverislioColors.primary,
          onTap: onLocationsPressed,
        ),
        IntegrationActionCard(
          icon: Icons.receipt_long_rounded,
          label: LocaleKeys.transaction_history.translate,
          color: AlisverislioColors.primary,
          onTap: onTransactionsPressed,
        ),
      ],
    );
  }
}
