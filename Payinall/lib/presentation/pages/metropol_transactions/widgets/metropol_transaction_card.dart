import 'package:flutter/material.dart';
import 'package:payinall/core/generated/locale_keys.g.dart';
import 'package:payinall/presentation/shared/extensions/string_extension.dart';
import 'package:payinall/domain/entities/metropol_transaction.dart';
import 'package:payinall/presentation/shared/extensions/theme_extension.dart';
import 'package:payinall/presentation/widgets/integration_components.dart';

final class MetropolTransactionCard extends StatelessWidget {
  const MetropolTransactionCard({required this.transaction, super.key});

  final MetropolTransaction transaction;

  IconData get _transactionIcon {
    switch (transaction.paymentTypeId) {
      case 16:
        return Icons.replay_rounded;
      case 17:
        return Icons.shopping_bag_rounded;
      case 18:
        return Icons.undo_rounded;
      case 19:
        return Icons.local_gas_station_rounded;
      default:
        return Icons.receipt_rounded;
    }
  }

  String get _transactionTypeLabel {
    switch (transaction.paymentTypeId) {
      case 16:
        return LocaleKeys.alisverislio_cashback.translate;
      case 17:
        return LocaleKeys.metropol_transfer.translate;
      case 18:
        return LocaleKeys.metropol_transfer_refund.translate;
      case 19:
        return LocaleKeys.fuel_loading.translate;
      default:
        return transaction.transactionInfo;
    }
  }

  @override
  Widget build(BuildContext context) {
    return IntegrationSurface(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          IntegrationIconBox(icon: _transactionIcon, size: 38),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.merchantName.isNotEmpty
                      ? transaction.merchantName
                      : _transactionTypeLabel,
                  style: context.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Text(
                  '${transaction.walletName} • ${transaction.transactionDate}',
                  style: context.textTheme.labelSmall?.copyWith(
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${transaction.amount} ₺',
            style: context.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: context.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
