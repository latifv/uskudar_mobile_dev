part of 'transaction_history_bloc.dart';

sealed class TransactionHistoryEvent {
  const TransactionHistoryEvent();
}

final class TransactionHistoryLoadData extends TransactionHistoryEvent {
  const TransactionHistoryLoadData();
}

final class TransactionHistoryLoadMore extends TransactionHistoryEvent {
  const TransactionHistoryLoadMore();
}

final class TransactionHistoryFilterChange extends TransactionHistoryEvent {
  const TransactionHistoryFilterChange(this.filter);

  final TransactionFilter filter;
}

final class TransactionHistoryDateRangeChange extends TransactionHistoryEvent {
  const TransactionHistoryDateRangeChange({
    required this.startDate,
    required this.endDate,
  });

  final DateTime startDate;
  final DateTime endDate;
}
