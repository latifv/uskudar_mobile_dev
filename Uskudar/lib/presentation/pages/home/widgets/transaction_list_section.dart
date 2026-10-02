import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:uskudar_mobile/core/generated/locale_keys.g.dart';
import 'package:uskudar_mobile/domain/entities/transaction.dart';
import 'package:uskudar_mobile/presentation/route/app_router.dart';
import 'package:uskudar_mobile/presentation/shared/constants/icon_size_constants.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/padding_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/spacing_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/string_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/theme_extension.dart';
import 'package:uskudar_mobile/presentation/widgets/transaction_list_tile.dart';

final class TransactionListSection extends StatelessWidget {
  const TransactionListSection({required this.transactions, super.key});
  final List<Transaction> transactions;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => context.router.navigate(const TransactionHistoryRoute()),
          child: Container(
            padding: context.paddingLowHorizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  LocaleKeys.last_transactions.translate,
                  style: context.textTheme.titleSmall?.copyWith(),
                ),
                TextButton(
                  onPressed: () {
                    unawaited(
                      context.router.navigate(const TransactionHistoryRoute()),
                    );
                  },
                  child: Text(
                    LocaleKeys.view_all.translate,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: context.colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (transactions.isEmpty)
          _buildEmptyState(context)
        else
          ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: transactions.length,
            itemBuilder: (_, index) {
              return Column(
                children: [
                  if (index != 0)
                    Divider(
                      height: 0.5,
                      color: context.colorScheme.onSurface.withAlpha(64),
                    ),
                  TransactionListTile(
                    transaction: transactions[index],
                    compact: true,
                  ),
                ],
              );
            },
          ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          context.spacingNormalHeight,
          Icon(
            Icons.bar_chart_sharp,
            size: IconSizeConstants.xl,
            color: context.colorScheme.onSurface.withAlpha(64),
          ),
          context.spacingNormalHeight,
          Text(
            LocaleKeys.transaction_history_empty_message.translate,
            style: context.textTheme.titleSmall?.copyWith(
              color: context.colorScheme.onSurface.withAlpha(128),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
