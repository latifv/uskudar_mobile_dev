import 'package:flutter/material.dart';
import 'package:payinall/core/generated/locale_keys.g.dart';
import 'package:payinall/domain/entities/transaction_receipt.dart';
import 'package:payinall/presentation/shared/constants/icon_size_constants.dart';
import 'package:payinall/presentation/shared/extensions/border_radius_extension.dart';
import 'package:payinall/presentation/shared/extensions/datetime_extension.dart';
import 'package:payinall/presentation/shared/extensions/double_extension.dart';
import 'package:payinall/presentation/shared/extensions/padding_extension.dart';
import 'package:payinall/presentation/shared/extensions/spacing_extension.dart';
import 'package:payinall/presentation/shared/extensions/string_extension.dart';
import 'package:payinall/presentation/shared/extensions/theme_extension.dart';

final class TransferResultCard extends StatelessWidget {
  const TransferResultCard({required this.receipt, super.key});

  final TransactionReceipt receipt;

  @override
  Widget build(BuildContext context) {
    final safeAmount = receipt.amount;
    final safeCommission = receipt.commissionAmount;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: context.borderRadiusLowAll),
      child: Container(
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
              receipt.toCustomerFullName,
            ),
            _buildDetailRow(
              context,
              _getCustomerNumberLabel(),
              receipt.toCustomerNumber,
            ),
            _buildDetailRow(
              context,
              LocaleKeys.transfer_amount.translate,
              safeAmount.toFormattedCurrency(),
            ),
            _buildDetailRow(
              context,
              LocaleKeys.transaction_fee.translate,
              safeCommission.toFormattedCurrency(),
            ),
            if (safeCommission > 0)
              _buildDetailRow(
                context,
                LocaleKeys.commission_from.translate,
                receipt.commissionFromTypeName,
              ),
            _buildDetailRow(
              context,
              LocaleKeys.date.translate,
              receipt.createdDate.toFormattedDateTime(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    String title,
    String? value, {
    bool isTotal = false,
    bool isHighlighted = false,
    VoidCallback? onCopy,
  }) {
    if (value == null) return const SizedBox.shrink();
    return Container(
      padding: context.paddingLowVertical,
      decoration: isHighlighted
          ? BoxDecoration(
              color: context.colorScheme.primary.withAlpha(26),
              borderRadius: context.borderRadiusLowAll,
            )
          : null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 4,
            child: Text(
              title,
              style: context.textTheme.bodyMedium?.copyWith(
                fontWeight: isTotal || isHighlighted
                    ? FontWeight.bold
                    : FontWeight.normal,
                color: isHighlighted ? context.colorScheme.primary : null,
              ),
            ),
          ),
          Expanded(
            flex: 7,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                  child: Text(
                    value,
                    style: isTotal
                        ? context.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: context.colorScheme.primary,
                          )
                        : isHighlighted
                        ? context.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: context.colorScheme.primary,
                          )
                        : context.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    textAlign: TextAlign.end,
                  ),
                ),
                if (onCopy != null) ...[
                  context.spacingLowWidth,
                  InkWell(
                    onTap: onCopy,
                    child: const Icon(Icons.copy, size: IconSizeConstants.n),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool _isPhoneNumber(String? value) {
    if (value == null || value.isEmpty) return false;

    final phoneRegex = RegExp(r'^(\+90|90|0)?5[0-9]{9}$');
    return phoneRegex.hasMatch(value);
  }

  bool _isIban(String? value) {
    if (value == null || value.isEmpty) return false;

    final cleanValue = value.replaceAll(' ', '').toUpperCase();
    return cleanValue.startsWith('TR') && cleanValue.length >= 20;
  }

  String _getCustomerNumberLabel() {
    final customerNumber = receipt.toCustomerNumber;

    if (_isIban(customerNumber)) {
      return LocaleKeys.iban.translate;
    } else if (_isPhoneNumber(customerNumber)) {
      return LocaleKeys.phone.translate;
    } else {
      return LocaleKeys.address.translate;
    }
  }
}
