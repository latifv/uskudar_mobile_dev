part of 'transaction_detail_bloc.dart';

sealed class TransactionDetailEvent {
  const TransactionDetailEvent();
}

final class TransactionDetailLoadData extends TransactionDetailEvent {
  const TransactionDetailLoadData(this.transactionId);

  final String transactionId;
}
