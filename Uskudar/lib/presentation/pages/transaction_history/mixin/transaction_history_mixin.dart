import 'dart:async';

import 'package:flutter/material.dart';
import 'package:payinall/core/generated/locale_keys.g.dart';
import 'package:payinall/di/di.dart';
import 'package:payinall/presentation/pages/transaction_history/bloc/transaction_history_bloc.dart';
import 'package:payinall/presentation/pages/transaction_history/enum/transaction_filter.dart';
import 'package:payinall/presentation/shared/extensions/string_extension.dart';

mixin TransactionHistoryMixin<T extends StatefulWidget> on State<T> {
  late final TransactionHistoryBloc bloc;
  late final ScrollController transactionScrollController;

  @override
  void initState() {
    super.initState();
    bloc = getIt<TransactionHistoryBloc>();
    transactionScrollController = ScrollController()
      ..addListener(_onTransactionScroll);
  }

  @override
  void dispose() {
    transactionScrollController
      ..removeListener(_onTransactionScroll)
      ..dispose();
    unawaited(bloc.close());
    super.dispose();
  }

  void onTransactionHistoryLoadData() {
    bloc.add(const TransactionHistoryLoadData());
  }

  void _onTransactionScroll() {
    if (!transactionScrollController.hasClients) return;
    final position = transactionScrollController.position;
    if (position.pixels >= position.maxScrollExtent - 240) {
      bloc.add(const TransactionHistoryLoadMore());
    }
  }

  void onTransactionHistoryFilterChange(TransactionFilter filter) {
    bloc.add(TransactionHistoryFilterChange(filter));
  }

  Future<void> onShowDateRangePicker() async {
    final currentState = bloc.state;
    final initialStartDate =
        currentState.startDate ??
        DateTime.now().subtract(const Duration(days: 7));
    final initialEndDate = currentState.endDate ?? DateTime.now();

    final dateRange = await showDialog<DateTimeRange>(
      context: context,
      builder: (context) {
        return Theme(
          data: Theme.of(context).copyWith(
            dialogTheme: DialogThemeData(
              backgroundColor: Theme.of(context).colorScheme.surface,
            ),
          ),
          child: Builder(
            builder: (context) {
              return DateRangePickerDialog(
                firstDate: DateTime.now().subtract(const Duration(days: 365)),
                lastDate: DateTime.now(),
                initialDateRange: DateTimeRange(
                  start: initialStartDate,
                  end: initialEndDate,
                ),
                initialEntryMode: DatePickerEntryMode.calendarOnly,
                helpText: LocaleKeys.select_date_range.translate,
                cancelText: LocaleKeys.cancel.translate,
                confirmText: LocaleKeys.confirm.translate,
                errorFormatText: LocaleKeys.invalid_date_format.translate,
                errorInvalidText: LocaleKeys.invalid_date.translate,
                errorInvalidRangeText: LocaleKeys.invalid_date_range.translate,
                fieldStartHintText: LocaleKeys.start_date.translate,
                fieldEndHintText: LocaleKeys.end_date.translate,
                currentDate: DateTime.now(),
              );
            },
          ),
        );
      },
    );

    if (dateRange != null) {
      bloc.add(
        TransactionHistoryDateRangeChange(
          startDate: dateRange.start,
          endDate: dateRange.end,
        ),
      );
    }
  }
}
