import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payinall/core/generated/locale_keys.g.dart';
import 'package:payinall/presentation/pages/transaction_history/bloc/transaction_history_bloc.dart';
import 'package:payinall/presentation/pages/transaction_history/mixin/transaction_history_mixin.dart';
import 'package:payinall/presentation/pages/transaction_history/widgets/transaction_filter_tabs.dart';
import 'package:payinall/presentation/pages/transaction_history/widgets/transaction_list_section.dart';
import 'package:payinall/presentation/shared/extensions/padding_extension.dart';
import 'package:payinall/presentation/shared/extensions/string_extension.dart';
import 'package:payinall/presentation/widgets/custom_loading.dart';
import 'package:payinall/presentation/widgets/error_try_again.dart';

@RoutePage()
final class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  State<TransactionHistoryScreen> createState() =>
      _TransactionHistoryScreenState();
}

final class _TransactionHistoryScreenState
    extends State<TransactionHistoryScreen>
    with TransactionHistoryMixin {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => bloc..add(const TransactionHistoryLoadData()),
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: () async {
            onTransactionHistoryLoadData();
          },
          child: SafeArea(
            child: BlocBuilder<TransactionHistoryBloc, TransactionHistoryState>(
              builder: (_, state) {
                if (state.status == TransactionHistoryStatus.initial ||
                    state.status == TransactionHistoryStatus.loading) {
                  return const Center(child: CustomLoading());
                }
                if (state.status == TransactionHistoryStatus.error) {
                  return _buildErrorBody(state);
                }
                return Padding(
                  padding: context.paddingBaseLow,
                  child: _buildBody(state),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(TransactionHistoryState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          child: TransactionFilterTabs(
            selectedFilter: state.filter,
            onFilterSelected: onTransactionHistoryFilterChange,
            onDateRangePressed: onShowDateRangePicker,
            startDate: state.startDate,
            endDate: state.endDate,
          ),
        ),
        Expanded(
          child: TransactionListSection(
            transactions: state.transactions ?? [],
            filter: state.filter,
            scrollController: transactionScrollController,
            isLoadingMore: state.isLoadingMore,
          ),
        ),
      ],
    );
  }

  Widget _buildErrorBody(TransactionHistoryState state) {
    return ErrorTryAgain(
      message: state.message ?? LocaleKeys.unknown_error.translate,
      onTryAgain: onTransactionHistoryLoadData,
    );
  }
}
