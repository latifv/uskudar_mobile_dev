part of 'metropol_transactions_bloc.dart';

enum MetropolTransactionsStatus { initial, loading, loaded, error }

final class MetropolTransactionsState extends Equatable {
  const MetropolTransactionsState({
    this.status = MetropolTransactionsStatus.initial,
    this.transactions,
    this.message,
  });

  final MetropolTransactionsStatus status;
  final List<MetropolTransaction>? transactions;
  final String? message;

  MetropolTransactionsState copyWith({
    MetropolTransactionsStatus? status,
    List<MetropolTransaction>? transactions,
    String? message,
  }) {
    return MetropolTransactionsState(
      status: status ?? this.status,
      transactions: transactions ?? this.transactions,
      message: message,
    );
  }

  @override
  List<Object?> get props => [status, transactions, message];
}
