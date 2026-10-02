part of 'transaction_detail_bloc.dart';

enum TransactionDetailStatus { initial, loading, loaded, error }

final class TransactionDetailState extends Equatable {
  const TransactionDetailState({
    this.status = TransactionDetailStatus.initial,
    this.receipt,
    this.message,
  });

  final TransactionDetailStatus status;
  final TransactionReceipt? receipt;
  final String? message;

  TransactionDetailState copyWith({
    TransactionDetailStatus? status,
    TransactionReceipt? receipt,
    String? message,
  }) {
    return TransactionDetailState(
      status: status ?? this.status,
      receipt: receipt ?? this.receipt,
      message: message,
    );
  }

  @override
  List<Object?> get props => [status, receipt, message];
}
