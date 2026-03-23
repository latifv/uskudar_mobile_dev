part of 'transaction_history_bloc.dart';

enum TransactionHistoryStatus { initial, loading, loaded, error }

final class TransactionHistoryState extends Equatable {
  const TransactionHistoryState({
    this.status = TransactionHistoryStatus.initial,
    this.transactions,
    this.allTransactions,
    this.filter = TransactionFilter.all,
    this.message,
    this.startDate,
    this.endDate,
  });

  final TransactionHistoryStatus status;
  final List<Transaction>? transactions;
  final List<Transaction>? allTransactions;
  final TransactionFilter filter;
  final String? message;
  final DateTime? startDate;
  final DateTime? endDate;

  TransactionHistoryState copyWith({
    TransactionHistoryStatus? status,
    List<Transaction>? transactions,
    List<Transaction>? allTransactions,
    TransactionFilter? filter,
    String? message,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return TransactionHistoryState(
      status: status ?? this.status,
      transactions: transactions ?? this.transactions,
      allTransactions: allTransactions ?? this.allTransactions,
      filter: filter ?? this.filter,
      message: message,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }

  @override
  List<Object?> get props => [
    status,
    transactions,
    allTransactions,
    filter,
    message,
    startDate,
    endDate,
  ];
}
