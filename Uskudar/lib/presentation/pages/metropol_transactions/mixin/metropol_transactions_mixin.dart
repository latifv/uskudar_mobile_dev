import 'dart:async';

import 'package:flutter/material.dart';
import 'package:uskudar_mobile/di/di.dart';
import 'package:uskudar_mobile/presentation/pages/metropol_transactions/bloc/metropol_transactions_bloc.dart';
import 'package:uskudar_mobile/presentation/shared/components/toast_component.dart';

mixin MetropolTransactionsMixin<T extends StatefulWidget> on State<T> {
  late final MetropolTransactionsBloc bloc;

  DateTime startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime endDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    bloc = getIt<MetropolTransactionsBloc>();
    loadTransactions();
  }

  @override
  void dispose() {
    unawaited(bloc.close());
    super.dispose();
  }

  void loadTransactions() {
    bloc.add(
      MetropolTransactionsLoad(
        startDate: startDate.toIso8601String(),
        endDate: endDate.toIso8601String(),
      ),
    );
  }

  Future<void> onShowDateRangePicker() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2024),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(start: startDate, end: endDate),
    );

    if (picked != null && mounted) {
      setState(() {
        startDate = picked.start;
        endDate = picked.end;
      });
      loadTransactions();
    }
  }

  void blocListener(BuildContext context, MetropolTransactionsState state) {
    if (state.status == MetropolTransactionsStatus.error) {
      ToastComponent.showErrorToast(
        context: context,
        message: state.message ?? '',
      );
    }
  }
}
