import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:uskudar_mobile/core/generated/locale_keys.g.dart';
import 'package:uskudar_mobile/domain/entities/customer_process.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/border_radius_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/padding_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/spacing_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/string_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/theme_extension.dart';

final class AccountLimitItem extends StatelessWidget {
  const AccountLimitItem({required this.limit, super.key});
  final CustomerProcess limit;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: context.paddingLowBottom,
      elevation: 0,
      color: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: context.borderRadiusLowAll,
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: Padding(
        padding: context.paddingNormalAll,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${limit.timeInfo} ${limit.processName}',
              style: context.textTheme.displaySmall?.copyWith(),
            ),
            context.spacingLowHeight,
            _buildLimitInfo(
              context,
              '${LocaleKeys.remaining_transaction_count.translate}:',
              limit.remainingNumberOfTransactions == -1
                  ? LocaleKeys.unlimited.translate
                  : limit.remainingNumberOfTransactions.toString(),
            ),
            context.spacingLowHeight,
            _buildLimitInfo(
              context,
              '${LocaleKeys.remaining_amount.translate}:',
              limit.remainingAmountOfMoney == -1
                  ? LocaleKeys.unlimited.translate
                  : _formatCurrency(limit.remainingAmountOfMoney),
            ),
            context.spacingLowHeight,
            _buildLimitInfo(
              context,
              '${LocaleKeys.transfer_limit.translate}:',
              limit.onlyTransferLimit == 0
                  ? LocaleKeys.unlimited.translate
                  : _formatCurrency(limit.onlyTransferLimit),
            ),
          ],
        ),
      ),
    );
  }

  String _formatCurrency(int amount) {
    final formatter = NumberFormat.currency(symbol: '₺', decimalDigits: 2);
    return formatter.format(amount);
  }

  Widget _buildLimitInfo(BuildContext context, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: context.textTheme.bodySmall?.copyWith(
            color: context.colorScheme.onSurface.withAlpha(164),
          ),
        ),
        Text(
          value,
          style: context.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
