part of 'metropol_transactions_bloc.dart';

sealed class MetropolTransactionsEvent {
  const MetropolTransactionsEvent();
}

final class MetropolTransactionsLoad extends MetropolTransactionsEvent {
  const MetropolTransactionsLoad({
    required this.startDate,
    required this.endDate,
  });

  final String startDate;
  final String endDate;
}
