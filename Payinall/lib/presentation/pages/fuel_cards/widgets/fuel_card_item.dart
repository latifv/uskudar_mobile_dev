import 'package:flutter/material.dart';
import 'package:payinall/core/generated/locale_keys.g.dart';
import 'package:payinall/presentation/shared/extensions/string_extension.dart';
import 'package:payinall/domain/entities/fuel_card.dart';
import 'package:payinall/presentation/shared/extensions/border_radius_extension.dart';
import 'package:payinall/presentation/shared/extensions/double_extension.dart';
import 'package:payinall/presentation/shared/extensions/padding_extension.dart';
import 'package:payinall/presentation/shared/extensions/spacing_extension.dart';
import 'package:payinall/presentation/shared/extensions/theme_extension.dart';

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
            _buildHeader(context),
            context.spacingLowHeight,
            Divider(color: context.colorScheme.outlineVariant),
            context.spacingLowHeight,
            _buildBalanceRow(context),
            context.spacingNormalHeight,
            _buildActions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: context.colorScheme.primary.withAlpha(25),
          child: Icon(
            Icons.local_gas_station_rounded,
            color: context.colorScheme.primary,
          ),
        ),
        context.spacingNormalWidth,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                card.cardTypeName,
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                card.cardNo,
                style: context.textTheme.bodyMedium?.copyWith(
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
          style: context.textTheme.bodyMedium?.copyWith(
            color: context.colorScheme.onSurfaceVariant,
          ),
        ),
        Text(
          balance != null ? balance!.toFormattedCurrency() : '-',
          style: context.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
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
        icon: const Icon(Icons.add_rounded),
        label: Text(LocaleKeys.top_up_balance.translate),
      ),
    );
  }
}
