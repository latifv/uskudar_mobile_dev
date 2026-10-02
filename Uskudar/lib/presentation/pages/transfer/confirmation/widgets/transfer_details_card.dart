import 'package:flutter/material.dart';
import 'package:uskudar_mobile/core/generated/locale_keys.g.dart';
import 'package:uskudar_mobile/domain/entities/wallet_transfer.dart';
import 'package:uskudar_mobile/domain/entities/withdraw_transfer.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/border_radius_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/double_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/padding_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/spacing_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/string_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/theme_extension.dart';

final class TransferDetailsCard extends StatelessWidget {
  const TransferDetailsCard({
    this.walletTransfer,
    this.withdrawTransfer,
    super.key,
  });

  final WalletTransfer? walletTransfer;
  final WithdrawTransfer? withdrawTransfer;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: context.borderRadiusLowAll),
      child: Column(children: [_buildTransferDetails(context)]),
    );
  }

  Widget _buildTransferDetails(BuildContext context) {
    return Container(
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
          context.spacingLowHeight,
          _buildDetailRow(
            context,
            LocaleKeys.recipient.translate,
            walletTransfer?.buyerFullName ?? withdrawTransfer?.fullName ?? '',
          ),
          _buildDetailRow(
            context,
            walletTransfer != null
                ? (_isPhoneNumber(walletTransfer?.buyerInfo)
                      ? LocaleKeys.phone.translate
                      : LocaleKeys.wallet_address.translate)
                : LocaleKeys.iban.translate,
            walletTransfer?.buyerInfo ?? withdrawTransfer?.ibanNumber ?? '',
          ),
          _buildDetailRow(
            context,
            LocaleKeys.transfer_amount.translate,
            walletTransfer?.amount.toFormattedCurrency() ??
                withdrawTransfer?.amount.toFormattedCurrency() ??
                (0.0).toFormattedCurrency(),
          ),
          _buildDetailRow(
            context,
            LocaleKeys.transaction_fee.translate,
            walletTransfer?.commissionAmount.toFormattedCurrency() ??
                withdrawTransfer?.commissionAmount.toFormattedCurrency() ??
                (0.0).toFormattedCurrency(),
          ),
          if ((walletTransfer?.commissionAmount ??
                  withdrawTransfer?.commissionAmount ??
                  0.0) >
              0)
            _buildDetailRow(
              context,
              LocaleKeys.commission_from.translate,
              walletTransfer?.commissionFrom ??
                  withdrawTransfer?.commissionFrom ??
                  '',
            ),

          if (walletTransfer != null || withdrawTransfer != null)
            _buildTransactionNumberRow(context),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    String title,
    String value,
  ) {
    return Container(
      margin: context.paddingLowBottom,
      padding: context.paddingLowAll,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: context.textTheme.bodyMedium,
          ),
          Text(
            value,
            style: context.textTheme.displayLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionNumberRow(BuildContext context) {
    return Center(
      child: Container(
        margin: context.paddingLowBottom,
        padding: context.paddingLowAll,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              LocaleKeys.transaction_number.translate,
              style: context.textTheme.bodyLarge,
            ),
            context.spacingLowHeight,
            Text(
              walletTransfer?.transactionNumber ??
                  withdrawTransfer?.transactionNumber ??
                  '',
              style: context.textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }

  bool _isPhoneNumber(String? value) {
    if (value == null || value.isEmpty) return false;

    final phoneRegex = RegExp(r'^(\+90|90|0)?5[0-9]{9}$');
    return phoneRegex.hasMatch(value);
  }
}
