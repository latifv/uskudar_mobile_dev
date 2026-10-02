import 'package:flutter/material.dart';
import 'package:payinall/domain/entities/transaction.dart';
import 'package:payinall/presentation/pages/transaction_history/enum/transaction_filter.dart';
import 'package:payinall/presentation/shared/constants/icon_size_constants.dart';
import 'package:payinall/presentation/shared/extensions/media_query_extension.dart';
import 'package:payinall/presentation/shared/extensions/spacing_extension.dart';
import 'package:payinall/presentation/shared/extensions/theme_extension.dart';
import 'package:payinall/presentation/widgets/transaction_list_tile.dart';

final class TransactionListSection extends StatelessWidget {
  const TransactionListSection({
    required this.transactions,
    required this.filter,
    required this.scrollController,
    required this.isLoadingMore,
    super.key,
  });

  final List<Transaction> transactions;
  final TransactionFilter filter;
  final ScrollController scrollController;
  final bool isLoadingMore;

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return _buildEmptyState(context);
    }
    return ListView.builder(
      controller: scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: transactions.length + (isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == transactions.length) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        return TransactionListTile(transaction: transactions[index]);
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(
          height: context.dynamicHeight(0.5),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.bar_chart_sharp,
                  size: IconSizeConstants.xl,
                  color: context.colorScheme.onSurface.withAlpha(64),
                ),
                context.spacingNormalHeight,
                Text(
                  filter.emptyMessage,
                  style: context.textTheme.titleSmall?.copyWith(
                    color: context.colorScheme.onSurface.withAlpha(128),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
