import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:payinall/core/constants/app_constants.dart';
import 'package:payinall/domain/entities/transaction.dart';
import 'package:payinall/domain/enums/commission_from_type.dart';
import 'package:payinall/presentation/route/app_router.dart';
import 'package:payinall/presentation/shared/extensions/border_radius_extension.dart';
import 'package:payinall/presentation/shared/extensions/datetime_extension.dart';
import 'package:payinall/presentation/shared/extensions/double_extension.dart';
import 'package:payinall/presentation/shared/extensions/padding_extension.dart';
import 'package:payinall/presentation/shared/extensions/theme_extension.dart';

final class TransactionListTile extends StatelessWidget {
  const TransactionListTile({required this.transaction, super.key});

  final Transaction transaction;

  Color get _circleColor =>
      transaction.isIncoming ? Colors.green.shade100 : Colors.red.shade100;
  Color get _iconColor => transaction.isIncoming ? Colors.green : Colors.red;

  double get _radius => 25;
  int get _titleColorOpacityAlpha => 128;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: context.borderRadiusLowAll,
      ),
      child: ListTile(
        onTap: () => context.router.push(
          TransactionDetailRoute(transactionId: transaction.id),
        ),
        contentPadding:
            (context.paddingLowAll / 2) + context.paddingLowHorizontal,
        leading: CircleAvatar(
          radius: _radius,
          backgroundColor: _circleColor,
          child: Text(
            transaction.isIncoming
                ? transaction.fromFullName[0]
                : transaction.toFullName?[0] ?? AppConstants.appName[0],
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: _iconColor,
            ),
          ),
        ),
        title: Text(
          transaction.isIncoming
              ? transaction.fromFullName
              : transaction.toFullName ?? AppConstants.appName,
          style: context.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          _subtitle,
          style: context.textTheme.bodySmall?.copyWith(
            color: context.colorScheme.onSurface.withAlpha(
              _titleColorOpacityAlpha,
            ),
          ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${transaction.isIncoming ? '+' : '-'}${_getDisplayAmount().toFormattedCurrency()}',
              style: context.textTheme.bodyLarge?.copyWith(
                color: transaction.isIncoming ? Colors.green : Colors.red,
              ),
            ),
            Text(
              transaction.date.toFormattedDateTime(),
              style: context.textTheme.bodySmall?.copyWith(
                color: context.colorScheme.onSurface.withAlpha(
                  _titleColorOpacityAlpha,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String get _subtitle {
    if (transaction.commissionAmount <= 0) return transaction.transferType;

    return '${transaction.transferType} • Komisyon: ${transaction.commissionAmount.toFormattedCurrency()}';
  }

  double _getDisplayAmount() {
    if (transaction.isIncoming &&
        transaction.commissionFromType != CommissionFromType.sender.value) {
      return transaction.amount - transaction.commissionAmount;
    }

    if (!transaction.isIncoming &&
        transaction.commissionFromType == CommissionFromType.sender.value) {
      return transaction.amount + transaction.commissionAmount;
    }
    return transaction.amount;
  }
}
