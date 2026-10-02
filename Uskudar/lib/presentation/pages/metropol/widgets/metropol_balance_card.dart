import 'package:flutter/material.dart';
import 'package:uskudar_mobile/domain/entities/metropol_user_balance.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/double_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/theme_extension.dart';
import 'package:uskudar_mobile/presentation/widgets/integration_components.dart';

final class MetropolBalanceCard extends StatelessWidget {
  const MetropolBalanceCard({
    required this.balance,
    super.key,
  });

  final MetropolUserBalance balance;

  @override
  Widget build(BuildContext context) {
    return IntegrationSurface(
      showBorder: false,
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Expanded(
            child: _buildBalanceItem(
              context,
              icon: Icons.restaurant_rounded,
              label: 'Resto Bakiye',
              amount: balance.restoBalance,
              color: AlisverislioColors.primary,
            ),
          ),
          Container(
            width: 1,
            height: 54,
            color: AlisverislioColors.divider,
          ),
          Expanded(
            child: _buildBalanceItem(
              context,
              icon: Icons.card_giftcard_rounded,
              label: 'Gift Bakiye',
              amount: balance.giftBalance,
              color: AlisverislioColors.cashback,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required double amount,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: color),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.labelSmall?.copyWith(
                    color: AlisverislioColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              amount.toFormattedCurrency(),
              style: context.textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
