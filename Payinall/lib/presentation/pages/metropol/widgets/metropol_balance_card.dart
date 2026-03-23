import 'package:flutter/material.dart';
import 'package:payinall/domain/entities/metropol_user_balance.dart';
import 'package:payinall/presentation/shared/extensions/border_radius_extension.dart';
import 'package:payinall/presentation/shared/extensions/double_extension.dart';
import 'package:payinall/presentation/shared/extensions/padding_extension.dart';
import 'package:payinall/presentation/shared/extensions/spacing_extension.dart';
import 'package:payinall/presentation/shared/extensions/theme_extension.dart';

final class MetropolBalanceCard extends StatelessWidget {
  const MetropolBalanceCard({
    required this.balance,
    super.key,
  });

  final MetropolUserBalance balance;

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
          children: [
            _buildBalanceRow(
              context,
              icon: Icons.restaurant_rounded,
              label: 'Resto Bakiye',
              amount: balance.restoBalance,
              color: context.colorScheme.primary,
            ),
            context.spacingLowHeight,
            Divider(color: context.colorScheme.outlineVariant),
            context.spacingLowHeight,
            _buildBalanceRow(
              context,
              icon: Icons.card_giftcard_rounded,
              label: 'Gift Bakiye',
              amount: balance.giftBalance,
              color: context.colorScheme.tertiary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required double amount,
    required Color color,
  }) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: color.withAlpha(25),
          child: Icon(icon, color: color),
        ),
        context.spacingNormalWidth,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: context.colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                amount.toFormattedCurrency(),
                style: context.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
