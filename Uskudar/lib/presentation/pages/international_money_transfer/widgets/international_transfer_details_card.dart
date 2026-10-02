import 'package:flutter/material.dart';
import 'package:uskudar_mobile/core/generated/locale_keys.g.dart';
import 'package:uskudar_mobile/domain/entities/international_transfer_result.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/double_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/padding_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/spacing_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/string_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/theme_extension.dart';

class InternationalTransferDetailsCard extends StatelessWidget {
  const InternationalTransferDetailsCard({
    required this.transferResult,
    super.key,
  });

  final InternationalTransferResult transferResult;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: context.paddingNormalAll,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              LocaleKeys.transfer_details.translate,
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            context.spacingNormalHeight,
            _buildDetailRow(
              context,
              LocaleKeys.recipient.translate,
              transferResult.toFullName,
            ),
            _buildDetailRow(
              context,
              LocaleKeys.recipient_info.translate,
              transferResult.toInfo,
            ),
            _buildDetailRow(
              context,
              LocaleKeys.amount.translate,
              transferResult.amount.toFormattedCurrency(),
            ),
            _buildDetailRow(
              context,
              LocaleKeys.commission_amount.translate,
              transferResult.commissionAmount.toFormattedCurrency(),
            ),
            _buildDetailRow(
              context,
              LocaleKeys.commission_from.translate,
              transferResult.commissionFrom,
            ),
            const Divider(),
            _buildDetailRow(
              context,
              LocaleKeys.received_amount.translate,
              '${transferResult.receivedPaymentAmount.toFormattedCurrencyWithOutSymbol()} ${transferResult.receivedPaymentAmountCurrency}',
              isHighlighted: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    String label,
    String value, {
    bool isHighlighted = false,
  }) {
    return Padding(
      padding: context.paddingLowVertical,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
          Text(
            value,
            style: context.textTheme.bodyMedium?.copyWith(
              fontWeight: isHighlighted ? FontWeight.bold : FontWeight.w500,
              color: isHighlighted ? context.colorScheme.primary : null,
            ),
          ),
        ],
      ),
    );
  }
}
