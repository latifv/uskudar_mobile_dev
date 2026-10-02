import 'package:flutter/material.dart';
import 'package:uskudar_mobile/core/generated/locale_keys.g.dart';
import 'package:uskudar_mobile/domain/entities/fuel_card.dart';
import 'package:uskudar_mobile/domain/entities/fuel_provider.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/double_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/string_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/theme_extension.dart';
import 'package:uskudar_mobile/presentation/widgets/integration_components.dart';

final class FuelCardItem extends StatelessWidget {
  const FuelCardItem({
    required this.card,
    required this.balance,
    required this.onTopUp,
    required this.onDelete,
    super.key,
  });

  final FuelCard card;
  final double? balance;
  final VoidCallback onTopUp;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return IntegrationSurface(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 10),
          _buildBalanceRow(context),
          const SizedBox(height: 12),
          _buildActions(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        const IntegrationIconBox(
          icon: Icons.local_gas_station_rounded,
          size: 42,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                FuelProvider.fromCardType(card.cardType).name,
                style: context.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                card.cardNo,
                style: context.textTheme.labelSmall?.copyWith(
                  color: context.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: onDelete,
          icon: Icon(
            Icons.delete_outline_rounded,
            color: context.colorScheme.error,
          ),
          tooltip: LocaleKeys.delete_card.translate,
        ),
      ],
    );
  }

  Widget _buildBalanceRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          LocaleKeys.balance.translate,
          style: context.textTheme.bodySmall?.copyWith(
            color: context.colorScheme.onSurfaceVariant,
          ),
        ),
        Text(
          balance != null ? balance!.toFormattedCurrency() : '-',
          style: context.textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.w800,
            color: context.colorScheme.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildActions(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: onTopUp,
        style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(44)),
        icon: const Icon(Icons.add_rounded, size: 18),
        label: Text(
          LocaleKeys.top_up_balance.translate,
          style: const TextStyle(fontSize: 13),
        ),
      ),
    );
  }
}
